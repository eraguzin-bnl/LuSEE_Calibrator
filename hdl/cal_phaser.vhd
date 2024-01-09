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
    -- Representation of 2pi as a multiple of pi. First bit is sign bit
    -- Next 2 bits are integer (10 is 2, so 2*pi) followed by 29 bits of fractional 0s
    -- The standard cordic input is 32 bits, where the first bit is sign and the next bit is integer (max of 1)
    -- And then 29 fractional bits. This constant is made to be added or subtracted from that number
    
    SIGNAL calbin_s                        : std_logic_vector(11 DOWNTO 0);
    SIGNAL fifo_bin_out                    : std_logic_vector(11 DOWNTO 0);
    SIGNAL fifo_check_count                : unsigned (1 downto 0);
    SIGNAL calbin_out                      : unsigned(12 DOWNTO 0);
    SIGNAL kk                              : unsigned(12 DOWNTO 0);
    SIGNAL kk_shift                        : unsigned(12 DOWNTO 0);
    
    SIGNAL cordic_counter                  : integer range 0 to 63 := 0;
    SIGNAL cal_drift_s                     : signed(32 DOWNTO 0);
    SIGNAL cordic_in                       : std_logic_vector(31 DOWNTO 0);
    SIGNAL cordic_valid_in                 : std_logic;
    SIGNAL cordic_valid_out                : std_logic;
    SIGNAL cordic_request_for_data         : std_logic;
    SIGNAL cordic_cos                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL cordic_sin                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_s                         : signed(32 DOWNTO 0);
    SIGNAL update_drift_s                  : std_logic;
    
    SIGNAL fifo_bin_we                     : std_logic;
    SIGNAL fifo_bin_re                     : std_logic;
    SIGNAL fifo_full                       : std_logic;
    SIGNAL fifo_empty                      : std_logic;
    
    SIGNAL cos_fifo_we                     : std_logic;
    SIGNAL cos_fifo_re                     : std_logic;
    SIGNAL cos_fifo_full                       : std_logic;
    SIGNAL cos_fifo_empty                      : std_logic;
    SIGNAL cos_fifo_in                  : std_logic_vector(31 DOWNTO 0);
    SIGNAL cos_fifo_out                 : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL sin_fifo_we                     : std_logic;
    SIGNAL sin_fifo_re                     : std_logic;
    SIGNAL sin_fifo_full                       : std_logic;
    SIGNAL sin_fifo_empty                      : std_logic;
    SIGNAL sin_fifo_in                  : std_logic_vector(31 DOWNTO 0);
    SIGNAL sin_fifo_out                 : std_logic_vector(31 DOWNTO 0);
    
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
    
    SIGNAL error_sin_fifo_full                : std_logic;
    SIGNAL error_sin_fifo_empty                : std_logic;
    SIGNAL error_cos_fifo_full                : std_logic;
    SIGNAL error_cos_fifo_empty                : std_logic;
    
    type state_type is (S_IDLE,
        S_WAIT_FOR_FIFO_OUT,
        S_WAIT_FOR_FIFO_OUT2,
        S_FIFO_IS_OUT,
        S_WAIT_FOR_RESULT1,
        S_WAIT_FOR_RESULT2,
        S_WAIT_FOR_RESULT3,
        S_WAIT_FOR_RESULT4,
        S_WAIT_FOR_RESULT5,
        S_WAIT_FOR_RESULT6,
        S_ACT_ON_RESULT1,
        S_ACT_ON_RESULT2);
    signal state: state_type;
    
    type state_type2 is (S_CORDIC_IDLE,
        S_CORDIC_INPUT,
        S_CORDIC_WAIT,
        S_CORDIC_OUTPUT,
        S_CORDIC_CORRECT,
        S_CORDIC_WAIT_FOR_UPDATE);
    signal state2: state_type2;
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
        
    cos_fifo : entity work.CORDICFIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => cos_fifo_in,
        WE       => cos_fifo_we,
        FULL     => cos_fifo_full,
        Q        => cos_fifo_out,
        RE       => cos_fifo_re,
        EMPTY    => cos_fifo_empty
        );
        
    sin_fifo : entity work.CORDICFIFO
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => sin_fifo_in,
        WE       => sin_fifo_we,
        FULL     => sin_fifo_full,
        Q        => sin_fifo_out,
        RE       => sin_fifo_re,
        EMPTY    => sin_fifo_empty
        );
        
    cordic : entity work.CORECORDIC_C0
    PORT MAP(
        NGRST    => '1',
        RST      => reset,
        CLK      => clk,
        DIN_A    => cordic_in,
        DIN_VALID    => cordic_valid_in,
        DOUT_X       => cordic_cos,
        DOUT_Y       => cordic_sin,
        DOUT_VALID   => cordic_valid_out,
        RFD          => cordic_request_for_data
        );
        
    process (clk) begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                calbin_s <= (others=>'0');
                calbin_out <= (others=>'0');
                fifo_check_count <= (others=>'0');
                kk <= (others=>'0');
                
                cal_drift_s <= (others=>'0');
                cordic_valid_in <= '0';
                cordic_counter <= 0;
                cordic_in <= (others=>'0');
                
                fifo_bin_we <= '0';
                fifo_bin_re <= '0';
                
                cos_fifo_we <= '0';
                cos_fifo_re <= '0';
                cos_fifo_in <= (others=>'0');
                sin_fifo_we <= '0';
                sin_fifo_re <= '0';
                sin_fifo_in <= (others=>'0');
                --Real defaults to +1.0, because it's cosine(0)
                phase_s <= (others=>'0');
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
                kk_shift       <= (others=>'0');
                valid_in         <= '0';
                error_fifo_full  <= '0';
                error_fifo_order  <= '0';
                error_multiplication  <= '0';
                
                error_sin_fifo_full <= '0';
                error_sin_fifo_empty <= '0';
                error_cos_fifo_full <= '0';
                error_cos_fifo_empty <= '0';
                
                readycal <= '0';
                update_drift <= '0';
                update_drift_s <= '0';
                calbin       <= (others=> '0');
                phase_cor_re  <= (others=> '0');
                phase_cor_im  <= (others=> '0');
                kar_out       <= (others=> '0');
                readyout    <= '0';
                
                --sin_fifo_full <= '0';
                --sin_fifo_empty <= '0';
                --cos_fifo_full <= '0';
                --cos_fifo_empty <= '0';
        
                state            <= S_IDLE;
                state2           <= S_CORDIC_IDLE;
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
                    
                case state is
                when S_IDLE =>
                    readycal <= '0';
                    readyout <= '0';
                    kar_out <= (others=> '0');
                    calbin <= (others=> '0');
                    update_drift <= '0';
                    -- Only act on incoming bins where bins%4 = 2
                    if (fifo_empty = '0') then
                        if (fifo_bin_out = x"001") then
                            calbin_out <= unsigned('0' & fifo_bin_out);
                            fifo_bin_re <= '0';
                            
                            if ((cos_fifo_empty = '0') and (sin_fifo_empty = '0')) then
                                cos_fifo_re <= '1';
                                sin_fifo_re <= '1';
                                state <= S_WAIT_FOR_FIFO_OUT;
                            end if;                            
                        else
                            -- Takes 2 cycles for result to come out, so give it one cycle to come out and one to act on it
                            if (fifo_check_count = 0) then
                                fifo_bin_re <= '1';
                                fifo_check_count <= fifo_check_count + 1;
                            elsif (fifo_check_count = 1) then
                                fifo_bin_re <= '0';
                                fifo_check_count <= fifo_check_count + 1;
                            elsif (fifo_check_count = 2) then
                                fifo_bin_re <= '0';
                                fifo_check_count <= (others=>'0');
                            else
                                fifo_check_count <= (others=>'0');
                            end if;
                        end if;
                    else
                        fifo_bin_re <= '0';
                    end if;
                when S_WAIT_FOR_FIFO_OUT =>
                    cos_fifo_re <= '0';
                    sin_fifo_re <= '0';
                    state <= S_WAIT_FOR_FIFO_OUT2;
                when S_WAIT_FOR_FIFO_OUT2 =>
                    state <= S_FIFO_IS_OUT;
                when S_FIFO_IS_OUT =>
                    multiplicand_re <= signed(cos_fifo_out);
                    multiplicand_im <= signed(sin_fifo_out);
                    valid_in <= '1';
                    state <= S_WAIT_FOR_RESULT1;
                when S_WAIT_FOR_RESULT1 =>
                    valid_in <= '0';
                    readycal <= '0';
                    readyout <= '0';
                    fifo_bin_re <= '0';
                    kk_shift <= shift_left(calbin_out, 1);
                    calbin <= std_logic_vector(calbin_out(9 downto 0));
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
                    state <= S_WAIT_FOR_RESULT4;
                when S_WAIT_FOR_RESULT4 =>
                    kar_out <= kar_s(15 downto 0);
                    if (calbin_out /= 512) then
                        if (unsigned('0' & fifo_bin_out) /= (calbin_out + 1)) then
                            error_fifo_order <= '1';
                        end if;
                    else
                        Nac <= Nac + 1;
                    end if;
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
                    if (calbin_out = 1) then
                        phase_mult2_re <= sum_re(64 downto 33);
                        phase_mult2_im <= sum_im(64 downto 33);
                        multiplicand_re <= sum_re(64 downto 33);
                        multiplicand_im <= sum_im(64 downto 33);
                    else
                        phase_st_re <= sum_re(64 downto 33);
                        phase_st_im <= sum_im(64 downto 33);
                        phase_cor_re <= std_logic_vector(sum_re(64 downto 33));
                        phase_cor_im <= std_logic_vector(sum_im(64 downto 33));
                    end if;
                    --Start next multiplication
                    valid_in <= '1';
                    
                    readycal <= '1';
                    if (Nac = 63) then
                        readyout <= '1';
                    end if;
                    
                    
                    if (calbin_out /= 512) then
                        calbin_out <= unsigned('0' & fifo_bin_out);
                        state <= S_WAIT_FOR_RESULT1;
                    else
                        calbin_out <= (others=>'0');
                        if (Nac > 63) then
                            update_drift <= '1';
                            update_drift_s <= '1';
                            Nac <= to_unsigned(0, Nac'length);
                        end if;
                        state <= S_IDLE;
                    end if;
                when others =>		
                    state <= S_IDLE;
                end case;
                
                case state2 is
                when S_CORDIC_IDLE =>
                    cal_drift_s <= resize(signed(cal_drift), cal_drift_s'length);
                    cordic_valid_in <= '0';
                    cos_fifo_we <= '0';
                    sin_fifo_we <= '0';
                    state2 <= S_CORDIC_INPUT;
                when S_CORDIC_INPUT =>
                    cordic_in <= std_logic_vector(phase_s(32) & phase_s(30 DOWNTO 0));
                    if (cordic_request_for_data = '1') then
                        cordic_valid_in <= '1';
                        state2 <= S_CORDIC_WAIT;
                    end if;                
                when S_CORDIC_WAIT =>
                    cordic_valid_in <= '0';
                    if (cordic_valid_out = '1') then
                        if (cos_fifo_full =  '1') then
                            error_cos_fifo_full <= '1';
                        else
                            cos_fifo_in <= cordic_cos;
                            cos_fifo_we <= '1';
                        end if;
                        
                        if (sin_fifo_full = '1') then
                            error_sin_fifo_full <= '1';
                        else
                            sin_fifo_in <= cordic_sin;
                            sin_fifo_we <= '1';
                        end if;
                        
                        state2 <= S_CORDIC_OUTPUT;
                    end if;                
                when S_CORDIC_OUTPUT =>
                    cos_fifo_we <= '0';
                    sin_fifo_we <= '0';
                    if (cordic_counter = 63) then
                        state2 <= S_CORDIC_WAIT_FOR_UPDATE;
                    else
                        cordic_counter <= cordic_counter + 1;
                        phase_s <= phase_s + cal_drift_s;
                        --Check bounds with +/- pi and adjust
                        state2 <= S_CORDIC_CORRECT;
                    end if;
                when S_CORDIC_CORRECT =>
                    if ((phase_s(32 downto 30) = "001")) then
                        phase_s(32 downto 30) <= "111";
                    elsif (phase_s(32 DOWNTO 30) = "110") then
                        phase_s(32 downto 30) <= "000";
                    end if;
                    state2 <= S_CORDIC_INPUT;
                when S_CORDIC_WAIT_FOR_UPDATE =>
                    cordic_counter <= 0;
                    if (update_drift_s = '1') then
                        update_drift_s <= '0';
                        state2 <= S_CORDIC_IDLE;
                    end if;
                when others =>
                    state2 <= S_CORDIC_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_phaser;
