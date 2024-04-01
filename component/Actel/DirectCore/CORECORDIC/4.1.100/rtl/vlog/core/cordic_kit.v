//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
//IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             Common static modules
//
//Rev:
//v4.0 10/23/2014
//
//SVN Revision Information:
//SVN$Revision:$
//SVN$Date:$
//
//Resolved SARS
//
//Notes:
//
//****************************************************************

`timescale 1 ns/100 ps

//                         ____  ____  __      __   _  _
//                        (  _ \( ___)(  )    /__\ ( \/ )
//                         )(_) ))__)  )(__  /(__)\ \  /
//                        (____/(____)(____)(__)(__)(__)

//----------- Register-based 1-bit Delay has only input and output ---------
module cordic_kitDelay_bit_reg(nGrst, rst, clk, clkEn, inp, outp);
  parameter
    DELAY = 2;

  input  nGrst, rst, clk, clkEn;
  input  inp;
  output outp;
  // extra register to avoid error if DELAY==0
  reg delayLine [0:DELAY];
  integer i;

  generate
    if(DELAY==0)
      assign outp = inp;
    else begin
      assign outp = delayLine[DELAY-1];

      always @(posedge clk or negedge nGrst)
        if(!nGrst)
          for(i=0; i<DELAY; i=i+1)         delayLine[i] <= 1'b0;
        else
          if (clkEn)
            if (rst)
              for (i = 0; i<DELAY; i=i+1)  delayLine[i] <= 1'b0;
            else  begin
              for(i=DELAY-1; i>=1; i=i-1)  delayLine[i] <= delayLine[i-1];
              delayLine[0] <= inp;
            end  // clkEn
    end
  endgenerate
endmodule
/*
  cordic_kitDelay_bit_reg # (.DELAY(DELAY)) dly_0 (
      .nGrst(NGRST), .rst(1'b0), .clk(CLK), .clkEn(1'b1),
      .inp(inp),
      .outp(outp) );
*/


//----------- Register-based Multi-bit Delay has only input and output ---------
module cordic_kitDelay_reg(nGrst, rst, clk, clkEn, inp, outp);
  parameter
    BITWIDTH = 16,
    DELAY = 2;

  input  nGrst, rst, clk, clkEn;
  input  [BITWIDTH-1:0] inp;
  output   [BITWIDTH-1:0] outp;
  // extra register to avoid error if DELAY==0
  reg [BITWIDTH-1:0] delayLine [0:DELAY];
  integer i;

  generate
    if(DELAY==0)
      assign outp = inp;
    else begin
      assign outp = delayLine[DELAY-1];

      always @(posedge clk or negedge nGrst)
        if(!nGrst)
          for(i=0; i<DELAY; i=i+1)         delayLine[i] <= 'b0;
        else
          if (clkEn)
            if (rst)
              for (i = 0; i<DELAY; i=i+1)  delayLine[i] <= 'b0;
            else begin
              for(i=DELAY-1; i>=1; i=i-1)  delayLine[i] <= delayLine[i-1];
              delayLine[0] <= inp;
            end  // clkEn
    end
  endgenerate
endmodule
/*
  cordic_kitDelay_reg # (.BITWIDTH(DATA_WIDTH), .DELAY(WRAP_LAYERS) ) wrap_0 (
      .nGrst(NGRST), .rst(1'b0), .clk(CLK), .clkEn(1'b1),
      .inp(DATAI),
      .outp(datai_wrap) );
*/




// simple incremental counter
module cordic_countS(nGrst, rst, clk, clkEn, cntEn, Q, dc);
  parameter WIDTH = 16;
  parameter DCVALUE = (1 << WIDTH) - 1; // state to decode
  parameter BUILD_DC = 1;

  input nGrst, rst, clk, clkEn, cntEn;
  output [WIDTH-1:0] Q;
  output dc;  // decoder output
  reg [WIDTH-1:0] Q;

  assign dc = (BUILD_DC==1)? (Q == DCVALUE) : 1'bx;

  always@(negedge nGrst or posedge clk)
    if(!nGrst) Q <= {WIDTH{1'b0}};
    else
      if(clkEn)
        if(rst)       Q <= {WIDTH{1'b0}};
        else
          if(cntEn)   Q <= Q + 1'b1;
endmodule
/* instance
  cordic_countS # ( .WIDTH(WIDTH), .DCVALUE({WIDTH{1'bx}}),
                .BUILD_DC(0) ) counter_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(clkEn),
    .cntEn(cntEn), .Q(outp), .dc() );
*/



//  ___  ____   __   ____  ____    __  __    __    ___  _   _  ____  _  _  ____
// / __)(_  _) /__\ (_  _)( ___)  (  \/  )  /__\  / __)( )_( )(_  _)( \( )( ___)
// \__ \  )(  /(__)\  )(   )__)    )    (  /(__)\( (__  ) _ (  _)(_  )  (  )__)
// (___/ (__)(__)(__)(__) (____)  (_/\/\_)(__)(__)\___)(_) (_)(____)(_)\_)(____)
//  --------  CORDIC Word-serial State Machine  ----------
module cordicSm(nGrst, clk, rst, din_valid,  //inp
  rfd, rfd_pilot,
  micro_done, ld_data_valid, iter_count, freeze_regs);
  parameter ITERATIONS  = 24;
  parameter LOGITER     = 5;      // log2(ITERATIONS)
  parameter COARSE      = 0;
  parameter IN_REG      = 0;

  localparam LOGITER_M    = ceil_log2(ITERATIONS+1);
  localparam FRONT_PIPES  = COARSE + IN_REG;

  input   nGrst, clk, rst, din_valid;
  output  ld_data_valid, freeze_regs, rfd, rfd_pilot, micro_done;
  output [LOGITER-1:0] iter_count;

  reg rfdn;
  wire rst_iterCount;
  wire [LOGITER_M-1:0] iterCount;
  wire ld_data_validi;
  wire [LOGITER-1:0] iter_counti;

  // rst or ld_data_valid resets and kicks off the iterCounter. After
  // ITERATIONS-1 cycles, the counter generates a short rfd_pilot signal and
  // gets stuck in ITERATIONS state, as rfd goes High thus preventing counting

  assign rst_iterCount = rst | ld_data_valid;
  cordic_countS # ( .WIDTH(LOGITER_M), .DCVALUE(ITERATIONS-1),
                .BUILD_DC(1) ) iterCounter_0 (
    .nGrst(nGrst), .rst(rst_iterCount), .clk(clk), .clkEn(1'b1),
//sar68170    .cntEn(rfdn),
    .cntEn(~rfd),
    .Q(iterCount), .dc(rfd_pilot) );

  // Negative rfd RS flop
  always @ (negedge nGrst or posedge clk)
    if(nGrst==1'b0) rfdn <= 1'b0;
    else
      if((rst==1'b1) || (rfd_pilot==1'b1))
        rfdn <= 1'b0;
      else
        if (ld_data_validi==1'b1) rfdn <=1'b1;

  // output data are ready when rfd==1
//sar68170  assign rfd = ~rfdn;
  assign rfd = ~rfdn & ~rst;                                  //sar68170
  assign iter_counti = iterCount[LOGITER-1:0];
//sar68170  assign ld_data_validi = din_valid & ~rfdn;
  assign ld_data_validi = din_valid & rfd;                    //sar68170

  // Actual inp data may come to micro-rotator one or two clks later due to
  // optional In_reg & Coarse circuits, which are just pipelines. Thus,
  // control signals (iter_count, ld_data_valid & freeze_regs) going to the
  // uRotator must be delayed, too
  cordic_kitDelay_reg # (.BITWIDTH(LOGITER), .DELAY(FRONT_PIPES))
      dly_iter_count_0 (.nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(iter_counti), .outp(iter_count) );

  cordic_kitDelay_bit_reg # (.DELAY(FRONT_PIPES)) dly_ld_valid_0 (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(ld_data_validi), .outp(ld_data_valid) );

  cordic_kitDelay_bit_reg # (.DELAY(FRONT_PIPES+COARSE)) dly_freeze_reg_0 (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(~rfd), .outp(freeze_regs) );

  cordic_kitDelay_bit_reg # (.DELAY(FRONT_PIPES+1)) dly_micro_done_0 (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(rfd_pilot), .outp(micro_done) );


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


//                         _____                       _
//                        |  __ \                     | |
//                        | |__) |___  _   _ _ __   __| |
//                        |  _  // _ \| | | | '_ \ / _` |
//                        | | \ \ (_) | |_| | | | | (_| |
//                        |_|  \_\___/ \__,_|_| |_|\__,_|

