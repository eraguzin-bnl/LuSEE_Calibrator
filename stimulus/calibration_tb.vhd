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
    
    signal real_in_s  : std_logic_vector(31 DOWNTO 0);
    signal imag_in_s  : std_logic_vector(31 DOWNTO 0);
    
    signal Nac1_s     : std_logic_vector(1 DOWNTO 0);

    signal calbin      : std_logic_vector(8 DOWNTO 0);
    signal calbin_out      : std_logic_vector(8 DOWNTO 0);
    signal phase_cor_re  : std_logic_vector(31 DOWNTO 0);
    signal phase_cor_im  : std_logic_vector(31 DOWNTO 0);
    signal kar_out       : std_logic_vector(17 DOWNTO 0);
    signal readyout      : std_logic;
    signal update_drift   : std_logic;
    signal readycal      : std_logic;
    
    signal outreal_s                           : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal outimag_s                           : std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
    signal powertop_s                          : std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
    signal powerbot_s                          : std_logic_vector(31 DOWNTO 0);  -- ufix32_En33
    signal drift_FD_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_En5
    signal drift_SD_s                          : std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
    signal average_ready_s                     : std_logic;
    
    signal cplx_index                          : std_logic_vector(5 downto 0);
    signal sum1_index                          : std_logic_vector(5 downto 0);
    signal sum2_index                          : std_logic_vector(5 downto 0);
    signal powertop_index                      : std_logic_vector(5 downto 0);
    signal powerbot_index                      : std_logic_vector(5 downto 0);
    signal driftFD_index                       : std_logic_vector(5 downto 0);
    signal driftSD1_index                      : std_logic_vector(5 downto 0);
    signal driftSD2_index                      : std_logic_vector(5 downto 0);
    signal error_s                             : std_logic_vector(11 DOWNTO 0);
    
    SIGNAL readyin_gated                    : std_logic;
    SIGNAL readyin_gated_s                  : std_logic;
    SIGNAL readyin_count                    : unsigned(2 downto 0);
    
    signal cal_drift_out                         : std_logic_vector(31 DOWNTO 0);
    signal error_process                       : std_logic_vector(6 DOWNTO 0);
    signal have_lock_out_s                   : std_logic;
    signal foutreal1_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutimag1_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutreal2_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutimag2_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutreal3_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutimag3_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutreal4_s                       : std_logic_vector(31 DOWNTO 0);
    signal foutimag4_s                       : std_logic_vector(31 DOWNTO 0);
    signal fout_ready_s                      : std_logic;
    signal new_phase_rdy_s                   : std_logic;

    signal default_drift                     : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal have_lock_value                   : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal have_lock_radian                  : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal lower_guard_value                 : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal upper_guard_value                 : std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
    signal power_ratio                       : std_logic_vector(1 DOWNTO 0);
    signal Nac2                              : std_logic_vector(3 DOWNTO 0);
    signal antenna_enable                    : std_logic_vector(3 DOWNTO 0);
    
begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            cplx_index       <= std_logic_vector(to_unsigned(29, cplx_index'length));
            sum1_index       <= std_logic_vector(to_unsigned(32, sum1_index'length));
            sum2_index       <= std_logic_vector(to_unsigned(36, sum2_index'length));
            powertop_index   <= std_logic_vector(to_unsigned(32, powertop_index'length));
            powerbot_index   <= std_logic_vector(to_unsigned(32, powerbot_index'length));
            driftFD_index    <= std_logic_vector(to_unsigned(30, driftFD_index'length));
            driftSD1_index   <= std_logic_vector(to_unsigned(26, driftSD1_index'length));
            driftSD2_index   <= std_logic_vector(to_unsigned(2, driftSD2_index'length));
            Nac1_s           <= "10"; --0 is 32, 1 is 64, 2 is 128

            -- phase_drift_per_ppm = 50e3*4096/102.4e6 *(1/1e6)*2*pi; I will leave out the pi because of angle fixed point representation
            -- phase_drift_per_ppm = 0.000004
            -- alpha_to_pdrift = 16*phase_drift_per_ppm;
            -- alpha_to_pdrift = 0.000064

            --have_lock_value
            -- 0.05*alpha_to_pdrift = 0.0000032 * pi = 1.0053E-5
            -- 0.05*alpha_to_pdrift = binary(00.000000000000000010101000101010) aka
            -- 1/(2**17) + 1/(2**19) + 1/(2**21) + 1/(2**25) + 1/(2**27) + 1/(2**29) = 1.0053E-5
            -- So this can be compared cleanly to the ratio which is not in radian mode

            --have_lock_radian
            -- 0.05*alpha_to_pdrift_radian = 0.0000032
            -- 0.05*alpha_to_pdrift_radian = binary(00.000000000000000000110101101100) aka
            -- 1/(2**19) + 1/(2**20) + 1/(2**22) + 1/(2**24) + 1/(2**25) + 1/(2**27) + 1/(2**28) = 0.000003200024...
            -- So this can be added cleanly to the phase output which has the same fixed point representation

            --upper and lower guard
            -- 1.2*alpha_to_pdrift = 0.0000768
            -- 1.2*alpha_to_pdrift = binary(00.000000000000010100001000011111) aka
            -- 1/(2**14) + 1/(2**16) + 1/(2**21) + 1/(2**26) + 1/(2**27) + 1/(2**28) + 1/(2**29) + 1/(2**30) = 0.00007679965...
            -- So this can be compared directly to the phase output which has the same fixed point representation
            -- -1.2*alpha_to_pdrift = binary(11.111111111111101011110111100001)
            have_lock_value  <= "00000000000000000010101000101010";
            have_lock_radian <= "00000000000000000000110101101100";
            lower_guard_value <= "11111111111111101011110111100001";
            upper_guard_value <= "01100100100001111110110101010001";

            --default_drift     <= x"000002C8";
            default_drift     <= x"00005088";

            power_ratio       <= "01"; --0 is 4, 1 is 8, 2 is 16, 3 is 32
            Nac2              <= x"3"; --2^x where x is this value
            antenna_enable    <= "1111";
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
    VARIABLE file_status: integer := 0;
    FILE bin_in_file: TEXT;
    VARIABLE bin_in_l: LINE;
    VARIABLE bin_in_v: std_logic_vector(11 DOWNTO 0);
    
    FILE cal_drift_file: TEXT;
    VARIABLE cal_drift_l: LINE;
    VARIABLE cal_drift_v: std_logic_vector(31 DOWNTO 0);
    
    FILE readyin_file: TEXT;
    VARIABLE readyin_l: LINE;
    VARIABLE readyin_v: std_logic_vector(0 DOWNTO 0);
    
    FILE real_in_file: TEXT;
    VARIABLE real_in_l: LINE;
    VARIABLE real_in_v: std_logic_vector(31 DOWNTO 0);
    
    FILE imag_in_file: TEXT;
    VARIABLE imag_in_l: LINE;
    VARIABLE imag_in_v: std_logic_vector(31 DOWNTO 0);

  BEGIN
  wait for SYSCLK_PERIOD;
    IF (file_status = 0) THEN
        report "Opening file";
        file_open(bin_in_file, "bin_in.dat", read_mode);
        file_open(cal_drift_file, "cal_drift.dat", read_mode);
        file_open(readyin_file, "readyin.dat", read_mode);
        file_open(real_in_file, "real_in_short.dat", read_mode);
        file_open(imag_in_file, "imag_in_short.dat", read_mode);
        --file_open(real_in_file, "real_in.dat", read_mode);
        --file_open(imag_in_file, "imag_in.dat", read_mode);
        
        READLINE(real_in_file, real_in_l);
        HREAD(real_in_l, real_in_v);
        real_in_s <= real_in_v;
      
        READLINE(imag_in_file, imag_in_l);
        HREAD(imag_in_l, imag_in_v);
        imag_in_s <= imag_in_v;
        
        file_status := 1;
    END IF;
    
    IF (file_status = 2) THEN
        report "Opening real and imag file";
        file_open(real_in_file, "real_in_short.dat", read_mode);
        file_open(imag_in_file, "imag_in_short.dat", read_mode);
        
        READLINE(real_in_file, real_in_l);
        HREAD(real_in_l, real_in_v);
        real_in_s <= real_in_v;
      
        READLINE(imag_in_file, imag_in_l);
        HREAD(imag_in_l, imag_in_v);
        imag_in_s <= imag_in_v;
        
        file_status := 1;
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
    
    IF SYSRESET = '0' AND NOT ENDFILE(bin_in_file) AND readyin_gated = '1' THEN
    --IF SYSRESET = '0' AND NOT ENDFILE(bin_in_file) THEN
      READLINE(real_in_file, real_in_l);
      HREAD(real_in_l, real_in_v);
      real_in_s <= real_in_v;
      
      READLINE(imag_in_file, imag_in_l);
      HREAD(imag_in_l, imag_in_v);
      imag_in_s <= imag_in_v;
    END IF;
    
    IF readyin_gated = '0' and readyin_gated_s = '1' THEN
        report "VHDL --> Falling edge of readyin, restarting";
        file_close(real_in_file);
        file_close(imag_in_file);
        file_status := 2;
    END IF;
    
    readyin_gated_s <= readyin_gated;

    IF ENDFILE(bin_in_file) THEN
      report "VHDL --> Sample input file ended, restarting";
      file_close(readyin_file);
      file_close(cal_drift_file);
      file_close(bin_in_file);
      file_close(real_in_file);
      file_close(imag_in_file);
      file_status := 0;
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
            Nac1 => Nac1_s,
            bin_in => bin_in_s,
            --cal_drift => std_logic_vector(shift_right(unsigned(cal_drift_s), 14) / 3),
            cal_drift => cal_drift_out,
            readyin => readyin_gated,
            new_phase_rdy => new_phase_rdy_s,

            -- Outputs
            calbin => calbin,
            phase_cor_re => phase_cor_re,
            phase_cor_im => phase_cor_im,
            kar_out => kar_out,
            readyout =>  readyout,
            readycal =>  readycal
        );
        
    cal_average : entity work.cal_average
        port map( 
            -- Inputs
            clk => SYSCLK,
            reset => SYSRESET,
            Nac1 => Nac1_s,
            bin_in => bin_in_s,
            readyin => readyin_gated,
            real_in => real_in_s,
            imag_in => imag_in_s,
            calbin_in => calbin,
            phase_cor_re => phase_cor_re,
            phase_cor_im => phase_cor_im,
            kar => kar_out,
            readyout => readyout,
            readycal => readycal,
            cplx_index => cplx_index,
            sum1_index => sum1_index,
            sum2_index => sum2_index,
            powertop_index => powertop_index,
            powerbot_index => powerbot_index,
            driftFD_index => driftFD_index,
            driftSD1_index => driftSD1_index,
            driftSD2_index => driftSD2_index,
            error_stick => '1',
            
            -- Outputs
            error => error_s,
            outreal => outreal_s,
            outimag => outimag_s,
            powertop => powertop_s,
            powerbot => powerbot_s,
            drift_FD => drift_FD_s,
            drift_SD => drift_SD_s,
            calbin_out => calbin_out,
            average_ready =>  average_ready_s,
            update_drift => update_drift
        );
        
    cal_process : entity work.cal_process
        PORT MAP( 
            clk => SYSCLK,
            reset => SYSRESET,
            outreal1 => outreal_s,
            outimag1 => outimag_s,
            powertop1 => powertop_s,
            powerbot1 => powerbot_s,
            drift_FD1 => drift_FD_s,
            drift_SD1 => drift_SD_s,
            outreal2 => outreal_s,
            outimag2 => outimag_s,
            powertop2 => powertop_s,
            powerbot2 => powerbot_s,
            drift_FD2 => drift_FD_s,
            drift_SD2 => drift_SD_s,
            outreal3 => outreal_s,
            outimag3 => outimag_s,
            powertop3 => powertop_s,
            powerbot3 => powerbot_s,
            drift_FD3 => drift_FD_s,
            drift_SD3 => drift_SD_s,
            outreal4 => outreal_s,
            outimag4 => outimag_s,
            powertop4 => powertop_s,
            powerbot4 => powerbot_s,
            drift_FD4 => drift_FD_s,
            drift_SD4 => drift_SD_s,
            calbin => calbin_out,
            readyout => average_ready_s,
            drift_in => cal_drift_out,
            update_drift => update_drift,
            error_stick => '1',

            default_drift   => default_drift,
            have_lock_value => have_lock_value,
            have_lock_radian  => have_lock_radian,
            lower_guard_value  => lower_guard_value,
            upper_guard_value  => upper_guard_value,
            power_ratio        => power_ratio,
            Nac2_setting       => Nac2,
            antenna_enable    => antenna_enable,
            
            error => error_process,
            drift_out => cal_drift_out,
            have_lock_out => have_lock_out_s,
            foutreal1 => foutreal1_s,
            foutimag1 => foutimag1_s,
            foutreal2 => foutreal2_s,
            foutimag2 => foutimag2_s,
            foutreal3 => foutreal3_s,
            foutimag3 => foutimag3_s,
            foutreal4 => foutreal4_s,
            foutimag4 => foutimag4_s,
            fout_ready => fout_ready_s,
            new_phase_rdy => new_phase_rdy_s
        );
end behavioral;

