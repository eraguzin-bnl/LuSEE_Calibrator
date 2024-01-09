`timescale 1 ns/100 ps
// Version: 2022.3 2022.3.0.8


module CALFIFO_C0_CALFIFO_C0_0_USRAM_top(
       R_DATA,
       W_DATA,
       R_ADDR,
       W_ADDR,
       BLK_EN,
       R_ADDR_SRST_N,
       R_DATA_SRST_N,
       R_ADDR_EN,
       R_DATA_EN,
       CLK,
       W_EN
    );
output [11:0] R_DATA;
input  [11:0] W_DATA;
input  [8:0] R_ADDR;
input  [8:0] W_ADDR;
input  BLK_EN;
input  R_ADDR_SRST_N;
input  R_DATA_SRST_N;
input  R_ADDR_EN;
input  R_DATA_EN;
input  CLK;
input  W_EN;

    wire \R_DATA_TEMPR0[0] , \R_DATA_TEMPR1[0] , \R_DATA_TEMPR2[0] , 
        \R_DATA_TEMPR3[0] , \R_DATA_TEMPR4[0] , \R_DATA_TEMPR5[0] , 
        \R_DATA_TEMPR6[0] , \R_DATA_TEMPR7[0] , \R_DATA_TEMPR0[1] , 
        \R_DATA_TEMPR1[1] , \R_DATA_TEMPR2[1] , \R_DATA_TEMPR3[1] , 
        \R_DATA_TEMPR4[1] , \R_DATA_TEMPR5[1] , \R_DATA_TEMPR6[1] , 
        \R_DATA_TEMPR7[1] , \R_DATA_TEMPR0[2] , \R_DATA_TEMPR1[2] , 
        \R_DATA_TEMPR2[2] , \R_DATA_TEMPR3[2] , \R_DATA_TEMPR4[2] , 
        \R_DATA_TEMPR5[2] , \R_DATA_TEMPR6[2] , \R_DATA_TEMPR7[2] , 
        \R_DATA_TEMPR0[3] , \R_DATA_TEMPR1[3] , \R_DATA_TEMPR2[3] , 
        \R_DATA_TEMPR3[3] , \R_DATA_TEMPR4[3] , \R_DATA_TEMPR5[3] , 
        \R_DATA_TEMPR6[3] , \R_DATA_TEMPR7[3] , \R_DATA_TEMPR0[4] , 
        \R_DATA_TEMPR1[4] , \R_DATA_TEMPR2[4] , \R_DATA_TEMPR3[4] , 
        \R_DATA_TEMPR4[4] , \R_DATA_TEMPR5[4] , \R_DATA_TEMPR6[4] , 
        \R_DATA_TEMPR7[4] , \R_DATA_TEMPR0[5] , \R_DATA_TEMPR1[5] , 
        \R_DATA_TEMPR2[5] , \R_DATA_TEMPR3[5] , \R_DATA_TEMPR4[5] , 
        \R_DATA_TEMPR5[5] , \R_DATA_TEMPR6[5] , \R_DATA_TEMPR7[5] , 
        \R_DATA_TEMPR0[6] , \R_DATA_TEMPR1[6] , \R_DATA_TEMPR2[6] , 
        \R_DATA_TEMPR3[6] , \R_DATA_TEMPR4[6] , \R_DATA_TEMPR5[6] , 
        \R_DATA_TEMPR6[6] , \R_DATA_TEMPR7[6] , \R_DATA_TEMPR0[7] , 
        \R_DATA_TEMPR1[7] , \R_DATA_TEMPR2[7] , \R_DATA_TEMPR3[7] , 
        \R_DATA_TEMPR4[7] , \R_DATA_TEMPR5[7] , \R_DATA_TEMPR6[7] , 
        \R_DATA_TEMPR7[7] , \R_DATA_TEMPR0[8] , \R_DATA_TEMPR1[8] , 
        \R_DATA_TEMPR2[8] , \R_DATA_TEMPR3[8] , \R_DATA_TEMPR4[8] , 
        \R_DATA_TEMPR5[8] , \R_DATA_TEMPR6[8] , \R_DATA_TEMPR7[8] , 
        \R_DATA_TEMPR0[9] , \R_DATA_TEMPR1[9] , \R_DATA_TEMPR2[9] , 
        \R_DATA_TEMPR3[9] , \R_DATA_TEMPR4[9] , \R_DATA_TEMPR5[9] , 
        \R_DATA_TEMPR6[9] , \R_DATA_TEMPR7[9] , \R_DATA_TEMPR0[10] , 
        \R_DATA_TEMPR1[10] , \R_DATA_TEMPR2[10] , \R_DATA_TEMPR3[10] , 
        \R_DATA_TEMPR4[10] , \R_DATA_TEMPR5[10] , \R_DATA_TEMPR6[10] , 
        \R_DATA_TEMPR7[10] , \R_DATA_TEMPR0[11] , \R_DATA_TEMPR1[11] , 
        \R_DATA_TEMPR2[11] , \R_DATA_TEMPR3[11] , \R_DATA_TEMPR4[11] , 
        \R_DATA_TEMPR5[11] , \R_DATA_TEMPR6[11] , \R_DATA_TEMPR7[11] , 
        \BLKX0[0] , \BLKX0[1] , \BLKX0[2] , \BLKX0[3] , \BLKX0[4] , 
        \BLKX0[5] , \BLKX0[6] , \BLKX0[7] , \BLKZ0[0] , \BLKZ0[1] , 
        \BLKZ0[2] , \BLKZ0[3] , \BLKZ0[4] , \BLKZ0[5] , \BLKZ0[6] , 
        \BLKZ0[7] , \ACCESS_BUSY[0][0] , \ACCESS_BUSY[1][0] , 
        \ACCESS_BUSY[2][0] , \ACCESS_BUSY[3][0] , \ACCESS_BUSY[4][0] , 
        \ACCESS_BUSY[5][0] , \ACCESS_BUSY[6][0] , \ACCESS_BUSY[7][0] , 
        OR4_10_Y, OR2_5_Y, OR4_0_Y, OR2_0_Y, CFG2_3_Y, CFG2_1_Y, 
        CFG2_2_Y, CFG2_0_Y, OR4_3_Y, OR2_7_Y, OR4_8_Y, OR2_3_Y, 
        OR4_5_Y, OR2_1_Y, OR4_11_Y, OR2_9_Y, OR4_2_Y, OR2_4_Y, OR4_1_Y, 
        OR2_8_Y, CFG2_6_Y, CFG2_7_Y, CFG2_5_Y, CFG2_4_Y, OR4_4_Y, 
        OR2_2_Y, OR4_6_Y, OR2_10_Y, OR4_7_Y, OR2_6_Y, OR4_9_Y, 
        OR2_11_Y, VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    OR4 \OR4_R_DATA[11]  (.A(OR4_3_Y), .B(OR2_7_Y), .C(
        \R_DATA_TEMPR6[11] ), .D(\R_DATA_TEMPR7[11] ), .Y(R_DATA[11]));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[4]  (.A(CFG2_3_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[4] ));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[6]  (.A(CFG2_5_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[6] ));
    CFG2 #( .INIT(4'h2) )  CFG2_2 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_2_Y));
    OR2 OR2_10 (.A(\R_DATA_TEMPR4[10] ), .B(\R_DATA_TEMPR5[10] ), .Y(
        OR2_10_Y));
    OR4 \OR4_R_DATA[9]  (.A(OR4_2_Y), .B(OR2_4_Y), .C(
        \R_DATA_TEMPR6[9] ), .D(\R_DATA_TEMPR7[9] ), .Y(R_DATA[9]));
    OR4 OR4_1 (.A(\R_DATA_TEMPR0[5] ), .B(\R_DATA_TEMPR1[5] ), .C(
        \R_DATA_TEMPR2[5] ), .D(\R_DATA_TEMPR3[5] ), .Y(OR4_1_Y));
    OR4 \OR4_R_DATA[10]  (.A(OR4_6_Y), .B(OR2_10_Y), .C(
        \R_DATA_TEMPR6[10] ), .D(\R_DATA_TEMPR7[10] ), .Y(R_DATA[10]));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%3%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R3C0 (.BLK_EN(\BLKX0[3] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[3] ), .ACCESS_BUSY(
        \ACCESS_BUSY[3][0] ), .R_DATA({\R_DATA_TEMPR3[11] , 
        \R_DATA_TEMPR3[10] , \R_DATA_TEMPR3[9] , \R_DATA_TEMPR3[8] , 
        \R_DATA_TEMPR3[7] , \R_DATA_TEMPR3[6] , \R_DATA_TEMPR3[5] , 
        \R_DATA_TEMPR3[4] , \R_DATA_TEMPR3[3] , \R_DATA_TEMPR3[2] , 
        \R_DATA_TEMPR3[1] , \R_DATA_TEMPR3[0] }));
    OR4 \OR4_R_DATA[3]  (.A(OR4_5_Y), .B(OR2_1_Y), .C(
        \R_DATA_TEMPR6[3] ), .D(\R_DATA_TEMPR7[3] ), .Y(R_DATA[3]));
    OR2 OR2_5 (.A(\R_DATA_TEMPR4[1] ), .B(\R_DATA_TEMPR5[1] ), .Y(
        OR2_5_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[5]  (.A(CFG2_1_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[5] ));
    OR2 OR2_11 (.A(\R_DATA_TEMPR4[4] ), .B(\R_DATA_TEMPR5[4] ), .Y(
        OR2_11_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[2]  (.A(CFG2_2_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[2] ));
    OR4 OR4_9 (.A(\R_DATA_TEMPR0[4] ), .B(\R_DATA_TEMPR1[4] ), .C(
        \R_DATA_TEMPR2[4] ), .D(\R_DATA_TEMPR3[4] ), .Y(OR4_9_Y));
    OR4 \OR4_R_DATA[1]  (.A(OR4_10_Y), .B(OR2_5_Y), .C(
        \R_DATA_TEMPR6[1] ), .D(\R_DATA_TEMPR7[1] ), .Y(R_DATA[1]));
    OR4 \OR4_R_DATA[8]  (.A(OR4_4_Y), .B(OR2_2_Y), .C(
        \R_DATA_TEMPR6[8] ), .D(\R_DATA_TEMPR7[8] ), .Y(R_DATA[8]));
    CFG2 #( .INIT(4'h2) )  CFG2_5 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_5_Y));
    OR4 OR4_4 (.A(\R_DATA_TEMPR0[8] ), .B(\R_DATA_TEMPR1[8] ), .C(
        \R_DATA_TEMPR2[8] ), .D(\R_DATA_TEMPR3[8] ), .Y(OR4_4_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[0]  (.A(CFG2_3_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[0] ));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%1%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R1C0 (.BLK_EN(\BLKX0[1] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[1] ), .ACCESS_BUSY(
        \ACCESS_BUSY[1][0] ), .R_DATA({\R_DATA_TEMPR1[11] , 
        \R_DATA_TEMPR1[10] , \R_DATA_TEMPR1[9] , \R_DATA_TEMPR1[8] , 
        \R_DATA_TEMPR1[7] , \R_DATA_TEMPR1[6] , \R_DATA_TEMPR1[5] , 
        \R_DATA_TEMPR1[4] , \R_DATA_TEMPR1[3] , \R_DATA_TEMPR1[2] , 
        \R_DATA_TEMPR1[1] , \R_DATA_TEMPR1[0] }));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[3]  (.A(CFG2_4_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[3] ));
    OR4 \OR4_R_DATA[0]  (.A(OR4_8_Y), .B(OR2_3_Y), .C(
        \R_DATA_TEMPR6[0] ), .D(\R_DATA_TEMPR7[0] ), .Y(R_DATA[0]));
    OR4 OR4_10 (.A(\R_DATA_TEMPR0[1] ), .B(\R_DATA_TEMPR1[1] ), .C(
        \R_DATA_TEMPR2[1] ), .D(\R_DATA_TEMPR3[1] ), .Y(OR4_10_Y));
    OR4 \OR4_R_DATA[2]  (.A(OR4_11_Y), .B(OR2_9_Y), .C(
        \R_DATA_TEMPR6[2] ), .D(\R_DATA_TEMPR7[2] ), .Y(R_DATA[2]));
    OR4 OR4_2 (.A(\R_DATA_TEMPR0[9] ), .B(\R_DATA_TEMPR1[9] ), .C(
        \R_DATA_TEMPR2[9] ), .D(\R_DATA_TEMPR3[9] ), .Y(OR4_2_Y));
    CFG2 #( .INIT(4'h4) )  CFG2_7 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_7_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[7]  (.A(CFG2_4_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[7] ));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[1]  (.A(CFG2_1_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[1] ));
    OR2 OR2_0 (.A(\R_DATA_TEMPR4[7] ), .B(\R_DATA_TEMPR5[7] ), .Y(
        OR2_0_Y));
    OR4 OR4_11 (.A(\R_DATA_TEMPR0[2] ), .B(\R_DATA_TEMPR1[2] ), .C(
        \R_DATA_TEMPR2[2] ), .D(\R_DATA_TEMPR3[2] ), .Y(OR4_11_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[6]  (.A(CFG2_2_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[6] ));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%6%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R6C0 (.BLK_EN(\BLKX0[6] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[6] ), .ACCESS_BUSY(
        \ACCESS_BUSY[6][0] ), .R_DATA({\R_DATA_TEMPR6[11] , 
        \R_DATA_TEMPR6[10] , \R_DATA_TEMPR6[9] , \R_DATA_TEMPR6[8] , 
        \R_DATA_TEMPR6[7] , \R_DATA_TEMPR6[6] , \R_DATA_TEMPR6[5] , 
        \R_DATA_TEMPR6[4] , \R_DATA_TEMPR6[3] , \R_DATA_TEMPR6[2] , 
        \R_DATA_TEMPR6[1] , \R_DATA_TEMPR6[0] }));
    OR2 OR2_8 (.A(\R_DATA_TEMPR4[5] ), .B(\R_DATA_TEMPR5[5] ), .Y(
        OR2_8_Y));
    OR2 OR2_7 (.A(\R_DATA_TEMPR4[11] ), .B(\R_DATA_TEMPR5[11] ), .Y(
        OR2_7_Y));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%5%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R5C0 (.BLK_EN(\BLKX0[5] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[5] ), .ACCESS_BUSY(
        \ACCESS_BUSY[5][0] ), .R_DATA({\R_DATA_TEMPR5[11] , 
        \R_DATA_TEMPR5[10] , \R_DATA_TEMPR5[9] , \R_DATA_TEMPR5[8] , 
        \R_DATA_TEMPR5[7] , \R_DATA_TEMPR5[6] , \R_DATA_TEMPR5[5] , 
        \R_DATA_TEMPR5[4] , \R_DATA_TEMPR5[3] , \R_DATA_TEMPR5[2] , 
        \R_DATA_TEMPR5[1] , \R_DATA_TEMPR5[0] }));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[4]  (.A(CFG2_6_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[4] ));
    OR4 OR4_6 (.A(\R_DATA_TEMPR0[10] ), .B(\R_DATA_TEMPR1[10] ), .C(
        \R_DATA_TEMPR2[10] ), .D(\R_DATA_TEMPR3[10] ), .Y(OR4_6_Y));
    OR4 OR4_8 (.A(\R_DATA_TEMPR0[0] ), .B(\R_DATA_TEMPR1[0] ), .C(
        \R_DATA_TEMPR2[0] ), .D(\R_DATA_TEMPR3[0] ), .Y(OR4_8_Y));
    CFG2 #( .INIT(4'h4) )  CFG2_1 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_1_Y));
    CFG2 #( .INIT(4'h8) )  CFG2_4 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_4_Y));
    OR2 OR2_6 (.A(\R_DATA_TEMPR4[6] ), .B(\R_DATA_TEMPR5[6] ), .Y(
        OR2_6_Y));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%4%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R4C0 (.BLK_EN(\BLKX0[4] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[4] ), .ACCESS_BUSY(
        \ACCESS_BUSY[4][0] ), .R_DATA({\R_DATA_TEMPR4[11] , 
        \R_DATA_TEMPR4[10] , \R_DATA_TEMPR4[9] , \R_DATA_TEMPR4[8] , 
        \R_DATA_TEMPR4[7] , \R_DATA_TEMPR4[6] , \R_DATA_TEMPR4[5] , 
        \R_DATA_TEMPR4[4] , \R_DATA_TEMPR4[3] , \R_DATA_TEMPR4[2] , 
        \R_DATA_TEMPR4[1] , \R_DATA_TEMPR4[0] }));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%0%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R0C0 (.BLK_EN(\BLKX0[0] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[0] ), .ACCESS_BUSY(
        \ACCESS_BUSY[0][0] ), .R_DATA({\R_DATA_TEMPR0[11] , 
        \R_DATA_TEMPR0[10] , \R_DATA_TEMPR0[9] , \R_DATA_TEMPR0[8] , 
        \R_DATA_TEMPR0[7] , \R_DATA_TEMPR0[6] , \R_DATA_TEMPR0[5] , 
        \R_DATA_TEMPR0[4] , \R_DATA_TEMPR0[3] , \R_DATA_TEMPR0[2] , 
        \R_DATA_TEMPR0[1] , \R_DATA_TEMPR0[0] }));
    OR2 OR2_3 (.A(\R_DATA_TEMPR4[0] ), .B(\R_DATA_TEMPR5[0] ), .Y(
        OR2_3_Y));
    OR4 OR4_3 (.A(\R_DATA_TEMPR0[11] ), .B(\R_DATA_TEMPR1[11] ), .C(
        \R_DATA_TEMPR2[11] ), .D(\R_DATA_TEMPR3[11] ), .Y(OR4_3_Y));
    CFG2 #( .INIT(4'h1) )  CFG2_6 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_6_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[5]  (.A(CFG2_7_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[5] ));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[2]  (.A(CFG2_5_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[2] ));
    OR4 OR4_0 (.A(\R_DATA_TEMPR0[7] ), .B(\R_DATA_TEMPR1[7] ), .C(
        \R_DATA_TEMPR2[7] ), .D(\R_DATA_TEMPR3[7] ), .Y(OR4_0_Y));
    CFG2 #( .INIT(4'h8) )  CFG2_0 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_0_Y));
    OR2 OR2_9 (.A(\R_DATA_TEMPR4[2] ), .B(\R_DATA_TEMPR5[2] ), .Y(
        OR2_9_Y));
    CFG2 #( .INIT(4'h1) )  CFG2_3 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_3_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[3]  (.A(CFG2_0_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[3] ));
    OR2 OR2_1 (.A(\R_DATA_TEMPR4[3] ), .B(\R_DATA_TEMPR5[3] ), .Y(
        OR2_1_Y));
    OR4 \OR4_R_DATA[4]  (.A(OR4_9_Y), .B(OR2_11_Y), .C(
        \R_DATA_TEMPR6[4] ), .D(\R_DATA_TEMPR7[4] ), .Y(R_DATA[4]));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[0]  (.A(CFG2_6_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[0] ));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[7]  (.A(CFG2_0_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[7] ));
    OR4 OR4_7 (.A(\R_DATA_TEMPR0[6] ), .B(\R_DATA_TEMPR1[6] ), .C(
        \R_DATA_TEMPR2[6] ), .D(\R_DATA_TEMPR3[6] ), .Y(OR4_7_Y));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%7%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R7C0 (.BLK_EN(\BLKX0[7] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[7] ), .ACCESS_BUSY(
        \ACCESS_BUSY[7][0] ), .R_DATA({\R_DATA_TEMPR7[11] , 
        \R_DATA_TEMPR7[10] , \R_DATA_TEMPR7[9] , \R_DATA_TEMPR7[8] , 
        \R_DATA_TEMPR7[7] , \R_DATA_TEMPR7[6] , \R_DATA_TEMPR7[5] , 
        \R_DATA_TEMPR7[4] , \R_DATA_TEMPR7[3] , \R_DATA_TEMPR7[2] , 
        \R_DATA_TEMPR7[1] , \R_DATA_TEMPR7[0] }));
    OR2 OR2_4 (.A(\R_DATA_TEMPR4[9] ), .B(\R_DATA_TEMPR5[9] ), .Y(
        OR2_4_Y));
    OR4 \OR4_R_DATA[5]  (.A(OR4_1_Y), .B(OR2_8_Y), .C(
        \R_DATA_TEMPR6[5] ), .D(\R_DATA_TEMPR7[5] ), .Y(R_DATA[5]));
    OR4 \OR4_R_DATA[7]  (.A(OR4_0_Y), .B(OR2_0_Y), .C(
        \R_DATA_TEMPR6[7] ), .D(\R_DATA_TEMPR7[7] ), .Y(R_DATA[7]));
    OR4 \OR4_R_DATA[6]  (.A(OR4_7_Y), .B(OR2_6_Y), .C(
        \R_DATA_TEMPR6[6] ), .D(\R_DATA_TEMPR7[6] ), .Y(R_DATA[6]));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[1]  (.A(CFG2_7_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[1] ));
    RAM64x12 #( .RAMINDEX("core%512%12%SPEED%2%0%MICRO_RAM") )  
        CALFIFO_C0_CALFIFO_C0_0_USRAM_top_R2C0 (.BLK_EN(\BLKX0[2] ), 
        .BUSY_FB(GND), .R_ADDR({R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0]}), .R_ADDR_AD_N(VCC), 
        .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), .R_ADDR_EN(R_ADDR_EN), 
        .R_ADDR_SD(GND), .R_ADDR_SL_N(R_ADDR_SRST_N), .R_CLK(CLK), 
        .R_DATA_AD_N(VCC), .R_DATA_AL_N(VCC), .R_DATA_BYPASS(GND), 
        .R_DATA_EN(R_DATA_EN), .R_DATA_SD(GND), .R_DATA_SL_N(
        R_DATA_SRST_N), .W_ADDR({W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0]}), .W_CLK(CLK), .W_DATA({
        W_DATA[11], W_DATA[10], W_DATA[9], W_DATA[8], W_DATA[7], 
        W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], W_DATA[2], 
        W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[2] ), .ACCESS_BUSY(
        \ACCESS_BUSY[2][0] ), .R_DATA({\R_DATA_TEMPR2[11] , 
        \R_DATA_TEMPR2[10] , \R_DATA_TEMPR2[9] , \R_DATA_TEMPR2[8] , 
        \R_DATA_TEMPR2[7] , \R_DATA_TEMPR2[6] , \R_DATA_TEMPR2[5] , 
        \R_DATA_TEMPR2[4] , \R_DATA_TEMPR2[3] , \R_DATA_TEMPR2[2] , 
        \R_DATA_TEMPR2[1] , \R_DATA_TEMPR2[0] }));
    OR4 OR4_5 (.A(\R_DATA_TEMPR0[3] ), .B(\R_DATA_TEMPR1[3] ), .C(
        \R_DATA_TEMPR2[3] ), .D(\R_DATA_TEMPR3[3] ), .Y(OR4_5_Y));
    OR2 OR2_2 (.A(\R_DATA_TEMPR4[8] ), .B(\R_DATA_TEMPR5[8] ), .Y(
        OR2_2_Y));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
