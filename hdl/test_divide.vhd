--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: test_divide.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::PolarFire> <Die::MPF300TS> <Package::FCG1152>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

entity test_divide is
port (
    clk       : IN std_logic;
    reset     : IN std_logic;
	numerator : IN  std_logic_vector(31 downto 0);
    denominator : IN  std_logic_vector(31 downto 0);
    quotient : OUT std_logic_vector(31 downto 0)
);
end test_divide;
architecture architecture_test_divide of test_divide is
	signal numerator_s : signed(31 downto 0);
	signal denominator_s : signed(31 downto 0);
    signal quotient_s : signed(31 downto 0);
    signal quotient_s2 : signed(31 downto 0);
begin
    numerator_s <= signed(numerator);
    denominator_s <= signed(denominator);
    quotient <= std_logic_vector(quotient_s2);
    process (clk) begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                --numerator_s <= (others=>'0');
                --denominator_s <= (others=>'0');
                quotient_s <= (others=>'0');
                quotient_s2 <= (others=>'0');
            else
                quotient_s <= numerator_s / denominator_s;
                quotient_s2 <= quotient_s;
            end if;
        end if;
    end process;
end architecture_test_divide;
