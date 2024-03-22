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
USE IEEE.numeric_std.ALL;

use work.MultiplyTestPkg.all;

entity cal_average is
  generic(
    ACCUMULATOR_BASE : integer := 36
  );
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        Nac1                              :   IN    std_logic_vector(1 DOWNTO 0);
        bin_in                            :   IN    std_logic_vector(11 DOWNTO 0);  -- Just a stream of literally 0 through 2047
        readyin                           :   IN    std_logic;                      -- From the notch filter showing that bins are coming in
        real_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        imag_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        calbin_in                         :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix10
        phase_cor_re                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        phase_cor_im                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        kar                               :   IN    std_logic_vector(17 DOWNTO 0);  -- ufix16
        readyout                          :   IN    std_logic;
        readycal                          :   IN    std_logic;
        cplx_index                        :   IN    std_logic_vector(5 downto 0);
        sum1_index                        :   IN    std_logic_vector(5 downto 0);
        sum2_index                        :   IN    std_logic_vector(5 downto 0);
        powertop_index                    :   IN    std_logic_vector(5 downto 0);
        powerbot_index                    :   IN    std_logic_vector(5 downto 0);
        driftFD_index                     :   IN    std_logic_vector(5 downto 0);
        driftSD1_index                    :   IN    std_logic_vector(5 downto 0);
        driftSD2_index                    :   IN    std_logic_vector(5 downto 0);
        error_stick                       :   IN    std_logic;
        error                             :   OUT   std_logic_vector(10 DOWNTO 0);
        outreal                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        outimag                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En24
        powertop                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En18
        powerbot                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En33
        drift_FD                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En5
        drift_SD                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_E11
        calbin_out                        :   OUT   std_logic_vector(8 DOWNTO 0);  -- ufix10
        average_ready                     :   OUT   std_logic;
        update_drift                      :   OUT   std_logic
);
end cal_average;
architecture architecture_cal_average of cal_average is
    SIGNAL read_address                   : std_logic_vector(8 downto 0);
    SIGNAL write_address                  : std_logic_vector(8 downto 0);
    SIGNAL write_en                       : std_logic;
    
    SIGNAL first_time                     : std_logic;
    SIGNAL sum0_re_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0_im_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0_re_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0_im_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0_re_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0_im_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    
    SIGNAL sum0alt_re_write_data          : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0alt_im_write_data          : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0alt_re_read_data           : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0alt_im_read_data           : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0alt_re_read_data_s         : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum0alt_im_read_data_s         : signed(ACCUMULATOR_BASE+2 downto 0);
    
    SIGNAL sum1_re_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum1_im_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum1_re_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum1_im_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum1_re_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum1_im_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    
    SIGNAL sum2_re_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum2_im_write_data             : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum2_re_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum2_im_read_data              : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum2_re_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    SIGNAL sum2_im_read_data_s            : signed(ACCUMULATOR_BASE+2 downto 0);
    
    SIGNAL notch_data_re_we               : std_logic;
    SIGNAL notch_data_re_re               : std_logic;
    SIGNAL notch_data_re_full             : std_logic;
    SIGNAL notch_data_re_empty            : std_logic;
    SIGNAL notch_data_re_s                : std_logic_vector(31 DOWNTO 0);
    SIGNAL notch_data_re_out              : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL notch_data_im_we               : std_logic;
    SIGNAL notch_data_im_re               : std_logic;
    SIGNAL notch_data_im_full             : std_logic;
    SIGNAL notch_data_im_empty            : std_logic;
    SIGNAL notch_data_im_s                : std_logic_vector(31 DOWNTO 0);
    SIGNAL notch_data_im_out              : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL phase_data_re_we               : std_logic;
    SIGNAL phase_data_re_re               : std_logic;
    SIGNAL phase_data_re_full             : std_logic;
    SIGNAL phase_data_re_empty            : std_logic;
    SIGNAL phase_data_re_s                : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_data_re_out              : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL phase_data_im_we               : std_logic;
    SIGNAL phase_data_im_re               : std_logic;
    SIGNAL phase_data_im_full             : std_logic;
    SIGNAL phase_data_im_empty            : std_logic;
    SIGNAL phase_data_im_s                : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_data_im_out              : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL calbin_s                       : unsigned(8 DOWNTO 0);
    SIGNAL kar_readyout_data_we           : std_logic;
    SIGNAL kar_readyout_data_re           : std_logic;
    SIGNAL kar_readyout_data_full         : std_logic;
    SIGNAL kar_readyout_data_empty        : std_logic;
    SIGNAL kar_readyout_data_s            : std_logic_vector(27 DOWNTO 0);
    SIGNAL kar_readyout_data_out          : std_logic_vector(27 DOWNTO 0);
    
    SIGNAL kar_curr                       : unsigned(17 DOWNTO 0);
    SIGNAL kar_squared                    : unsigned(35 DOWNTO 0);
    SIGNAL kar_squared_signed             : signed(35 DOWNTO 0);
    SIGNAL readyout_curr                  : std_logic; 
    SIGNAL tick                           : std_logic;
    
    SIGNAL readyin_s                      : std_logic;
    SIGNAL readycal_s                     : std_logic;
    SIGNAL error_data_fifo_full           : std_logic;
    SIGNAL error_data_fifo_backup         : std_logic;
    SIGNAL error_phase_fifo_full          : std_logic;
    SIGNAL error_fifo_alignment           : std_logic;
    
    SIGNAL product_re_re                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_re_im                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_re                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_im                  : std_logic_vector(63 DOWNTO 0);
    
    SIGNAL product_kar_squared_re         : std_logic_vector(67 DOWNTO 0);
    SIGNAL product_kar_squared_im         : std_logic_vector(67 DOWNTO 0);
    
    SIGNAL multiplicand1_re               : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand1_im               : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand2_re               : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand2_im               : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL multiplicand_kar_squared       : std_logic_vector(35 DOWNTO 0);
    SIGNAL multiplicand3_re               : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand3_im               : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL sum_re                         : signed(64 DOWNTO 0);
    SIGNAL sum_im                         : signed(64 DOWNTO 0);
    SIGNAL valid_in                       : std_logic;
    SIGNAL valid_out                      : std_logic_vector(3 DOWNTO 0);
    
    SIGNAL valid_in_kar_squared           : std_logic;
    SIGNAL valid_out_kar_squared          : std_logic_vector(1 DOWNTO 0);
    
    SIGNAL Nac1_s                         : integer range 0 to 2;
    
    SIGNAL sum0_re_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum0alt_re_new                 : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum1_re_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum2_re_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    
    SIGNAL sum0_im_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum0alt_im_new                 : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum1_im_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    SIGNAL sum2_im_new                    : signed(ACCUMULATOR_BASE+2 DOWNTO 0);
    
    SIGNAL cplx_slice                     : integer range 0 to 33;
    SIGNAL sum1_slice                     : integer range 0 to 32;
    SIGNAL sum2_slice                     : integer range 0 to 36;
    SIGNAL powertop_slice                 : integer range 0 to 33;
    SIGNAL powerbot_slice                 : integer range 0 to 33;
    SIGNAL driftFD_slice                  : integer range 0 to 33;
    SIGNAL driftSD1_slice                 : integer range 0 to 33;
    SIGNAL driftSD2_slice                 : integer range 0 to 33;
    
    SIGNAL cplx_in_re                     : signed(31 DOWNTO 0);
    SIGNAL cplx_in_im                     : signed(31 DOWNTO 0);
    
    SIGNAL drift_SD1                      : signed(63 DOWNTO 0);
    SIGNAL drift_SD_s                     : signed(31 DOWNTO 0);
    
    SIGNAL error_stick_s                  : std_logic;
    SIGNAL error_s                        : std_logic_vector(6 DOWNTO 0);
    
    signal SD1_shifted1_dummy      : signed(63 DOWNTO 0);
    signal SD1_shifted2_dummy      : signed(31 DOWNTO 0);
    
    signal SD2_shifted1_dummy      : signed(64 DOWNTO 0);
    signal SD2_shifted2_dummy      : signed(31 DOWNTO 0);
    
    type state_type is (S_IDLE,
        S_FIFO_WAIT_1,
        S_FIFO_WAIT_2,
        S_BEGIN_MULTIPLY,
        S_MULTIPLY_WAIT,
        S_BIT_SLICE,
        S_BEGIN_MULTIPLY_2,
        S_MULTIPLY_WAIT_2,
        S_BIT_SLICE_2,
        S_STORE_OR_OUTPUT,
        S_BEGIN_MULTIPLY_3,
        S_MULTIPLY_WAIT_3,
        S_BEGIN_MULTIPLY_4,
        S_MULTIPLY_WAIT_4,
        S_BEGIN_MULTIPLY_5,
        S_MULTIPLY_WAIT_5,
        S_BEGIN_MULTIPLY_6,
        S_MULTIPLY_WAIT_6,
        S_BEGIN_MULTIPLY_7,
        S_MULTIPLY_WAIT_7,
        S_OUTPUT_READY);
    signal state: state_type;
    
    component CAL_AVERAGE_DATA_FIFO
    PORT ( 
        CLK                               :   IN    std_logic;
        DATA                              :   IN    std_logic_vector(31 downto 0);
        RE                                :   IN    std_logic;
        RESET_N                           :   IN    std_logic;
        WE                                :   IN    std_logic;
        EMPTY                             :   OUT   std_logic;
        FULL                              :   OUT   std_logic;
        Q                                 :   OUT   std_logic_vector(31 downto 0)
        );
    end component;
    
    component CAL_AVERAGE_OTHER_FIFO
    PORT ( 
        CLK                               :   IN    std_logic;
        DATA                              :   IN    std_logic_vector(27 downto 0);
        RE                                :   IN    std_logic;
        RESET_N                           :   IN    std_logic;
        WE                                :   IN    std_logic;
        EMPTY                             :   OUT   std_logic;
        FULL                              :   OUT   std_logic;
        Q                                 :   OUT   std_logic_vector(27 downto 0)
        );
    end component;
    
    component PF_TPSRAM_CAL
    PORT ( 
        CLK                               :   IN    std_logic;
        R_ADDR                            :   IN    std_logic_vector(8 downto 0);
        W_ADDR                            :   IN    std_logic_vector(8 downto 0);
        W_DATA                            :   IN    signed(ACCUMULATOR_BASE+2 downto 0);
        W_EN                              :   IN    std_logic;
        R_DATA                            :   OUT   signed(ACCUMULATOR_BASE+2 downto 0)
        );
    end component;

