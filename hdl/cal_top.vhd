--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: cal_top.vhd
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

library polarfire;
use polarfire.all;

entity cal_top is
port (
	clk : IN  std_logic;
    reset : IN std_logic;
    have_lock : OUT std_logic
);
end cal_top;
architecture architecture_cal_top of cal_top is
	signal bin_in_s   : std_logic_vector(11 DOWNTO 0);
    signal cal_drift_s   : std_logic_vector(31 DOWNTO 0);
    signal readyin_s   : std_logic;
    
    signal real_in_s  : std_logic_vector(31 DOWNTO 0);
    signal imag_in_s  : std_logic_vector(31 DOWNTO 0);
    
    signal Nac1_s      : std_logic_vector(1 DOWNTO 0);

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
    signal driftSD_index                       : std_logic_vector(5 downto 0);
    signal error_s                             : std_logic_vector(10 DOWNTO 0);
    
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
    attribute syn_keep : boolean;
    attribute syn_keep of bin_in_s, cal_drift_s, readyin_s, real_in_s, imag_in_s, calbin, calbin_out, phase_cor_re, phase_cor_im,
    kar_out, readyout, update_drift, readycal, outreal_s, outimag_s, powertop_s, powerbot_s, drift_FD_s, drift_SD_s, average_ready_s,
    cplx_index, sum1_index,  sum2_index, powertop_index, powerbot_index, driftFD_index, driftSD_index, error_s, cal_drift_out, 
    error_process, have_lock_out_s, foutreal1_s, foutimag1_s, foutreal2_s, foutimag2_s, foutreal3_s, foutimag3_s, foutreal4_s,
    foutimag4_s, fout_ready_s, new_phase_rdy_s: signal is true;

begin
   cal_phaser : entity work.cal_phaser
        port map( 
            -- Inputs
            clk => clk,
            reset => reset,
            Nac1 => Nac1_s,
            bin_in => bin_in_s,
            --cal_drift => std_logic_vector(shift_right(unsigned(cal_drift_s), 14) / 3),
            cal_drift => cal_drift_out,
            readyin => '1',
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
            clk => clk,
            reset => reset,
            Nac1 => Nac1_s,
            bin_in => bin_in_s,
            readyin => '1',
            real_in => real_in_s,
            imag_in => imag_in_s,
            calbin_in => calbin,
            phase_cor_re => phase_cor_re,
            phase_cor_im => phase_cor_im,
            kar => kar_out,
            readyout => readyout,
            readycal => readycal,
            cplx_index => std_logic_vector(to_unsigned(29, cplx_index'length)),
            sum1_index => std_logic_vector(to_unsigned(32, sum1_index'length)),
            sum2_index => std_logic_vector(to_unsigned(32, sum2_index'length)),
            powertop_index => std_logic_vector(to_unsigned(32, powertop_index'length)),
            powerbot_index => std_logic_vector(to_unsigned(32, powerbot_index'length)),
            driftFD_index => std_logic_vector(to_unsigned(29, driftFD_index'length)),
            driftSD1_index => std_logic_vector(to_unsigned(26, driftSD_index'length)),
            driftSD2_index => std_logic_vector(to_unsigned(2, driftSD_index'length)),
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
            clk => clk,
            reset => reset,
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

            default_drift   => x"00005088",
            have_lock_value => "00000000000000000010101000101010",
            have_lock_radian  => "00000000000000000000110101101100",
            lower_guard_value  => "11111111111111101011110111100001",
            upper_guard_value  => "01100100100001111110110101010001",
            power_ratio        => "01",
            Nac2_setting       => x"4",
            antenna_enable    => "1111",
            
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
    have_lock <= have_lock_out_s;
end architecture_cal_top;
