//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
//IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             Word-serial architecture
//
//Rev:
//v4.0 9/3/2014
//
//SVN Revision Information:
//SVN$Revision:$
//SVN$Date:$
//
//Resolved SARS
//
//Notes:
///////////////////////////////////////////////////////////////////////////////
//                           +-+-+-+-+-+-+ +-+-+-+-+-+
//                           |C|O|R|D|I|C| |M|o|d|e|s|
//                           +-+-+-+-+-+-+ +-+-+-+-+-+
//                      In       Out              Comments
//          ROTATION MODES
//0 General rotation   X,Y,A     X',Y'   Rotate inp vector (X,Y) by angle A to get outp vector(X',Y')
//1 Polar2Rectangular  r,0,A     X',Y'   X'=K*r*cosA; Y'=K*r*sinA; converts polar (r,A) to cartesian(X',Y')
//3 Sin, Cos        (1/g),0,A  cosA,sinA User only inputs A.  1/gain applies internally
//          VECTORING MODES
//2 Rectangular2Polar  X,Y,0     X',A'   X'=K*sqrt(X^2,Y^2);A'=arctan(Y/X); converts rectangular(X,Y) to polar(X',A')
//4 Arctan             X,Y,0        A'   A'=arctan(Y/X).  Only A' comes out
///////////////////////////////////////////////////////////////////////////////

//****************************************************************
//  ----------------------  Conventions  -----------------------------------
//        Mode    |     Inputs         |           Outputs
//  --------------|--------------------|------------------------------------
//                    R O T A T I O N  M O D E S
//  General       | DIN_X: Abscissa X  | DOUT_X = K*(DIN_X*cosA - DIN_Y*sinA)
//  Rotation      | DIN_Y: Ordinate Y  | DOUT_Y = K*(DIN_Y*cosA + DIN_X*sinA)
//  (by Givens)   | DIN_A: Phase A     | DOUT_A   -

//  Polar to      | DIN_X: Magnitude R | DOUT_X = K*R*cosA
//  Rectangular   | DIN_Y: 0           | DOUT_Y = K*R*sinA
//                | DIN_A: Phase A     | DOUT_A   -

//  Sin, Cos      | DIN_X: 1/g (applies within uRotator)| DOUT_X = sinA
//                | DIN_Y: 0                            | DOUT_Y = cosA
//                | DIN_A: Phase A                      | DOUT_A   -

//                    V E C T O R I N G  M O D E S
//  Rectangular   | DIN_X: Abscissa X  | DOUT_X = K*sqrt(X^2+Y^2) "Magnitude R"
//  to Polar      | DIN_Y: Ordinate Y  | DOUT_Y     -
//                | DIN_A: 0           | DOUT_A = arctan(Y/X) "Phase A"

//  Arctan        | DIN_X: Abscissa X  | DOUT_X     -
//                | DIN_Y: Ordinate Y  | DOUT_Y     -
//                | DIN_A: 0           | DOUT_A = arctan(Y/X) "Phase A"
//  K - CORDIC gain