// ---------------------  Round Up or Symmetric Round  ----------------------
// 2-clk delay to match convergent rounding
// -------------------------------
// INWIDTH must be >= OUTWIDTH
// -------------------------------
module cordic_kitRndUp (nGrst, rst, clk, datai_valid, inp, outp);
  parameter INWIDTH   = 16;
  parameter OUTWIDTH  = 12;

  input nGrst, rst, clk, datai_valid;
  input[INWIDTH-1:0] inp;
  output [OUTWIDTH-1:0] outp;

  wire[OUTWIDTH:0] inp_w, inp_ww;
  wire[OUTWIDTH-1:0] outp_w;

  assign inp_w  = inp[INWIDTH-1:INWIDTH-OUTWIDTH-1];
  assign inp_ww = inp_w + 'b1;
  assign outp_w = inp_ww[OUTWIDTH:1];

  cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(2) ) pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(datai_valid),
      .inp(outp_w),  .outp(outp) );
endmodule

module cordic_kitRndSymm (nGrst, rst, clk, datai_valid, inp, outp);
  parameter INWIDTH   = 16;
  parameter OUTWIDTH  = 12;

  localparam M = INWIDTH - OUTWIDTH;
  localparam [INWIDTH-1:0] ALLZEROS = 'b0;
  localparam [INWIDTH-1:0] ALLONES  = ~ALLZEROS;
  localparam [INWIDTH-1:0] NEGADD   = ~(ALLONES << (M-1));
  localparam [INWIDTH-1:0] POSADD   = NEGADD + 'b1;

  input nGrst, rst, clk, datai_valid;
  input[INWIDTH-1:0] inp;
  output [OUTWIDTH-1:0] outp;

  wire [INWIDTH-1:0] halfRnd;
  wire[OUTWIDTH-1:0] outp_w;

  assign halfRnd = (inp[INWIDTH-1]==1'b0)? inp + POSADD : inp + NEGADD;
  assign outp_w = halfRnd[INWIDTH-1:INWIDTH-OUTWIDTH];

  cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(2) ) pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(datai_valid),
      .inp(outp_w),  .outp(outp) );
