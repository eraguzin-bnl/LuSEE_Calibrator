//****************************************************************
//Microsemi Corporation Proprietary and Confidential
//Copyright 2014 Microsemi Corporation.  All rights reserved
//
//ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
//ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
//IN ADVANCE IN WRITING.
//
//Description: CoreCORDIC
//             Word-serial architecture.  Test bench
//
//Rev:
//v4.0 10/31/2014  Maintenance Update
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
module testbench;
  `include "coreparameters.v"

  localparam WORDSIZE_MAX = 48;
  localparam WORDSIZE_MIN = 8;

  localparam MODE_ROTATION = (MODE==0) || (MODE==1) || (MODE==3);
  localparam MODE_VECTOR = (MODE==2) || (MODE==4);

  // PAR_DIN_VALID_OPTION: 0-always valid, 1-every other clk,
  // 2-two clks valid then two clks not; 4-four clks valid, then four not
  localparam PAR_DIN_VALID_OPTION = 0;

  localparam LOGITER  = ceil_log2(ITERATIONS);

  localparam real PI = 3.14159265358979;
  localparam real IN_SCALEFL = real_antilog2(IN_BITS-2);
  // UI prevents OUT_BITS being more than DP_BITS
  localparam real OUT_SCALEFL = real_antilog2(OUT_BITS-3);
  localparam CHECKPTS = 16;
  // If 0, use TB-generated extrn_increm to increm testVectCount
  // Otherwise increm the counter automatically by looping back the dout_valid
  localparam AUTOCYCLE = 0;

  wire clk, rst, nGrst;
  integer i;
  wire [IN_BITS-1:0] a0, x0, y0;
  reg  [IN_BITS-1:0] disp_a0r, disp_x0r, disp_y0r;
  reg  [IN_BITS-1:0] disp_a0r2, disp_x0r2, disp_y0r2;               //5/18/2015
  wire [IN_BITS-1:0] disp_a0, disp_x0, disp_y0;

  wire [OUT_BITS-1:0] yn, xn, an;

  wire [2:0] valid_count;
  wire load_argument, dout_valid;
  wire [ceil_log2(CHECKPTS)-1:0] inVectCount, goldVectCount;
  wire [ceil_log2(CHECKPTS):0]  goldVectCount_i;
  wire extrn_increm, rst_tick, end_test;

  reg Fail, step;
  wire [OUT_BITS-1:0] cos_gold, sin_gold, magni_gold, phase_gold;
  wire rfd;

  generate
    if(ARCHITECT==1) begin: word_serial_tb   //Word-serial testbench
      // External increm signal for the input test vector
      bhvCountS # ( .WIDTH(6), .DCVALUE(ITERATIONS+3),
                    .BUILD_DC(1) ) testSample_increm_0 (
        .nGrst(nGrst), .rst(rst | extrn_increm), .clk(clk), .clkEn(1'b1),
        .cntEn(1'b1), .Q(), .dc(extrn_increm) );

      // Kick off the argument load by rst, then use extrn_increm or dout_valid to load further args
      assign load_argument = (AUTOCYCLE==0)? extrn_increm : rfd;

      // Latch the input vectors on load_argument to display them later
      always @(posedge clk)
        if(load_argument==1'b1) begin
          disp_x0r <= x0;
          disp_y0r <= y0;
          disp_a0r <= a0;
          disp_x0r2 <= disp_x0r;                                    //5/18/2015
          disp_y0r2 <= disp_y0r;                                    //5/18/2015
          disp_a0r2 <= disp_a0r;                                    //5/18/2015
        end

      assign disp_x0 = (COARSE==1)? disp_x0r2 : disp_x0r;          //5/18/2015
      assign disp_y0 = (COARSE==1)? disp_y0r2 : disp_y0r;          //5/18/2015
      assign disp_a0 = (COARSE==1)? disp_a0r2 : disp_a0r;          //5/18/2015
    end
    else  begin: par_tb   //Parallel testbench
      bhvCountS # ( .WIDTH(3),
        .DCVALUE(1),
        .BUILD_DC(0) ) counter_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
        .cntEn(1'b1), .Q(valid_count), .dc() );

      // A step after nGrst or rst
      bhvEdge # (.REDGE(0)) edge_detect_0 (   // 1 - rising edge, or 0 - falling edge
        .nGrst(nGrst), .rst(1'b0), .clk(clk),
        .inp(rst),
        .outp(rst_tick) );

      always @(posedge clk or negedge nGrst)
        if (nGrst == 1'b0)
          step <= 1'b0;
        else
          if(rst==1'b1)
            step <= 1'b0;
          else
            if(rst_tick==1'b1)
              step <= 1'b1;


      assign load_argument =  (PAR_DIN_VALID_OPTION==0)? step :
                              (PAR_DIN_VALID_OPTION==1)? step & valid_count[0] :
                              (PAR_DIN_VALID_OPTION==2)? step & valid_count[1] :
                              (PAR_DIN_VALID_OPTION==3)? step & valid_count[2] : step;

      // Keep the input vectors to display them later
      bhvDelay # (.DELAY(ITERATIONS+2+2*COARSE),
          .WIDTH(3*IN_BITS) ) pipe_par_dly_0 (
        .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
        .inp({x0, y0, a0}),
        .outp({disp_x0, disp_y0, disp_a0}) );
    end
  endgenerate


//                            +-+-+-+-+-+-+ +-+-+
//                            |C|o|m|m|o|n| |T|B|
//                            +-+-+-+-+-+-+ +-+-+

  // Count new samples loaded
  bhvCountS # ( .WIDTH(ceil_log2(CHECKPTS)), .DCVALUE(),
                .BUILD_DC(0) ) inVectCount_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
    .cntEn(load_argument), .Q(inVectCount), .dc() );

  cordic_bhvInpVect inpVect_vectoring (
    .count(inVectCount),
    .xin(x0),
    .yin(y0),
    .ain(a0)  );

  // Count the golden output samples
  bhvCountS # ( .WIDTH(ceil_log2(CHECKPTS)+1),
                .DCVALUE(CHECKPTS),
                .BUILD_DC(1) ) goldVectCount_0 (
    .nGrst(nGrst), .rst(rst), .clk(clk), .clkEn(1'b1),
  .cntEn(dout_valid), .Q(goldVectCount_i), .dc(end_test) );

  assign goldVectCount = goldVectCount_i[ceil_log2(CHECKPTS)-1:0];

  generate if (MODE_ROTATION)
    begin: rotation_gold_vect
      cordic_bhvOutpVect goldVect_0 (
        .count(goldVectCount),
        .goldSample1(sin_gold),
        .goldSample2(cos_gold)  );
    end
  endgenerate

  generate if (MODE_VECTOR)
    begin: vectoring_gold_vect
      cordic_bhvOutpVect goldVect_0 (
        .count(goldVectCount),
        .goldSample1(magni_gold),
        .goldSample2(phase_gold)  );
    end
  endgenerate

  CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC #( .ARCHITECT(ARCHITECT),
                .MODE(MODE),
                .DP_OPTION(DP_OPTION),
                .DP_WIDTH(DP_WIDTH),
                .IN_BITS(IN_BITS),
                .OUT_BITS(OUT_BITS),
                .ITERATIONS(ITERATIONS),
                .ROUND(ROUND),
                .COARSE(COARSE) ) CORECORDIC_0 (
    .CLK(clk), .RST(rst),
    .NGRST(nGrst),
//sar68170 temp    .NGRST(1'b1),
    .DIN_VALID(load_argument),
    .RFD(rfd),                                        //4/23/2015
    .DOUT_VALID(dout_valid),
    .DIN_X(x0),
    .DIN_Y(y0),
    .DIN_A(a0),
    .DOUT_X(xn),
    .DOUT_Y(yn),
    .DOUT_A(an));

  // Check the results
  always @(posedge clk or negedge nGrst)
    if (nGrst == 1'b0)
      Fail = 1'b0;
    else if (rst==1'b1)
      Fail = 1'b0;

    else  begin
      if((dout_valid==1'b1) && MODE_ROTATION) begin
	      $display("Input x, y and rotation angle(rad). Fx-pt: %d, %d and %d; Fl-pt %.3f, %.3f and %.3f", $signed(disp_x0), $signed(disp_y0), $signed(disp_a0),
            $signed(disp_x0)/IN_SCALEFL, $signed(disp_y0)/IN_SCALEFL, (PI/2)*$signed(disp_a0)/IN_SCALEFL);
        $display("Expected x and y results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(sin_gold), $signed(cos_gold),
            $signed(sin_gold)/OUT_SCALEFL, $signed(cos_gold)/OUT_SCALEFL);

        if ( (xn == sin_gold) && (yn == cos_gold) )
		      $display("Passed");
        else  begin
          Fail = 1'b1;
		      $display("Error! Actual x and y results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(xn), $signed(yn),
            $signed(xn)/OUT_SCALEFL, $signed(yn)/OUT_SCALEFL);
        end
        $display("");
      end

      if((dout_valid==1'b1) && (MODE_VECTOR)) begin
	      $display("Input x and y. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(disp_x0), $signed(disp_y0),
            $signed(disp_x0)/IN_SCALEFL, $signed(disp_y0)/IN_SCALEFL);
        $display("Expected Magnitude and Phase (rad) results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(magni_gold), $signed(phase_gold),
            $signed(magni_gold)/OUT_SCALEFL, (PI/2)*$signed(phase_gold)/OUT_SCALEFL);

        if ( (xn == magni_gold) && (an == phase_gold) )
		      $display("Passed");
        else  begin
          Fail = 1'b1;
		      $display("Error! Actual Magnitude and Phase results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(xn), $signed(an),
            $signed(xn)/OUT_SCALEFL, (PI/2)*$signed(an)/OUT_SCALEFL);
        end
      end


      // Finish test
      if (end_test==1'b1) begin
        $display("************************************************************");
        if(ARCHITECT==1)            // Word-serial
  	      if (MODE_VECTOR)
            if (Fail == 1'b1)
              $display("**** Word-serial CORDIC Sqrt/Atan TEST FAILED *****");
            else
              $display("---- Word-serial CORDIC Sqrt/Atan test passed -----");
          else
            if (Fail == 1'b1)
              $display("**** Word-serial CORDIC Rotation TEST FAILED *****");
            else
              $display("---- Word-serial CORDIC Rotation test passed -----");


        if(ARCHITECT==2)            // Parallel
  	      if (MODE_VECTOR)
            if (Fail == 1'b1)
              $display("**** Parallel CORDIC Sqrt/Atan TEST FAILED *****");
            else
              $display("---- Parallel CORDIC Sqrt/Atan test passed -----");
          else
            if (Fail == 1'b1)
              $display("**** Parallel CORDIC Rotation TEST FAILED *****");
            else
              $display("---- Parallel CORDIC Rotation test passed -----");

        $display("**********************************************************");
		    $stop;
      end
    end

//4/23/2015  bhvClockGen # (.CLKPERIOD(10), .NGRSTLASTS(17)) clk_gen_0 (
//4/23/2015    .clk(clk), .rst(rst), .nGrst(nGrst) );
  bhvClkGen # (.CLKPERIOD(10), .NGRSTLASTS(17), .RST_DLY(10)) clk_gen_0 (
    .clk(clk), .rst(rst), .nGrst(nGrst) );

//                              +-+-+-+-+-+-+-+-+-+
//                              |F|u|n|c|t|i|o|n|s|
//                              +-+-+-+-+-+-+-+-+-+
//  ---------------------------------------------------------------------------
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

  function real real_antilog2;
      input integer x;
      integer tmp;
      real res;
    begin
      if(x>48) $display("Invalid argument for 'antilog2' function");
      tmp = 0;
      res = 1.0;
      while (tmp < x) begin
        tmp = tmp + 1;
        res = res * 2.0;
      end
      real_antilog2 = res;
    end
  endfunction


endmodule