`timescale 1 ns / 1 ns

module CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC (
      NGRST,
      RST,
      CLK,
      DIN_X,
      DIN_Y,
      DIN_A,
      DIN_VALID,
      DOUT_X,
      DOUT_Y,
      DOUT_A,
      DOUT_VALID,
      RFD  );
  parameter ARCHITECT    = 0;   // 0-word-serial; 1-parallel
  parameter MODE         = 0;
  parameter DP_OPTION    = 0;   // DP width: 0-auto; 1-manual; 2-full
  parameter DP_WIDTH     = 16;  // DP width if DP_OPTION==manual
  parameter IN_BITS      = 16;
  parameter OUT_BITS     = 16;
  parameter ROUND        = 0;   // 0-truncate; 1-converg; 2-symm; 3-up
  parameter ITERATIONS   = 24;
  parameter COARSE       = 0;   // 0-don't; 1-povide coarse rotator

  localparam WORDSIZE_MAX = 48;
  localparam WORDSIZE_MIN = 8;

  localparam MODE_VECTOR = (MODE==2) || (MODE==4);

  // Set CORDIC datapath bitwidths
  localparam LOGITER    = ceil_log2(ITERATIONS);
  localparam BITS00 = IN_BITS + 2;
  localparam BITS02 = IN_BITS + ITERATIONS + LOGITER;

  localparam BITS0 = (DP_OPTION==0)? BITS00 : (DP_OPTION==1)? DP_WIDTH : BITS02;
  localparam BITS1 = (BITS0 < WORDSIZE_MIN)? WORDSIZE_MIN : BITS0;
  // Cordic datapath bit width
  localparam DP_BITS = (BITS1 > WORDSIZE_MAX)? WORDSIZE_MAX : BITS1;
  // Round to the smaller of uRotator DP_BITS and OUT_BITS
  localparam EFFECT_OUT_BITS = (OUT_BITS < DP_BITS)? OUT_BITS : DP_BITS;
  // End setting CORDIC datapath bitwidths

  // Dummy params
  localparam IN_REG       = 0;   // Not used; 0-no pipe, 1-input pipe
  localparam OUT_REG      = 0;   // Not used; 0-no pipe, 1-output pipe
  localparam USE_RAM      = 0;   // Not used
  localparam URAM_MAXDEPTH= 0;   // Not used
  localparam FPGA_FAMILY  = 19;  // Not used
  localparam DIE_SIZE     = 20;  // Not used

  input NGRST, RST, CLK, DIN_VALID;
  input [IN_BITS-1:0]  DIN_X, DIN_Y, DIN_A;
  output DOUT_VALID, RFD;
  output [OUT_BITS-1:0] DOUT_X, DOUT_Y, DOUT_A;

  wire [IN_BITS-1:0] din_xi, din_yi, din_ai;
  wire [IN_BITS-1:0] rcpr_gain_fx;                              //5/15/2015
  wire rsti;

  // generate kickstart on nGrst or pass sync rst thru
  cordic_init_kickstart
      kickstart_0 (.nGrst(NGRST), .clk(CLK), .rst(RST), .rsto(rsti) );

  // Enforce necessary constants at the input
  generate
    case (MODE)
      0:  begin                   // General rotation
          assign din_xi = DIN_X;
          assign din_yi = DIN_Y;
          assign din_ai = DIN_A;
          end
      1:  begin                   // Polar to Rectangular
          assign din_xi = DIN_X;
          assign din_yi = 'b0;
          assign din_ai = DIN_A;
          end
      2:  begin                   // Rectangular to Polar
          assign din_xi = DIN_X;
          assign din_yi = DIN_Y;
          assign din_ai = 'b0;
          end
      3:  begin                   // Sin/Cos
//5/15/2015          // Provide a dummy din_xi signal here.  Inside a uRotator it gets
//5/15/2015          // replaced with rcprGain
//5/15/2015          assign din_xi = DIN_X;      //it is replaced with rcprGain at uRotator
          assign din_xi = rcpr_gain_fx;
          assign din_yi = 'b0;
          assign din_ai = DIN_A;
          end
      4:  begin                   // Arctan
          assign din_xi = DIN_X;
          assign din_yi = DIN_Y;
          assign din_ai = 'b0;
          end
      default:  begin             // General rotation
          assign din_xi = DIN_X;
          assign din_yi = DIN_Y;
          assign din_ai = DIN_A;
          end
    endcase
  endgenerate


  generate
    if(ARCHITECT <= 1) begin: word_serial
      CORECORDIC_C0_CORECORDIC_C0_0_cordic_word # (
        .IN_BITS    (IN_BITS ),
        .OUT_BITS   (OUT_BITS),
        .ITERATIONS (ITERATIONS ),
        .MODE_VECTOR(MODE_VECTOR),
        .MODE(MODE),
        .DP_OPTION  (DP_OPTION),
        .DP_BITS    (DP_BITS),
        .EFFECT_OUT_BITS  (EFFECT_OUT_BITS),
        .ROUND      (ROUND   ),
        .IN_REG     (IN_REG  ),
        .OUT_REG    (OUT_REG ),
        .COARSE     (COARSE  ),
        .FPGA_FAMILY(FPGA_FAMILY ),
        .DIE_SIZE   (DIE_SIZE    )  ) cordic_word_0 (
          .nGrst      (NGRST),
          .rst        (rsti),
          .clk        (CLK),
          .din_valid  (DIN_VALID ),
          .rfd        (RFD),
          .dout_valid (DOUT_VALID),
          .out_x      (DOUT_X),
          .out_y      (DOUT_Y),
          .out_a      (DOUT_A),
          .din_x      (din_xi),
          .din_y      (din_yi),
          .din_a      (din_ai),
          .rcpr_gain_fx (rcpr_gain_fx) );                       //5/15/2015
    end
  endgenerate

  generate
    if(ARCHITECT > 1)
    begin: parallel
      CORECORDIC_C0_CORECORDIC_C0_0_cordic_par # (
        .IN_BITS    (IN_BITS ),
        .OUT_BITS   (OUT_BITS),
        .ITERATIONS (ITERATIONS ),
        .MODE_VECTOR(MODE_VECTOR),
        .MODE(MODE),
        .DP_OPTION  (DP_OPTION),
        .DP_BITS    (DP_BITS),
        .EFFECT_OUT_BITS  (EFFECT_OUT_BITS),
        .ROUND      (ROUND   ),
        .IN_REG     (IN_REG  ),
        .OUT_REG    (OUT_REG ),
        .COARSE     (COARSE  )    ) cordic_paral_0 (
          .nGrst    (NGRST),
          .rst      (rsti),
          .clk      (CLK),
          .din_valid (DIN_VALID ),
          .dout_valid (DOUT_VALID),
          .out_x    (DOUT_X),
          .out_y    (DOUT_Y),
          .out_a    (DOUT_A),
          .din_x    (din_xi),
          .din_y    (din_yi),
          .din_a    (din_ai),
          .rcpr_gain_fx (rcpr_gain_fx) );                       //5/15/2015

      assign RFD = 1'b1;
    end
  endgenerate

// ------------------
  function [31:0] ceil_log2;
      input integer x;
      integer tmp, res;
    begin
      tmp = 1;
      res = 0;
      while (tmp < x) begin
        tmp = tmp * 2;
        res = res + 1;
      end
      ceil_log2 = res;
    end
  endfunction
endmodule