endmodule


// ---------------------------  Convergent Rounding  --------------------------
// Round-to-nearest-even  = Convergent = Round half to even = Unbiased =
// statistician's rounding = Dutch rounding = Gaussian rounding =
// Odd-even rounding = Bankers' rounding = broken rounding = DDR rounding
// and is widely used in bookkeeping.
// 2-clk delay
// -------------------------------
// INWIDTH must be >= OUTWIDTH+2.
// -------------------------------
// Overflow may occur when inp>0 only since we always add 1 or 0, never add -1
module cordic_kitRndEven (nGrst, clk, datai_valid, rst, inp, outp);
  parameter INWIDTH   = 16;
  parameter OUTWIDTH  = 12;

  input nGrst, clk, rst, datai_valid;
  input [INWIDTH-1:0]  inp;
  output[OUTWIDTH-1:0] outp;

  wire roundBit, roundBit_tick, stickyBit, rBit, lsBit, riskOV;
  wire [OUTWIDTH-1:0] inp_w, inp_tick, outp_w;

  // sign bit
  wire signBit = inp[INWIDTH-1];

  // the least significant remaining bit
  assign lsBit = inp[INWIDTH-OUTWIDTH];
  // the most significant truncated bit
  assign rBit = inp[INWIDTH-OUTWIDTH-1];
  assign stickyBit  = |inp[INWIDTH-OUTWIDTH-2:0];
  // Detect the max positive number of size OUTWIDTH: sign==0, others==1
  assign riskOV = (~signBit) & (&inp[INWIDTH-2:INWIDTH-OUTWIDTH]);
  // Calculate the bit to be added to the remaining bits
  assign roundBit = rBit & (stickyBit | lsBit) & ~riskOV;

  // Pipe the roundBit
  cordic_kitDelay_bit_reg # (.DELAY(1)) roundBit_pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(datai_valid),
      .inp(roundBit), .outp(roundBit_tick) );

  // Simply delay the bits to match the roundBit delay
  assign inp_w = inp[INWIDTH-1:INWIDTH-OUTWIDTH];
  cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(1) ) inp_pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(datai_valid),
      .inp(inp_w),  .outp(inp_tick) );

  // Calculate the result and pipe it
  assign outp_w = inp_tick + roundBit_tick;
  cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(1) ) result_pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(datai_valid),
      .inp(outp_w),  .outp(outp) );

endmodule


// Combine all round types depending on ROUND parameter and
// INWIDTH/OUTWIDTH values:
// ROUND                          Function
// ---------------------------------------
//  0     INWIDTH >  OUTWIDTH     Truncate
//  1     INWIDTH > OUTWIDTH+1    Convergent round
//  2     INWIDTH > OUTWIDTH+1    Symmetry round
//  3     INWIDTH >  OUTWIDTH     Round Up

