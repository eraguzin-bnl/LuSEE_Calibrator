--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: multiply_test_pkg.vhd
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

package MultiplyTestPkg is
    procedure test64_slice_proc (
        signal data         : in std_logic_vector(63 downto 0);
        signal slice        : in integer range 0 to 32;
        error_index         : in integer range 0 to 6;
        signal error_out    : out std_logic_vector(6 downto 0)
        );
        
    procedure test65_slice_proc (
        signal data         : in signed(64 downto 0);
        signal slice        : in integer range 0 to 33;
        error_index         : in integer range 0 to 6;
        signal error_out    : out std_logic_vector(6 downto 0)
        );
        
    procedure test66_slice_proc (
        signal data         : in signed(65 downto 0);
        signal slice        : in integer range 0 to 34;
        error_index         : in integer range 0 to 6;
        signal error_out    : out std_logic_vector(6 downto 0)
        );
end package MultiplyTestPkg;

package body MultiplyTestPkg is
    procedure test64_slice_proc (
            signal data            : in std_logic_vector(63 downto 0);
            signal slice           : in integer range 0 to 32;
            error_index            : in integer range 0 to 6;
            signal error_out       : out std_logic_vector(6 downto 0)
            )
        is
            variable test64_slice  : signed(63 DOWNTO 0) := (others=>'0');
            CONSTANT error_ones    : signed(63 downto 0) := (others=>'1');
            CONSTANT error_zeroes  : signed(63 downto 0) := (others=>'0');
        begin
            test64_slice := shift_right(signed(data), slice + 32);
            -- First check to see if number is negative
            if (test64_slice(63) = '1') then
                --This is a signed negative number, if there are any 0s higher than the slice you took off, you missed data
                if (test64_slice < error_ones) then
                    error_out(error_index) <= '1';
                end if;
                -- Saw cases where the top most signed bit was different, so you get an overflow effect. 
                -- That's not caught by method above, need to check the MSB directly
                if (data(31 + slice) /= '1') then
                    error_out(error_index) <= '1';
                end if;
            else
                --This is a signed positive number, if there are any 1s higher than the slice you took off, you missed data
                if (test64_slice > error_zeroes) then
                    error_out(error_index) <= '1';
                end if;
                
                if (data(31 + slice) /= '0') then
                    error_out(error_index) <= '1';
                end if;
            end if;
    end test64_slice_proc;
    
    procedure test65_slice_proc (
            signal data            : in signed(64 downto 0);
            signal slice           : in integer range 0 to 33;
            error_index            : in integer range 0 to 6;
            signal error_out       : out std_logic_vector(6 downto 0)
            )
        is
            variable test65_slice  : signed(64 DOWNTO 0) := (others=>'0');
            CONSTANT error_ones    : signed(64 downto 0) := (others=>'1');
            CONSTANT error_zeroes  : signed(64 downto 0) := (others=>'0');
        begin
            test65_slice := shift_right(data, slice + 32);
            -- First check to see if number is negative
            if (test65_slice(64) = '1') then
                --This is a signed negative number, if there are any 0s higher than the slice you took off, you missed data
                if (test65_slice < error_ones) then
                    error_out(error_index) <= '1';
                end if;
                
                if (data(31 + slice) /= '1') then
                    error_out(error_index) <= '1';
                end if;
            else
                --This is a signed positive number, if there are any 1s higher than the slice you took off, you missed data
                if (test65_slice > error_zeroes) then
                    error_out(error_index) <= '1';
                end if;
                
                if (data(31 + slice) /= '0') then
                    error_out(error_index) <= '1';
                end if;
            end if;
    end test65_slice_proc;
    
    procedure test66_slice_proc (
            signal data            : in signed(65 downto 0);
            signal slice           : in integer range 0 to 34;
            error_index            : in integer range 0 to 6;
            signal error_out       : out std_logic_vector(6 downto 0)
            )
        is
            variable test66_slice  : signed(65 DOWNTO 0) := (others=>'0');
            CONSTANT error_ones    : signed(65 downto 0) := (others=>'1');
            CONSTANT error_zeroes  : signed(65 downto 0) := (others=>'0');
        begin
            test66_slice := shift_right(data, slice + 32);
            -- First check to see if number is negative
            if (test66_slice(65) = '1') then
                --This is a signed negative number, if there are any 0s higher than the slice you took off, you missed data
                if (test66_slice < error_ones) then
                    error_out(error_index) <= '1';
                end if;
                
                if (data(31 + slice) /= '1') then
                    error_out(error_index) <= '1';
                end if;
            else
                --This is a signed positive number, if there are any 1s higher than the slice you took off, you missed data
                if (test66_slice > error_zeroes) then
                    error_out(error_index) <= '1';
                end if;
                
                if (data(31 + slice) /= '0') then
                    error_out(error_index) <= '1';
                end if;
            end if;
    end test66_slice_proc;
end package body MultiplyTestPkg;