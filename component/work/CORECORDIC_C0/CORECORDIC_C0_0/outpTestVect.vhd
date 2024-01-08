--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
--APPROVED IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Output test vector
--
--Rev:
--v4.0 12/2/2014  Porting in TGI framework
--
--SVN Revision Information:
--SVN$Revision:$
--SVN$Date:$
--
--Resolved SARS
--
--
--
--Notes:
--
--****************************************************************

-- This is an automatically generated file


-- CORDIC Output test vector for mode:  Rotation (0)

--             In Rotation Mode    In Vectoring Mode
-- goldSample1  XN=gain*R*cosA    XN=gain*sqrt(X^2+Y^2)
-- goldSample2  YN=gain*R*sinA    AN=arctan(Y/X) 

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;

ENTITY cordic_bhvOutpVect IS 
  PORT (
    count   : IN integer;
    goldSample1, goldSample2: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  );
END ENTITY cordic_bhvOutpVect;

ARCHITECTURE rtl_gen OF cordic_bhvOutpVect IS 
BEGIN
  PROCESS (count) 
  BEGIN
    CASE count IS
      WHEN  0 => 
        goldSample1 <= "11100000000000000000000000000000";   --    -536870912
        goldSample2 <= "00000000000000000000000000000000";   --    0
      WHEN  1 => 
        goldSample1 <= "11100010011011111001010000110001";   --    -496004047
        goldSample2 <= "11110011110000010000111010101101";   --    -205451603
      WHEN  2 => 
        goldSample1 <= "11101001010111110110000110011010";   --    -379625062
        goldSample2 <= "11101001010111110110000110011010";   --    -379625062
      WHEN  3 => 
        goldSample1 <= "11110011110000010000111010101101";   --    -205451603
        goldSample2 <= "11100010011011111001010000110001";   --    -496004047
      WHEN  4 => 
        goldSample1 <= "00000000000000000000000000000000";   --    0
        goldSample2 <= "11100000000000000000000000000000";   --    -536870912
      WHEN  5 => 
        goldSample1 <= "00001100001111101111000101010011";   --    205451603
        goldSample2 <= "11100010011011111001010000110001";   --    -496004047
      WHEN  6 => 
        goldSample1 <= "00010110101000001001111001100110";   --    379625062
        goldSample2 <= "11101001010111110110000110011010";   --    -379625062
      WHEN  7 => 
        goldSample1 <= "00011101100100000110101111001111";   --    496004047
        goldSample2 <= "11110011110000010000111010101101";   --    -205451603
      WHEN  8 => 
        goldSample1 <= "00100000000000000000000000000000";   --    536870912
        goldSample2 <= "00000000000000000000000000000000";   --    0
      WHEN  9 => 
        goldSample1 <= "00011101100100000110101111001111";   --    496004047
        goldSample2 <= "00001100001111101111000101010011";   --    205451603
      WHEN 10 => 
        goldSample1 <= "00010110101000001001111001100110";   --    379625062
        goldSample2 <= "00010110101000001001111001100110";   --    379625062
      WHEN 11 => 
        goldSample1 <= "00001100001111101111000101010011";   --    205451603
        goldSample2 <= "00011101100100000110101111001111";   --    496004047
      WHEN 12 => 
        goldSample1 <= "00000000000000000000000000000000";   --    0
        goldSample2 <= "00100000000000000000000000000000";   --    536870912
      WHEN 13 => 
        goldSample1 <= "11110011110000010000111010101101";   --    -205451603
        goldSample2 <= "00011101100100000110101111001111";   --    496004047
      WHEN 14 => 
        goldSample1 <= "11101001010111110110000110011010";   --    -379625062
        goldSample2 <= "00010110101000001001111001100110";   --    379625062
      WHEN 15 => 
        goldSample1 <= "11100010011011111001010000110001";   --    -496004047
        goldSample2 <= "00001100001111101111000101010011";   --    205451603
      WHEN OTHERS => 
        goldSample1 <= (others=>'0');
        goldSample2 <= (others=>'0');
    END CASE;
  END PROCESS;
END ARCHITECTURE;