//  1-3   INWIDTH ==OUTWIDTH+1    Round Up
//  x     INWIDTH <= OUTWIDTH     Sign extend
module cordic_kitRoundTop (nGrst, rst, clk, inp, outp,
  //just bit that travels side by side with data.  No interaction with rounding
  validi, valido);
  parameter INWIDTH   = 16;
  parameter OUTWIDTH  = 12;
  parameter ROUND = 1;   // Simply truncate if QUANTIZATION==0
  parameter VALID_BIT = 0;

  input nGrst, rst, clk, validi;
  input[INWIDTH-1:0] inp;
  output valido;
  output [OUTWIDTH-1:0] outp;

  wire [OUTWIDTH-1:0] outp_w;

  // Sign extend
  generate if (INWIDTH <= OUTWIDTH)
    begin: sign_extend
      cordic_signExt # ( .INWIDTH(INWIDTH), .OUTWIDTH(OUTWIDTH), .UNSIGNED(0)) signExt_0 (
      .inp(inp), .outp(outp_w)   );
      cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(2) ) pipe_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
        .inp(outp_w),  .outp(outp) );
    end
  endgenerate

  // Truncate
  generate if ( (INWIDTH>OUTWIDTH) && (ROUND==0) )
    begin: truncate
      assign outp_w = inp[INWIDTH-1:INWIDTH-OUTWIDTH];

      cordic_kitDelay_reg # (.BITWIDTH(OUTWIDTH), .DELAY(2) ) pipe_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
        .inp(outp_w),  .outp(outp) );
    end
  endgenerate

  // Round Up
  generate if ( ( (INWIDTH>OUTWIDTH) && (ROUND==3) ) ||
              ( (INWIDTH==OUTWIDTH+1) && (ROUND!=0) ) )
    begin: round_up
      cordic_kitRndUp # ( .INWIDTH (INWIDTH ),
                            .OUTWIDTH(OUTWIDTH) ) kitRndUp_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk),
        .datai_valid(1'b1), .inp(inp), .outp(outp)  );
    end
  endgenerate

  // Round Symm
  generate if ( (INWIDTH>OUTWIDTH+1) && (ROUND==2) )
    begin: symm
      cordic_kitRndSymm # ( .INWIDTH (INWIDTH ),
                            .OUTWIDTH(OUTWIDTH) ) kitSymm_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk),
        .datai_valid(1'b1), .inp(inp), .outp(outp)  );
    end
  endgenerate

  generate if ( (INWIDTH>OUTWIDTH+1) && (ROUND==1) )
    begin: converg_round
      cordic_kitRndEven # (.INWIDTH (INWIDTH ),
                        .OUTWIDTH(OUTWIDTH) ) kitRndEven_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk),
        .datai_valid(1'b1), .inp(inp), .outp(outp) );
    end
  endgenerate

  // Pipe valid bit
  generate if (VALID_BIT==1) begin: create_valid_bit
    cordic_kitDelay_bit_reg # (.DELAY(2)) valid_pipe_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk),
      .clkEn(1'b1),
      .inp(validi), .outp(valido) );
    end
  endgenerate
endmodule


//sar68170 start
// Generate rsto, which combines nGrst and rst
// nGrst rst      Comments
// ----------
//  yes   0   nGrst only. nGrst starts rsto; tc terminates rsto
//  yes   1   nGrst followed by rst. nGrst starts rsto; rst terminates rsto
//  no    0   Prohibited: at least one of nGrst or rst must be present
//  no    1   rsto = rst
module cordic_init_kickstart (nGrst, clk, rst, rsto);
  input nGrst, rst, clk;
  output rsto;

  wire pulse, terminate_rsto;
  reg rstoi = 1'b0;

  // After deasserting nGrst wait several clk cycles, then generate a 1-clk
  // pulse.  The counter below works once after nGrst. Then rstoi holds it.
  cordic_countS # (.WIDTH(4), .DCVALUE(15), .BUILD_DC(1) ) counter_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
    .cntEn(rstoi),
    .Q(), .dc(pulse) );   // terminal count

  // Terminate rstoi on rst or pulse, whichever comes first
  assign terminate_rsto = rst | pulse;
  always@(negedge nGrst or posedge clk)
    if(nGrst==1'b0)       rstoi <= 1'b1;
    else
      if(terminate_rsto)  rstoi <= 1'b0;

  // If no nGrst, rstoi can be in any state. Say rstoi=1. Then rsto will stay
  // in state 1 until rst comes and SM will be reset. If rstoi=0, rsto=rst
  // and SM will be reset as well
  assign rsto = rstoi | rst ;
endmodule
//sar68170 end

//module cordic_init_kickstart_initial (nGrst, clk, rst, rsto);
//  input nGrst, rst, clk;
//  output rsto;
//
//  wire pulse;
//  reg block_pulse;
//
//  // After deasserting nGrst, wait several clk cycles, then generate a 1-clk
//  // pulse.  The counter below works once after nGrst, then stays in state 0.
//  cordic_countS # (.WIDTH(4), .DCVALUE(15), .BUILD_DC(1) ) counter_0 (
//    .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
//    .cntEn(~block_pulse),
//    .Q(),
//    .dc(pulse) );
//
//  // If rst comes first, block the pulse
//  always@(negedge nGrst or posedge clk)
//    if(nGrst==1'b0)   block_pulse <= 1'b0;
//    else
//      if(rsto)        block_pulse <= 1'b1;
//
//  assign rsto = rst | pulse;
//endmodule

//        +-+-+ +-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+
//        |D|P| |B|i|t|s| |T|r|a|n|s|i|t|i|o|n|
//        +-+-+ +-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+
// Datapath bit alignment-transition from input to uRotator
module cordic_dp_bits_trans(xin, yin, ain, xout, yout, aout);
  parameter IN_BITS = 16;
  parameter DP_BITS = 16;

  input [IN_BITS-1:0] xin, yin, ain;
  output[DP_BITS-1:0] xout, yout, aout;
  // Signed wire declared for arithmetic shift below to be trully arithmetic
  wire signed [DP_BITS-1:0] xouti, youti, aouti;

  // CORDIC arithmetic has datapath width of dpBits.
  // Input fx-pt data are to be scaled up or down to the datapath width.
  // IMPORTANT: X,Y datapath must have an extra bit to accomodate large output
  // vectors (e.g. 1.67*sqrt(1^2+1^2)=1.647*1.41) due to CORDIC gain!!!

  // First sign-extend inputs to output size
  cordic_signExt # (.INWIDTH(IN_BITS),
    .OUTWIDTH(DP_BITS),
    .UNSIGNED(0), // 0-signed conversion; 1-unsigned
    .DROP_MSB(0)  ) sign_ext_x_0 (.inp(xin), .outp(xouti) );

  cordic_signExt # (.INWIDTH(IN_BITS),
    .OUTWIDTH(DP_BITS),
    .UNSIGNED(0), // 0-signed conversion; 1-unsigned
    .DROP_MSB(0)  ) sign_ext_y_0 (.inp(yin), .outp(youti) );

  cordic_signExt # (.INWIDTH(IN_BITS),
    .OUTWIDTH(DP_BITS),
    .UNSIGNED(0), // 0-signed conversion; 1-unsigned
    .DROP_MSB(0)  ) sign_ext_a_0 (.inp(ain), .outp(aouti) );

  generate
    if(DP_BITS >= IN_BITS+1) begin: inBits_less1
      assign xout = xouti << (DP_BITS-1-IN_BITS);
      assign yout = youti << (DP_BITS-1-IN_BITS);
    end
  endgenerate

  generate
    if(DP_BITS < IN_BITS+1) begin: inBits_more1
      // Note: Right arith shift by (IN_BITS-DP_BITS) has been done at sign
      // extension above
      assign xout = xouti>>>1;
      assign yout = youti>>>1;
    end
  endgenerate

  generate
    if(DP_BITS >= IN_BITS) begin: inBits_less
      // Shift input data up to match Cordic arithmetic bit width
      assign aout = aouti << (DP_BITS-IN_BITS);
    end
  endgenerate

  generate
    if(DP_BITS < IN_BITS) begin: inBits_more
      // Note: Right arith shift by (IN_BITS-DP_BITS) has been done at sign
      // extension above
      assign aout = aouti;
    end
  endgenerate
