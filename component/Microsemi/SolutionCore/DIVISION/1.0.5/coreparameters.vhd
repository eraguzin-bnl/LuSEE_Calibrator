----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Feb 15 09:43:32 2024
-- Parameters for DIVISION
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant FAMILY : integer := 26;
    constant g_ARCHITECTURE : integer := 0;
    constant g_DEN_BITS : integer := 32;
    constant g_LATENCY_FACTOR : integer := 1;
    constant g_NUM_BITS : integer := 32;
    constant HDL_License : string( 1 to 1 ) := "O";
    constant testbench : string( 1 to 4 ) := "User";
end coreparameters;
