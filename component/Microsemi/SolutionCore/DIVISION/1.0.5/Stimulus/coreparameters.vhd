----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Jul 21 12:13:50 2016
-- Parameters for DIVISION
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant FAMILY : integer := 19;
    constant g_ALGORITHM : integer := 0;
    constant g_DEN_BITS : integer := 18;
    constant g_LATENCY_FACTOR : integer := 1;
    constant g_NUM_BITS : integer := 18;
    constant HDL_License : string( 1 to 1 ) := "U";
    constant testbench : string( 1 to 4 ) := "User";
end coreparameters;