endmodule


//                       ____
//                      / ___| ___    __ _  _ __  ___   ___
//                     | |    / _ \  / _` || '__|/ __| / _ \
//                     | |___| (_) || (_| || |   \__ \|  __/
//                      \____|\___/  \__,_||_|   |___/ \___|

// Coarse pre-rotator rotates inp vestor based on mode if necessary.
// If coarse rotation was performed, it raises flag to let post-rotator know it
// needs to correct a micro-rotator output

// Coarse Algo
//-----------------------------------
// halfMaxVal = antilog(IN_BITS-2);

//  Rotation Modes
//    if( inp.a > halfMaxVal)  {
//      coarse.a    = inp.a - halfMaxVal;  // subtract PI/2
//      coarseFlag  = 1;
//    }
//    if( inp.a < -halfMaxVal) {
//      coarse.a    = inp.a + halfMaxVal;  // add PI/2
//      coarseFlag  = -1;
//    }

//  Vectoring Modes
//    if(inp.x < 0)   { // initial vector is in quadrant 2 or 3
//      if(inp.y >= 0)  { // initial vector is in quadrant 2
//        // rotate by -PI/2
//        coarse.x = inp.y;
//        coarse.y = -inp.x;
//        coarseFlag  = 1;
//      }
//      else            { // initial vector is in quadrant 3
//        // rotate by +PI/2
//        coarse.x = -inp.y;
//        coarse.y = inp.x;
//        coarseFlag  = -1;
//      }
//    }
module cordic_coarse_pre_rotator (nGrst, rst, clk, datai_valid,
                din_x, din_y, din_a, x2u, y2u, a2u, coarse_flag, datai_valido);
  parameter IN_BITS     = 16;
  parameter MODE_VECTOR = 0;
  parameter COARSE      = 0;

  input nGrst, rst, clk, datai_valid;
  input [IN_BITS-1:0] din_x, din_y, din_a;
  output[IN_BITS-1:0] x2u, y2u, a2u;
  output [1:0] coarse_flag;
  output datai_valido;

  wire [IN_BITS-1:0] x2u_w, y2u_w, a2u_w;
  wire [1:0] coarse_flag_w;

  // !!! IMPORTANT: SET THE SOFT cordic_angle_scale FUNCTION = 2*fx_half_PI !!!
  reg [IN_BITS-1:0] fx_half_PI = 1 << (IN_BITS-3);                // sss

  generate if( (COARSE!=0)&&(MODE_VECTOR!=1) ) begin: pre_coarse_rotationMode
    assign a2u_w =  ($signed(din_a) > $signed(fx_half_PI) )?  $signed(din_a) - $signed(fx_half_PI) :
                    ($signed(din_a) < -$signed(fx_half_PI) )? $signed(din_a) + $signed(fx_half_PI) :
                                              din_a;
    assign x2u_w = din_x;
    assign y2u_w = din_y;
    assign coarse_flag_w =  ($signed(din_a) > $signed(fx_half_PI) )?  2'b01 :   // 1
                            ($signed(din_a) < -$signed(fx_half_PI) )? 2'b10 :   //-1
                                                      2'b00;    // 0
    end
  endgenerate


  generate if( (COARSE!=0)&&(MODE_VECTOR==1) ) begin: pre_coarse_vectorMode
    assign x2u_w = ($signed(din_x) >= 0)? din_x : ($signed(din_y) >= 0)? din_y : -$signed(din_y);
    assign y2u_w = ($signed(din_x) >= 0)? din_y : ($signed(din_y) >= 0)? -$signed(din_x) : din_x;
    assign a2u_w = din_a;
    assign coarse_flag_w = ($signed(din_x) >= 0)? 2'b00 : ($signed(din_y) >= 0)? 2'b01 : 2'b10;
    end
  endgenerate

  generate if (COARSE!=0) begin: coarse_regs
    cordic_kitDelay_reg # (.BITWIDTH(IN_BITS), .DELAY(1) ) preCoarseReg_x (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(x2u_w), .outp(x2u) );

    cordic_kitDelay_reg # (.BITWIDTH(IN_BITS), .DELAY(1) ) preCoarseReg_y (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(y2u_w), .outp(y2u) );

    cordic_kitDelay_reg # (.BITWIDTH(IN_BITS), .DELAY(1) ) preCoarseReg_a (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(a2u_w), .outp(a2u) );

    // Delay validity bit to match the above regs
    cordic_kitDelay_bit_reg # (.DELAY(1)) dly_0 (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(datai_valid),
      .outp(datai_valido) );

    // Save coarse_flag for a period of datai_valid.
    cordic_kitDelay_reg # (.BITWIDTH(2), .DELAY(1) ) preCoarseReg_flag (
      .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(datai_valid | rst),
      .inp(coarse_flag_w), .outp(coarse_flag) );
    end
  endgenerate

  generate if (COARSE==0) begin: no_coarse
    assign x2u = din_x;
    assign y2u = din_y;
    assign a2u = din_a;
    assign datai_valido = datai_valid;
    assign coarse_flag = 2'b11;
    end
  endgenerate
