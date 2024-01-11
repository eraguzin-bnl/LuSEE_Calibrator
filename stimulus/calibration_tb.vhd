----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Jan 11 15:43:05 2024
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: calibration_tb.vhd
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


library ieee;
USE IEEE.numeric_std.ALL;
USE STD.textio.ALL;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;

entity calibration_tb is
end calibration_tb;

architecture behavioral of calibration_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal SYSRESET : std_logic := '0';
    
    signal bin_in_s   : std_logic_vector(11 DOWNTO 0);
    signal cal_drift_s   : std_logic_vector(31 DOWNTO 0);
    signal readyin_s   : std_logic;

    signal calbin      : std_logic_vector(9 DOWNTO 0);
    signal phase_cor_re  : std_logic_vector(31 DOWNTO 0);
    signal phase_cor_im  : std_logic_vector(31 DOWNTO 0);
    signal kar_out       : std_logic_vector(15 DOWNTO 0);
    signal readyout      : std_logic;
    signal update_drift   : std_logic;
    signal readycal      : std_logic;
    
    SIGNAL readyin_gated                    : std_logic;
    SIGNAL readyin_count                    : unsigned(1 downto 0);
begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            SYSRESET <= '1';
            wait for ( SYSCLK_PERIOD * 10 );
            
            SYSRESET <= '0';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Data source for adc
  fileread: PROCESS
    VARIABLE file_status: std_logic := '0';
    FILE bin_in_file: TEXT;
    VARIABLE bin_in_l: LINE;
    VARIABLE bin_in_v: std_logic_vector(11 DOWNTO 0);
    
    FILE cal_drift_file: TEXT;
    VARIABLE cal_drift_l: LINE;
    VARIABLE cal_drift_v: std_logic_vector(31 DOWNTO 0);
    
    FILE readyin_file: TEXT;
    VARIABLE readyin_l: LINE;
    VARIABLE readyin_v: std_logic_vector(0 DOWNTO 0);

  BEGIN
  wait for SYSCLK_PERIOD;
    IF (file_status = '0') THEN
        report "Opening file";
        file_open(bin_in_file, "bin_in.dat", read_mode);
        file_open(cal_drift_file, "cal_drift.dat", read_mode);
        file_open(readyin_file, "readyin.dat", read_mode);
        file_status := '1';
    END IF;

    IF SYSRESET = '0' AND NOT ENDFILE(bin_in_file) THEN
      READLINE(bin_in_file, bin_in_l);
      HREAD(bin_in_l, bin_in_v);
      bin_in_s <= bin_in_v;
      
      READLINE(cal_drift_file, cal_drift_l);
      HREAD(cal_drift_l, cal_drift_v);
      cal_drift_s <= cal_drift_v;
      
      READLINE(readyin_file, readyin_l);
      HREAD(readyin_l, readyin_v);
      readyin_s <= readyin_v(0);
    END IF;

    IF ENDFILE(bin_in_file) THEN
      report "VHDL --> Sample input file ended, restarting";
      file_close(bin_in_file);
      file_status := '0';
    END IF;
  END PROCESS fileread;
  
   --Slow down the clock to emulate averaging happening
    gating_process: PROCESS (readyin_s, SYSRESET)
      BEGIN
        IF SYSRESET = '1' THEN
          readyin_gated <= '0';
          readyin_count <= to_unsigned(0, readyin_count'length);
        ELSIF readyin_s'event AND readyin_s = '1' THEN
          IF readyin_count = 0 THEN
            readyin_gated <= '1';
          ELSE
            readyin_gated <= '0';
          END IF;
          readyin_count <= readyin_count + 1;
        ELSIF readyin_s'event AND readyin_s = '0' THEN
          readyin_gated <= '0';
        END IF;
      END PROCESS gating_process;
      
    cal_phaser : entity work.cal_phaser
        port map( 
            -- Inputs
            clk => SYSCLK,
            reset => SYSRESET,
            bin_in => bin_in_s,
            cal_drift => std_logic_vector(shift_right(unsigned(cal_drift_s), 14) / 3),
            readyin => readyin_gated,

            -- Outputs
            calbin => calbin,
            phase_cor_re => phase_cor_re,
            phase_cor_im => phase_cor_im,
            kar_out => kar_out,
            readyout =>  readyout,
            update_drift =>  update_drift,
            readycal =>  readycal
        );

end behavioral;

