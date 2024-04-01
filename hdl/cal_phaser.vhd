--------------------------------------------------------------------------------
-- Company: Brookhaven Lab - LuSEE Project
--
-- File: cal_phaser.vhd
--
-- Description: 
--
-- This is the first block of the LuSEE Calibrator. It essentially takes in a stream of bins from 0 to 2047 representing the bins that
-- have just been released by the notch filter averager. Using the literal numbers from 0 to 2047, it buffers bins 2, 6, 10, etc...
-- So 512 total bins to do some calculations. For each of the 512 it calculates a `kar` value based on which cycle and bin this is
-- For each bin, we want a phase value to try to zero in on the angle of the calibration source
-- We have initial conditions, and this block receives a "cal_drift" angle. It uses a Cordic to get the cosine and sine an initial angle
-- And that complex number becomes "phase_st". It's squared to get "phase_mult2".
-- Then for each of the 512 calibration bins, "phase_st" is continually successively by "phase_mult2"
-- The result is sent out along with the number of the cal bin. Then the next cycle starts, and the cordic input angle is incremented by "cal_drift"
-- After 32/64/128 cycles of this, another signal goes high indicating that the cycles were done and a new cal_drift value is received from later blocks in the system

-- This block makes use of the numeric notation for the Microsemi Cordic block here:
-- https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/CoreCORDIC_HB.pdf
--
-- More information
-- https://docs.google.com/document/d/1j1BpxA1HZ0g0dKb2WQrU_U5UYvrOX7eJ6SPmg9MIlb8/edit#heading=h.y5j2rt84yvr7
--
-- Author: Eric Raguzin
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY cal_phaser IS
generic(
  size : integer := 32;
  Nac_max : integer := 127
  );
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        Nac1                              :   IN    std_logic_vector(1 DOWNTO 0);
        bin_in                            :   IN    std_logic_vector(11 DOWNTO 0);  -- Just a stream of literally 0 through 2047
        cal_drift                         :   IN    std_logic_vector(31 DOWNTO 0);  -- The value to shift the cordic input by for 32/64/128 cycles
        readyin                           :   IN    std_logic;                      -- From the notch filter showing that bins are coming in
        new_phase_rdy                     :   IN    std_logic;
        calbin                            :   OUT   std_logic_vector(8 DOWNTO 0);   -- Output of which bin's values are going out
        phase_cor_re                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- Real part of complex phase result
        phase_cor_im                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- Imaginary part of complex phase result
        kar_out                           :   OUT   std_logic_vector(17 DOWNTO 0);  -- Calculation based on bin and cycle
        readyout                          :   OUT   std_logic;                      -- Goes high on 32/64/128th cycle
        readycal                          :   OUT   std_logic                       -- Goes high every cycle to tell average block to consume new values
        );
END cal_phaser;