endmodule




// Coarse post-rotator rotates outp vestor based on mode and outputs the final
// vector.  If does so if pre-rotator had raised a flag.  Otherwise it just let
// the micro-rotator output thru.

// Coarse Algo
//-----------------------------------
// halfMax = antiLog(OUT_BITS-2)

// Rotation Modes
//    if(coarseFlag==1)  {
//      coarse.x = -inp.y;
//      coarse.y = inp.x;
//    }
//    if(coarseFlag==-1)  {
//      coarse.x = inp.y;
//      coarse.y = -inp.x;
//    }

// Vectoring Modes
//    if(coarseFlag==1)
//      coarse.a = inp.a + halfMax;
//    if(coarseFlag==-1)
//      coarse.a = inp.a - halfMax;
module cordic_coarse_post_rotator (nGrst, rst, clk, datai_valid, coarse_flag,
                                  xu, yu, au, out_x, out_y, out_a, datao_valid);
  parameter BITS        = 16;
  parameter MODE_VECTOR = 0;
  parameter COARSE      = 0;

  input nGrst, rst, clk, datai_valid;
  input [1:0] coarse_flag;
  input [BITS-1:0] xu, yu, au;
  output[BITS-1:0] out_x, out_y, out_a;
  output datao_valid;

  wire [BITS-1:0] x_w, y_w, a_w;
  // !!! IMPORTANT: SET THE SOFT cordic_angle_scale FUNCTION = 2*fx_half_PI !!!
  reg [BITS-1:0] fx_half_PI = 1 << (BITS-3);              // sss
  wire coarse_flag_w;

  generate if( (COARSE!=0)&&(MODE_VECTOR!=1) ) begin: post_coarse_rotationMode
    assign x_w=(coarse_flag==2'b01)? -$signed(yu):(coarse_flag==2'b10)? yu:xu;
    assign y_w=(coarse_flag==2'b01)? xu:(coarse_flag==2'b10)? -$signed(xu):yu;
    assign a_w='b0;
    end
  endgenerate

  generate if( (COARSE!=0)&&(MODE_VECTOR==1) ) begin: post_coarse_vectorMode
    assign x_w = xu;
    assign y_w = yu;
    assign a_w = (coarse_flag==2'b01)? au + fx_half_PI :
                                    (coarse_flag==2'b10)? au - fx_half_PI : au;
    end
  endgenerate

  generate if (COARSE!=0) begin: coarse_regs
    cordic_kitDelay_reg # (.BITWIDTH(BITS), .DELAY(1) ) preCoarseReg_x (
      .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
      .inp(x_w), .outp(out_x) );

    cordic_kitDelay_reg # (.BITWIDTH(BITS), .DELAY(1) ) preCoarseReg_y (
      .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
      .inp(y_w), .outp(out_y) );

    cordic_kitDelay_reg # (.BITWIDTH(BITS), .DELAY(1) ) preCoarseReg_a (
      .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
      .inp(a_w), .outp(out_a) );

    // Delay validity bit to match the above regs
    cordic_kitDelay_bit_reg # (.DELAY(1)) dly_0 (
      .nGrst(nGrst), .rst(1'b0), .clk(clk), .clkEn(1'b1),
      .inp(datai_valid),
      .outp(datao_valid) );
    end
  endgenerate

  generate if (COARSE==0) begin: no_coarse
    assign out_x = xu;
    assign out_y = yu;
    assign out_a = au;
    assign datao_valid = datai_valid;
    end
  endgenerate
