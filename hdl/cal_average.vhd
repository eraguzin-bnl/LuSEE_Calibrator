--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: cal_average.vhd
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

entity cal_average is
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        bin_in                            :   IN    std_logic_vector(11 DOWNTO 0);  -- Just a stream of literally 0 through 2047
        readyin                           :   IN    std_logic;                      -- From the notch filter showing that bins are coming in
        real_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        imag_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        calbin                            :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
        phase_cor_re                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        phase_cor_im                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        kar                               :   IN    std_logic_vector(15 DOWNTO 0);  -- ufix16
        readyout                          :   IN    std_logic;
        readycal                          :   IN    std_logic;
        outreal                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        outimag                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        powertop                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
        powerbot                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En33
        drift_FD                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En5
        drift_SD                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_E11
);
end cal_average;
architecture architecture_cal_average of cal_average is
    SIGNAL notch_data_re_we                     : std_logic;
    SIGNAL notch_data_re_re                     : std_logic;
    SIGNAL notch_data_re_full                   : std_logic;
    SIGNAL notch_data_re_empty                  : std_logic;
    SIGNAL notch_data_re_s                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL notch_data_re_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL notch_data_im_we                     : std_logic;
    SIGNAL notch_data_im_re                     : std_logic;
    SIGNAL notch_data_im_full                   : std_logic;
    SIGNAL notch_data_im_empty                  : std_logic;
    SIGNAL notch_data_im_s                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL notch_data_im_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL phase_data_re_we                     : std_logic;
    SIGNAL phase_data_re_re                     : std_logic;
    SIGNAL phase_data_re_full                   : std_logic;
    SIGNAL phase_data_re_empty                  : std_logic;
    SIGNAL phase_data_re_s                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_data_re_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL phase_data_im_we                     : std_logic;
    SIGNAL phase_data_im_re                     : std_logic;
    SIGNAL phase_data_im_full                   : std_logic;
    SIGNAL phase_data_im_empty                  : std_logic;
    SIGNAL phase_data_im_s                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_data_im_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL kar_readyout_data_we                     : std_logic;
    SIGNAL kar_readyout_data_re                     : std_logic;
    SIGNAL kar_readyout_data_full                   : std_logic;
    SIGNAL kar_readyout_data_empty                  : std_logic;
    SIGNAL kar_readyout_data_s                      : std_logic_vector(16 DOWNTO 0);
    SIGNAL kar_readyout_data_out                    : std_logic_vector(16 DOWNTO 0);
    
    SIGNAL readyin_s                            : std_logic;
    SIGNAL readycal_s                           : std_logic;
    SIGNAL error_data_fifo_full                 : std_logic;
    SIGNAL error_data_fifo_backup               : std_logic;
    SIGNAL error_phase_fifo_full                 : std_logic;
    SIGNAL error_phase_fifo_backup               : std_logic;

