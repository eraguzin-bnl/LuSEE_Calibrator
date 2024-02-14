----------------------------------------------------------------------
-- Created by SmartDesign Wed Feb 14 17:58:48 2024
-- Version: 2022.3 2022.3.0.8
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Component Description (Tcl) 
----------------------------------------------------------------------
--# Exporting Component Description of DIVISION_C0 to TCL
--# Family: PolarFire
--# Part Number: MPF300TS-1FCG1152I
--# Create and Configure the core component DIVISION_C0
--create_and_configure_core -core_vlnv {Microsemi:SolutionCore:DIVISION:1.0.5} -component_name {DIVISION_C0} -params {\
--"g_ARCHITECTURE:0"  \
--"g_DEN_BITS:32"  \
--"g_LATENCY_FACTOR:1"  \
--"g_NUM_BITS:32"   }
--# Exporting Component Description of DIVISION_C0 to TCL done

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library polarfire;
use polarfire.all;
----------------------------------------------------------------------
-- DIVISION_C0 entity declaration
----------------------------------------------------------------------
entity DIVISION_C0 is
    -- Port list
    port(
        -- Inputs
        den_i     : in  std_logic_vector(31 downto 0);
        num_i     : in  std_logic_vector(31 downto 0);
        reset_i   : in  std_logic;
        start_i   : in  std_logic;
        sys_clk_i : in  std_logic;
        -- Outputs
        done_o    : out std_logic;
        q_o       : out std_logic_vector(31 downto 0);
        r_o       : out std_logic_vector(31 downto 0)
        );
end DIVISION_C0;
----------------------------------------------------------------------
-- DIVISION_C0 architecture body
----------------------------------------------------------------------
architecture RTL of DIVISION_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- DIVISION   -   Microsemi:SolutionCore:DIVISION:1.0.5
component DIVISION
    generic( 
        g_ARCHITECTURE   : integer := 0 ;
        g_DEN_BITS       : integer := 32 ;
        g_LATENCY_FACTOR : integer := 1 ;
        g_NUM_BITS       : integer := 32 
        );
    -- Port list
    port(
        -- Inputs
        den_i     : in  std_logic_vector(31 downto 0);
        num_i     : in  std_logic_vector(31 downto 0);
        reset_i   : in  std_logic;
        start_i   : in  std_logic;
        sys_clk_i : in  std_logic;
        -- Outputs
        done_o    : out std_logic;
        q_o       : out std_logic_vector(31 downto 0);
        r_o       : out std_logic_vector(31 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal done_o_net_0 : std_logic;
signal q_o_net_0    : std_logic_vector(31 downto 0);
signal r_o_net_0    : std_logic_vector(31 downto 0);
signal done_o_net_1 : std_logic;
signal q_o_net_1    : std_logic_vector(31 downto 0);
signal r_o_net_1    : std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 done_o_net_1     <= done_o_net_0;
 done_o           <= done_o_net_1;
 q_o_net_1        <= q_o_net_0;
 q_o(31 downto 0) <= q_o_net_1;
 r_o_net_1        <= r_o_net_0;
 r_o(31 downto 0) <= r_o_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- DIVISION_C0_0   -   Microsemi:SolutionCore:DIVISION:1.0.5
DIVISION_C0_0 : DIVISION
    generic map( 
        g_ARCHITECTURE   => ( 0 ),
        g_DEN_BITS       => ( 32 ),
        g_LATENCY_FACTOR => ( 1 ),
        g_NUM_BITS       => ( 32 )
        )
    port map( 
        -- Inputs
        reset_i   => reset_i,
        sys_clk_i => sys_clk_i,
        start_i   => start_i,
        num_i     => num_i,
        den_i     => den_i,
        -- Outputs
        done_o    => done_o_net_0,
        q_o       => q_o_net_0,
        r_o       => r_o_net_0 
        );

end RTL;