endmodule




//        ___  ____  ___  _  _    ____  _  _  ____  ____  _  _  ____
//       / __)(_  _)/ __)( \( )  ( ___)( \/ )(_  _)( ___)( \( )(  _ \
//       \__ \ _)(_( (_-. )  (    )__)  )  (   )(   )__)  )  (  )(_) )
//       (___/(____)\___/(_)\_)  (____)(_/\_) (__) (____)(_)\_)(____/
// Resize a vector inp to the specified size.
// When resizing to a larger vector, sign extend the inp: the new [leftmost]
// bit positions are filled with a sign bit (UNSIGNED==0) or 0's (UNSIGNED==1).
// When resizing to a smaller vector, account for the DROP_MSB flavor:
// - DROP_MSB==0.  Normal. Simply drop extra LSB's
// - DROP_MSB==1.  Unusual. If signed, retain the sign bit along with the LSB's
//                 If unsigned, simply drop extra MSB"s

module cordic_signExt (inp, outp);
  parameter INWIDTH = 16;
  parameter OUTWIDTH = 20;
  parameter UNSIGNED = 0;   // 0-signed conversion; 1-unsigned
  // When INWIDTH>OUTWIDTH, drop extra MSB's.  Normally extra LSB's are dropped.
  parameter DROP_MSB = 0;

  input [INWIDTH-1:0] inp;
  output[OUTWIDTH-1:0] outp;

  wire sB, u_sB;

  // Input sign bit
  assign sB   = inp[INWIDTH-1];
  generate
    if(INWIDTH == OUTWIDTH) begin: pass_thru
      assign outp = inp;
    end
  endgenerate

  generate
    if(OUTWIDTH>INWIDTH) begin: extend_sign
      assign outp[INWIDTH-1:0] = inp;
      assign u_sB = (UNSIGNED==0)? sB : 1'b0;
      assign outp[OUTWIDTH-1:INWIDTH] = {(OUTWIDTH-INWIDTH){u_sB}};
    end
  endgenerate

  generate
    if((OUTWIDTH<INWIDTH) && (DROP_MSB==0)) begin: cut_lsbs
      assign outp = inp[INWIDTH-1:INWIDTH-OUTWIDTH];
    end
  endgenerate

  generate
    if((OUTWIDTH<INWIDTH) && (DROP_MSB==1)) begin: cut_msbs
      assign outp[OUTWIDTH-2:0] = inp[OUTWIDTH-2:0];
      // If signed, keep the input sign bit; otherwise just drop extra MSB's
      assign outp[OUTWIDTH-1] = (UNSIGNED==0)? sB : inp[OUTWIDTH-1];
    end
  endgenerate
endmodule

/* usage:
  cordic_signExt # ( .INWIDTH(DATA_WIDTH),
              .OUTWIDTH(DATA_WIDTH_MAC),
              .UNSIGNED(UNSIGNED),
              .DROP_MSB(0) ) signExt_0 (
    .inp(data), .outp(data2mac)   );
*/