begin

    -- Since we cannot process each bin as fast as they are coming in (every 4 clock cycles), each real and imaginary value is
    -- Stored in a FIFO and the state machine does the math as it can
    -- This FIFO has room for 512 samples of values. 
    -- It should never fill up, because the cal_phaser block should be sending the phase data soon after a batch is coming in
    notch_data_re : entity work.CAL_AVERAGE_DATA_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => notch_data_re_s,
        WE       => notch_data_re_we,
        FULL     => notch_data_re_full,
        Q        => notch_data_re_out,
        RE       => notch_data_re_re,
        EMPTY    => notch_data_re_empty
        );
        
    notch_data_im : entity work.CAL_AVERAGE_DATA_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => notch_data_im_s,
        WE       => notch_data_im_we,
        FULL     => notch_data_im_full,
        Q        => notch_data_im_out,
        RE       => notch_data_im_re,
        EMPTY    => notch_data_im_empty
        );
        
    phase_data_re : entity work.CAL_AVERAGE_DATA_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => phase_data_re_s,
        WE       => phase_data_re_we,
        FULL     => phase_data_re_full,
        Q        => phase_data_re_out,
        RE       => phase_data_re_re,
        EMPTY    => phase_data_re_empty
        );
        
    phase_data_im : entity work.CAL_AVERAGE_DATA_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => phase_data_im_s,
        WE       => phase_data_im_we,
        FULL     => phase_data_im_full,
        Q        => phase_data_im_out,
        RE       => phase_data_im_re,
        EMPTY    => phase_data_im_empty
        );
        
    --17 bits, 16 for kar, 1 for readyout
    kar_readyout : entity work.CAL_AVERAGE_OTHER_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => kar_readyout_data_im_s,
        WE       => kar_readyout_data_im_we,
        FULL     => kar_readyout_data_im_full,
        Q        => kar_readyout_data_im_out,
        RE       => kar_readyout_data_im_re,
        EMPTY    => kar_readyout_data_im_empty
        );

    process (clk) begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                notch_data_re_s              <= (others=>'0');
                notch_data_re_we             <= '0';
                notch_data_im_s              <= (others=>'0');
                notch_data_im_we             <= '0';
                
                phase_data_re_s              <= (others=>'0');
                phase_data_re_we             <= '0';
                phase_data_im_s              <= (others=>'0');
                phase_data_im_we             <= '0';
                
                kar_readyout_data_s              <= (others=>'0');
                kar_readyout_data_we             <= '0';
                
                error_data_fifo_full         <= '0';
                error_data_fifo_backup       <= '0';
                error_phase_fifo_full         <= '0';
                error_phase_fifo_backup       <= '0';
                readyin_s                    <= '0';
                readycal_s                   <= '0';
            else
                -- This section will just put any incoming bin of 2, 6, 10, 14, into the FIFO for processing
                -- And throw an error if it ever fills up
                notch_data_re_we <= '0';
                notch_data_im_we <= '0';
                if (readyin = '1') then
                    -- Only act on incoming bins where bins%4 = 2
                    if (bin_in(1 downto 0) = "10") then
                        -- Save incoming data so we can multiply when we have the phase later
                        if (notch_data_re_full = '0' and notch_data_im_full = '0') then
                            notch_data_re_s <= real_in;
                            notch_data_re_we <= '1';
                            notch_data_im_s <= imag_in;
                            notch_data_im_we <= '1';
                        else
                            --With a depth of 512 and enough time between notch filter averages to process, should never fill up
                            error_data_fifo_full <= '1';
                        end if;
                    end if;
                end if;
                readyin_s <= readyin;
                if (readyin_s = '0' and readyin = '1' and (notch_data_re_empty = '0' or notch_data_im_empty = '0')) then
                    -- When a new batch comes in, both FIFOs should be completely empty
                    error_data_fifo_backup <= '1';
                end if;
                
                phase_data_re_we <= '0';
                phase_data_im_we <= '0';
                kar_readyout_data_we <= '0';
                if (readycal = '1') then
                    if (bin_in(1 downto 0) = "10") then
                        -- Save incoming data so we can multiply when we have the phase later
                        if (phase_data_re_full = '0' and phase_data_im_full = '0' and kar_readyout_data_full = '0') then
                            phase_data_re_s <= phase_cor_re;
                            phase_data_re_we <= '1';
                            phase_data_im_s <= phase_cor_im;
                            phase_data_im_we <= '1';
                            kar_readyout_data_s <= readyout & kar;
                            kar_readyout_data_we <= '1';
                        else
                            --With a depth of 512 and enough time between notch filter averages to process, should never fill up
                            error_phase_fifo_full <= '1';
                        end if;
                    end if;
                end if;
                readycal_s <= readycal;
                if (readycal_s='0' and readycal='1' and (phase_data_re_empty='0' or phase_data_im_empty='0' or kar_readyout_data_empty='0')) then
                    -- When a new batch comes in, both FIFOs should be completely empty
                    error_phase_fifo_backup <= '1';
                end if;
            end if;
        end if;
    end process;
end architecture_cal_average;
