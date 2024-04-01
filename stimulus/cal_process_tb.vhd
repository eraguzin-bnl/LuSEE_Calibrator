----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Feb 12 11:31:58 2024
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: cal_process_tb.vhd
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
use ieee.std_logic_1164.all;
USE STD.textio.ALL;
use ieee.std_logic_textio.all;
USE IEEE.numeric_std.ALL;

entity cal_process_tb is
end cal_process_tb;

architecture behavioral of cal_process_tb is

    constant SYSCLK_PERIOD : time := 100 ns; -- 10MHZ

    signal SYSCLK : std_logic := '0';
    signal SYSRESET : std_logic := '0';
    
    signal outreal1_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal outimag1_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal powertop1_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
    signal powerbot1_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
    signal drift_FD1_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En4
    signal drift_SD1_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
    signal outreal2_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
    signal outimag2_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
    signal powertop2_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
    signal powerbot2_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
    signal drift_FD2_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En7
    signal drift_SD2_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal outreal3_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal outimag3_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal powertop3_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
    signal powerbot3_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
    signal drift_FD3_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En4
    signal drift_SD3_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
    signal outreal4_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
    signal outimag4_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
    signal powertop4_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
    signal powerbot4_s                         : std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
    signal drift_FD4_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En7
    signal drift_SD4_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal calbin_s                            : std_logic_vector(8 DOWNTO 0);  -- ufix10
    signal readyout_s                          : std_logic;
    signal drift_in_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En43
    signal update_drift_s                      : std_logic;
    
    signal error_s                             : std_logic_vector(6 DOWNTO 0);
    signal drift_out_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En43
    signal have_lock_out_s                     : std_logic;
    signal foutreal1_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
    signal foutimag1_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
    signal foutreal2_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal foutimag2_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal foutreal3_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
    signal foutimag3_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
    signal foutreal4_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal foutimag4_s                         : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal fout_ready_s                        : std_logic;

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
    
    fileread: PROCESS
        VARIABLE file_status: integer := 0;
        
        FILE outreal1_file: TEXT;
        VARIABLE outreal1_l: LINE;
        VARIABLE outreal1_v: std_logic_vector(31 DOWNTO 0);
        FILE outimag1_file: TEXT;
        VARIABLE outimag1_l: LINE;
        VARIABLE outimag1_v: std_logic_vector(31 DOWNTO 0);
        FILE powertop1_file: TEXT;
        VARIABLE powertop1_l: LINE;
        VARIABLE powertop1_v: std_logic_vector(31 DOWNTO 0);
        FILE powerbot1_file: TEXT;
        VARIABLE powerbot1_l: LINE;
        VARIABLE powerbot1_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_FD1_file: TEXT;
        VARIABLE drift_FD1_l: LINE;
        VARIABLE drift_FD1_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_SD1_file: TEXT;
        VARIABLE drift_SD1_l: LINE;
        VARIABLE drift_SD1_v: std_logic_vector(31 DOWNTO 0);
        
        FILE outreal2_file: TEXT;
        VARIABLE outreal2_l: LINE;
        VARIABLE outreal2_v: std_logic_vector(31 DOWNTO 0);
        FILE outimag2_file: TEXT;
        VARIABLE outimag2_l: LINE;
        VARIABLE outimag2_v: std_logic_vector(31 DOWNTO 0);
        FILE powertop2_file: TEXT;
        VARIABLE powertop2_l: LINE;
        VARIABLE powertop2_v: std_logic_vector(31 DOWNTO 0);
        FILE powerbot2_file: TEXT;
        VARIABLE powerbot2_l: LINE;
        VARIABLE powerbot2_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_FD2_file: TEXT;
        VARIABLE drift_FD2_l: LINE;
        VARIABLE drift_FD2_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_SD2_file: TEXT;
        VARIABLE drift_SD2_l: LINE;
        VARIABLE drift_SD2_v: std_logic_vector(31 DOWNTO 0);
        
        FILE outreal3_file: TEXT;
        VARIABLE outreal3_l: LINE;
        VARIABLE outreal3_v: std_logic_vector(31 DOWNTO 0);
        FILE outimag3_file: TEXT;
        VARIABLE outimag3_l: LINE;
        VARIABLE outimag3_v: std_logic_vector(31 DOWNTO 0);
        FILE powertop3_file: TEXT;
        VARIABLE powertop3_l: LINE;
        VARIABLE powertop3_v: std_logic_vector(31 DOWNTO 0);
        FILE powerbot3_file: TEXT;
        VARIABLE powerbot3_l: LINE;
        VARIABLE powerbot3_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_FD3_file: TEXT;
        VARIABLE drift_FD3_l: LINE;
        VARIABLE drift_FD3_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_SD3_file: TEXT;
        VARIABLE drift_SD3_l: LINE;
        VARIABLE drift_SD3_v: std_logic_vector(31 DOWNTO 0);
        
        FILE outreal4_file: TEXT;
        VARIABLE outreal4_l: LINE;
        VARIABLE outreal4_v: std_logic_vector(31 DOWNTO 0);
        FILE outimag4_file: TEXT;
        VARIABLE outimag4_l: LINE;
        VARIABLE outimag4_v: std_logic_vector(31 DOWNTO 0);
        FILE powertop4_file: TEXT;
        VARIABLE powertop4_l: LINE;
        VARIABLE powertop4_v: std_logic_vector(31 DOWNTO 0);
        FILE powerbot4_file: TEXT;
        VARIABLE powerbot4_l: LINE;
        VARIABLE powerbot4_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_FD4_file: TEXT;
        VARIABLE drift_FD4_l: LINE;
        VARIABLE drift_FD4_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_SD4_file: TEXT;
        VARIABLE drift_SD4_l: LINE;
        VARIABLE drift_SD4_v: std_logic_vector(31 DOWNTO 0);
        
        FILE calbin_file: TEXT;
        VARIABLE calbin_l: LINE;
        VARIABLE calbin_v: std_logic_vector(31 DOWNTO 0);
        FILE readyout_file: TEXT;
        VARIABLE readyout_l: LINE;
        VARIABLE readyout_v: std_logic_vector(31 DOWNTO 0);
        FILE drift_in_file: TEXT;
        VARIABLE drift_in_l: LINE;
        VARIABLE drift_in_v: std_logic_vector(31 DOWNTO 0);
        FILE update_drift_file: TEXT;
        VARIABLE update_drift_l: LINE;
        VARIABLE update_drift_v: std_logic_vector(31 DOWNTO 0);

    BEGIN
        wait for SYSCLK_PERIOD;
        IF (file_status = 0) THEN
            report "Opening file";
            file_open(outreal1_file, "outreal1_proc.dat", read_mode);
            file_open(outimag1_file, "outimag1_proc.dat", read_mode);
            file_open(powertop1_file, "powertop1_proc.dat", read_mode);
            file_open(powerbot1_file, "powerbot1_proc.dat", read_mode);
            file_open(drift_FD1_file, "drift_FD1_proc.dat", read_mode);
            file_open(drift_SD1_file, "drift_SD1_proc.dat", read_mode);
            
            file_open(outreal2_file, "outreal2_proc.dat", read_mode);
            file_open(outimag2_file, "outimag2_proc.dat", read_mode);
            file_open(powertop2_file, "powertop2_proc.dat", read_mode);
            file_open(powerbot2_file, "powerbot2_proc.dat", read_mode);
            file_open(drift_FD2_file, "drift_FD2_proc.dat", read_mode);
            file_open(drift_SD2_file, "drift_SD2_proc.dat", read_mode);
            
            file_open(outreal3_file, "outreal3_proc.dat", read_mode);
            file_open(outimag3_file, "outimag3_proc.dat", read_mode);
            file_open(powertop3_file, "powertop3_proc.dat", read_mode);
            file_open(powerbot3_file, "powerbot3_proc.dat", read_mode);
            file_open(drift_FD3_file, "drift_FD3_proc.dat", read_mode);
            file_open(drift_SD3_file, "drift_SD3_proc.dat", read_mode);
            
            file_open(outreal4_file, "outreal4_proc.dat", read_mode);
            file_open(outimag4_file, "outimag4_proc.dat", read_mode);
            file_open(powertop4_file, "powertop4_proc.dat", read_mode);
            file_open(powerbot4_file, "powerbot4_proc.dat", read_mode);
            file_open(drift_FD4_file, "drift_FD4_proc.dat", read_mode);
            file_open(drift_SD4_file, "drift_SD4_proc.dat", read_mode);
            
            file_open(calbin_file, "calbin_proc.dat", read_mode);
            file_open(readyout_file, "readyout_proc.dat", read_mode);
            file_open(drift_in_file, "drift_in_proc.dat", read_mode);
            file_open(update_drift_file, "update_drift_proc.dat", read_mode);
            
            file_status := 1;
        END IF;

        IF SYSRESET = '0' AND NOT ENDFILE(outreal1_file) THEN
          READLINE(outreal1_file, outreal1_l);
          HREAD(outreal1_l, outreal1_v);
          outreal1_s <= outreal1_v;
          READLINE(outimag1_file, outimag1_l);
          HREAD(outimag1_l, outimag1_v);
          outimag1_s <= outimag1_v;
          READLINE(powertop1_file, powertop1_l);
          HREAD(powertop1_l, powertop1_v);
          powertop1_s <= powertop1_v;
          READLINE(powerbot1_file, powerbot1_l);
          HREAD(powerbot1_l, powerbot1_v);
          powerbot1_s <= powerbot1_v;
          READLINE(drift_FD1_file, drift_FD1_l);
          HREAD(drift_FD1_l, drift_FD1_v);
          drift_FD1_s <= drift_FD1_v;
          READLINE(drift_SD1_file, drift_SD1_l);
          HREAD(drift_SD1_l, drift_SD1_v);
          drift_SD1_s <= drift_SD1_v;
          
          READLINE(outreal2_file, outreal2_l);
          HREAD(outreal2_l, outreal2_v);
          outreal2_s <= outreal2_v;
          READLINE(outimag2_file, outimag2_l);
          HREAD(outimag2_l, outimag2_v);
          outimag2_s <= outimag2_v;
          READLINE(powertop2_file, powertop2_l);
          HREAD(powertop2_l, powertop2_v);
          powertop2_s <= powertop2_v;
          READLINE(powerbot2_file, powerbot2_l);
          HREAD(powerbot2_l, powerbot2_v);
          powerbot2_s <= powerbot2_v;
          READLINE(drift_FD2_file, drift_FD2_l);
          HREAD(drift_FD2_l, drift_FD2_v);
          drift_FD2_s <= drift_FD2_v;
          READLINE(drift_SD2_file, drift_SD2_l);
          HREAD(drift_SD2_l, drift_SD2_v);
          drift_SD2_s <= drift_SD2_v;
          
          READLINE(outreal3_file, outreal3_l);
          HREAD(outreal3_l, outreal3_v);
          outreal3_s <= outreal3_v;
          READLINE(outimag3_file, outimag3_l);
          HREAD(outimag3_l, outimag3_v);
          outimag3_s <= outimag3_v;
          READLINE(powertop3_file, powertop3_l);
          HREAD(powertop3_l, powertop3_v);
          powertop3_s <= powertop3_v;
          READLINE(powerbot3_file, powerbot3_l);
          HREAD(powerbot3_l, powerbot3_v);
          powerbot3_s <= powerbot3_v;
          READLINE(drift_FD3_file, drift_FD3_l);
          HREAD(drift_FD3_l, drift_FD3_v);
          drift_FD3_s <= drift_FD3_v;
          READLINE(drift_SD3_file, drift_SD3_l);
          HREAD(drift_SD3_l, drift_SD3_v);
          drift_SD3_s <= drift_SD3_v;
          
          READLINE(outreal4_file, outreal4_l);
          HREAD(outreal4_l, outreal4_v);
          outreal4_s <= outreal4_v;
          READLINE(outimag4_file, outimag4_l);
          HREAD(outimag4_l, outimag4_v);
          outimag4_s <= outimag4_v;
          READLINE(powertop4_file, powertop4_l);
          HREAD(powertop4_l, powertop4_v);
          powertop4_s <= powertop4_v;
          READLINE(powerbot4_file, powerbot4_l);
          HREAD(powerbot4_l, powerbot4_v);
          powerbot4_s <= powerbot4_v;
          READLINE(drift_FD4_file, drift_FD4_l);
          HREAD(drift_FD4_l, drift_FD4_v);
          drift_FD4_s <= drift_FD4_v;
          READLINE(drift_SD4_file, drift_SD4_l);
          HREAD(drift_SD4_l, drift_SD4_v);
          drift_SD4_s <= drift_SD4_v;
          
          READLINE(calbin_file, calbin_l);
          HREAD(calbin_l, calbin_v);
          calbin_s <= calbin_v(8 DOWNTO 0);
          READLINE(readyout_file, readyout_l);
          HREAD(readyout_l, readyout_v);
          readyout_s <= readyout_v(0);
          READLINE(drift_in_file, drift_in_l);
          HREAD(drift_in_l, drift_in_v);
          drift_in_s <= drift_in_v;
          READLINE(update_drift_file, update_drift_l);
          HREAD(update_drift_l, update_drift_v);
          update_drift_s <= update_drift_v(0);
        END IF;

        IF ENDFILE(outreal1_file) THEN
            report "VHDL --> Sample input file ended, restarting";
            file_close(outreal1_file);
            file_close(outimag1_file);
            file_close(powertop1_file);
            file_close(powerbot1_file);
            file_close(drift_FD1_file);
            file_close(drift_SD1_file);
            
            file_close(outreal2_file);
            file_close(outimag2_file);
            file_close(powertop2_file);
            file_close(powerbot2_file);
            file_close(drift_FD2_file);
            file_close(drift_SD2_file);
            
            file_close(outreal3_file);
            file_close(outimag3_file);
            file_close(powertop3_file);
            file_close(powerbot3_file);
            file_close(drift_FD3_file);
            file_close(drift_SD3_file);
            
            file_close(outreal4_file);
            file_close(outimag4_file);
            file_close(powertop4_file);
            file_close(powerbot4_file);
            file_close(drift_FD4_file);
            file_close(drift_SD4_file);
            
            file_close(calbin_file);
            file_close(readyout_file);
            file_close(drift_in_file);
            file_close(update_drift_file);
          file_status := 0;
        END IF;
    END PROCESS fileread;

    cal_process : entity work.cal_process
        PORT MAP( 
            clk => SYSCLK,
            reset => SYSRESET,
            outreal1 => outreal1_s,
            outimag1 => outimag1_s,
            powertop1 => powertop1_s,
            powerbot1 => powerbot1_s,
            drift_FD1 => drift_FD1_s,
            drift_SD1 => drift_SD1_s,
            outreal2 => outreal2_s,
            outimag2 => outimag2_s,
            powertop2 => powertop2_s,
            powerbot2 => powerbot2_s,
            drift_FD2 => drift_FD2_s,
            drift_SD2 => drift_SD2_s,
            outreal3 => outreal3_s,
            outimag3 => outimag3_s,
            powertop3 => powertop3_s,
            powerbot3 => powerbot3_s,
            drift_FD3 => drift_FD3_s,
            drift_SD3 => drift_SD3_s,
            outreal4 => outreal4_s,
            outimag4 => outimag4_s,
            powertop4 => powertop4_s,
            powerbot4 => powerbot4_s,
            drift_FD4 => drift_FD4_s,
            drift_SD4 => drift_SD4_s,
            calbin => calbin_s,
            readyout => readyout_s,
            drift_in => drift_in_s,
            update_drift => update_drift_s,
            error_stick => '1',
            
            default_drift   => x"00005088",
            have_lock_value => "00000000000000000010101000101010",
            have_lock_radian  => "00000000000000000000110101101100",
            lower_guard_value  => "11111111111111101011110111100001",
            upper_guard_value  => "01100100100001111110110101010001",
            power_ratio        => "01",
            Nac2_setting       => x"4",
            antenna_enable    => "1111",
            
            error => error_s,
            drift_out => drift_out_s,
            have_lock_out => have_lock_out_s,
            foutreal1 => foutreal1_s,
            foutimag1 => foutimag1_s,
            foutreal2 => foutreal2_s,
            foutimag2 => foutimag2_s,
            foutreal3 => foutreal3_s,
            foutimag3 => foutimag3_s,
            foutreal4 => foutreal4_s,
            foutimag4 => foutimag4_s,
            fout_ready => fout_ready_s
        );

end behavioral;

