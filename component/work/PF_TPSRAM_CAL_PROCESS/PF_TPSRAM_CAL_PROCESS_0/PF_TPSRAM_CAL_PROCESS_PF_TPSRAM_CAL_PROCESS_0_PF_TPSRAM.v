`timescale 1 ns/100 ps
// Version: 2024.1 2024.1.0.3


module PF_TPSRAM_CAL_PROCESS_PF_TPSRAM_CAL_PROCESS_0_PF_TPSRAM(
       W_DATA,
       R_DATA,
       W_ADDR,
       R_ADDR,
       W_EN,
       CLK
    );
input  [41:0] W_DATA;
output [41:0] R_DATA;
input  [8:0] W_ADDR;
input  [8:0] R_ADDR;
input  W_EN;
input  CLK;

    wire \ACCESS_BUSY[0][0] , \ACCESS_BUSY[0][1] , VCC, GND, ADLIB_VCC;
    wire GND_power_net1;
    wire VCC_power_net1;
    assign GND = GND_power_net1;
    assign VCC = VCC_power_net1;
    assign ADLIB_VCC = VCC_power_net1;
    
    RAM1K20 #( .RAMINDEX("PF_TPSRAM_CAL_PROCESS_0%512-512%42-42%SPEED%0%1%TWO-PORT%ECC_EN-0")
         )  
        PF_TPSRAM_CAL_PROCESS_PF_TPSRAM_CAL_PROCESS_0_PF_TPSRAM_R0C1 (
        .A_DOUT({nc0, nc1, nc2, nc3, nc4, nc5, nc6, nc7, nc8, nc9, 
        nc10, nc11, nc12, R_DATA[41], R_DATA[40], R_DATA[39], 
        R_DATA[38], R_DATA[37], R_DATA[36], R_DATA[35]}), .B_DOUT({
        nc13, nc14, nc15, R_DATA[34], R_DATA[33], R_DATA[32], 
        R_DATA[31], R_DATA[30], R_DATA[29], R_DATA[28], nc16, nc17, 
        nc18, R_DATA[27], R_DATA[26], R_DATA[25], R_DATA[24], 
        R_DATA[23], R_DATA[22], R_DATA[21]}), .DB_DETECT(), 
        .SB_CORRECT(), .ACCESS_BUSY(\ACCESS_BUSY[0][1] ), .A_ADDR({
        R_ADDR[8], R_ADDR[7], R_ADDR[6], R_ADDR[5], R_ADDR[4], 
        R_ADDR[3], R_ADDR[2], R_ADDR[1], R_ADDR[0], GND, GND, GND, GND, 
        GND}), .A_BLK_EN({VCC, VCC, VCC}), .A_CLK(CLK), .A_DIN({GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, 
        W_DATA[41], W_DATA[40], W_DATA[39], W_DATA[38], W_DATA[37], 
        W_DATA[36], W_DATA[35]}), .A_REN(VCC), .A_WEN({GND, VCC}), 
        .A_DOUT_EN(VCC), .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), 
        .B_ADDR({W_ADDR[8], W_ADDR[7], W_ADDR[6], W_ADDR[5], W_ADDR[4], 
        W_ADDR[3], W_ADDR[2], W_ADDR[1], W_ADDR[0], GND, GND, GND, GND, 
        GND}), .B_BLK_EN({W_EN, VCC, VCC}), .B_CLK(CLK), .B_DIN({GND, 
        GND, GND, W_DATA[34], W_DATA[33], W_DATA[32], W_DATA[31], 
        W_DATA[30], W_DATA[29], W_DATA[28], GND, GND, GND, W_DATA[27], 
        W_DATA[26], W_DATA[25], W_DATA[24], W_DATA[23], W_DATA[22], 
        W_DATA[21]}), .B_REN(VCC), .B_WEN({VCC, VCC}), .B_DOUT_EN(VCC), 
        .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .ECC_EN(GND), 
        .BUSY_FB(GND), .A_WIDTH({VCC, GND, VCC}), .A_WMODE({GND, GND}), 
        .A_BYPASS(GND), .B_WIDTH({VCC, GND, VCC}), .B_WMODE({GND, GND})
        , .B_BYPASS(GND), .ECC_BYPASS(GND));
    RAM1K20 #( .RAMINDEX("PF_TPSRAM_CAL_PROCESS_0%512-512%42-42%SPEED%0%0%TWO-PORT%ECC_EN-0")
         )  
        PF_TPSRAM_CAL_PROCESS_PF_TPSRAM_CAL_PROCESS_0_PF_TPSRAM_R0C0 (
        .A_DOUT({nc19, nc20, nc21, nc22, nc23, nc24, nc25, nc26, nc27, 
        nc28, nc29, nc30, nc31, R_DATA[20], R_DATA[19], R_DATA[18], 
        R_DATA[17], R_DATA[16], R_DATA[15], R_DATA[14]}), .B_DOUT({
        nc32, nc33, nc34, R_DATA[13], R_DATA[12], R_DATA[11], 
        R_DATA[10], R_DATA[9], R_DATA[8], R_DATA[7], nc35, nc36, nc37, 
        R_DATA[6], R_DATA[5], R_DATA[4], R_DATA[3], R_DATA[2], 
        R_DATA[1], R_DATA[0]}), .DB_DETECT(), .SB_CORRECT(), 
        .ACCESS_BUSY(\ACCESS_BUSY[0][0] ), .A_ADDR({R_ADDR[8], 
        R_ADDR[7], R_ADDR[6], R_ADDR[5], R_ADDR[4], R_ADDR[3], 
        R_ADDR[2], R_ADDR[1], R_ADDR[0], GND, GND, GND, GND, GND}), 
        .A_BLK_EN({VCC, VCC, VCC}), .A_CLK(CLK), .A_DIN({GND, GND, GND, 
        GND, GND, GND, GND, GND, GND, GND, GND, GND, GND, W_DATA[20], 
        W_DATA[19], W_DATA[18], W_DATA[17], W_DATA[16], W_DATA[15], 
        W_DATA[14]}), .A_REN(VCC), .A_WEN({GND, VCC}), .A_DOUT_EN(VCC), 
        .A_DOUT_ARST_N(VCC), .A_DOUT_SRST_N(VCC), .B_ADDR({W_ADDR[8], 
        W_ADDR[7], W_ADDR[6], W_ADDR[5], W_ADDR[4], W_ADDR[3], 
        W_ADDR[2], W_ADDR[1], W_ADDR[0], GND, GND, GND, GND, GND}), 
        .B_BLK_EN({W_EN, VCC, VCC}), .B_CLK(CLK), .B_DIN({GND, GND, 
        GND, W_DATA[13], W_DATA[12], W_DATA[11], W_DATA[10], W_DATA[9], 
        W_DATA[8], W_DATA[7], GND, GND, GND, W_DATA[6], W_DATA[5], 
        W_DATA[4], W_DATA[3], W_DATA[2], W_DATA[1], W_DATA[0]}), 
        .B_REN(VCC), .B_WEN({VCC, VCC}), .B_DOUT_EN(VCC), 
        .B_DOUT_ARST_N(VCC), .B_DOUT_SRST_N(VCC), .ECC_EN(GND), 
        .BUSY_FB(GND), .A_WIDTH({VCC, GND, VCC}), .A_WMODE({GND, GND}), 
        .A_BYPASS(GND), .B_WIDTH({VCC, GND, VCC}), .B_WMODE({GND, GND})
        , .B_BYPASS(GND), .ECC_BYPASS(GND));
    GND GND_power_inst1 (.Y(GND_power_net1));
    VCC VCC_power_inst1 (.Y(VCC_power_net1));
    
endmodule
