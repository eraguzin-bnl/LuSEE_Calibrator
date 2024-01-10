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
        index1                            :   IN    std_logic_vector(5 downto 0);
        index2                            :   IN    std_logic_vector(5 downto 0);
        index3                            :   IN    std_logic_vector(5 downto 0);
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
    
    SIGNAL kar_curr                                : unsigned(15 DOWNTO 0);
    SIGNAL kar_squared                             : unsigned(31 DOWNTO 0);
    SIGNAL kar_squared_signed                      : signed(31 DOWNTO 0);
    SIGNAL readyout_curr                           : std_logic; 
    SIGNAL tick                                    : std_logic;
    
    SIGNAL readyin_s                            : std_logic;
    SIGNAL readycal_s                           : std_logic;
    SIGNAL error_data_fifo_full                 : std_logic;
    SIGNAL error_data_fifo_backup               : std_logic;
    SIGNAL error_phase_fifo_full                 : std_logic;
    SIGNAL error_phase_fifo_backup               : std_logic;
    SIGNAL error_fifo_alignment                 : std_logic;
    
    SIGNAL product_re_re                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_re_im                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_re                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_im                   : std_logic_vector(63 DOWNTO 0);
    
    SIGNAL multiplicand1_re                 : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand1_im                 : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand2_re                 : std_logic_vector(31 DOWNTO 0);
    SIGNAL multiplicand2_im                 : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL sum_re                          : signed(64 DOWNTO 0);
    SIGNAL sum_im                          : signed(64 DOWNTO 0);
    SIGNAL valid_in                        : std_logic;
    SIGNAL valid_out                       : std_logic_vector(3 DOWNTO 0);
    
    SIGNAL sum0_re_new                        : signed(37 DOWNTO 0);
    SIGNAL sum0alt_re_new                     : signed(37 DOWNTO 0);
    SIGNAL sum1_re_new                        : signed(37 DOWNTO 0);
    SIGNAL sum2_re_new                        : signed(37 DOWNTO 0);
    
    SIGNAL sum0_im_new                        : signed(37 DOWNTO 0);
    SIGNAL sum0alt_im_new                     : signed(37 DOWNTO 0);
    SIGNAL sum1_im_new                        : signed(37 DOWNTO 0);
    SIGNAL sum2_im_new                        : signed(37 DOWNTO 0);
    
    SIGNAL slice1                          : integer range 0 to 33;
    SIGNAL slice2                          : integer range 0 to 33;
    SIGNAL slice3                          : integer range 0 to 33;
    SIGNAL cplx_in_re                      : signed(31 DOWNTO 0);
    SIGNAL cplx_in_im                      : signed(31 DOWNTO 0);
    SIGNAL cplx_in_re_rev                  : signed(31 DOWNTO 0);
    SIGNAL cplx_in_im_rev                  : signed(31 DOWNTO 0);
    
    type state_type is (S_IDLE,
        S_FIFO_WAIT_1,
        S_FIFO_WAIT_2,
        S_BEGIN_MULTIPLY,
        S_MULTIPLY_WAIT,
        S_BIT_SLICE,
        S_BEGIN_MULTIPLY_2,
        S_MULTIPLY_WAIT_2,
        S_BIT_SLICE_2,
        S_WAIT_FOR_RESULT6,
        S_ACT_ON_RESULT1,
        S_ACT_ON_RESULT2);
    signal state: state_type;

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
        DATA     => kar_readyout_data_s,
        WE       => kar_readyout_data_we,
        FULL     => kar_readyout_data_full,
        Q        => kar_readyout_data_out,
        RE       => kar_readyout_data_re,
        EMPTY    => kar_readyout_data_empty
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
                valid_in                      <= '0';
                
                multiplicand1_re             <= (others=>'0');
                multiplicand1_im             <= (others=>'0');
                multiplicand2_re             <= (others=>'0');
                multiplicand2_im             <= (others=>'0');
                
                kar_curr                     <= (others=>'0');
                kar_squared                  <= (others=>'0');
                kar_squared_signed           <= (others=>'0');
                readyout_curr                <= '0';
                
                tick                         <= '1';
                cplx_in_re                   <= (others=>'0');
                cplx_in_im                   <= (others=>'0');
                cplx_in_re_rev               <= (others=>'0');
                cplx_in_im_rev               <= (others=>'0');
                
                slice1                       <= 0;
                slice2                       <= 0;
                slice3                       <= 0;
                
                sum0_re_new                  <= (others=>'0');
                sum0alt_re_new               <= (others=>'0');
                sum1_re_new                  <= (others=>'0');
                sum2_re_new                  <= (others=>'0');
                
                sum0_im_new                  <= (others=>'0');
                sum0alt_im_new               <= (others=>'0');
                sum1_im_new                  <= (others=>'0');
                sum2_im_new                  <= (others=>'0');
                
                error_data_fifo_full         <= '0';
                error_data_fifo_backup       <= '0';
                error_phase_fifo_full         <= '0';
                error_phase_fifo_backup       <= '0';
                error_fifo_alignment         <= '0';
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
                
                case state is
                when S_IDLE =>
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
                    
                    kar_curr <= unsigned(kar_readyout_data_out(15 DOWNTO 0));
                    readyout_curr <= kar_readyout_data_out(16);
                    state <= S_MULTIPLY_WAIT;
                when S_MULTIPLY_WAIT =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        sum_im <= resize(signed(product_re_im), 65) + resize(signed(product_im_re), 65);
                        kar_squared <= kar_curr * kar_curr;
                        state <= S_BIT_SLICE;
                    end if;
                    slice1 <= to_integer(unsigned(index1));
                when S_BIT_SLICE =>
                    cplx_in_re <= sum_re(64 DOWNTO 33);
                    cplx_in_im <= sum_im(64 DOWNTO 33);
                    kar_squared_signed <= signed(kar_squared);
                    state <= S_BEGIN_MULTIPLY_2;
                when S_BEGIN_MULTIPLY_2 =>
                    multiplicand1_re <= std_logic_vector(cplx_in_re);
                    multiplicand1_im <= std_logic_vector(cplx_in_im);
                    multiplicand2_re <= std_logic_vector(-kar_squared_signed);
                    multiplicand2_im <= x"0000" & std_logic_vector(kar_curr);
                    valid_in <= '1';
                    
                    state <= S_MULTIPLY_WAIT_2;
                when S_MULTIPLY_WAIT_2 =>
                    valid_in <= '0';
                    if (valid_out = "1111") then
                        state <= S_BIT_SLICE_2;
                    end if;
                    slice2 <= to_integer(unsigned(index2));
                when S_BIT_SLICE_2 =>
                    sum0_re_new <= cplx_in_re;
                    sum0_im_new <= cplx_in_im;
                    if (tick) then
                        sum0alt_re_new <= cplx_in_re;
                        sum0alt_im_new <= cplx_in_im;
                    else
                        sum0alt_re_new <= -cplx_in_re;
                        sum0alt_im_new <= -cplx_in_im;
                    end if;
                    tick <= not tick;
                    
                    --Todo, do the negative part in the next step when adding
                    sum1_re_new <= -1 * signed(product_im_im(63 DOWNTO 32));
                    sum1_im_new <= signed(product_re_im(63 DOWNTO 32));
                    
                    sum2_re_new <= signed(product_re_re(63 DOWNTO 32));
                    sum2_im_new <= signed(product_im_re(63 DOWNTO 32));
                    
                    state <= S_BEGIN_MULTIPLY_2;
                when others =>		
                    state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_average;
