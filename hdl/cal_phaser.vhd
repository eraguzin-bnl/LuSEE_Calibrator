--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: cal_phaser.vhd
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

ENTITY cal_phaser IS
generic(
  size : integer := 32
  );
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        bin_in                            :   IN    std_logic_vector(11 DOWNTO 0);  -- ufix12
        cal_drift                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En46
        readyin                           :   IN    std_logic;
        calbin                            :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
        phase_cor_re                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        phase_cor_im                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
        kar_out                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- ufix16
        readyout                          :   OUT   std_logic;
        update_drift                      :   OUT   std_logic;
        readycal                          :   OUT   std_logic
        );
END cal_phaser;

architecture architecture_cal_phaser of cal_phaser is
    SIGNAL calbin_s                        : std_logic_vector(11 DOWNTO 0);
    SIGNAL fifo_bin_out                    : std_logic_vector(11 DOWNTO 0);
    SIGNAL calbin_out                      : std_logic_vector(12 DOWNTO 0);
    SIGNAL kk                              : unsigned(12 DOWNTO 0);
    SIGNAL kk_shift                        : unsigned(12 DOWNTO 0);
    
    SIGNAL fifo_bin_we                     : std_logic;
    SIGNAL fifo_bin_re                     : std_logic;
    SIGNAL fifo_full                       : std_logic;
    SIGNAL fifo_empty                      : std_logic;
    
    --These are fixed point signed values, represented by two's complement
    --The values range from -1 to +1
    --The MSB is the signed bit, then the second bit is the whole number, then the rest is the fraction
    SIGNAL phase_st_re                  : signed(31 DOWNTO 0);
    SIGNAL phase_st_im                  : signed(31 DOWNTO 0);
    SIGNAL phase_mult2_re               : signed(31 DOWNTO 0);
    SIGNAL phase_mult2_im               : signed(31 DOWNTO 0);
    
    SIGNAL Nac                            : unsigned(6 DOWNTO 0);
    SIGNAL kar_s                          : std_logic_vector(19 DOWNTO 0);
    SIGNAL multiplicand_re                : signed(31 DOWNTO 0);
    SIGNAL multiplicand_im                : signed(31 DOWNTO 0);
    SIGNAL product_re_re                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_re_im                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_re                  : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_im                  : std_logic_vector(63 DOWNTO 0);
    
    SIGNAL sum_re                         : signed(64 DOWNTO 0);
    SIGNAL sum_im                         : signed(64 DOWNTO 0);
    SIGNAL valid_in                       : std_logic;
    SIGNAL valid_out                      : std_logic_vector(3 DOWNTO 0);
    
    SIGNAL error_fifo_full                : std_logic;
    SIGNAL error_fifo_order               : std_logic;
    SIGNAL error_multiplication           : std_logic;
    
    type state_type is (S_IDLE,
        S_WAIT_FOR_RESULT1,
        S_WAIT_FOR_RESULT2,
        S_WAIT_FOR_RESULT3,
        S_WAIT_FOR_RESULT4,
        S_WAIT_FOR_RESULT5,
        S_WAIT_FOR_RESULT6,
        S_ACT_ON_RESULT1,
        S_ACT_ON_RESULT2);
    signal state: state_type;
