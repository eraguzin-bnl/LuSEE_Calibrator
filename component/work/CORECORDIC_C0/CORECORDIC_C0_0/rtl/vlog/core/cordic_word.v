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
//
//****************************************************************

`timescale 1 ns / 1 ns

//----------  CORECORDIC  ----------------------------------

module CORECORDIC_C0_CORECORDIC_C0_0_cordic_word(nGrst, rst, clk, din_valid, din_x, din_y, din_a,
                                    rfd, dout_valid, out_x, out_y, out_a,
                                    rcpr_gain_fx );             //5/15/2015
  parameter IN_BITS     = 16;
  parameter OUT_BITS    = 16;
  parameter ITERATIONS  = 24;
  parameter MODE_VECTOR = 0;
  parameter MODE        = 0;
  parameter DP_OPTION   = 0;
  parameter DP_BITS     = 8;
  parameter EFFECT_OUT_BITS = 8;
  parameter ROUND       = 0;
  parameter COARSE      = 0;
  // Not used
  parameter IN_REG      = 0;
  parameter OUT_REG     = 0;
  parameter FPGA_FAMILY = 19;
  parameter DIE_SIZE    = 20;

  localparam LOGITER    = ceil_log2(ITERATIONS);

  input   clk, rst, nGrst, din_valid;
  output  dout_valid, rfd;
  input  [IN_BITS-1:0]  din_x, din_y, din_a;
  output [OUT_BITS-1:0] out_x, out_y, out_a;
  output [IN_BITS-1:0] rcpr_gain_fx;                            //5/15/2015

  wire [IN_BITS-1:0]  x2u, y2u, a2u;  // inputs to uRotator
  wire [1:0] coarse_flag, coarse_flag2post;
  wire pre_coarse_valid, rnd_done;
  wire [LOGITER-1:0] iter_count;
  wire [DP_BITS-1:0] romAngle;
  wire [DP_BITS-1:0] x0, y0, a0, xn_u, yn_u, an_u;
  wire [EFFECT_OUT_BITS-1:0] post_coarse_x, post_coarse_y, post_coarse_a;
  wire rfd_pilot, ld_data_valid, ld_data2calc;
  wire [EFFECT_OUT_BITS-1:0] xn_rnd, yn_rnd, an_rnd;

  assign ld_data_valid = din_valid & rfd;

  cordic_coarse_pre_rotator # (.IN_BITS(IN_BITS), .MODE_VECTOR(MODE_VECTOR),
                        .COARSE(COARSE) ) pre_rotat_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk),
    .datai_valid(ld_data_valid),
    .din_x(din_x), .din_y(din_y), .din_a(din_a),
    .x2u(x2u), .y2u(y2u), .a2u(a2u),
    .coarse_flag(coarse_flag),
    .datai_valido(pre_coarse_valid) );

  // Store coarse_flag until it is used by coarse postRotator
  cordic_kitDelay_reg # (.BITWIDTH(2), .DELAY(1) ) hold_coarse_flag_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(rfd_pilot | rst),
      .inp(coarse_flag), .outp(coarse_flag2post) );

  cordicSm #( .ITERATIONS(ITERATIONS), .LOGITER(LOGITER),
              .COARSE(COARSE), .IN_REG(IN_REG) ) sm_0 (
    .nGrst(nGrst), .clk(clk), .rst(rst),
    .din_valid (din_valid),
    .ld_data_valid (ld_data2calc),
    .rfd(rfd), .rfd_pilot(rfd_pilot),
    .micro_done(micro_done),
    .iter_count(iter_count),
    .freeze_regs(freeze_regs)    );

  // CORDIC arithmetic has datapath width of dpBits.
  // Input fx-pt data are to be scaled up or down to the datapath width.
  // IMPORTANT: the datapath must have an extra bit to accomodate large output
  // vectors (e.g. 1.67*sqrt(1^2+1^2)=1.647*1.41) due to CORDIC gain!!!
  cordic_dp_bits_trans # (.IN_BITS(IN_BITS),
                   .DP_BITS(DP_BITS)  ) trans_inp2dp_0 (
    .xin(x2u), .yin(y2u), .ain(a2u),
    .xout(x0), .yout(y0), .aout(a0) );

  CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator # (
    .IN_BITS   (IN_BITS),                                       //5/15/2015 
    .DP_BITS   (DP_BITS   ),
    .ITERATIONS (ITERATIONS ),
    .LOGITER    (LOGITER),
    .MODE_VECTOR  (MODE_VECTOR),
    .MODE(MODE),
    .FPGA_FAMILY(FPGA_FAMILY),
    .DIE_SIZE   (DIE_SIZE   ) )  uRotator_0 (
      .nGrst(nGrst), .rst(rst), .clk(clk), .ld_data_valid(ld_data2calc),
      .x0(x0), .y0(y0), .a0(a0),
      .iter_count(iter_count), .freeze_regs(freeze_regs),
      .xn(xn_u), .yn(yn_u), .an(an_u),
      .rcpr_gain_fx(rcpr_gain_fx) );                            //5/15/2015

  // Round micro-rotator outputs
  // Two cases are possible:
  // 1. OUT_BITS <= DP_BITS perhaps is more likely.  Then it makes sense to
  //    cut extra bits before going to coarse_post_rotator, which has an adder
  // 2. OUT_BITS > DP_BITS.  Then it makes sense to use coarse_post_rotator and
  //    then just sign extend the output. This case's blocked by GUI

  // Round to EFFECT_OUT_BITS that is round to OUT_BITS if it is smaller than
  // uRotator DP_BITS; otherwise just pass it through
  cordic_kitRoundTop # (.INWIDTH(DP_BITS), .OUTWIDTH(EFFECT_OUT_BITS),
                        .ROUND(ROUND), .VALID_BIT(1) ) roundx_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk),
    .inp(xn_u), .outp(xn_rnd),
    .validi(micro_done), .valido(rnd_done) );
  cordic_kitRoundTop # (.INWIDTH(DP_BITS), .OUTWIDTH(EFFECT_OUT_BITS),
                        .ROUND(ROUND), .VALID_BIT(0) ) roundy_0 (
    .nGrst(nGrst), .rst(1'b0), .clk(clk),
    .inp(yn_u), .outp(yn_rnd),
    .validi(), .valido() );
  cordic_kitRoundTop # (.INWIDTH(DP_BITS), .OUTWIDTH(EFFECT_OUT_BITS),
                        .ROUND(ROUND), .VALID_BIT(0) ) rounda_0 (
    .nGrst(nGrst), .rst(1'b0), .clk(clk),
    .inp(an_u), .outp(an_rnd),
    .validi(), .valido() );

  cordic_coarse_post_rotator # (
      .BITS(EFFECT_OUT_BITS),
      .MODE_VECTOR(MODE_VECTOR), .COARSE(COARSE) ) post_rotat_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk),
    .datai_valid(rnd_done), .coarse_flag(coarse_flag2post),
    .xu(xn_rnd), .yu(yn_rnd), .au(an_rnd),
    .out_x(post_coarse_x), .out_y(post_coarse_y), .out_a(post_coarse_a),
    .datao_valid(dout_valid) );

  generate if(OUT_BITS <= DP_BITS) begin: let_coarse_out
    assign out_x = post_coarse_x;
    assign out_y = post_coarse_y;
    assign out_a = post_coarse_a;
    end
  endgenerate

  generate if(OUT_BITS > DP_BITS) begin: coarse_then_signExt
    cordic_signExt # (.INWIDTH(DP_BITS), .OUTWIDTH(OUT_BITS), .UNSIGNED(0))
      signExt_0 (.inp(post_coarse_x), .outp(out_x)   );
    cordic_signExt # (.INWIDTH(DP_BITS), .OUTWIDTH(OUT_BITS), .UNSIGNED(0))
      signExt_1 (.inp(post_coarse_y), .outp(out_y)   );
    cordic_signExt # (.INWIDTH(DP_BITS), .OUTWIDTH(OUT_BITS), .UNSIGNED(0))
      signExt_2 (.inp(post_coarse_a), .outp(out_a)   );
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


//                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
//                        |M|i|c|r|o|-|R|o|t|a|t|o|r|
//                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
module CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator(nGrst, rst, clk, ld_data_valid,
    freeze_regs, x0, y0, a0, iter_count, xn, yn, an,
    rcpr_gain_fx );                                             //5/15/2015
  parameter IN_BITS    = 16;                                    //5/15/2015
  parameter DP_BITS    = 16;
  parameter ITERATIONS  = 24;
  parameter LOGITER     = 6;
  parameter MODE_VECTOR = 0;
  parameter MODE        = 0;
  parameter FPGA_FAMILY = 19;
  parameter DIE_SIZE    = 20;

  input nGrst, clk, rst, ld_data_valid, freeze_regs;
  input [DP_BITS-1:0] x0, y0, a0;
  input [LOGITER-1:0] iter_count;
  output[DP_BITS-1:0] xn, yn, an;
  output[IN_BITS-1:0] rcpr_gain_fx;                             //5/15/2015

//5/15/2015  wire [DP_BITS-1:0] romAngle, rcprGain_fx;
  wire [DP_BITS-1:0] romAngle;                                  //5/15/2015
//5/15/2015  wire [DP_BITS-1:0] x0i = (MODE==3)? rcprGain_fx : x0;
                                                    
  cordic_word_calc # ( .MODE_VECTOR(MODE_VECTOR),
                  .DP_BITS(DP_BITS),
                  .LOGITER(LOGITER) ) calculator_0  (
    .rst(rst), .nGrst(nGrst), .clk(clk), .clkEn(1'b1),
//5/15/2015    .x0(x0i), 
    .x0(x0),                                                    //5/15/2015
    .y0(y0), .a0(a0),
    .xn(xn), .yn(yn), .an(an),
    .ld_data_valid (ld_data_valid),
    .freeze_regs (freeze_regs),
    .iter_count(iter_count),
    .aRom(romAngle)   );

  CORECORDIC_C0_CORECORDIC_C0_0_word_cROM cordicRam (.iterCount(iter_count), .arctan(romAngle),
//5/15/2015                                  .rcprGain_fx(rcprGain_fx) );
                            .rcprGain_fx(rcpr_gain_fx) );       //5/15/2015
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



