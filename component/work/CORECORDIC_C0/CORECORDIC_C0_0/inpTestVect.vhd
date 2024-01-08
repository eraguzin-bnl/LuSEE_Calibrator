--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
--APPROVED IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Input test vector
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

-- CORDIC Input test vector for MODE 3
--  ----------------------  Conventions  -----------------------------------  
--        Mode    |     Inputs         |           Outputs                    
--  --------------|--------------------|------------------------------------  
--                    R O T A T I O N  M O D E S                              
--  General       | DIN_X: Abscissa X  | DOUT_X = K*(DIN_X*cosA - DIN_Y*sinA) 
--  Rotation      | DIN_Y: Ordinate Y  | DOUT_Y = K*(DIN_Y*cosA + DIN_X*sinA) 
--  (by Givens)   | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
--  Polar to      | DIN_X: Magnitude R | DOUT_X = K*R*cosA                    
--  Rectangular   | DIN_Y: 0           | DOUT_Y = K*R*sinA                    
--                | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
--  Sin, Cos  | DIN_X: 0 (1/g applies internally) | DOUT_X = sinA             
--            | DIN_Y: 0                          | DOUT_Y = cosA             
--            | DIN_A: Phase A                    | DOUT_A   -                
                                                                              
--                    V E C T O R I N G  M O D E S                            
--  Rectangular | DIN_X: Abscissa X  | DOUT_X = K*sqrt(X^2+Y^2)'Magnitude R' 
--  to Polar    | DIN_Y: Ordinate Y  | DOUT_Y     -                           
--              | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'         
                                                                              
--  Arctan        | DIN_X: Abscissa X  | DOUT_X     -                         
--                | DIN_Y: Ordinate Y  | DOUT_Y     -                         
--                | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'       
                                                                              
--  K - CORDIC gain                                                         

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;

ENTITY cordic_bhvInpVect IS 
  PORT (
    count   : IN integer;
    xin, yin, ain: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)  );
END ENTITY cordic_bhvInpVect;

ARCHITECTURE rtl_gen OF cordic_bhvInpVect IS 
BEGIN
  PROCESS (count) 
  BEGIN
    CASE count IS
      WHEN  0 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11000000000000000000000000000000";   --    -1073741824
      WHEN  1 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11001000000000000000000000000000";   --    -939524096
      WHEN  2 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11010000000000000000000000000000";   --    -805306368
      WHEN  3 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11011000000000000000000000000000";   --    -671088640
      WHEN  4 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11100000000000000000000000000000";   --    -536870912
      WHEN  5 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11101000000000000000000000000000";   --    -402653184
      WHEN  6 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11110000000000000000000000000000";   --    -268435456
      WHEN  7 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "11111000000000000000000000000000";   --    -134217728
      WHEN  8 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00000000000000000000000000000000";   --    0
      WHEN  9 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00001000000000000000000000000000";   --    134217728
      WHEN 10 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00010000000000000000000000000000";   --    268435456
      WHEN 11 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00011000000000000000000000000000";   --    402653184
      WHEN 12 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00100000000000000000000000000000";   --    536870912
      WHEN 13 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00101000000000000000000000000000";   --    671088640
      WHEN 14 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00110000000000000000000000000000";   --    805306368
      WHEN 15 => 
        xin <= "00100110110111010011101101101010";   --    652032874
        yin <= "00000000000000000000000000000000";   --    0
        ain <= "00111000000000000000000000000000";   --    939524096
      WHEN OTHERS => 
        xin <= (others=>'0');
        yin <= (others=>'0');
        ain <= (others=>'0');
    END CASE;
  END PROCESS;
END ARCHITECTURE;