architecture architecture_cal_phaser of cal_phaser is
    -- See here for how angles and sin/cos outputs are represented:
    -- https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/CoreCORDIC_HB.pdf
    
    -- cal_drift and phase_s and cordic_input are angles. The way angles are represented are fractions of pi. Manual has good example
    -- First bit is sign bit, second bit if 1 means the value is +/- pi, and there is an implied decimal point and the other 29 are fractional bits
    
    -- All the sin/cos, multiplicand and phase_st and phase_mult2 values are in linear format. Manual has good example
    -- The standard cordic input is 32 bits, where the first bit is sign and the next bit is integer (max of 2.32) and then 29 fractional bits
    -- So a 1 (which is the highest the cos/sin output can be) is 001.000...
    -- With the fractional part at the first decimal point. -1 is 101.000... and so on
    
    SIGNAL calbin_s                        : std_logic_vector(11 DOWNTO 0);
    SIGNAL fifo_bin_out                    : std_logic_vector(8 DOWNTO 0);
    SIGNAL fifo_check_count                : unsigned (1 downto 0);
    SIGNAL calbin_out                      : unsigned(9 DOWNTO 0); --Needs an extra bit for addition overflow
    SIGNAL kk                              : unsigned(12 DOWNTO 0);
    
    CONSTANT NAC_BASE_SHIFT                : integer := 5;
    CONSTANT ONE_U                         : unsigned(7 DOWNTO 0) := x"01";
    SIGNAL Nac1_setting_s                  : integer range 0 to 2;
    SIGNAL Nac1_max                        : unsigned(7 DOWNTO 0);
    signal Nac1_limit                      : integer range 0 to 255;
    
    SIGNAL cordic_counter                  : integer range 0 to Nac_max := 0;
    SIGNAL cal_drift_s                     : signed(31 DOWNTO 0);
    SIGNAL cordic_in                       : std_logic_vector(31 DOWNTO 0);
    SIGNAL cordic_valid_in                 : std_logic;
    SIGNAL cordic_valid_out                : std_logic;
    SIGNAL cordic_request_for_data         : std_logic;
    SIGNAL cordic_cos                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL cordic_sin                      : std_logic_vector(31 DOWNTO 0);
    SIGNAL phase_s                         : signed(31 DOWNTO 0);
    
    SIGNAL fifo_bin_we                     : std_logic;
    SIGNAL fifo_bin_re                     : std_logic;
    SIGNAL fifo_full                       : std_logic;
    SIGNAL fifo_empty                      : std_logic;
    
    SIGNAL cos_fifo_we                     : std_logic;
    SIGNAL cos_fifo_re                     : std_logic;
    SIGNAL cos_fifo_full                   : std_logic;
    SIGNAL cos_fifo_empty                  : std_logic;
    SIGNAL cos_fifo_in                     : std_logic_vector(31 DOWNTO 0);
    SIGNAL cos_fifo_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL sin_fifo_we                     : std_logic;
    SIGNAL sin_fifo_re                     : std_logic;
    SIGNAL sin_fifo_full                   : std_logic;
    SIGNAL sin_fifo_empty                  : std_logic;
    SIGNAL sin_fifo_in                     : std_logic_vector(31 DOWNTO 0);
    SIGNAL sin_fifo_out                    : std_logic_vector(31 DOWNTO 0);
    
    SIGNAL phase_st_re                     : signed(31 DOWNTO 0);
    SIGNAL phase_st_im                     : signed(31 DOWNTO 0);
    
    SIGNAL Nac                             : unsigned(7 DOWNTO 0);
    SIGNAL kar_s                           : std_logic_vector(20 DOWNTO 0);
    SIGNAL multiplicand_re                 : signed(31 DOWNTO 0);
    SIGNAL multiplicand_im                 : signed(31 DOWNTO 0);
    SIGNAL product_re_re                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_re_im                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_re                   : std_logic_vector(63 DOWNTO 0);
    SIGNAL product_im_im                   : std_logic_vector(63 DOWNTO 0);
    
    SIGNAL sum_re                          : signed(63 DOWNTO 0);
    SIGNAL sum_im                          : signed(63 DOWNTO 0);
    SIGNAL valid_in                        : std_logic;
    SIGNAL valid_out                       : std_logic_vector(3 DOWNTO 0);
    
    SIGNAL error_fifo_full                 : std_logic;
    SIGNAL error_fifo_order                : std_logic;
    SIGNAL error_multiplication            : std_logic;
    
    SIGNAL error_sin_fifo_full             : std_logic;
    SIGNAL error_sin_fifo_empty            : std_logic;
    SIGNAL error_cos_fifo_full             : std_logic;
    SIGNAL error_cos_fifo_empty            : std_logic;
    
    SIGNAL first_time                      : std_logic;
    
    -- The first state machine does the calaculations for each incoming bin each cycle
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
    
    -- This state machine calculates the cos and sin values for 32/64/128 cycles off the bat given the cal_drift
    type state_type2 is (S_CORDIC_IDLE,
        S_CORDIC_WAIT_FOR_DRIFT,
        S_CORDIC_INPUT,
        S_CORDIC_WAIT,
        S_CORDIC_OUTPUT,
        S_CORDIC_CORRECT,
        S_CORDIC_WAIT_FOR_UPDATE);
    signal state2: state_type2;
    
    component CALFIFO_C0
    PORT ( 
        CLK                               :   IN    std_logic;
        DATA                              :   IN    std_logic_vector(8 downto 0);
        RE                                :   IN    std_logic;
        RESET_N                           :   IN    std_logic;
        WE                                :   IN    std_logic;
        EMPTY                             :   OUT   std_logic;
        FULL                              :   OUT   std_logic;
        Q                                 :   OUT   std_logic_vector(8 downto 0)
        );
    end component;
    
    component CORDICFIFO
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
    
    component CORECORDIC_C0
    PORT ( 
        CLK                               :   IN    std_logic;
        DIN_A                             :   IN    std_logic_vector(31 downto 0);
        DIN_VALID                         :   IN    std_logic;
        RST                               :   IN    std_logic;
        NGRST                             :   IN    std_logic;
        
        DOUT_VALID                        :   OUT   std_logic;
        DOUT_X                            :   OUT   std_logic_vector(31 downto 0);
        DOUT_Y                            :   OUT   std_logic_vector(31 downto 0);
        RFD                               :   OUT   std_logic
        );
    end component;
