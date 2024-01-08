----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Tue Jan  2 10:48:10 2024
-- Parameters for CORECORDIC
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant ARCHITECT : integer := 1;
    constant COARSE : integer := 1;
    constant DP_OPTION : integer := 2;
    constant DP_WIDTH : integer := 16;
    constant IN_BITS : integer := 32;
    constant ITERATIONS : integer := 32;
    constant MODE : integer := 3;
    constant OUT_BITS : integer := 32;
    constant ROUND : integer := 3;
    constant testbench : integer := 1;
end coreparameters;
