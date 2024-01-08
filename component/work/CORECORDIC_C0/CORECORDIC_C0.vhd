----------------------------------------------------------------------
-- Created by SmartDesign Tue Jan  2 10:48:10 2024
-- Version: 2022.3 2022.3.0.8
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Component Description (Tcl) 
----------------------------------------------------------------------
--# Exporting Component Description of CORECORDIC_C0 to TCL
--# Family: PolarFire
--# Part Number: MPF300TS-1FCG1152I
--# Create and Configure the core component CORECORDIC_C0
--create_and_configure_core -core_vlnv {Actel:DirectCore:CORECORDIC:4.1.100} -component_name {CORECORDIC_C0} -params {\
--"ARCHITECT:1"  \
--"COARSE:true"  \
--"DP_OPTION:2"  \
--"DP_WIDTH:16"  \
--"IN_BITS:32"  \
--"ITERATIONS:32"  \
--"MODE:3"  \
--"OUT_BITS:32"  \
--"ROUND:3"   }
--# Exporting Component Description of CORECORDIC_C0 to TCL done

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library polarfire;
use polarfire.all;
library CORECORDIC_LIB;
use CORECORDIC_LIB.all;
----------------------------------------------------------------------
-- CORECORDIC_C0 entity declaration
----------------------------------------------------------------------
entity CORECORDIC_C0 is
    -- Port list
    port(
        -- Inputs
        CLK        : in  std_logic;
        DIN_A      : in  std_logic_vector(31 downto 0);
        DIN_VALID  : in  std_logic;
        NGRST      : in  std_logic;
        RST        : in  std_logic;
        -- Outputs
        DOUT_VALID : out std_logic;
        DOUT_X     : out std_logic_vector(31 downto 0);
        DOUT_Y     : out std_logic_vector(31 downto 0);
        RFD        : out std_logic
        );
end CORECORDIC_C0;
----------------------------------------------------------------------
-- CORECORDIC_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CORECORDIC_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC   -   Actel:DirectCore:CORECORDIC:4.1.100
component CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC
    generic( 
        ARCHITECT  : integer := 1 ;
        COARSE     : integer := 1 ;
        DP_OPTION  : integer := 2 ;
        DP_WIDTH   : integer := 16 ;
        IN_BITS    : integer := 32 ;
        ITERATIONS : integer := 32 ;
        MODE       : integer := 3 ;
        OUT_BITS   : integer := 32 ;
        ROUND      : integer := 3 
        );
    -- Port list
    port(
        -- Inputs
        CLK        : in  std_logic;
        DIN_A      : in  std_logic_vector(31 downto 0);
        DIN_VALID  : in  std_logic;
        DIN_X      : in  std_logic_vector(31 downto 0);
        DIN_Y      : in  std_logic_vector(31 downto 0);
        NGRST      : in  std_logic;
        RST        : in  std_logic;
        -- Outputs
        DOUT_A     : out std_logic_vector(31 downto 0);
        DOUT_VALID : out std_logic;
        DOUT_X     : out std_logic_vector(31 downto 0);
        DOUT_Y     : out std_logic_vector(31 downto 0);
        RFD        : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal DOUT_VALID_net_0 : std_logic;
signal DOUT_X_net_0     : std_logic_vector(31 downto 0);
signal DOUT_Y_net_0     : std_logic_vector(31 downto 0);
signal RFD_net_0        : std_logic;
signal DOUT_VALID_net_1 : std_logic;
signal RFD_net_1        : std_logic;
signal DOUT_X_net_1     : std_logic_vector(31 downto 0);
signal DOUT_Y_net_1     : std_logic_vector(31 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal DIN_X_const_net_0: std_logic_vector(31 downto 0);
signal DIN_Y_const_net_0: std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 DIN_X_const_net_0 <= B"00000000000000000000000000000000";
 DIN_Y_const_net_0 <= B"00000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 DOUT_VALID_net_1    <= DOUT_VALID_net_0;
 DOUT_VALID          <= DOUT_VALID_net_1;
 RFD_net_1           <= RFD_net_0;
 RFD                 <= RFD_net_1;
 DOUT_X_net_1        <= DOUT_X_net_0;
 DOUT_X(31 downto 0) <= DOUT_X_net_1;
 DOUT_Y_net_1        <= DOUT_Y_net_0;
 DOUT_Y(31 downto 0) <= DOUT_Y_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CORECORDIC_C0_0   -   Actel:DirectCore:CORECORDIC:4.1.100
CORECORDIC_C0_0 : CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC
    generic map( 
        ARCHITECT  => ( 1 ),
        COARSE     => ( 1 ),
        DP_OPTION  => ( 2 ),
        DP_WIDTH   => ( 16 ),
        IN_BITS    => ( 32 ),
        ITERATIONS => ( 32 ),
        MODE       => ( 3 ),
        OUT_BITS   => ( 32 ),
        ROUND      => ( 3 )
        )
    port map( 
        -- Inputs
        RST        => RST,
        NGRST      => NGRST,
        CLK        => CLK,
        DIN_VALID  => DIN_VALID,
        DIN_X      => DIN_X_const_net_0, -- tied to X"0" from definition
        DIN_Y      => DIN_Y_const_net_0, -- tied to X"0" from definition
        DIN_A      => DIN_A,
        -- Outputs
        DOUT_VALID => DOUT_VALID_net_0,
        RFD        => RFD_net_0,
        DOUT_X     => DOUT_X_net_0,
        DOUT_Y     => DOUT_Y_net_0,
        DOUT_A     => OPEN 
        );

end RTL;