begin
    --Custom made 32 x 32 bit pipelined multipliers
    --Inputs to this block just go straight in
    --Valid out high only when o_m is valid
    --Algorithm calls for us to multiply different values on first cycle vs other ones, so that's the reason for "multiplicand" signal
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
        
    --Since we cannot process each bin as fast as they are coming in (every 4 clock cycles), each bin is
    --Stored in a FIFO and the state machine does the math as it can
    --This FIFO has room for 512 samples of the bin numbers. But because it is working on them as they come in in batches of 512, it should never fill up
    incoming_bins : CALFIFO_C0
    PORT MAP( 
        CLK      => clk,
        RESET_N  => not reset,
        DATA     => calbin_s(8 downto 0),
        WE       => fifo_bin_we,
        FULL     => fifo_full,
        Q        => fifo_bin_out,
        RE       => fifo_bin_re,
        EMPTY    => fifo_empty
        );
        
    --After the Cordic state machine gets a new cal_drift value and knows that it's the first of 64 cycles, it immediately just calculates the
    --phase value for all 32/64/128 cycles and puts it in these FIFOs. The first state machine requests them as it begins each new cycle and then has to
    --work through 512 bins with that value
    cos_fifo : CORDICFIFO
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
        
    sin_fifo : CORDICFIFO
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
        
    -- This is the actual Cordic IP core, it inputs and outputs values in the characteristic format in the handbook:
    -- https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/CoreCORDIC_HB.pdf
    cordic : CORECORDIC_C0
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
                calbin_s              <= (others=>'0');
                calbin_out            <= (others=>'0');
                fifo_check_count      <= (others=>'0');
                kk                    <= (others=>'0');
                
                cal_drift_s           <= (others=>'0');
                cordic_valid_in       <= '0';
                cordic_counter        <= 0;
                cordic_in             <= (others=>'0');
                
                fifo_bin_we           <= '0';
                fifo_bin_re           <= '0';
                
                cos_fifo_we           <= '0';
                cos_fifo_re           <= '0';
                cos_fifo_in           <= (others=>'0');
                sin_fifo_we           <= '0';
                sin_fifo_re           <= '0';
                sin_fifo_in           <= (others=>'0');
                phase_s               <= (others=>'0');
                
                --This is +1.0 in the Cordic formatting, since it's defaulting to the real part of cosine(0)
                phase_st_re           <= x"20000000";
                phase_st_im           <= (others=>'0');
                multiplicand_re       <= (others=>'0');
                multiplicand_im       <= (others=>'0');
                sum_re                <= (others=>'0');
                sum_im                <= (others=>'0');
                Nac1_setting_s        <= 1; -- Default to 64 cycles. Needs to be in reset because Cordic starts immediately
                Nac1_max              <= (others=>'0');
                Nac1_limit            <= 0;
                Nac                   <= to_unsigned(0,Nac'length);
                kar_s                 <= (others=>'0');
                valid_in              <= '0';
                error_fifo_full       <= '0';
                error_fifo_order      <= '0';
                error_multiplication  <= '0';
                
                error_sin_fifo_full   <= '0';
                error_sin_fifo_empty  <= '0';
                error_cos_fifo_full   <= '0';
                error_cos_fifo_empty  <= '0';
                
                readycal              <= '0';
                calbin                <= (others=> '0');
                phase_cor_re          <= (others=> '0');
                phase_cor_im          <= (others=> '0');
                kar_out               <= (others=> '0');
                readyout              <= '0';
                
                first_time            <= '1';
                state                 <= S_IDLE;
                state2                <= S_CORDIC_IDLE;
            else
                -- Do Nac calculation to determine how many times to run Cordic and when to consider the set of cycles done
                Nac1_setting_s       <= to_integer(unsigned(Nac1));
                Nac1_max             <= shift_left(ONE_U, NAC_BASE_SHIFT + Nac1_setting_s);
                Nac1_limit           <= to_integer(Nac1_max - 1);
                -- This section will just put any incoming bin of 2, 6, 10, 14, into the FIFO for processing
                -- And throw an error if it ever fills up
                fifo_bin_we <= '0';
                if (readyin = '1') then
                    -- Only act on incoming bins where bins%4 = 2
                    if (bin_in(1 downto 0) = "10") then
                        if (fifo_full = '0') then
                            --Add 2 and divide by 4 to get equivalent calibration bin
                            calbin_s <= std_logic_vector(shift_right(unsigned(bin_in)+2, 2) - 1);
                            fifo_bin_we <= '1';
                        else
                            --With a depth of 512 and enough time between notch filter averages to process, should never fill up
                            error_fifo_full <= '1';
                        end if;
                    end if;
                end if;
                    
                case state is
                when S_IDLE =>
                    -- Flag outputs of the entire block should be zeroed when not being written
                    readycal <= '0';
                    readyout <= '0';
                    kar_out <= (others=> '0');
                    calbin <= (others=> '0');
                    -- Waits for previous block to start filling up the FIFO, and use cal bin format (1 to 512)
                    if (fifo_empty = '0') then
                        -- If we are in the IDLE state, we're waiting for the first calibration bin always
                        if (fifo_bin_out = "0" & x"00") then
                            -- Because the default reset FIFO outputs 0, it looks identical to when the first bin of 0 has been written
                            -- So for the first time after a reset, if the FIFO gets something put in it, immediately read it out
                            -- So the 0 we see is the actual data 0 and the next calbin will be 1, etc...
                            -- Without this, we will be a bin behind with two 0s in a row
                            if (first_time = '1') then
                                fifo_bin_re <= '1';
                                first_time <= '0';
                            else
                                -- We need to use the bin number for further calculations
                                calbin_out <= unsigned('0' & fifo_bin_out);
                                fifo_bin_re <= '0';
                                
                                -- We also wait until we have a Cordic output ready to do phase calculations with and then move into the state machine
                                if ((cos_fifo_empty = '0') and (sin_fifo_empty = '0')) then
                                    cos_fifo_re <= '1';
                                    sin_fifo_re <= '1';
                                    state <= S_WAIT_FOR_FIFO_OUT;
                                end if;
                            end if;
                        else
                            -- If we are in this state and don't see cal bin 1, we are erroneously halfway through a stream
                            -- So we will want to clear the FIFO until the previous IF check sees cal bin 1
                            -- Takes 2 cycles for result to come out (pipelined FIFO), so give it one cycle to come out and one to act on it
                            -- If the IF statement above doesn't catch a cal bin of 1, keep cycling through this FIFO
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
                        -- Want to make sure we are not trying to read an empty FIFO
                        fifo_bin_re <= '0';
                    end if;
                when S_WAIT_FOR_FIFO_OUT =>
                -- Because of pipelined Cordic FIFO, it takes 2 cycles to get the Cordic values out
                    fifo_check_count <= to_unsigned(0, fifo_check_count'length);
                    cos_fifo_re <= '0';
                    sin_fifo_re <= '0';
                    state <= S_WAIT_FOR_FIFO_OUT2;
                when S_WAIT_FOR_FIFO_OUT2 =>
                    state <= S_FIFO_IS_OUT;
                when S_FIFO_IS_OUT =>
                    -- We have the Cordic value. This state is only access the first time, when looping through the 512 cal bins, it will never go
                    -- this far back. So on this first iteration, we want to multiply the cordic value by the cordic value
                    -- and this sets up that with the multiplicand signal and tells the multiplier to start
                    multiplicand_re <= signed(cos_fifo_out);
                    multiplicand_im <= signed(sin_fifo_out);
                    phase_st_re <= signed(cos_fifo_out);
                    phase_st_im <= signed(sin_fifo_out);
                    valid_in <= '1';
                    state <= S_WAIT_FOR_RESULT1;
                when S_WAIT_FOR_RESULT1 =>
                    -- This state will be accessed both after the first and all subsequent multiplications have been initialized
                    -- So it sets the multiplier valid in signal low, starts requesting the next cal bin from the FIFO
                    -- Sets the output calbin value for the current calbin being calculated for
                    -- And does the first multiplication of kk
                    valid_in <= '0';
                    readycal <= '0';
                    readyout <= '0';
                    fifo_bin_re <= '0';
                    kk <= shift_left(resize(calbin_out+1, 13), 1) - 1;
                    calbin <= fifo_bin_out;
                    if (fifo_empty = '0') then
                        fifo_bin_re <= '1';
                    end if;
                    state <= S_WAIT_FOR_RESULT2;
                when S_WAIT_FOR_RESULT2 =>
                    -- Still waiting for multiplication
                    -- And we are also waiting for the next calbin to come out from the FIFO so request goes low
                    fifo_bin_re <= '0';
                    state <= S_WAIT_FOR_RESULT3;
                when S_WAIT_FOR_RESULT3 =>
                    -- Last step for kar output is to multiply by the cycle number (out of 64)
                    -- This is a multiplication that can be done in one cycle
                    -- Max would be (1024-1) * (128) which is fine for 18 x 18 unsigned multiplier in one clock cycle
                    kar_s <= std_logic_vector(kk * Nac);
                    state <= S_WAIT_FOR_RESULT4;
                when S_WAIT_FOR_RESULT4 =>
                    -- Product will always have a max of 18 bits, and that's the output size of block for kar
                    kar_out <= kar_s(17 downto 0);
                    -- By now the next cal bin has come out for the next cycle
                    -- If we're still in the same cycle, check to make sure it was one larger than the one we're processing now
                    if (calbin_out /= 511) then
                        if (unsigned(fifo_bin_out) /= (calbin_out + 1)) then
                            error_fifo_order <= '1';
                        end if;
                    end if;
                    state <= S_WAIT_FOR_RESULT5;
                when S_WAIT_FOR_RESULT5 =>
                    -- Should I have it all wait in this state for the multiplication to be done?
                    state <= S_WAIT_FOR_RESULT6;
                when S_WAIT_FOR_RESULT6 =>
                    state <= S_ACT_ON_RESULT1;
                when S_ACT_ON_RESULT1 =>
                    -- Multiplication is done!
                    -- Because we are multiplying complex numbers, the real/imaginary additions have to be done like below
                    -- Because of the constraints on these values, they can't overflow
                    if (valid_out = "1111") then
                        sum_re <= signed(product_re_re) - signed(product_im_im);
                        sum_im <= signed(product_re_im) + signed(product_im_re);
                        state <= S_ACT_ON_RESULT2;
                    else
                        -- Doing it this way ensures that the multiplier pipeline is always steady time-wise
                        error_multiplication <= '1';
                    end if;
                when S_ACT_ON_RESULT2 =>
                    -- Now we have our real and imaginary results for the phase multiplication
                    -- Because of the way the phase values are represented out of the cordic,
                    -- There was an implied decimal point between bit 30 and 29, and we were doing fixed point multiplication
                    -- So we really need to shift left 5 times so that the fixed point representation lines up
                    -- Using "shift_left" would have required more variables, since the result needs to be 65 bits before we convert it
                    -- to 32 bits for the output. So I decided to do it fixed like this and go directly to the output in 1 step
                    -- I grab the sign bit and then the relevant from the fixed point product output
                    -- I have confirmed that this works with the multiplicands and products by checking by hand
                    if (calbin_out = 0) then
                        -- On the first cycle, the algorithm calls for us to save the output of this first multiplication
                        -- And use it as the second multiplicand for the next 511 cycles, so that's what's done here
                        -- We'll never go back in these next 511 to overwrite the value of multiplicand_re and _im
                        -- But the output of this first cycle is the original cordic output, not the product
                        multiplicand_re <= sum_re(63) & sum_re(59 downto 29);
                        multiplicand_im <= sum_im(63) & sum_im(59 downto 29);
                        phase_cor_re <= std_logic_vector(phase_st_re);
                        phase_cor_im <= std_logic_vector(phase_st_im);
                    else
                        -- For the rest of the 511 cycles, the product output is the phase_cor output
                        -- As well as the phase_st that will be multiplied by next cycle
                        phase_st_re <= sum_re(63) & sum_re(59 downto 29);
                        phase_st_im <= sum_im(63) & sum_im(59 downto 29);
                        phase_cor_re <= std_logic_vector(sum_re(63) & sum_re(59 downto 29));
                        phase_cor_im <= std_logic_vector(sum_im(63) & sum_im(59 downto 29));
                    end if;
                    
                    -- We have a new phase to output, the output cal bin indicator is ready
                    -- Set the flag high so the further blocks know to latch it in
                    readycal <= '1';
                    
                    -- If this is the last (32nd, 64th, 128th) cycle, this flag goes high for the further blocks to do things with
                    if (Nac = Nac1_limit) then
                        readyout <= '1';
                    end if;
                    
                    -- If we still have more cal bins to go in the 512 long run, we have our next one ready at the output of the FIFO
                    -- And go back to the middle of the state machine where it will wait for the multiplication that just started
                    if (calbin_out /= 511) then
                        calbin_out <= unsigned('0' & fifo_bin_out);
                        valid_in <= '1';
                        state <= S_WAIT_FOR_RESULT1;
                    else
                        -- If that was the 512th bin, set back to 0 and go back to Idle to wait for the next stream of bins
                        calbin_out <= (others=>'0');
                        if (Nac = Nac1_limit) then
                            -- If this was also the last cycle, then send the update drift flags to further blocks know to give us new cordic inputs
                            Nac <= to_unsigned(0, Nac'length);
                        else
                            Nac <= Nac + 1;
                        end if;
                        state <= S_IDLE;
                    end if;
                when others =>		
                    state <= S_IDLE;
                end case;
                
                -- This state machine operates independently from the first
                -- When a new cycle of 32/64/128 starts, this state machine uses the initial cal_drift value and phase
                -- Run through the calculation of all the cordic outputs that will be used for the next 64 cycles of 512 bins
                case state2 is
                when S_CORDIC_IDLE =>
                    -- The cal drift that we use for the cycles is the input into this block when reset is lifted
                    -- Todo: See if I need to wait a certain amount of cycles after reset to start doing this?
                    --cal_drift_s <= resize(signed(cal_drift), cal_drift_s'length);
                    cordic_valid_in <= '0';
                    cos_fifo_we <= '0';
                    sin_fifo_we <= '0';
                    state2 <= S_CORDIC_WAIT_FOR_DRIFT;
                when S_CORDIC_WAIT_FOR_DRIFT =>
                    cal_drift_s <= signed(cal_drift);
                    state2 <= S_CORDIC_INPUT;
                when S_CORDIC_INPUT =>
                -- Algorithm calls for the cordic to take the negative phase as the input
                -- Phase has an initial value at the beginning or from previous cycles
                -- And negative phase is the instantaneous negation of it
                -- The phase is a signed value 1 bit larger than 32 to take into account addition from cal drift before the 2 pi adjust          
                -- So it's inputted like this
                    cordic_in <= std_logic_vector(-phase_s);
                    
                    -- Make sure the Cordic block is ready to start calculating with this angle
                    if (cordic_request_for_data = '1') then
                        cordic_valid_in <= '1';
                        state2 <= S_CORDIC_WAIT;
                    end if;                
                when S_CORDIC_WAIT =>
                    -- Just waiting for the cordic to signal that the calculation is done
                    cordic_valid_in <= '0';
                    if (cordic_valid_out = '1') then
                        -- Check that the FIFOs we're about to put this into have space, they should never fill up
                        if (cos_fifo_full =  '1') then
                            error_cos_fifo_full <= '1';
                        else
                            -- If they have space, we write the values to the FIFOs, because the other state machine is likely not ready for them
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
                    -- This phase either recognizes we're at the end for this 64 cycle batch, or calculates the next cordic input value
                    cos_fifo_we <= '0';
                    sin_fifo_we <= '0';
                    if (cordic_counter = Nac1_limit) then
                        state2 <= S_CORDIC_WAIT_FOR_UPDATE;
                    else
                        cordic_counter <= cordic_counter + 1;
                        -- We are always adding that cal_drift value for the 64 cordic inputs in a batch
                        phase_s <= phase_s + cal_drift_s;
                        --Check bounds with +/- pi and adjust
                        state2 <= S_CORDIC_CORRECT;
                    end if;
                when S_CORDIC_CORRECT =>
                    -- Cordic can take in values from pi to -pi so we need to correct if we go over
                    -- This checks to see if the overflow happened. With the way the representation of the angle works
                    -- To subtract or add 2*pi, you only need to change the sign bit, which is what I do here
                    -- The representation should always be a fraction of pi, so if we get to 1.XXXX pi or -1.XXXX pi, I subtract or add 2*pi
                    -- It's difficult to get across without actually writing it out bit by bit
                    if ((phase_s(31 downto 310) = "01")) then
                        -- This means that we are at at least 1.XXX pi. Flipping these bits is the equivalent of subtracting 2*pi
                        phase_s(31 downto 30) <= "11";
                    elsif (phase_s(31 DOWNTO 30) = "10") then
                        -- This means that we are at at least -1.XXX pi. Flipping these bits is the equivalent of adding 2*pi
                        phase_s(31 downto 30) <= "00";
                    end if;
                    -- If needed, the phase was corrected, and it can be inputted to the cordic at this state
                    state2 <= S_CORDIC_INPUT;
                when S_CORDIC_WAIT_FOR_UPDATE =>
                    -- We have done all 32/64/128 calculations for this batch
                    -- Wait until other state machine indicates that we are updating the drift
                    -- Acknowledge and cancel the flag and go back to calculate the next 32/64/128 drift values
                    -- Todo: I think there will need to be some more wait logic here, since new cal_drift values won't come instantaneously
                    cordic_counter <= 0;
                    if (new_phase_rdy = '1') then
                        state2 <= S_CORDIC_IDLE;
                    end if;
                when others =>
                    state2 <= S_CORDIC_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_phaser;