begin
    --Custom made 32 x 32 bit pipelined multipliers
    --Inputs to this block just go straight in
    --Valid out matches when o_m is valid
    --We are multiplying 2 complex numbers, so that's 4 different multiplications
    --Real of first * real of second
    mult_re_re : entity work.Multiply_generic32
        generic map(
            size => size)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => std_logic_vector(phase_st_re),
            i_mb => std_logic_vector(multiplicand_re),

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(0),

            -- Outputs
            o_m => product_re_re
        );
        
    --Real of first * imaginary of second
    mult_re_im : entity work.Multiply_generic32
        generic map(
            size => size)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => std_logic_vector(phase_st_re),
            i_mb => std_logic_vector(multiplicand_im),

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(1),

            -- Outputs
            o_m => product_re_im
        );
        
    --Imaginary of first * real of second
    mult_im_re : entity work.Multiply_generic32
        generic map(
            size => size)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => std_logic_vector(phase_st_im),
            i_mb => std_logic_vector(multiplicand_re),

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(2),

            -- Outputs
            o_m => product_im_re
        );
        
    --Imaginary of first * imaginary of second
    mult_im_im : entity work.Multiply_generic32
        generic map(
            size => size)
        port map(
            -- Inputs
            i_clk => clk,
            i_rstb => reset,
            i_ma => std_logic_vector(phase_st_im),
            i_mb => std_logic_vector(multiplicand_im),

            --Valid
            valid_in => valid_in,
            valid_out => valid_out(3),

            -- Outputs
            o_m => product_im_im
        );
        
    incoming_bins : entity work.CALFIFO_C0
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => calbin_s,
        WE       => fifo_bin_we,
        FULL     => fifo_full,
        Q        => fifo_bin_out,
        RE       => fifo_bin_re,
        EMPTY    => fifo_empty
        );
        
    process (clk) begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                calbin_s <= (others=>'0');
                calbin_out <= (others=>'0');
                kk <= (others=>'0');
                
                fifo_bin_we <= '0';
                fifo_bin_re <= '0';
                --Real defaults to +1.0, because it's cosine(0)
                phase_st_re <= x"40000000";
                phase_st_im <= (others=>'0');
                phase_mult2_re <= (others=>'0');
                phase_mult2_im <= (others=>'0');
                multiplicand_re <= (others=>'0');
                multiplicand_im <= (others=>'0');
                sum_re          <= (others=>'0');
                sum_im          <= (others=>'0');
                Nac              <= to_unsigned(0,Nac'length);
                kar_s          <= (others=>'0');
                valid_in         <= '0';
                error_fifo_full  <= '0';
                
                readycal <= '0';
                update_drift <= '0';
                calbin       <= (others=> '0');
                phase_cor_re  <= (others=> '0');
                phase_cor_im  <= (others=> '0');
                kar_out       <= (others=> '0');
                readyout    <= '0';
        
                state            <= S_IDLE;
            else
                fifo_bin_we <= '0';
                if (readyin = '1') then
                    -- Only act on incoming bins where bins%4 = 2
                    if (bin_in(1 downto 0) = "10") then
                        if (fifo_full = '0') then
                            --Add 2 and divide by 4 to get equivalent calibration bin
                            calbin_s <= std_logic_vector(shift_right(unsigned(bin_in)+2, 2));
                            fifo_bin_we <= '1';
                        else
                            error_fifo_full <= '1';
                        end if;
                    end if;
                end if;
                    
                CASE state IS
                when S_IDLE =>	
                    -- Only act on incoming bins where bins%4 = 2
                    if (fifo_empty = '0') then
                        if (fifo_bin_out = x"001") then
                            multiplicand_re <= phase_st_re;
                            multiplicand_im <= phase_st_im;
                            valid_in <= '1';
                            calbin_out <= '0' & fifo_bin_out;
                            state <= S_WAIT_FOR_RESULT1;
                        else
                            -- Takes 2 cycles for result to come out, so give it one extra off cycle before trying again
                            fifo_bin_re <= not fifo_bin_re;
                        end if;
                    else
                        fifo_bin_re <= '0';
                    end if;
                when S_WAIT_FOR_RESULT1 =>
                    valid_in <= '0';
                    fifo_bin_re <= '0';
                    kk_shift <= shift_left(unsigned(calbin_out), 1);
                    if (fifo_empty = '0') then
                        fifo_bin_re <= '1';
                    end if;
                    state <= S_WAIT_FOR_RESULT2;
                when S_WAIT_FOR_RESULT2 =>
                    kk <= kk_shift - 1;
                    fifo_bin_re <= '0';
                    state <= S_WAIT_FOR_RESULT3;
                when S_WAIT_FOR_RESULT3 =>
                    kar_s <= std_logic_vector(kk * Nac);
                    if (unsigned('0' & fifo_bin_out) /= (unsigned(calbin_out) + 1)) then
                        error_fifo_order <= '1';
                    end if;
                    calbin_out <= '0' & fifo_bin_out;
                    state <= S_WAIT_FOR_RESULT4;
                when S_WAIT_FOR_RESULT4 =>
                    kar_out <= kar_s(15 downto 0);
                    state <= S_WAIT_FOR_RESULT5;
                when S_WAIT_FOR_RESULT5 =>
                    state <= S_WAIT_FOR_RESULT6;
                when S_WAIT_FOR_RESULT6 =>
                    state <= S_ACT_ON_RESULT1;
                when S_ACT_ON_RESULT1 =>
                    -- Multiplication is done!
                    if (valid_out = "1111") then
                        sum_re <= resize(signed(product_re_re), 65) - resize(signed(product_im_im), 65);
                        sum_im <= resize(signed(product_re_im), 65) + resize(signed(product_im_re), 65);
                        state <= S_ACT_ON_RESULT2;
                    else
                        error_multiplication <= '1';
                    end if;
                when S_ACT_ON_RESULT2 =>
                    if ((unsigned(calbin_out) - 1) = 1) then
                        phase_mult2_re <= sum_re(64 downto 33);
                        phase_mult2_im <= sum_im(64 downto 33);
                        multiplicand_re <= sum_re(64 downto 33);
                        multiplicand_im <= sum_im(64 downto 33);
                    else
                        phase_st_re <= sum_re(64 downto 33);
                        phase_st_im <= sum_im(64 downto 33);
                    end if;
                    --Start next multiplication
                    valid_in <= '1';
                    state <= S_WAIT_FOR_RESULT1;
                when others =>		
                    state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_phaser;
