// This is automatically generated file 

`timescale 1 ns/100 ps
module CAL_AVERAGE_DATA_FIFO_CAL_AVERAGE_DATA_FIFO_0_ram_wrapper(
WDATA,  
WADDR,  
WEN,    
REN,    
RDATA,  
RADDR,  
RESET_N,
CLOCK,  
WCLOCK, 
A_SB_CORRECT, 
B_SB_CORRECT, 
A_DB_DETECT, 
B_DB_DETECT, 
RCLOCK  
);      
  

// --------------------------------------------------------------------------
// PARAMETER Declaration
// --------------------------------------------------------------------------
parameter                RWIDTH        = 32;  // Read  port Data Width
parameter                WWIDTH        = 32;  // Write port Data Width
parameter                RDEPTH        = 128; // Read  port Data Depth
parameter                WDEPTH        = 128; // Write port Data Depth
parameter                SYNC          = 0;   // Synchronous or Asynchronous operation | 1 - Single Clock, 0 - Dual clock
parameter                PIPE          = 1;   // Pipeline read data out
parameter                CTRL_TYPE     = 1;   // Controller only options | 1 - Controller Only, 2 - RAM1Kx18, 3 - RAM64x18
parameter                SYNC_RESET     = 0;   // Synchronous or Asynchronous RESET | 1 - Synchronous reset, 0 - Asynchronous reset
parameter                RAM_OPT     = 0;   // |  0 -High Speed , 1 - Low Power
// --------------------------------------------------------------------------
// I/O Declaration
// --------------------------------------------------------------------------
input [WWIDTH - 1 : 0]   WDATA;  
input [(WDEPTH - 1) : 0] WADDR;  
input                    WEN;    
input                    REN;    
output [RWIDTH - 1 : 0]  RDATA;  
input [(RDEPTH - 1) : 0] RADDR;  
input                    RESET_N;
input                    WCLOCK; 
input                    RCLOCK; 
output                    A_SB_CORRECT; 
output                    B_SB_CORRECT; 
output                    A_DB_DETECT; 
output                    B_DB_DETECT; 
input                    CLOCK;  
  

CAL_AVERAGE_DATA_FIFO_CAL_AVERAGE_DATA_FIFO_0_USRAM_top U6_syncpipe (
.R_DATA        (RDATA       ),
.W_DATA         (WDATA       ),
.R_ADDR        (RADDR       ),
.W_ADDR        (WADDR       ),
.BLK_EN         (REN         ),
.W_EN         (WEN         ),
.CLK           (CLOCK       ),
.R_ADDR_EN     (1'b1         ),
.R_DATA_SRST_N(RESET_N ),
.R_ADDR_SRST_N (RESET_N        ),
.R_DATA_EN     (1'b1         )
);


endmodule
