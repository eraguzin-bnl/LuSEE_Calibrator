//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Mar 19 17:31:00 2024
// Version: 2024.1 2024.1.0.3
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of CORECORDIC_C0 to TCL
# Family: PolarFire
# Part Number: MPF300TS-1FCG1152I
# Create and Configure the core component CORECORDIC_C0
create_and_configure_core -core_vlnv {Actel:DirectCore:CORECORDIC:4.1.100} -component_name {CORECORDIC_C0} -params {\
"ARCHITECT:1"  \
"COARSE:true"  \
"DP_OPTION:2"  \
"DP_WIDTH:16"  \
"IN_BITS:32"  \
"ITERATIONS:48"  \
"MODE:3"  \
"OUT_BITS:32"  \
"ROUND:3"   }
# Exporting Component Description of CORECORDIC_C0 to TCL done
*/

// CORECORDIC_C0
module CORECORDIC_C0(
    // Inputs
    CLK,
    DIN_A,
    DIN_VALID,
    NGRST,
    RST,
    // Outputs
    DOUT_VALID,
    DOUT_X,
    DOUT_Y,
    RFD
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         CLK;
input  [31:0] DIN_A;
input         DIN_VALID;
input         NGRST;
input         RST;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        DOUT_VALID;
output [31:0] DOUT_X;
output [31:0] DOUT_Y;
output        RFD;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK;
wire   [31:0] DIN_A;
wire          DIN_VALID;
wire          DOUT_VALID_net_0;
wire   [31:0] DOUT_X_net_0;
wire   [31:0] DOUT_Y_net_0;
wire          NGRST;
wire          RFD_net_0;
wire          RST;
wire          DOUT_VALID_net_1;
wire          RFD_net_1;
wire   [31:0] DOUT_X_net_1;
wire   [31:0] DOUT_Y_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [31:0] DIN_X_const_net_0;
wire   [31:0] DIN_Y_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign DIN_X_const_net_0 = 32'h00000000;
assign DIN_Y_const_net_0 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign DOUT_VALID_net_1 = DOUT_VALID_net_0;
assign DOUT_VALID       = DOUT_VALID_net_1;
assign RFD_net_1        = RFD_net_0;
assign RFD              = RFD_net_1;
assign DOUT_X_net_1     = DOUT_X_net_0;
assign DOUT_X[31:0]     = DOUT_X_net_1;
assign DOUT_Y_net_1     = DOUT_Y_net_0;
assign DOUT_Y[31:0]     = DOUT_Y_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC   -   Actel:DirectCore:CORECORDIC:4.1.100
CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC #( 
        .ARCHITECT  ( 1 ),
        .COARSE     ( 1 ),
        .DP_OPTION  ( 2 ),
        .DP_WIDTH   ( 16 ),
        .IN_BITS    ( 32 ),
        .ITERATIONS ( 48 ),
        .MODE       ( 3 ),
        .OUT_BITS   ( 32 ),
        .ROUND      ( 3 ) )
CORECORDIC_C0_0(
        // Inputs
        .RST        ( RST ),
        .NGRST      ( NGRST ),
        .CLK        ( CLK ),
        .DIN_VALID  ( DIN_VALID ),
        .DIN_X      ( DIN_X_const_net_0 ), // tied to 32'h00000000 from definition
        .DIN_Y      ( DIN_Y_const_net_0 ), // tied to 32'h00000000 from definition
        .DIN_A      ( DIN_A ),
        // Outputs
        .DOUT_VALID ( DOUT_VALID_net_0 ),
        .RFD        ( RFD_net_0 ),
        .DOUT_X     ( DOUT_X_net_0 ),
        .DOUT_Y     ( DOUT_Y_net_0 ),
        .DOUT_A     (  ) 
        );


endmodule
