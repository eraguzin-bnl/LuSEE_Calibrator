--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: cal_process.vhd
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

entity cal_process is
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        outreal1                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        outimag1                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        powertop1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
        powerbot1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
        drift_FD1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En4
        drift_SD1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
        outreal2                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
        outimag2                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
        powertop2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
        powerbot2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
        drift_FD2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En7
        drift_SD2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
        outreal3                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        outimag3                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        powertop3                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
        powerbot3                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
        drift_FD3                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En4
        drift_SD3                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
        outreal4                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
        outimag4                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En25
        powertop4                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
        powerbot4                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En21
        drift_FD4                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En7
        drift_SD4                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_E8
        calbin                            :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix10
        readyout                          :   IN    std_logic;
        drift_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En43
        update_drift                      :   IN    std_logic;
        
        drift_out                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En43
        have_lock_out                     :   OUT   std_logic;
        foutreal1                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
        foutimag1                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
        foutreal2                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        foutimag2                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        foutreal3                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
        foutimag3                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En20
        foutreal4                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        foutimag4                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        fout_ready                        :   OUT   std_logic
        );
end cal_process;
architecture architecture_cal_process of cal_process is
    signal FD1                            : signed(37 DOWNTO 0);
    signal FD2                            : signed(37 DOWNTO 0);
    signal FD3                            : signed(37 DOWNTO 0);
    signal FD4                            : signed(37 DOWNTO 0);
    signal SD1                            : signed(37 DOWNTO 0);
    signal SD2                            : signed(37 DOWNTO 0);
    signal SD3                            : signed(37 DOWNTO 0);
    signal SD4                            : signed(37 DOWNTO 0);

begin
    process (clk) begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                FD1              <= (others=>'0');
                FD2              <= (others=>'0');
                FD3              <= (others=>'0');
                FD4              <= (others=>'0');
                SD1              <= (others=>'0');
                SD2              <= (others=>'0');
                SD3              <= (others=>'0');
                SD4              <= (others=>'0');
            else
                if (readyout = '1') then
                    FD1 <= FD1 + signed(drift_FD1);
                    FD2 <= FD2 + signed(drift_FD2);
                    FD3 <= FD3 + signed(drift_FD3);
                    FD4 <= FD4 + signed(drift_FD4);
                    
                    SD1 <= SD1 + signed(drift_SD1);
                    SD2 <= SD2 + signed(drift_SD2);
                    SD3 <= SD3 + signed(drift_SD3);
                    SD4 <= SD4 + signed(drift_SD4);
                end if;
            end if;
        end if;
    end process;
end architecture_cal_process;
