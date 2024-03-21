`timescale 1 ns/100 ps
// Version: 2024.1 2024.1.0.3


module CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top(
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
output [27:0] R_DATA;
input  [27:0] W_DATA;
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
        \R_DATA_TEMPR0[12] , \R_DATA_TEMPR1[12] , \R_DATA_TEMPR2[12] , 
        \R_DATA_TEMPR3[12] , \R_DATA_TEMPR4[12] , \R_DATA_TEMPR5[12] , 
        \R_DATA_TEMPR6[12] , \R_DATA_TEMPR7[12] , \R_DATA_TEMPR0[13] , 
        \R_DATA_TEMPR1[13] , \R_DATA_TEMPR2[13] , \R_DATA_TEMPR3[13] , 
        \R_DATA_TEMPR4[13] , \R_DATA_TEMPR5[13] , \R_DATA_TEMPR6[13] , 
        \R_DATA_TEMPR7[13] , \R_DATA_TEMPR0[14] , \R_DATA_TEMPR1[14] , 
        \R_DATA_TEMPR2[14] , \R_DATA_TEMPR3[14] , \R_DATA_TEMPR4[14] , 
        \R_DATA_TEMPR5[14] , \R_DATA_TEMPR6[14] , \R_DATA_TEMPR7[14] , 
        \R_DATA_TEMPR0[15] , \R_DATA_TEMPR1[15] , \R_DATA_TEMPR2[15] , 
        \R_DATA_TEMPR3[15] , \R_DATA_TEMPR4[15] , \R_DATA_TEMPR5[15] , 
        \R_DATA_TEMPR6[15] , \R_DATA_TEMPR7[15] , \R_DATA_TEMPR0[16] , 
        \R_DATA_TEMPR1[16] , \R_DATA_TEMPR2[16] , \R_DATA_TEMPR3[16] , 
        \R_DATA_TEMPR4[16] , \R_DATA_TEMPR5[16] , \R_DATA_TEMPR6[16] , 
        \R_DATA_TEMPR7[16] , \R_DATA_TEMPR0[17] , \R_DATA_TEMPR1[17] , 
        \R_DATA_TEMPR2[17] , \R_DATA_TEMPR3[17] , \R_DATA_TEMPR4[17] , 
        \R_DATA_TEMPR5[17] , \R_DATA_TEMPR6[17] , \R_DATA_TEMPR7[17] , 
        \R_DATA_TEMPR0[18] , \R_DATA_TEMPR1[18] , \R_DATA_TEMPR2[18] , 
        \R_DATA_TEMPR3[18] , \R_DATA_TEMPR4[18] , \R_DATA_TEMPR5[18] , 
        \R_DATA_TEMPR6[18] , \R_DATA_TEMPR7[18] , \R_DATA_TEMPR0[19] , 
        \R_DATA_TEMPR1[19] , \R_DATA_TEMPR2[19] , \R_DATA_TEMPR3[19] , 
        \R_DATA_TEMPR4[19] , \R_DATA_TEMPR5[19] , \R_DATA_TEMPR6[19] , 
        \R_DATA_TEMPR7[19] , \R_DATA_TEMPR0[20] , \R_DATA_TEMPR1[20] , 
        \R_DATA_TEMPR2[20] , \R_DATA_TEMPR3[20] , \R_DATA_TEMPR4[20] , 
        \R_DATA_TEMPR5[20] , \R_DATA_TEMPR6[20] , \R_DATA_TEMPR7[20] , 
        \R_DATA_TEMPR0[21] , \R_DATA_TEMPR1[21] , \R_DATA_TEMPR2[21] , 
        \R_DATA_TEMPR3[21] , \R_DATA_TEMPR4[21] , \R_DATA_TEMPR5[21] , 
        \R_DATA_TEMPR6[21] , \R_DATA_TEMPR7[21] , \R_DATA_TEMPR0[22] , 
        \R_DATA_TEMPR1[22] , \R_DATA_TEMPR2[22] , \R_DATA_TEMPR3[22] , 
        \R_DATA_TEMPR4[22] , \R_DATA_TEMPR5[22] , \R_DATA_TEMPR6[22] , 
        \R_DATA_TEMPR7[22] , \R_DATA_TEMPR0[23] , \R_DATA_TEMPR1[23] , 
        \R_DATA_TEMPR2[23] , \R_DATA_TEMPR3[23] , \R_DATA_TEMPR4[23] , 
        \R_DATA_TEMPR5[23] , \R_DATA_TEMPR6[23] , \R_DATA_TEMPR7[23] , 
        \R_DATA_TEMPR0[24] , \R_DATA_TEMPR1[24] , \R_DATA_TEMPR2[24] , 
        \R_DATA_TEMPR3[24] , \R_DATA_TEMPR4[24] , \R_DATA_TEMPR5[24] , 
        \R_DATA_TEMPR6[24] , \R_DATA_TEMPR7[24] , \R_DATA_TEMPR0[25] , 
        \R_DATA_TEMPR1[25] , \R_DATA_TEMPR2[25] , \R_DATA_TEMPR3[25] , 
        \R_DATA_TEMPR4[25] , \R_DATA_TEMPR5[25] , \R_DATA_TEMPR6[25] , 
        \R_DATA_TEMPR7[25] , \R_DATA_TEMPR0[26] , \R_DATA_TEMPR1[26] , 
        \R_DATA_TEMPR2[26] , \R_DATA_TEMPR3[26] , \R_DATA_TEMPR4[26] , 
        \R_DATA_TEMPR5[26] , \R_DATA_TEMPR6[26] , \R_DATA_TEMPR7[26] , 
        \R_DATA_TEMPR0[27] , \R_DATA_TEMPR1[27] , \R_DATA_TEMPR2[27] , 
        \R_DATA_TEMPR3[27] , \R_DATA_TEMPR4[27] , \R_DATA_TEMPR5[27] , 
        \R_DATA_TEMPR6[27] , \R_DATA_TEMPR7[27] , \BLKX0[0] , 
        \BLKX0[1] , \BLKX0[2] , \BLKX0[3] , \BLKX0[4] , \BLKX0[5] , 
        \BLKX0[6] , \BLKX0[7] , \BLKZ0[0] , \BLKZ0[1] , \BLKZ0[2] , 
        \BLKZ0[3] , \BLKZ0[4] , \BLKZ0[5] , \BLKZ0[6] , \BLKZ0[7] , 
        \ACCESS_BUSY[0][0] , \ACCESS_BUSY[0][1] , \ACCESS_BUSY[0][2] , 
        \ACCESS_BUSY[1][0] , \ACCESS_BUSY[1][1] , \ACCESS_BUSY[1][2] , 
        \ACCESS_BUSY[2][0] , \ACCESS_BUSY[2][1] , \ACCESS_BUSY[2][2] , 
        \ACCESS_BUSY[3][0] , \ACCESS_BUSY[3][1] , \ACCESS_BUSY[3][2] , 
        \ACCESS_BUSY[4][0] , \ACCESS_BUSY[4][1] , \ACCESS_BUSY[4][2] , 
        \ACCESS_BUSY[5][0] , \ACCESS_BUSY[5][1] , \ACCESS_BUSY[5][2] , 
        \ACCESS_BUSY[6][0] , \ACCESS_BUSY[6][1] , \ACCESS_BUSY[6][2] , 
        \ACCESS_BUSY[7][0] , \ACCESS_BUSY[7][1] , \ACCESS_BUSY[7][2] , 
        OR4_0_Y, OR2_4_Y, OR4_24_Y, OR2_24_Y, OR4_17_Y, OR2_13_Y, 
        OR4_14_Y, OR2_17_Y, OR4_23_Y, OR2_8_Y, OR4_11_Y, OR2_27_Y, 
        OR4_12_Y, OR2_5_Y, OR4_6_Y, OR2_16_Y, CFG2_3_Y, CFG2_1_Y, 
        CFG2_2_Y, CFG2_0_Y, OR4_15_Y, OR2_26_Y, OR4_16_Y, OR2_2_Y, 
        OR4_8_Y, OR2_12_Y, OR4_20_Y, OR2_23_Y, OR4_19_Y, OR2_1_Y, 
        OR4_5_Y, OR2_3_Y, OR4_21_Y, OR2_18_Y, OR4_26_Y, OR2_22_Y, 
        OR4_18_Y, OR2_6_Y, OR4_13_Y, OR2_21_Y, OR4_9_Y, OR2_11_Y, 
        OR4_10_Y, OR2_19_Y, OR4_7_Y, OR2_20_Y, OR4_2_Y, OR2_25_Y, 
        OR4_22_Y, OR2_10_Y, CFG2_6_Y, CFG2_7_Y, CFG2_5_Y, CFG2_4_Y, 
        OR4_4_Y, OR2_0_Y, OR4_27_Y, OR2_7_Y, OR4_1_Y, OR2_15_Y, 
        OR4_3_Y, OR2_9_Y, OR4_25_Y, OR2_14_Y, VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    OR4 \OR4_R_DATA[11]  (.A(OR4_10_Y), .B(OR2_19_Y), .C(
        \R_DATA_TEMPR6[11] ), .D(\R_DATA_TEMPR7[11] ), .Y(R_DATA[11]));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[4]  (.A(CFG2_3_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[4] ));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[6]  (.A(CFG2_5_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[6] ));
    OR4 OR4_23 (.A(\R_DATA_TEMPR0[0] ), .B(\R_DATA_TEMPR1[0] ), .C(
        \R_DATA_TEMPR2[0] ), .D(\R_DATA_TEMPR3[0] ), .Y(OR4_23_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%4%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R4C0 
        (.BLK_EN(\BLKX0[4] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[4] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[4][0] ), .R_DATA({nc0, nc1, 
        \R_DATA_TEMPR4[9] , \R_DATA_TEMPR4[8] , \R_DATA_TEMPR4[7] , 
        \R_DATA_TEMPR4[6] , \R_DATA_TEMPR4[5] , \R_DATA_TEMPR4[4] , 
        \R_DATA_TEMPR4[3] , \R_DATA_TEMPR4[2] , \R_DATA_TEMPR4[1] , 
        \R_DATA_TEMPR4[0] }));
    CFG2 #( .INIT(4'h2) )  CFG2_2 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_2_Y));
    OR2 OR2_10 (.A(\R_DATA_TEMPR4[13] ), .B(\R_DATA_TEMPR5[13] ), .Y(
        OR2_10_Y));
    OR4 \OR4_R_DATA[9]  (.A(OR4_8_Y), .B(OR2_12_Y), .C(
        \R_DATA_TEMPR6[9] ), .D(\R_DATA_TEMPR7[9] ), .Y(R_DATA[9]));
    OR4 \OR4_R_DATA[22]  (.A(OR4_17_Y), .B(OR2_13_Y), .C(
        \R_DATA_TEMPR6[22] ), .D(\R_DATA_TEMPR7[22] ), .Y(R_DATA[22]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%1%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R1C1 
        (.BLK_EN(\BLKX0[1] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[1] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[1][1] ), .R_DATA({nc2, nc3, 
        \R_DATA_TEMPR1[19] , \R_DATA_TEMPR1[18] , \R_DATA_TEMPR1[17] , 
        \R_DATA_TEMPR1[16] , \R_DATA_TEMPR1[15] , \R_DATA_TEMPR1[14] , 
        \R_DATA_TEMPR1[13] , \R_DATA_TEMPR1[12] , \R_DATA_TEMPR1[11] , 
        \R_DATA_TEMPR1[10] }));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%7%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R7C2 
        (.BLK_EN(\BLKX0[7] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[7] ), .ACCESS_BUSY(
        \ACCESS_BUSY[7][2] ), .R_DATA({nc4, nc5, nc6, nc7, 
        \R_DATA_TEMPR7[27] , \R_DATA_TEMPR7[26] , \R_DATA_TEMPR7[25] , 
        \R_DATA_TEMPR7[24] , \R_DATA_TEMPR7[23] , \R_DATA_TEMPR7[22] , 
        \R_DATA_TEMPR7[21] , \R_DATA_TEMPR7[20] }));
    OR4 \OR4_R_DATA[10]  (.A(OR4_20_Y), .B(OR2_23_Y), .C(
        \R_DATA_TEMPR6[10] ), .D(\R_DATA_TEMPR7[10] ), .Y(R_DATA[10]));
    OR4 OR4_1 (.A(\R_DATA_TEMPR0[14] ), .B(\R_DATA_TEMPR1[14] ), .C(
        \R_DATA_TEMPR2[14] ), .D(\R_DATA_TEMPR3[14] ), .Y(OR4_1_Y));
    OR4 \OR4_R_DATA[17]  (.A(OR4_13_Y), .B(OR2_21_Y), .C(
        \R_DATA_TEMPR6[17] ), .D(\R_DATA_TEMPR7[17] ), .Y(R_DATA[17]));
    OR2 OR2_14 (.A(\R_DATA_TEMPR4[1] ), .B(\R_DATA_TEMPR5[1] ), .Y(
        OR2_14_Y));
    OR4 \OR4_R_DATA[3]  (.A(OR4_19_Y), .B(OR2_1_Y), .C(
        \R_DATA_TEMPR6[3] ), .D(\R_DATA_TEMPR7[3] ), .Y(R_DATA[3]));
    OR2 OR2_5 (.A(\R_DATA_TEMPR4[19] ), .B(\R_DATA_TEMPR5[19] ), .Y(
        OR2_5_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%3%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R3C1 
        (.BLK_EN(\BLKX0[3] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[3] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[3][1] ), .R_DATA({nc8, nc9, 
        \R_DATA_TEMPR3[19] , \R_DATA_TEMPR3[18] , \R_DATA_TEMPR3[17] , 
        \R_DATA_TEMPR3[16] , \R_DATA_TEMPR3[15] , \R_DATA_TEMPR3[14] , 
        \R_DATA_TEMPR3[13] , \R_DATA_TEMPR3[12] , \R_DATA_TEMPR3[11] , 
        \R_DATA_TEMPR3[10] }));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%2%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R2C0 
        (.BLK_EN(\BLKX0[2] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[2] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[2][0] ), .R_DATA({nc10, nc11, 
        \R_DATA_TEMPR2[9] , \R_DATA_TEMPR2[8] , \R_DATA_TEMPR2[7] , 
        \R_DATA_TEMPR2[6] , \R_DATA_TEMPR2[5] , \R_DATA_TEMPR2[4] , 
        \R_DATA_TEMPR2[3] , \R_DATA_TEMPR2[2] , \R_DATA_TEMPR2[1] , 
        \R_DATA_TEMPR2[0] }));
    OR4 OR4_18 (.A(\R_DATA_TEMPR0[8] ), .B(\R_DATA_TEMPR1[8] ), .C(
        \R_DATA_TEMPR2[8] ), .D(\R_DATA_TEMPR3[8] ), .Y(OR4_18_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[5]  (.A(CFG2_1_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[5] ));
    OR2 OR2_15 (.A(\R_DATA_TEMPR4[14] ), .B(\R_DATA_TEMPR5[14] ), .Y(
        OR2_15_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%6%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R6C0 
        (.BLK_EN(\BLKX0[6] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[6] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[6][0] ), .R_DATA({nc12, nc13, 
        \R_DATA_TEMPR6[9] , \R_DATA_TEMPR6[8] , \R_DATA_TEMPR6[7] , 
        \R_DATA_TEMPR6[6] , \R_DATA_TEMPR6[5] , \R_DATA_TEMPR6[4] , 
        \R_DATA_TEMPR6[3] , \R_DATA_TEMPR6[2] , \R_DATA_TEMPR6[1] , 
        \R_DATA_TEMPR6[0] }));
    OR2 OR2_11 (.A(\R_DATA_TEMPR4[20] ), .B(\R_DATA_TEMPR5[20] ), .Y(
        OR2_11_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[2]  (.A(CFG2_2_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[2] ));
    OR2 OR2_12 (.A(\R_DATA_TEMPR4[9] ), .B(\R_DATA_TEMPR5[9] ), .Y(
        OR2_12_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%3%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R3C0 
        (.BLK_EN(\BLKX0[3] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[3] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[3][0] ), .R_DATA({nc14, nc15, 
        \R_DATA_TEMPR3[9] , \R_DATA_TEMPR3[8] , \R_DATA_TEMPR3[7] , 
        \R_DATA_TEMPR3[6] , \R_DATA_TEMPR3[5] , \R_DATA_TEMPR3[4] , 
        \R_DATA_TEMPR3[3] , \R_DATA_TEMPR3[2] , \R_DATA_TEMPR3[1] , 
        \R_DATA_TEMPR3[0] }));
    OR4 OR4_9 (.A(\R_DATA_TEMPR0[20] ), .B(\R_DATA_TEMPR1[20] ), .C(
        \R_DATA_TEMPR2[20] ), .D(\R_DATA_TEMPR3[20] ), .Y(OR4_9_Y));
    OR4 \OR4_R_DATA[1]  (.A(OR4_25_Y), .B(OR2_14_Y), .C(
        \R_DATA_TEMPR6[1] ), .D(\R_DATA_TEMPR7[1] ), .Y(R_DATA[1]));
    OR4 \OR4_R_DATA[8]  (.A(OR4_18_Y), .B(OR2_6_Y), .C(
        \R_DATA_TEMPR6[8] ), .D(\R_DATA_TEMPR7[8] ), .Y(R_DATA[8]));
    OR4 \OR4_R_DATA[12]  (.A(OR4_2_Y), .B(OR2_25_Y), .C(
        \R_DATA_TEMPR6[12] ), .D(\R_DATA_TEMPR7[12] ), .Y(R_DATA[12]));
    OR4 \OR4_R_DATA[26]  (.A(OR4_5_Y), .B(OR2_3_Y), .C(
        \R_DATA_TEMPR6[26] ), .D(\R_DATA_TEMPR7[26] ), .Y(R_DATA[26]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%0%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R0C0 
        (.BLK_EN(\BLKX0[0] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[0] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[0][0] ), .R_DATA({nc16, nc17, 
        \R_DATA_TEMPR0[9] , \R_DATA_TEMPR0[8] , \R_DATA_TEMPR0[7] , 
        \R_DATA_TEMPR0[6] , \R_DATA_TEMPR0[5] , \R_DATA_TEMPR0[4] , 
        \R_DATA_TEMPR0[3] , \R_DATA_TEMPR0[2] , \R_DATA_TEMPR0[1] , 
        \R_DATA_TEMPR0[0] }));
    CFG2 #( .INIT(4'h2) )  CFG2_5 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_5_Y));
    OR2 OR2_17 (.A(\R_DATA_TEMPR4[16] ), .B(\R_DATA_TEMPR5[16] ), .Y(
        OR2_17_Y));
    OR4 OR4_4 (.A(\R_DATA_TEMPR0[7] ), .B(\R_DATA_TEMPR1[7] ), .C(
        \R_DATA_TEMPR2[7] ), .D(\R_DATA_TEMPR3[7] ), .Y(OR4_4_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[0]  (.A(CFG2_3_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[0] ));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[3]  (.A(CFG2_4_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[3] ));
    OR2 OR2_20 (.A(\R_DATA_TEMPR4[5] ), .B(\R_DATA_TEMPR5[5] ), .Y(
        OR2_20_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%0%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R0C1 
        (.BLK_EN(\BLKX0[0] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[0] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[0][1] ), .R_DATA({nc18, nc19, 
        \R_DATA_TEMPR0[19] , \R_DATA_TEMPR0[18] , \R_DATA_TEMPR0[17] , 
        \R_DATA_TEMPR0[16] , \R_DATA_TEMPR0[15] , \R_DATA_TEMPR0[14] , 
        \R_DATA_TEMPR0[13] , \R_DATA_TEMPR0[12] , \R_DATA_TEMPR0[11] , 
        \R_DATA_TEMPR0[10] }));
    OR4 OR4_26 (.A(\R_DATA_TEMPR0[2] ), .B(\R_DATA_TEMPR1[2] ), .C(
        \R_DATA_TEMPR2[2] ), .D(\R_DATA_TEMPR3[2] ), .Y(OR4_26_Y));
    OR4 \OR4_R_DATA[0]  (.A(OR4_23_Y), .B(OR2_8_Y), .C(
        \R_DATA_TEMPR6[0] ), .D(\R_DATA_TEMPR7[0] ), .Y(R_DATA[0]));
    OR2 OR2_19 (.A(\R_DATA_TEMPR4[11] ), .B(\R_DATA_TEMPR5[11] ), .Y(
        OR2_19_Y));
    OR4 \OR4_R_DATA[24]  (.A(OR4_16_Y), .B(OR2_2_Y), .C(
        \R_DATA_TEMPR6[24] ), .D(\R_DATA_TEMPR7[24] ), .Y(R_DATA[24]));
    OR2 OR2_24 (.A(\R_DATA_TEMPR4[4] ), .B(\R_DATA_TEMPR5[4] ), .Y(
        OR2_24_Y));
    OR4 \OR4_R_DATA[2]  (.A(OR4_26_Y), .B(OR2_22_Y), .C(
        \R_DATA_TEMPR6[2] ), .D(\R_DATA_TEMPR7[2] ), .Y(R_DATA[2]));
    OR4 OR4_10 (.A(\R_DATA_TEMPR0[11] ), .B(\R_DATA_TEMPR1[11] ), .C(
        \R_DATA_TEMPR2[11] ), .D(\R_DATA_TEMPR3[11] ), .Y(OR4_10_Y));
    OR4 OR4_2 (.A(\R_DATA_TEMPR0[12] ), .B(\R_DATA_TEMPR1[12] ), .C(
        \R_DATA_TEMPR2[12] ), .D(\R_DATA_TEMPR3[12] ), .Y(OR4_2_Y));
    CFG2 #( .INIT(4'h4) )  CFG2_7 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_7_Y));
    OR4 \OR4_R_DATA[16]  (.A(OR4_14_Y), .B(OR2_17_Y), .C(
        \R_DATA_TEMPR6[16] ), .D(\R_DATA_TEMPR7[16] ), .Y(R_DATA[16]));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[7]  (.A(CFG2_4_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[7] ));
    OR4 OR4_14 (.A(\R_DATA_TEMPR0[16] ), .B(\R_DATA_TEMPR1[16] ), .C(
        \R_DATA_TEMPR2[16] ), .D(\R_DATA_TEMPR3[16] ), .Y(OR4_14_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%7%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R7C0 
        (.BLK_EN(\BLKX0[7] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[7] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[7][0] ), .R_DATA({nc20, nc21, 
        \R_DATA_TEMPR7[9] , \R_DATA_TEMPR7[8] , \R_DATA_TEMPR7[7] , 
        \R_DATA_TEMPR7[6] , \R_DATA_TEMPR7[5] , \R_DATA_TEMPR7[4] , 
        \R_DATA_TEMPR7[3] , \R_DATA_TEMPR7[2] , \R_DATA_TEMPR7[1] , 
        \R_DATA_TEMPR7[0] }));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%5%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R5C0 
        (.BLK_EN(\BLKX0[5] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[5] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[5][0] ), .R_DATA({nc22, nc23, 
        \R_DATA_TEMPR5[9] , \R_DATA_TEMPR5[8] , \R_DATA_TEMPR5[7] , 
        \R_DATA_TEMPR5[6] , \R_DATA_TEMPR5[5] , \R_DATA_TEMPR5[4] , 
        \R_DATA_TEMPR5[3] , \R_DATA_TEMPR5[2] , \R_DATA_TEMPR5[1] , 
        \R_DATA_TEMPR5[0] }));
    OR2 OR2_25 (.A(\R_DATA_TEMPR4[12] ), .B(\R_DATA_TEMPR5[12] ), .Y(
        OR2_25_Y));
    OR2 OR2_21 (.A(\R_DATA_TEMPR4[17] ), .B(\R_DATA_TEMPR5[17] ), .Y(
        OR2_21_Y));
    OR2 OR2_22 (.A(\R_DATA_TEMPR4[2] ), .B(\R_DATA_TEMPR5[2] ), .Y(
        OR2_22_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[1]  (.A(CFG2_1_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[1] ));
    OR2 OR2_13 (.A(\R_DATA_TEMPR4[22] ), .B(\R_DATA_TEMPR5[22] ), .Y(
        OR2_13_Y));
    OR2 OR2_27 (.A(\R_DATA_TEMPR4[23] ), .B(\R_DATA_TEMPR5[23] ), .Y(
        OR2_27_Y));
    OR2 OR2_0 (.A(\R_DATA_TEMPR4[7] ), .B(\R_DATA_TEMPR5[7] ), .Y(
        OR2_0_Y));
    OR4 OR4_15 (.A(\R_DATA_TEMPR0[25] ), .B(\R_DATA_TEMPR1[25] ), .C(
        \R_DATA_TEMPR2[25] ), .D(\R_DATA_TEMPR3[25] ), .Y(OR4_15_Y));
    OR4 OR4_11 (.A(\R_DATA_TEMPR0[23] ), .B(\R_DATA_TEMPR1[23] ), .C(
        \R_DATA_TEMPR2[23] ), .D(\R_DATA_TEMPR3[23] ), .Y(OR4_11_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%6%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R6C2 
        (.BLK_EN(\BLKX0[6] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[6] ), .ACCESS_BUSY(
        \ACCESS_BUSY[6][2] ), .R_DATA({nc24, nc25, nc26, nc27, 
        \R_DATA_TEMPR6[27] , \R_DATA_TEMPR6[26] , \R_DATA_TEMPR6[25] , 
        \R_DATA_TEMPR6[24] , \R_DATA_TEMPR6[23] , \R_DATA_TEMPR6[22] , 
        \R_DATA_TEMPR6[21] , \R_DATA_TEMPR6[20] }));
    OR4 \OR4_R_DATA[14]  (.A(OR4_1_Y), .B(OR2_15_Y), .C(
        \R_DATA_TEMPR6[14] ), .D(\R_DATA_TEMPR7[14] ), .Y(R_DATA[14]));
    OR4 OR4_12 (.A(\R_DATA_TEMPR0[19] ), .B(\R_DATA_TEMPR1[19] ), .C(
        \R_DATA_TEMPR2[19] ), .D(\R_DATA_TEMPR3[19] ), .Y(OR4_12_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[6]  (.A(CFG2_2_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[6] ));
    OR4 \OR4_R_DATA[23]  (.A(OR4_11_Y), .B(OR2_27_Y), .C(
        \R_DATA_TEMPR6[23] ), .D(\R_DATA_TEMPR7[23] ), .Y(R_DATA[23]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%5%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R5C1 
        (.BLK_EN(\BLKX0[5] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[5] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[5][1] ), .R_DATA({nc28, nc29, 
        \R_DATA_TEMPR5[19] , \R_DATA_TEMPR5[18] , \R_DATA_TEMPR5[17] , 
        \R_DATA_TEMPR5[16] , \R_DATA_TEMPR5[15] , \R_DATA_TEMPR5[14] , 
        \R_DATA_TEMPR5[13] , \R_DATA_TEMPR5[12] , \R_DATA_TEMPR5[11] , 
        \R_DATA_TEMPR5[10] }));
    OR4 OR4_17 (.A(\R_DATA_TEMPR0[22] ), .B(\R_DATA_TEMPR1[22] ), .C(
        \R_DATA_TEMPR2[22] ), .D(\R_DATA_TEMPR3[22] ), .Y(OR4_17_Y));
    OR2 OR2_8 (.A(\R_DATA_TEMPR4[0] ), .B(\R_DATA_TEMPR5[0] ), .Y(
        OR2_8_Y));
    OR2 OR2_7 (.A(\R_DATA_TEMPR4[15] ), .B(\R_DATA_TEMPR5[15] ), .Y(
        OR2_7_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[4]  (.A(CFG2_6_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[4] ));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%4%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R4C2 
        (.BLK_EN(\BLKX0[4] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[4] ), .ACCESS_BUSY(
        \ACCESS_BUSY[4][2] ), .R_DATA({nc30, nc31, nc32, nc33, 
        \R_DATA_TEMPR4[27] , \R_DATA_TEMPR4[26] , \R_DATA_TEMPR4[25] , 
        \R_DATA_TEMPR4[24] , \R_DATA_TEMPR4[23] , \R_DATA_TEMPR4[22] , 
        \R_DATA_TEMPR4[21] , \R_DATA_TEMPR4[20] }));
    OR4 OR4_6 (.A(\R_DATA_TEMPR0[18] ), .B(\R_DATA_TEMPR1[18] ), .C(
        \R_DATA_TEMPR2[18] ), .D(\R_DATA_TEMPR3[18] ), .Y(OR4_6_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%5%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R5C2 
        (.BLK_EN(\BLKX0[5] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[5] ), .ACCESS_BUSY(
        \ACCESS_BUSY[5][2] ), .R_DATA({nc34, nc35, nc36, nc37, 
        \R_DATA_TEMPR5[27] , \R_DATA_TEMPR5[26] , \R_DATA_TEMPR5[25] , 
        \R_DATA_TEMPR5[24] , \R_DATA_TEMPR5[23] , \R_DATA_TEMPR5[22] , 
        \R_DATA_TEMPR5[21] , \R_DATA_TEMPR5[20] }));
    OR4 OR4_20 (.A(\R_DATA_TEMPR0[10] ), .B(\R_DATA_TEMPR1[10] ), .C(
        \R_DATA_TEMPR2[10] ), .D(\R_DATA_TEMPR3[10] ), .Y(OR4_20_Y));
    OR4 OR4_19 (.A(\R_DATA_TEMPR0[3] ), .B(\R_DATA_TEMPR1[3] ), .C(
        \R_DATA_TEMPR2[3] ), .D(\R_DATA_TEMPR3[3] ), .Y(OR4_19_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%7%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R7C1 
        (.BLK_EN(\BLKX0[7] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[7] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[7][1] ), .R_DATA({nc38, nc39, 
        \R_DATA_TEMPR7[19] , \R_DATA_TEMPR7[18] , \R_DATA_TEMPR7[17] , 
        \R_DATA_TEMPR7[16] , \R_DATA_TEMPR7[15] , \R_DATA_TEMPR7[14] , 
        \R_DATA_TEMPR7[13] , \R_DATA_TEMPR7[12] , \R_DATA_TEMPR7[11] , 
        \R_DATA_TEMPR7[10] }));
    CFG2 #( .INIT(4'h4) )  CFG2_1 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_1_Y));
    OR4 OR4_8 (.A(\R_DATA_TEMPR0[9] ), .B(\R_DATA_TEMPR1[9] ), .C(
        \R_DATA_TEMPR2[9] ), .D(\R_DATA_TEMPR3[9] ), .Y(OR4_8_Y));
    OR4 \OR4_R_DATA[25]  (.A(OR4_15_Y), .B(OR2_26_Y), .C(
        \R_DATA_TEMPR6[25] ), .D(\R_DATA_TEMPR7[25] ), .Y(R_DATA[25]));
    CFG2 #( .INIT(4'h8) )  CFG2_4 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_4_Y));
    OR2 OR2_6 (.A(\R_DATA_TEMPR4[8] ), .B(\R_DATA_TEMPR5[8] ), .Y(
        OR2_6_Y));
    OR4 \OR4_R_DATA[13]  (.A(OR4_22_Y), .B(OR2_10_Y), .C(
        \R_DATA_TEMPR6[13] ), .D(\R_DATA_TEMPR7[13] ), .Y(R_DATA[13]));
    OR2 OR2_3 (.A(\R_DATA_TEMPR4[26] ), .B(\R_DATA_TEMPR5[26] ), .Y(
        OR2_3_Y));
    OR4 OR4_3 (.A(\R_DATA_TEMPR0[27] ), .B(\R_DATA_TEMPR1[27] ), .C(
        \R_DATA_TEMPR2[27] ), .D(\R_DATA_TEMPR3[27] ), .Y(OR4_3_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%4%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R4C1 
        (.BLK_EN(\BLKX0[4] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[4] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[4][1] ), .R_DATA({nc40, nc41, 
        \R_DATA_TEMPR4[19] , \R_DATA_TEMPR4[18] , \R_DATA_TEMPR4[17] , 
        \R_DATA_TEMPR4[16] , \R_DATA_TEMPR4[15] , \R_DATA_TEMPR4[14] , 
        \R_DATA_TEMPR4[13] , \R_DATA_TEMPR4[12] , \R_DATA_TEMPR4[11] , 
        \R_DATA_TEMPR4[10] }));
    OR4 OR4_24 (.A(\R_DATA_TEMPR0[4] ), .B(\R_DATA_TEMPR1[4] ), .C(
        \R_DATA_TEMPR2[4] ), .D(\R_DATA_TEMPR3[4] ), .Y(OR4_24_Y));
    CFG2 #( .INIT(4'h1) )  CFG2_6 (.A(W_ADDR[7]), .B(W_ADDR[6]), .Y(
        CFG2_6_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%6%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R6C1 
        (.BLK_EN(\BLKX0[6] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[6] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[6][1] ), .R_DATA({nc42, nc43, 
        \R_DATA_TEMPR6[19] , \R_DATA_TEMPR6[18] , \R_DATA_TEMPR6[17] , 
        \R_DATA_TEMPR6[16] , \R_DATA_TEMPR6[15] , \R_DATA_TEMPR6[14] , 
        \R_DATA_TEMPR6[13] , \R_DATA_TEMPR6[12] , \R_DATA_TEMPR6[11] , 
        \R_DATA_TEMPR6[10] }));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKZ0[5]  (.A(CFG2_7_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[5] ));
    OR2 OR2_23 (.A(\R_DATA_TEMPR4[10] ), .B(\R_DATA_TEMPR5[10] ), .Y(
        OR2_23_Y));
    OR2 OR2_16 (.A(\R_DATA_TEMPR4[18] ), .B(\R_DATA_TEMPR5[18] ), .Y(
        OR2_16_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[2]  (.A(CFG2_5_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[2] ));
    OR4 OR4_0 (.A(\R_DATA_TEMPR0[21] ), .B(\R_DATA_TEMPR1[21] ), .C(
        \R_DATA_TEMPR2[21] ), .D(\R_DATA_TEMPR3[21] ), .Y(OR4_0_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%0%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R0C2 
        (.BLK_EN(\BLKX0[0] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[0] ), .ACCESS_BUSY(
        \ACCESS_BUSY[0][2] ), .R_DATA({nc44, nc45, nc46, nc47, 
        \R_DATA_TEMPR0[27] , \R_DATA_TEMPR0[26] , \R_DATA_TEMPR0[25] , 
        \R_DATA_TEMPR0[24] , \R_DATA_TEMPR0[23] , \R_DATA_TEMPR0[22] , 
        \R_DATA_TEMPR0[21] , \R_DATA_TEMPR0[20] }));
    CFG2 #( .INIT(4'h8) )  CFG2_0 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_0_Y));
    OR2 OR2_9 (.A(\R_DATA_TEMPR4[27] ), .B(\R_DATA_TEMPR5[27] ), .Y(
        OR2_9_Y));
    CFG2 #( .INIT(4'h1) )  CFG2_3 (.A(R_ADDR[7]), .B(R_ADDR[6]), .Y(
        CFG2_3_Y));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKX0[3]  (.A(CFG2_0_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[3] ));
    OR4 OR4_25 (.A(\R_DATA_TEMPR0[1] ), .B(\R_DATA_TEMPR1[1] ), .C(
        \R_DATA_TEMPR2[1] ), .D(\R_DATA_TEMPR3[1] ), .Y(OR4_25_Y));
    OR4 OR4_21 (.A(\R_DATA_TEMPR0[6] ), .B(\R_DATA_TEMPR1[6] ), .C(
        \R_DATA_TEMPR2[6] ), .D(\R_DATA_TEMPR3[6] ), .Y(OR4_21_Y));
    OR4 OR4_13 (.A(\R_DATA_TEMPR0[17] ), .B(\R_DATA_TEMPR1[17] ), .C(
        \R_DATA_TEMPR2[17] ), .D(\R_DATA_TEMPR3[17] ), .Y(OR4_13_Y));
    OR4 OR4_22 (.A(\R_DATA_TEMPR0[13] ), .B(\R_DATA_TEMPR1[13] ), .C(
        \R_DATA_TEMPR2[13] ), .D(\R_DATA_TEMPR3[13] ), .Y(OR4_22_Y));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%2%1%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R2C1 
        (.BLK_EN(\BLKX0[2] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[19], W_DATA[18], 
        W_DATA[17], W_DATA[16], W_DATA[15], W_DATA[14], W_DATA[13], 
        W_DATA[12], W_DATA[11], W_DATA[10]}), .W_EN(\BLKZ0[2] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[2][1] ), .R_DATA({nc48, nc49, 
        \R_DATA_TEMPR2[19] , \R_DATA_TEMPR2[18] , \R_DATA_TEMPR2[17] , 
        \R_DATA_TEMPR2[16] , \R_DATA_TEMPR2[15] , \R_DATA_TEMPR2[14] , 
        \R_DATA_TEMPR2[13] , \R_DATA_TEMPR2[12] , \R_DATA_TEMPR2[11] , 
        \R_DATA_TEMPR2[10] }));
    OR2 OR2_1 (.A(\R_DATA_TEMPR4[3] ), .B(\R_DATA_TEMPR5[3] ), .Y(
        OR2_1_Y));
    OR4 \OR4_R_DATA[4]  (.A(OR4_24_Y), .B(OR2_24_Y), .C(
        \R_DATA_TEMPR6[4] ), .D(\R_DATA_TEMPR7[4] ), .Y(R_DATA[4]));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[0]  (.A(CFG2_6_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[0] ));
    OR4 \OR4_R_DATA[15]  (.A(OR4_27_Y), .B(OR2_7_Y), .C(
        \R_DATA_TEMPR6[15] ), .D(\R_DATA_TEMPR7[15] ), .Y(R_DATA[15]));
    OR4 OR4_27 (.A(\R_DATA_TEMPR0[15] ), .B(\R_DATA_TEMPR1[15] ), .C(
        \R_DATA_TEMPR2[15] ), .D(\R_DATA_TEMPR3[15] ), .Y(OR4_27_Y));
    OR2 OR2_18 (.A(\R_DATA_TEMPR4[6] ), .B(\R_DATA_TEMPR5[6] ), .Y(
        OR2_18_Y));
    CFG3 #( .INIT(8'h80) )  \CFG3_BLKX0[7]  (.A(CFG2_0_Y), .B(
        R_ADDR[8]), .C(BLK_EN), .Y(\BLKX0[7] ));
    OR4 OR4_7 (.A(\R_DATA_TEMPR0[5] ), .B(\R_DATA_TEMPR1[5] ), .C(
        \R_DATA_TEMPR2[5] ), .D(\R_DATA_TEMPR3[5] ), .Y(OR4_7_Y));
    OR4 \OR4_R_DATA[21]  (.A(OR4_0_Y), .B(OR2_4_Y), .C(
        \R_DATA_TEMPR6[21] ), .D(\R_DATA_TEMPR7[21] ), .Y(R_DATA[21]));
    OR2 OR2_4 (.A(\R_DATA_TEMPR4[21] ), .B(\R_DATA_TEMPR5[21] ), .Y(
        OR2_4_Y));
    OR4 \OR4_R_DATA[19]  (.A(OR4_12_Y), .B(OR2_5_Y), .C(
        \R_DATA_TEMPR6[19] ), .D(\R_DATA_TEMPR7[19] ), .Y(R_DATA[19]));
    OR4 \OR4_R_DATA[5]  (.A(OR4_7_Y), .B(OR2_20_Y), .C(
        \R_DATA_TEMPR6[5] ), .D(\R_DATA_TEMPR7[5] ), .Y(R_DATA[5]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%3%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R3C2 
        (.BLK_EN(\BLKX0[3] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[3] ), .ACCESS_BUSY(
        \ACCESS_BUSY[3][2] ), .R_DATA({nc50, nc51, nc52, nc53, 
        \R_DATA_TEMPR3[27] , \R_DATA_TEMPR3[26] , \R_DATA_TEMPR3[25] , 
        \R_DATA_TEMPR3[24] , \R_DATA_TEMPR3[23] , \R_DATA_TEMPR3[22] , 
        \R_DATA_TEMPR3[21] , \R_DATA_TEMPR3[20] }));
    OR4 \OR4_R_DATA[20]  (.A(OR4_9_Y), .B(OR2_11_Y), .C(
        \R_DATA_TEMPR6[20] ), .D(\R_DATA_TEMPR7[20] ), .Y(R_DATA[20]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%1%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R1C2 
        (.BLK_EN(\BLKX0[1] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[1] ), .ACCESS_BUSY(
        \ACCESS_BUSY[1][2] ), .R_DATA({nc54, nc55, nc56, nc57, 
        \R_DATA_TEMPR1[27] , \R_DATA_TEMPR1[26] , \R_DATA_TEMPR1[25] , 
        \R_DATA_TEMPR1[24] , \R_DATA_TEMPR1[23] , \R_DATA_TEMPR1[22] , 
        \R_DATA_TEMPR1[21] , \R_DATA_TEMPR1[20] }));
    OR4 \OR4_R_DATA[27]  (.A(OR4_3_Y), .B(OR2_9_Y), .C(
        \R_DATA_TEMPR6[27] ), .D(\R_DATA_TEMPR7[27] ), .Y(R_DATA[27]));
    OR4 \OR4_R_DATA[7]  (.A(OR4_4_Y), .B(OR2_0_Y), .C(
        \R_DATA_TEMPR6[7] ), .D(\R_DATA_TEMPR7[7] ), .Y(R_DATA[7]));
    OR2 OR2_26 (.A(\R_DATA_TEMPR4[25] ), .B(\R_DATA_TEMPR5[25] ), .Y(
        OR2_26_Y));
    OR4 \OR4_R_DATA[6]  (.A(OR4_21_Y), .B(OR2_18_Y), .C(
        \R_DATA_TEMPR6[6] ), .D(\R_DATA_TEMPR7[6] ), .Y(R_DATA[6]));
    OR4 \OR4_R_DATA[18]  (.A(OR4_6_Y), .B(OR2_16_Y), .C(
        \R_DATA_TEMPR6[18] ), .D(\R_DATA_TEMPR7[18] ), .Y(R_DATA[18]));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%2%2%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R2C2 
        (.BLK_EN(\BLKX0[2] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21], W_DATA[20]}), .W_EN(\BLKZ0[2] ), .ACCESS_BUSY(
        \ACCESS_BUSY[2][2] ), .R_DATA({nc58, nc59, nc60, nc61, 
        \R_DATA_TEMPR2[27] , \R_DATA_TEMPR2[26] , \R_DATA_TEMPR2[25] , 
        \R_DATA_TEMPR2[24] , \R_DATA_TEMPR2[23] , \R_DATA_TEMPR2[22] , 
        \R_DATA_TEMPR2[21] , \R_DATA_TEMPR2[20] }));
    CFG3 #( .INIT(8'h20) )  \CFG3_BLKZ0[1]  (.A(CFG2_7_Y), .B(
        W_ADDR[8]), .C(W_EN), .Y(\BLKZ0[1] ));
    RAM64x12 #( .RAMINDEX("core%512%28%SPEED%1%0%MICRO_RAM") )  
        CAL_AVERAGE_OTHER_FIFO_CAL_AVERAGE_OTHER_FIFO_0_USRAM_top_R1C0 
        (.BLK_EN(\BLKX0[1] ), .BUSY_FB(GND), .R_ADDR({R_ADDR[5], 
        R_ADDR[4], R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0]}), 
        .R_ADDR_AD_N(VCC), .R_ADDR_AL_N(VCC), .R_ADDR_BYPASS(GND), 
        .R_ADDR_EN(R_ADDR_EN), .R_ADDR_SD(GND), .R_ADDR_SL_N(
        R_ADDR_SRST_N), .R_CLK(CLK), .R_DATA_AD_N(VCC), .R_DATA_AL_N(
        VCC), .R_DATA_BYPASS(GND), .R_DATA_EN(R_DATA_EN), .R_DATA_SD(
        GND), .R_DATA_SL_N(R_DATA_SRST_N), .W_ADDR({W_ADDR[5], 
        W_ADDR[4], W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0]}), 
        .W_CLK(CLK), .W_DATA({GND, GND, W_DATA[9], W_DATA[8], 
        W_DATA[7], W_DATA[6], W_DATA[5], W_DATA[4], W_DATA[3], 
        W_DATA[2], W_DATA[1], W_DATA[0]}), .W_EN(\BLKZ0[1] ), 
        .ACCESS_BUSY(\ACCESS_BUSY[1][0] ), .R_DATA({nc62, nc63, 
        \R_DATA_TEMPR1[9] , \R_DATA_TEMPR1[8] , \R_DATA_TEMPR1[7] , 
        \R_DATA_TEMPR1[6] , \R_DATA_TEMPR1[5] , \R_DATA_TEMPR1[4] , 
        \R_DATA_TEMPR1[3] , \R_DATA_TEMPR1[2] , \R_DATA_TEMPR1[1] , 
        \R_DATA_TEMPR1[0] }));
    OR4 OR4_16 (.A(\R_DATA_TEMPR0[24] ), .B(\R_DATA_TEMPR1[24] ), .C(
        \R_DATA_TEMPR2[24] ), .D(\R_DATA_TEMPR3[24] ), .Y(OR4_16_Y));
    OR4 OR4_5 (.A(\R_DATA_TEMPR0[26] ), .B(\R_DATA_TEMPR1[26] ), .C(
        \R_DATA_TEMPR2[26] ), .D(\R_DATA_TEMPR3[26] ), .Y(OR4_5_Y));
    OR2 OR2_2 (.A(\R_DATA_TEMPR4[24] ), .B(\R_DATA_TEMPR5[24] ), .Y(
        OR2_2_Y));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