//----------------------  WORD-SERIAL CORDIC CALCULATOR  ----------------------
module cordic_word_calc(clk, nGrst, rst, clkEn,
    x0, y0, a0, xn, yn, an,
    ld_data_valid, iter_count,
    freeze_regs,  // freeze all registers an, xn, yn when freeze_regs==0. freeze_regs= ~rfd
    aRom);
  parameter   MODE_VECTOR = 0;    //Rotating = 0; vectoring = 1
  parameter   DP_BITS = 48;
  parameter   LOGITER = 6;

  input   clk, nGrst, rst, ld_data_valid, clkEn, freeze_regs;
  input [DP_BITS-1:0]  x0, y0, a0;
  input [LOGITER-1:0]    iter_count;
  input [DP_BITS-1:0]  aRom;
  output [DP_BITS-1:0] xn, yn, an;
  reg [DP_BITS-1:0] xn, yn, an;

  wire [DP_BITS-1:0]   XshiftOut, YshiftOut;
  wire  d;

  // X/Y shiftOut = $signed(xn/yn)>>>iterCount
	assign XshiftOut = shftRA(yn, iter_count);
  assign YshiftOut = shftRA(xn, iter_count);
  assign d = (MODE_VECTOR!=0) ? (~yn[DP_BITS - 1]) : an[DP_BITS-1];

  always @(posedge clk or negedge nGrst)
    if (nGrst == 1'b0)  begin
      an <= {DP_BITS{1'b0}};
      xn <= {DP_BITS{1'b0}};
      yn <= {DP_BITS{1'b0}};
    end
    else
      if (clkEn==1'b1) begin
	      if (rst == 1'b1)  begin
		      an <= {DP_BITS{1'b0}};
		      xn <= {DP_BITS{1'b0}};
		      yn <= {DP_BITS{1'b0}};
	      end
        else
          if (ld_data_valid == 1'b1) begin
            an <= a0;
            xn <= x0;
            yn <= y0;
          end
          else
            if (freeze_regs==1'b1)
              if (d == 1'b1)  begin
                an <= an + aRom;
                xn <= xn + XshiftOut;
                yn <= yn - YshiftOut;
              end
              else  begin
                an <= an - aRom;
                xn <= xn - XshiftOut;
                yn <= yn + YshiftOut;
              end
      end   //clkEn

  //-----------------  Right Arithmetic Shift
  function [DP_BITS-1:0] shftRA;
      input [DP_BITS-1:0] x;
	    input integer shft;
	    reg temp_MSB;
	    integer i;
    begin
      temp_MSB = x[DP_BITS-1];
	    shftRA = x >> shft;
      for (i=0; i<shft && i<DP_BITS; i=i+1)
        shftRA[DP_BITS-1-i] = temp_MSB;
    end
  endfunction
endmodule



//----------------------  PARALLEL CORDIC CALCULATOR  ----------------------
// For now set the constant width, the same as in Word-serial architecture

module cordic_par_calc(clk, nGrst, rst, clkEn,
    x0, y0, a0, xn, yn, an,
    aRom);
  parameter   MODE_VECTOR = 0;    //Rotating = 0; vectoring = 1
  parameter   DP_BITS = 16;
  parameter   LOGITER = 6;
  parameter   ITER_NUM = 1;       // Running iteration number

  input   clk, nGrst, rst, clkEn;
  input [DP_BITS-1:0]  x0, y0, a0, aRom;
  output [DP_BITS-1:0] xn, yn, an;
  reg [DP_BITS-1:0] xn, yn, an;

  wire [DP_BITS-1:0]   XshiftOut, YshiftOut;
  wire  d;

  // X/Y shiftOut = $signed(xn/yn)>>>ITER_NUM
	assign XshiftOut = shftRA(y0, ITER_NUM);
  assign YshiftOut = shftRA(x0, ITER_NUM);
  assign d = (MODE_VECTOR!=0) ? (~y0[DP_BITS - 1]) : a0[DP_BITS - 1];

  always @(posedge clk or negedge nGrst)
    if (nGrst == 1'b0)  begin
      an <= {DP_BITS{1'b0}};
      xn <= {DP_BITS{1'b0}};
      yn <= {DP_BITS{1'b0}};
    end
    else
      if (clkEn==1'b1) begin
	      if (rst == 1'b1)  begin
		      an <= {DP_BITS{1'b0}};
		      xn <= {DP_BITS{1'b0}};
		      yn <= {DP_BITS{1'b0}};
	      end
        else
          if (d == 1'b1)  begin
            an <= a0 + aRom;
            xn <= x0 + XshiftOut;
            yn <= y0 - YshiftOut;
          end
          else  begin
            an <= a0 - aRom;
            xn <= x0 - XshiftOut;
            yn <= y0 + YshiftOut;
          end
      end   //clkEn

  //-----------------  Right Arithmetic Shift
  function [DP_BITS-1:0] shftRA;
      input [DP_BITS-1:0] x;
	    input integer shft;
	    reg temp_MSB;
	    integer i;
    begin
      temp_MSB = x[DP_BITS-1];
	    shftRA = x >> shft;
      for (i=0; i<shft && i<DP_BITS; i=i+1)
        shftRA[DP_BITS-1-i] = temp_MSB;
    end
  endfunction
endmodule