begin
    error <= error_data_fifo_full & error_data_fifo_backup & error_phase_fifo_full & error_fifo_alignment & error_s;
    -- Since we cannot process each bin as fast as they are coming in (every 4 clock cycles), each real and imaginary value is
    -- Stored in a FIFO and the state machine does the math as it can
    -- This FIFO has room for 512 samples of values. 
    -- It should never fill up, because the cal_phaser block should be sending the phase data soon after a batch is coming in
    notch_data_re : CAL_AVERAGE_DATA_FIFO
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
        
    notch_data_im : CAL_AVERAGE_DATA_FIFO
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
        
    phase_data_re : CAL_AVERAGE_DATA_FIFO
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
        
    phase_data_im : CAL_AVERAGE_DATA_FIFO
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
        
    --27 bits, 10 for calbin, 16 for kar, 1 for readyout, 512 depth
    kar_readyout : CAL_AVERAGE_OTHER_FIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => kar_readyout_data_s,
        WE       => kar_readyout_data_we,
        FULL     => kar_readyout_data_full,
        Q        => kar_readyout_data_out,
        RE       => kar_readyout_data_re,
        EMPTY    => kar_readyout_data_empty
        );
        
    --Kar^2 * real of cplx_in
    mult_kar_squared_re : entity work.Multiply_generic36
        generic map(
            a_size => 35)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand_kar_squared,
            i_mb => multiplicand3_re,

            --Valid
            valid_in => valid_in_kar_squared,
            valid_out => valid_out_kar_squared(0),

            -- Outputs
            o_m => product_kar_squared_re
        );
        
    --Kar^2 * imag of cplx_in
    mult_kar_squared_ime : entity work.Multiply_generic36
        generic map(
            a_size => 35)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand_kar_squared,
            i_mb => multiplicand3_im,

            --Valid
            valid_in => valid_in_kar_squared,
            valid_out => valid_out_kar_squared(1),

            -- Outputs
            o_m => product_kar_squared_im
        );
        
    --Real of first * real of second
    mult_re_re : entity work.Multiply_generic32
        generic map(
            size => 32)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand1_re,
            i_mb => multiplicand2_re,

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(0),

            -- Outputs
            o_m => product_re_re
        );
        
    --Real of first * imaginary of second
    mult_re_im : entity work.Multiply_generic32
        generic map(
            size => 32)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand1_re,
            i_mb => multiplicand2_im,

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(1),

            -- Outputs
            o_m => product_re_im
        );
        
    --Imaginary of first * real of second
    mult_im_re : entity work.Multiply_generic32
        generic map(
            size => 32)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand1_im,
            i_mb => multiplicand2_re,

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(2),

            -- Outputs
            o_m => product_im_re
        );
        
    --Imaginary of first * imaginary of second
    mult_im_im : entity work.Multiply_generic32
        generic map(
            size => 32)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => multiplicand1_im,
            i_mb => multiplicand2_im,

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(3),

            -- Outputs
            o_m => product_im_im
        );
        
    sum0_re_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum0_re_write_data,
        R_DATA   => sum0_re_read_data
        );
        
    sum0_im_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum0_im_write_data,
        R_DATA   => sum0_im_read_data
        );
        
    sum0alt_re_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum0alt_re_write_data,
        R_DATA   => sum0alt_re_read_data
        );
        
    sum0alt_im_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum0alt_im_write_data,
        R_DATA   => sum0alt_im_read_data
        );
        
    sum1_re_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum1_re_write_data,
        R_DATA   => sum1_re_read_data
        );
        
    sum1_im_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum1_im_write_data,
        R_DATA   => sum1_im_read_data
        );
        
    sum2_re_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum2_re_write_data,
        R_DATA   => sum2_re_read_data
        );
        
    sum2_im_accumulator : PF_TPSRAM_CAL
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sum2_im_write_data,
        R_DATA   => sum2_im_read_data
        );

    process (clk)
        variable result66_shifted : signed(65 DOWNTO 0) := (others=>'0');
    
        variable result65_shifted : signed(64 DOWNTO 0) := (others=>'0');
        variable result65_shifted2: signed(64 DOWNTO 0) := (others=>'0');
        
        variable result64_shifted : signed(63 DOWNTO 0) := (others=>'0');
        variable result64_shifted2: signed(63 DOWNTO 0) := (others=>'0');
        variable result68_shifted : signed(67 DOWNTO 0) := (others=>'0');
        variable result68_shifted2: signed(67 DOWNTO 0) := (others=>'0');
        
        variable SD1_shifted1      : signed(63 DOWNTO 0) := (others=>'0');
        variable SD1_shifted2      : signed(31 DOWNTO 0) := (others=>'0');
        
        variable SD2_shifted1      : signed(64 DOWNTO 0) := (others=>'0');
        variable SD2_shifted2      : signed(31 DOWNTO 0) := (others=>'0');
        begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                write_en                     <= '0';
                write_address                <= (others=>'0');
                read_address                 <= (others=>'0');
                
                first_time                   <= '1';
                sum0_re_write_data           <= (others=>'0');
                sum0_im_write_data           <= (others=>'0');
                sum0alt_re_write_data        <= (others=>'0');
                sum0alt_im_write_data        <= (others=>'0');
                sum1_re_write_data           <= (others=>'0');
                sum1_im_write_data           <= (others=>'0');
                sum2_re_write_data           <= (others=>'0');
                sum2_im_write_data           <= (others=>'0');
                    
                notch_data_re_s              <= (others=>'0');
                notch_data_re_we             <= '0';
                notch_data_im_s              <= (others=>'0');
                notch_data_im_we             <= '0';
                
                phase_data_re_s              <= (others=>'0');
                phase_data_re_we             <= '0';
                phase_data_im_s              <= (others=>'0');
                phase_data_im_we             <= '0';
                
                kar_readyout_data_s          <= (others=>'0');
                kar_readyout_data_we         <= '0';
                valid_in                     <= '0';
                valid_in_kar_squared         <= '0';
                
                multiplicand1_re             <= (others=>'0');
                multiplicand1_im             <= (others=>'0');
                multiplicand2_re             <= (others=>'0');
                multiplicand2_im             <= (others=>'0');
                
                multiplicand3_re             <= (others=>'0');
                multiplicand3_im             <= (others=>'0');
                multiplicand_kar_squared     <= (others=>'0');
                
                kar_curr                     <= (others=>'0');
                kar_squared                  <= (others=>'0');
                kar_squared_signed           <= (others=>'0');
                calbin_s                     <= (others=>'0');
                readyout_curr                <= '0';
                
                tick                         <= '1';
                cplx_in_re                   <= (others=>'0');
                cplx_in_im                   <= (others=>'0');
                
                cplx_slice                   <= 0;
                sum1_slice                   <= 0;
                sum2_slice                   <= 0;
                powertop_slice               <= 0;
                powerbot_slice               <= 0;
                driftFD_slice                <= 0;
                driftSD1_slice               <= 0;
                driftSD2_slice               <= 0;
                Nac1_s                       <= 1;
                
                calbin_out                   <= (others=>'0');
                average_ready                <= '0';
                update_drift                 <= '0';
                
                sum0_re_new                  <= (others=>'0');
                sum0alt_re_new               <= (others=>'0');
                sum1_re_new                  <= (others=>'0');
                sum2_re_new                  <= (others=>'0');
                
                sum0_im_new                  <= (others=>'0');
                sum0alt_im_new               <= (others=>'0');
                sum1_im_new                  <= (others=>'0');
                sum2_im_new                  <= (others=>'0');
                
                sum0_re_read_data_s          <= (others=>'0');
                sum0_im_read_data_s          <= (others=>'0');
                sum0alt_re_read_data_s       <= (others=>'0');
                sum0alt_im_read_data_s       <= (others=>'0');
                sum1_re_read_data_s          <= (others=>'0');
                sum1_im_read_data_s          <= (others=>'0');
                sum2_re_read_data_s          <= (others=>'0');
                sum2_im_read_data_s          <= (others=>'0');
                
                drift_SD1                    <= (others=>'0');
                drift_SD_s                   <= (others=>'0');
                
                error_data_fifo_full         <= '0';
                error_data_fifo_backup       <= '0';
                error_phase_fifo_full        <= '0';
                error_fifo_alignment         <= '0';
                readyin_s                    <= '0';
                readycal_s                   <= '0';
                
                outreal                      <= (others=>'0');
                outimag                      <= (others=>'0');
                powertop                     <= (others=>'0');
                powerbot                     <= (others=>'0');
                drift_FD                     <= (others=>'0');
                drift_SD                     <= (others=>'0');
                sum_re                       <= (others=>'0');
                sum_im                       <= (others=>'0');
                
                error_s                      <= (others=>'0');
                
                result66_shifted             := (others=>'0');
                result65_shifted             := (others=>'0');
                result65_shifted2            := (others=>'0');
                
                result64_shifted             := (others=>'0');
                result64_shifted2            := (others=>'0');
                result68_shifted             := (others=>'0');
                result68_shifted2            := (others=>'0');
            else
                -- This section will just put any incoming bin of 2, 6, 10, 14, into the FIFO for processing
                -- And throw an error if it ever fills up
                notch_data_re_we <= '0';
                notch_data_im_we <= '0';
                
                error_stick_s    <= error_stick;
                if (error_stick_s = '0') then
                    error_s <= (others=>'0');
                    error_data_fifo_full         <= '0';
                    error_data_fifo_backup       <= '0';
                    error_phase_fifo_full        <= '0';
                    error_fifo_alignment         <= '0';
                end if;
                
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
                    -- Save incoming data so we can multiply when we have the phase later
                    if (phase_data_re_full = '0' and phase_data_im_full = '0' and kar_readyout_data_full = '0') then
                        phase_data_re_s <= phase_cor_re;
                        phase_data_re_we <= '1';
                        phase_data_im_s <= phase_cor_im;
                        phase_data_im_we <= '1';
                        kar_readyout_data_s <= readyout & calbin_in & kar;
                        kar_readyout_data_we <= '1';
                    else
                        --With a depth of 512 and enough time between notch filter averages to process, should never fill up
                        error_phase_fifo_full <= '1';
                    end if;
                end if;
                readycal_s <= readycal;
                
                case state is
                when S_IDLE =>
                    average_ready <= '0';
                    update_drift <= '0';
                    calbin_out <= (others=>'0');
                    write_en <= '0';
                    -- Wait until we have phase data that has been FIFO'data
                    -- If there is phase data, there should ALWAYS be notch data
                    notch_data_re_re <= '0';
                    notch_data_im_re <= '0';
                    phase_data_re_re <= '0';
                    phase_data_im_re <= '0';
                    kar_readyout_data_re <= '0';
                    if (phase_data_re_empty='0') then
                        if (phase_data_im_empty='1' or kar_readyout_data_empty='1' or notch_data_re_empty='1' or notch_data_im_empty='1') then
                            error_fifo_alignment <= '1';
                        end if;
                        
                        -- Get the next output for all FIFOs
                        notch_data_re_re <= '1';
                        notch_data_im_re <= '1';
                        phase_data_re_re <= '1';
                        phase_data_im_re <= '1';
                        kar_readyout_data_re <= '1';
                        
                        state <= S_FIFO_WAIT_1;
                    end if;
                when S_FIFO_WAIT_1 =>
                    notch_data_re_re <= '0';
                    notch_data_im_re <= '0';
                    phase_data_re_re <= '0';
                    phase_data_im_re <= '0';
                    kar_readyout_data_re <= '0';
                    
                    state <= S_FIFO_WAIT_2;
                when S_FIFO_WAIT_2 =>
                    state <= S_BEGIN_MULTIPLY;
                when S_BEGIN_MULTIPLY =>
                    multiplicand1_re <= notch_data_re_out;
                    multiplicand1_im <= notch_data_im_out;
                    multiplicand2_re <= phase_data_re_out;
                    multiplicand2_im <= phase_data_im_out;
                    valid_in <= '1';
                    
                    kar_curr <= unsigned(kar_readyout_data_out(17 DOWNTO 0));
                    calbin_s <= unsigned(kar_readyout_data_out(26 DOWNTO 18));
                    readyout_curr <= kar_readyout_data_out(27);
                    state <= S_MULTIPLY_WAIT;
                when S_MULTIPLY_WAIT =>
                    valid_in <= '0';
                    if (first_time = '0') then
                        read_address <= std_logic_vector(calbin_s);
                    end if;
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        sum_im <= resize(signed(product_re_im), 65) + resize(signed(product_im_re), 65);
                        kar_squared <= kar_curr * kar_curr;
                        state <= S_BIT_SLICE;
                    end if;
                    cplx_slice <= to_integer(unsigned(cplx_index));
                when S_BIT_SLICE =>
                    result65_shifted  := shift_right(sum_re, cplx_slice);
                    result65_shifted2 := shift_right(sum_im, cplx_slice);
                    cplx_in_re <= result65_shifted(31 DOWNTO 0);
                    cplx_in_im <= result65_shifted2(31 DOWNTO 0);
                    
                    test65_slice_proc(sum_re, cplx_slice, 0, error_s);                    
                    test65_slice_proc(sum_im, cplx_slice, 0, error_s);
                    
                    kar_squared_signed <= signed(kar_squared);
                    state <= S_BEGIN_MULTIPLY_2;
                when S_BEGIN_MULTIPLY_2 =>
                    multiplicand1_re <= std_logic_vector(cplx_in_re);
                    multiplicand1_im <= std_logic_vector(cplx_in_im);
                    multiplicand2_im <= x"000" & "00" & std_logic_vector(kar_curr);
                    valid_in <= '1';
                    
                    multiplicand3_re <= std_logic_vector(cplx_in_re);
                    multiplicand3_im <= std_logic_vector(cplx_in_im);
                    multiplicand_kar_squared <= std_logic_vector(-kar_squared_signed);
                    valid_in_kar_squared <= '1';
                    
                    state <= S_MULTIPLY_WAIT_2;
                when S_MULTIPLY_WAIT_2 =>
                    valid_in <= '0';
                    valid_in_kar_squared <= '0';
                    if (valid_out_kar_squared = "11") then
                        state <= S_BIT_SLICE_2;
                    end if;
                    sum1_slice <= to_integer(unsigned(sum1_index));
                    sum2_slice <= to_integer(unsigned(sum2_index));
                when S_BIT_SLICE_2 =>
                    sum0_re_new <= resize(cplx_in_re, sum0_re_new'length);
                    sum0_im_new <= resize(cplx_in_im, sum0_im_new'length);
                    if (tick) then
                        sum0alt_re_new <= resize(cplx_in_re, sum0alt_re_new'length);
                        sum0alt_im_new <= resize(cplx_in_im, sum0alt_im_new'length);
                    else
                        sum0alt_re_new <= resize(-cplx_in_re, sum0alt_re_new'length);
                        sum0alt_im_new <= resize(-cplx_in_im, sum0alt_im_new'length);
                    end if;
                    
                    result64_shifted  := shift_right(signed(product_im_im), sum1_slice);
                    result64_shifted2 := shift_right(signed(product_re_im), sum1_slice);
                    
                    sum1_re_new <= resize(result64_shifted(31 DOWNTO 0), sum1_re_new'length);
                    sum1_im_new <= resize(result64_shifted2(31 DOWNTO 0), sum1_im_new'length);
                    
                    test64_slice_proc(product_im_im, sum1_slice, 1, error_s);
                    test64_slice_proc(product_re_im, sum1_slice, 1, error_s);
                    
                    result68_shifted  := shift_right(signed(product_kar_squared_re), sum2_slice);
                    result68_shifted2 := shift_right(signed(product_kar_squared_im), sum2_slice);
                    
                    sum2_re_new <= resize(result68_shifted(31 DOWNTO 0), sum2_re_new'length);
                    sum2_im_new <= resize(result68_shifted2(31 DOWNTO 0), sum2_im_new'length);
                    
                    test68_slice_proc(product_kar_squared_re, sum2_slice, 2, error_s);                    
                    test68_slice_proc(product_kar_squared_im, sum2_slice, 2, error_s);
                    
                    sum0_re_read_data_s <= sum0_re_read_data;
                    sum0_im_read_data_s <= sum0_im_read_data;
                    sum0alt_re_read_data_s <= sum0alt_re_read_data;
                    sum0alt_im_read_data_s <= sum0alt_im_read_data;
                    sum1_re_read_data_s <= sum1_re_read_data;
                    sum1_im_read_data_s <= sum1_im_read_data;
                    sum2_re_read_data_s <= sum2_re_read_data;
                    sum2_im_read_data_s <= sum2_im_read_data;
                    
                    if (unsigned(read_address) > 510) then
                        read_address <= (others=>'0');
                        tick <= not tick;
                    else
                        read_address <= std_logic_vector(unsigned(read_address) + to_unsigned(1, read_address'length));
                    end if;
                    
                    state <= S_STORE_OR_OUTPUT;
                when S_STORE_OR_OUTPUT =>
                    --Write and Read addresses can't be the same
                    write_address <= std_logic_vector(calbin_s);
                    write_en <= '1';
                    if (readyout_curr = '0') then
                        -- Because the first time after powerup, the read output will be undefined and you can't add to it
                        if (first_time = '1') then
                            sum0_re_write_data <= sum0_re_new;
                            sum0_im_write_data <= sum0_im_new;
                            sum0alt_re_write_data <= sum0alt_re_new;
                            sum0alt_im_write_data <= sum0alt_im_new;
                            sum1_re_write_data <= -sum1_re_new; -- Negative because this is the imaginary squared component
                            sum1_im_write_data <= sum1_im_new;
                            sum2_re_write_data <= sum2_re_new;
                            sum2_im_write_data <= sum2_im_new;
                            if (calbin_s = to_unsigned(511, calbin_s'length)) then
                                first_time <= '0';
                            end if;
                        else
                            sum0_re_write_data <= sum0_re_read_data_s + sum0_re_new;
                            sum0_im_write_data <= sum0_im_read_data_s + sum0_im_new;
                            sum0alt_re_write_data <= sum0alt_re_read_data_s + sum0alt_re_new;
                            sum0alt_im_write_data <= sum0alt_im_read_data_s + sum0alt_im_new;
                            sum1_re_write_data <= sum1_re_read_data_s - sum1_re_new; -- Negative because this is the imaginary squared component
                            sum1_im_write_data <= sum1_im_read_data_s + sum1_im_new;
                            sum2_re_write_data <= sum2_re_read_data_s + sum2_re_new;
                            sum2_im_write_data <= sum2_im_read_data_s + sum2_im_new;
                        end if;
                        
                        state <= S_IDLE;
                    else
                        sum0_re_write_data <= (others=>'0');
                        sum0_im_write_data <= (others=>'0');
                        sum0alt_re_write_data <= (others=>'0');
                        sum0alt_im_write_data <= (others=>'0');
                        sum1_re_write_data <= (others=>'0');
                        sum1_im_write_data <= (others=>'0');
                        sum2_re_write_data <= (others=>'0');
                        sum2_im_write_data <= (others=>'0');
                        
                        sum0_re_new <= sum0_re_read_data_s + sum0_re_new;
                        sum0_im_new <= sum0_im_read_data_s + sum0_im_new;
                        sum0alt_re_new <= sum0alt_re_read_data_s + sum0alt_re_new;
                        sum0alt_im_new <= sum0alt_im_read_data_s + sum0alt_im_new;
                        sum1_re_new <= sum1_re_read_data_s - sum1_re_new; -- Negative because this is the imaginary squared component
                        sum1_im_new <= sum1_im_read_data_s + sum1_im_new;
                        sum2_re_new <= sum2_re_read_data_s + sum2_re_new;
                        sum2_im_new <= sum2_im_read_data_s + sum2_im_new;
                        
                        calbin_out <= std_logic_vector(calbin_s);
                        Nac1_s <= to_integer(unsigned(Nac1));
                        state <= S_BEGIN_MULTIPLY_3;
                    end if;
                when S_BEGIN_MULTIPLY_3 =>
                    write_en <= '0';
                    
                    outreal <= std_logic_vector(sum0_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    outimag <= std_logic_vector(sum0_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    
                    multiplicand1_re <= std_logic_vector(sum1_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand1_im <= std_logic_vector(sum1_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_re <= std_logic_vector(sum0_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_im <= std_logic_vector(-sum0_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    valid_in <= '1';
                    
                    state <= S_MULTIPLY_WAIT_3;
                    
                when S_MULTIPLY_WAIT_3 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        state <= S_BEGIN_MULTIPLY_4;
                    end if;
                    driftFD_slice <= to_integer(unsigned(driftFD_index));
                when S_BEGIN_MULTIPLY_4 =>
                    result65_shifted := shift_right(sum_re, driftFD_slice);
                    drift_FD <= std_logic_vector(result65_shifted(31 DOWNTO 0));
                    
                    test65_slice_proc(sum_re, driftFD_slice, 3, error_s);
                    
                    multiplicand1_re <= std_logic_vector(sum2_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand1_im <= std_logic_vector(sum2_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_re <= std_logic_vector(sum0_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_im <= std_logic_vector(-sum0_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    valid_in <= '1';
                    
                    state <= S_MULTIPLY_WAIT_4;
                    
                when S_MULTIPLY_WAIT_4 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        drift_SD1 <= signed(product_re_re) - signed(product_im_im);
                        --drift_SD1 <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        state <= S_BEGIN_MULTIPLY_5;
                    end if;
                    
                when S_BEGIN_MULTIPLY_5 =>                    
                    multiplicand1_re <= std_logic_vector(sum1_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand1_im <= std_logic_vector(sum1_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_re <= std_logic_vector(sum1_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_im <= std_logic_vector(-sum1_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    valid_in <= '1';
                    
                    driftSD1_slice <= to_integer(unsigned(driftSD1_index));
                    driftSD2_slice <= to_integer(unsigned(driftSD2_index));
                    
                    state <= S_MULTIPLY_WAIT_5;
                    
                when S_MULTIPLY_WAIT_5 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        state <= S_BEGIN_MULTIPLY_6;
                    end if;
                    
                when S_BEGIN_MULTIPLY_6 =>
                    SD1_shifted1 := shift_right(drift_SD1, driftSD1_slice);
                    SD1_shifted1_dummy <= SD1_shifted1;
                    SD1_shifted2 := resize(SD1_shifted1, 32);
                    SD1_shifted2_dummy <= SD1_shifted2;
                    
                    SD2_shifted1 := shift_left(sum_re, driftSD2_slice);
                    SD2_shifted1_dummy <= SD2_shifted1;
                    SD2_shifted2 := resize(SD2_shifted1, 32);
                    SD2_shifted2_dummy <= SD2_shifted2;
                    
                    
                    drift_SD_s <= SD1_shifted2 + SD2_shifted2;
                
                    multiplicand1_re <= std_logic_vector(sum0_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand1_im <= std_logic_vector(sum0_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_re <= std_logic_vector(sum0_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_im <= std_logic_vector(-sum0_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    valid_in <= '1';
                    
                    state <= S_MULTIPLY_WAIT_6;
                    
                when S_MULTIPLY_WAIT_6 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        state <= S_BEGIN_MULTIPLY_7;
                    end if;
                    --driftSD_slice <= to_integer(unsigned(driftSD_index));
                    powertop_slice <= to_integer(unsigned(powertop_index));
                    
                when S_BEGIN_MULTIPLY_7 =>
                    --result66_shifted := shift_right(drift_SD_s, driftSD_slice);
                    result65_shifted2 := shift_right(sum_re, powertop_slice);
                    
                    --drift_SD <= std_logic_vector(result66_shifted(31 DOWNTO 0));
                    drift_SD <= std_logic_vector(drift_SD_s);
                    powertop <= std_logic_vector(result65_shifted2(31 DOWNTO 0));
                    
                    --test66_slice_proc(drift_SD_s, driftSD_slice, 4, error_s);                    
                    --test65_slice_proc(sum_re, powertop_slice, 5, error_s);
                
                    multiplicand1_re <= std_logic_vector(sum0alt_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand1_im <= std_logic_vector(sum0alt_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_re <= std_logic_vector(sum0alt_re_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    multiplicand2_im <= std_logic_vector(-sum0alt_im_new(ACCUMULATOR_BASE+Nac1_s DOWNTO ACCUMULATOR_BASE-31+Nac1_s));
                    valid_in <= '1';
                    
                    state <= S_MULTIPLY_WAIT_7;
                    
                when S_MULTIPLY_WAIT_7 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        state <= S_OUTPUT_READY;
                    end if;
                    powerbot_slice <= to_integer(unsigned(powerbot_index));
                    
                when S_OUTPUT_READY =>
                    result65_shifted := shift_right(sum_re, powerbot_slice);
                    powerbot <= std_logic_vector(result65_shifted(31 DOWNTO 0));
                    
                    test65_slice_proc(sum_re, powerbot_slice, 6, error_s);
                    
                    average_ready    <= '1';
                    if (kar_readyout_data_empty = '1') then
                        update_drift <= '1';
                    end if;
                    state <= S_IDLE;
                    
                when others =>		
                    state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_average;
