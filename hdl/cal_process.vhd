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
        error_stick                       :   IN    std_logic;
        
        error                             :   OUT   std_logic_vector(6 DOWNTO 0);
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
        fout_ready                        :   OUT   std_logic;
        new_phase_rdy                     :   OUT   std_logic
        );
end cal_process;
architecture architecture_cal_process of cal_process is
    -- Will add up to 2048/4 = 512 values (2^9), so needs another 9 bits for overflow
    signal FD1                            : signed(40 DOWNTO 0);
    signal FD2                            : signed(40 DOWNTO 0);
    signal FD3                            : signed(40 DOWNTO 0);
    signal FD4                            : signed(40 DOWNTO 0);
    signal SD1                            : signed(40 DOWNTO 0);
    signal SD2                            : signed(40 DOWNTO 0);
    signal SD3                            : signed(40 DOWNTO 0);
    signal SD4                            : signed(40 DOWNTO 0);
    
    signal FDX_neg                        : std_logic;
    signal SDX_neg                        : std_logic;
    signal fraction_num                   : integer range 0 to 30;
    
    signal top1                           : signed(40 DOWNTO 0);
    signal bot1                           : signed(40 DOWNTO 0);
    signal top2                           : signed(40 DOWNTO 0);
    signal bot2                           : signed(40 DOWNTO 0);
    signal top3                           : signed(40 DOWNTO 0);
    signal bot3                           : signed(40 DOWNTO 0);
    signal top4                           : signed(40 DOWNTO 0);
    signal bot4                           : signed(40 DOWNTO 0);
    
    SIGNAL read_address                   : std_logic_vector(8 downto 0);
    SIGNAL write_address                  : std_logic_vector(8 downto 0);
    SIGNAL write_en                       : std_logic;
    SIGNAL error_stick_s                  : std_logic;
    SIGNAL error_s                        : std_logic_vector(6 DOWNTO 0);
    
    -- Todo, I think we only need to go to 35
    SIGNAL sig1_re_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig1_im_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig2_re_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig2_im_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig3_re_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig3_im_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig4_re_write_data             : signed(37 DOWNTO 0);
    SIGNAL sig4_im_write_data             : signed(37 DOWNTO 0);
    
    SIGNAL sig1_re_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig1_im_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig2_re_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig2_im_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig3_re_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig3_im_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig4_re_read_data              : signed(37 DOWNTO 0);
    SIGNAL sig4_im_read_data              : signed(37 DOWNTO 0);
    
    SIGNAL foutreal1_s                    : signed(37 DOWNTO 0);
    SIGNAL foutimag1_s                    : signed(37 DOWNTO 0);
    SIGNAL foutreal2_s                    : signed(37 DOWNTO 0);
    SIGNAL foutimag2_s                    : signed(37 DOWNTO 0);
    SIGNAL foutreal3_s                    : signed(37 DOWNTO 0);
    SIGNAL foutimag3_s                    : signed(37 DOWNTO 0);
    SIGNAL foutreal4_s                    : signed(37 DOWNTO 0);
    SIGNAL foutimag4_s                    : signed(37 DOWNTO 0);
    signal Nac2                           : integer range 0 to 9;
    
    signal numerator_s                    : std_logic_vector(31 downto 0);
    signal denominator_s                  : std_logic_vector(31 downto 0);
    signal valid_in_s                     : std_logic;
    signal valid_out_s                    : std_logic;
    signal quotient_s                     : std_logic_vector(31 downto 0);
    signal remainder_s                    : std_logic_vector(31 downto 0);
    signal div_result                     : std_logic_vector(31 downto 0);
    signal FDX                            : signed(42 DOWNTO 0);
    signal SDX                            : signed(42 DOWNTO 0);
    signal delta_drift                    : signed(31 downto 0);
    SIGNAL drift_s                        : signed(31 DOWNTO 0);
    
    -- phase_drift_per_ppm = 50e3*4096/102.4e6 *(1/1e6)*2*pi; I will leave out the pi because of angle fixed point representation
    -- phase_drift_per_ppm = 0.000004
    -- alpha_to_pdrift = 16*phase_drift_per_ppm;
    -- alpha_to_pdrift = 0.000064
    
    -- 0.05*alpha_to_pdrift = 0.0000032
    -- 0.05*alpha_to_pdrift = binary(00.000000000000000000110101101100) aka
    -- 1/(2**19) + 1/(2**20) + 1/(2**22) + 1/(2**24) + 1/(2**25) + 1/(2**27) + 1/(2**28) = 0.000003200024...
    -- So this can be added cleanly to the phase output which has the same fixed point representation
    
    -- 1.2*alpha_to_pdrift = 0.0000768
    -- 1.2*alpha_to_pdrift = binary(00.000000000000010100001000011111) aka
    -- 1/(2**14) + 1/(2**16) + 1/(2**21) + 1/(2**26) + 1/(2**27) + 1/(2**28) + 1/(2**29) + 1/(2**30) = 0.00007679965...
    -- So this can be compared directly to the phase output which has the same fixed point representation
    -- -1.2*alpha_to_pdrift = binary(11.111111111111101011110111100000)
    
    CONSTANT k_0_05_alpha                : signed(31 DOWNTO 0) := "00000000000000000000110101101100";
    CONSTANT k_1_2_alpha                 : signed(31 DOWNTO 0) := "00000000000000010100001000011111";
    --CONSTANT k_negative_1_2_alpha        : signed(31 DOWNTO 0) := "10000000000000010100001000011111";
    CONSTANT k_negative_1_2_alpha        : signed(31 DOWNTO 0) := "11111111111111101011110111100000";
    
    type state_type is (S_IDLE,
        S_PWR_1,
        S_PWR_2,
        S_PWR_3,
        S_PWR_4,
        S_DIV_PREP_1,
        S_DIVIDE_1,
        S_DIVIDE_2,
        S_LATCH_DRIFT,
        S_CHECK_LOCK,
        S_ADD_DRIFT,
        S_CORRECT_DRIFT,
        S_OUTPUT_NEW_DRIFT,
        S_OUTPUT_READY);
    signal state: state_type;
    
    component PF_TPSRAM_CAL_PROCESS
    PORT ( 
        CLK                               :   IN    std_logic;
        R_ADDR                            :   IN    std_logic_vector(8 downto 0);
        W_ADDR                            :   IN    std_logic_vector(8 downto 0);
        W_DATA                            :   IN    signed(37 downto 0);
        W_EN                              :   IN    std_logic;
        R_DATA                            :   OUT   signed(37 downto 0)
        );
    end component;
    
    component DIVISION_C0
    PORT ( 
        den_i     : in  std_logic_vector(31 downto 0);
        num_i     : in  std_logic_vector(31 downto 0);
        reset_i   : in  std_logic;
        start_i   : in  std_logic;
        sys_clk_i : in  std_logic;
        
        done_o    : out std_logic;
        q_o       : out std_logic_vector(31 downto 0);
        r_o       : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    sig1_re_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig1_re_write_data,
        R_DATA   => sig1_re_read_data
        );
        
    sig1_im_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig1_im_write_data,
        R_DATA   => sig1_im_read_data
        );
        
        
    sig2_re_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig2_re_write_data,
        R_DATA   => sig2_re_read_data
        );
        
    sig2_im_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig2_im_write_data,
        R_DATA   => sig2_im_read_data
        );
        
    sig3_re_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig3_re_write_data,
        R_DATA   => sig3_re_read_data
        );
        
    sig3_im_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig3_im_write_data,
        R_DATA   => sig3_im_read_data
        );
    
    sig4_re_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig4_re_write_data,
        R_DATA   => sig4_re_read_data
        );
        
    sig4_im_accumulator : PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig4_im_write_data,
        R_DATA   => sig4_im_read_data
        );
        
    vhdl_divide : DIVISION_C0
    PORT MAP(
        sys_clk_i         => clk,
        reset_i       => not reset,
        num_i   => numerator_s,
        den_i => denominator_s,
        start_i    => valid_in_s, 
        done_o   => valid_out_s,
        q_o    => quotient_s,
        r_o    => remainder_s
    );
    error       <= error_s;
    foutreal1   <= std_logic_vector(foutreal1_s(37 DOWNTO 6));
    foutimag1   <= std_logic_vector(foutimag1_s(37 DOWNTO 6));
    foutreal2   <= std_logic_vector(foutreal2_s(37 DOWNTO 6));
    foutimag2   <= std_logic_vector(foutimag2_s(37 DOWNTO 6));
    foutreal3   <= std_logic_vector(foutreal3_s(37 DOWNTO 6));
    foutimag3   <= std_logic_vector(foutimag3_s(37 DOWNTO 6));
    foutreal4   <= std_logic_vector(foutreal4_s(37 DOWNTO 6));
    foutimag4   <= std_logic_vector(foutimag4_s(37 DOWNTO 6));
    
    process (clk)
        variable div_result_neg : signed(31 DOWNTO 0) := (others=>'0');
        begin
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
                
                FDX_neg          <= '0';
                SDX_neg          <= '0';
                fraction_num     <= 30;
                div_result       <= (others=>'0');
                
                FDX              <= (others=>'0');
                SDX              <= (others=>'0');
                delta_drift      <= (others=>'0');
                
                top1             <= (others=>'0');
                bot1             <= (others=>'0');
                top2             <= (others=>'0');
                bot2             <= (others=>'0');
                top3             <= (others=>'0');
                bot3             <= (others=>'0');
                top4             <= (others=>'0');
                bot4             <= (others=>'0');
                
                read_address           <= (others=>'0');
                write_address          <= (others=>'0');
                write_en               <= '0';
                Nac2                   <= 0;
                fout_ready             <= '0';
                --drift_s                <= (others=>'0');
                --drift_out              <= (others=>'0');
                drift_s                <= x"00005088";
                drift_out              <= x"00005088";
                --Was -0.0000192
                --drift_out              <= "11111111111111111010111101111000";
                -- Was 5.3E-8
                --drift_out              <= "00000000000000000000000000111001";
                have_lock_out          <= '0';
                new_phase_rdy          <= '0';
                
                sig1_re_write_data     <= (others=>'0');
                sig1_im_write_data     <= (others=>'0');
                sig2_re_write_data     <= (others=>'0');
                sig2_im_write_data     <= (others=>'0');
                sig3_re_write_data     <= (others=>'0');
                sig3_im_write_data     <= (others=>'0');
                sig4_re_write_data     <= (others=>'0');
                sig4_im_write_data     <= (others=>'0');
                
                foutreal1_s            <= (others=>'0');
                foutimag1_s            <= (others=>'0');
                foutreal2_s            <= (others=>'0');
                foutimag2_s            <= (others=>'0');
                foutreal3_s            <= (others=>'0');
                foutimag3_s            <= (others=>'0');
                foutreal4_s            <= (others=>'0');
                foutimag4_s            <= (others=>'0');
                error_s                <= (others=>'0');
                
                numerator_s            <= (others=>'0');
                denominator_s          <= (others=>'0');
                valid_in_s             <= '0';
                state                  <= S_IDLE;
            else
                error_stick_s    <= error_stick;
                if (error_stick_s = '0') then
                    error_s <= (others=>'0');
                end if;
                write_en <= '0';
                fout_ready <= '0';
                new_phase_rdy <= '0';
                
                if (readyout = '1') then
                    FD1 <= FD1 + signed(drift_FD1);
                    FD2 <= FD2 + signed(drift_FD2);
                    FD3 <= FD3 + signed(drift_FD3);
                    FD4 <= FD4 + signed(drift_FD4);
                    
                    SD1 <= SD1 + signed(drift_SD1);
                    SD2 <= SD2 + signed(drift_SD2);
                    SD3 <= SD3 + signed(drift_SD3);
                    SD4 <= SD4 + signed(drift_SD4);
                    
                    top1 <= top1 + signed(powertop1);
                    top2 <= top2 + signed(powertop2);
                    top3 <= top3 + signed(powertop3);
                    top4 <= top4 + signed(powertop4);
                    
                    bot1 <= bot1 + signed(powerbot1);
                    bot2 <= bot2 + signed(powerbot2);
                    bot3 <= bot3 + signed(powerbot3);
                    bot4 <= bot4 + signed(powerbot4);
                    
                    if (calbin = read_address) then
                        write_en               <= '1';
                        read_address           <= std_logic_vector(unsigned(read_address) + 1);
                        write_address          <= read_address;
                        
                        if (Nac2 = 0) then
                            sig1_re_write_data     <= resize(signed(outreal1), 38);
                            sig1_im_write_data     <= resize(signed(outimag1), 38);
                            sig2_re_write_data     <= resize(signed(outreal2), 38);
                            sig2_im_write_data     <= resize(signed(outimag2), 38);
                            sig3_re_write_data     <= resize(signed(outreal3), 38);
                            sig3_im_write_data     <= resize(signed(outimag3), 38);
                            sig4_re_write_data     <= resize(signed(outreal4), 38);
                            sig4_im_write_data     <= resize(signed(outimag4), 38);
                        elsif (Nac2 < 9) then
                            sig1_re_write_data     <= sig1_re_read_data + signed(outreal1);
                            sig1_im_write_data     <= sig1_im_read_data + signed(outimag1);
                            sig2_re_write_data     <= sig2_re_read_data + signed(outreal2);
                            sig2_im_write_data     <= sig2_im_read_data + signed(outimag2);
                            sig3_re_write_data     <= sig3_re_read_data + signed(outreal3);
                            sig3_im_write_data     <= sig3_im_read_data + signed(outimag3);
                            sig4_re_write_data     <= sig4_re_read_data + signed(outreal4);
                            sig4_im_write_data     <= sig4_im_read_data + signed(outimag4);
                        else
                            sig1_re_write_data     <= (others=>'0');
                            sig1_im_write_data     <= (others=>'0');
                            sig2_re_write_data     <= (others=>'0');
                            sig2_im_write_data     <= (others=>'0');
                            sig3_re_write_data     <= (others=>'0');
                            sig3_im_write_data     <= (others=>'0');
                            sig4_re_write_data     <= (others=>'0');
                            sig4_im_write_data     <= (others=>'0');
                            
                            foutreal1_s            <= sig1_re_read_data + signed(outreal1);
                            foutimag1_s            <= sig1_im_read_data + signed(outimag1);
                            foutreal2_s            <= sig2_re_read_data + signed(outreal2);
                            foutimag2_s            <= sig2_im_read_data + signed(outimag2);
                            foutreal3_s            <= sig3_re_read_data + signed(outreal3);
                            foutimag3_s            <= sig3_im_read_data + signed(outimag3);
                            foutreal4_s            <= sig4_re_read_data + signed(outreal4);
                            foutimag4_s            <= sig4_im_read_data + signed(outimag4);
        
                            fout_ready             <= '1';
                        end if;
                    else
                        error_s(0) <= '1';
                    end if;
                    
                    if (update_drift = '1') then
                        if (state = S_IDLE) then
                            state <= S_PWR_1;
                        else
                            error_s(1) <= '1';
                        end if;
                    end if;
                end if;
                
                case state is
                when S_IDLE =>
                    FDX <= (others=>'0');
                    SDX <= (others=>'0');
                    fraction_num     <= 30;
                    valid_in_s <= '0';
                when S_PWR_1 =>
                    if (shift_right(top1, 4) > bot1) then
                        FDX <= FDX + FD1;
                        SDX <= SDX + SD1;
                    end if;
                    state <= S_PWR_2;
                when S_PWR_2 =>
                    if (shift_right(top2, 4) > bot2) then
                        FDX <= FDX + FD2;
                        SDX <= SDX + SD2;
                    end if;
                    state <= S_PWR_3;
                when S_PWR_3 =>
                    if (shift_right(top3, 4) > bot3) then
                        FDX <= FDX + FD3;
                        SDX <= SDX + SD3;
                    end if;
                    state <= S_PWR_4;
                when S_PWR_4 =>
                    if (shift_right(top4, 4) > bot4) then
                        FDX <= FDX + FD4;
                        SDX <= SDX + SD4;
                    end if;
                    state <= S_DIV_PREP_1;
                when S_DIV_PREP_1 =>
                    if (FDX(FDX'left) = '1') then
                        FDX_neg <= '1';
                        numerator_s <= std_logic_vector(-FDX(FDX'left DOWNTO FDX'left - 31));
                    else
                        FDX_neg <= '0';
                        numerator_s <= std_logic_vector(FDX(FDX'left DOWNTO FDX'left - 31));
                    end if;
                    
                    if (SDX(SDX'left) = '1') then
                        SDX_neg <= '1';
                        denominator_s <= std_logic_vector(-SDX(SDX'left DOWNTO SDX'left - 31));
                    else
                        SDX_neg <= '0';
                        denominator_s <= std_logic_vector(SDX(SDX'left DOWNTO SDX'left - 31));
                    end if;
                    valid_in_s <= '1';
                    state <= S_DIVIDE_2;
                when S_DIVIDE_2 =>
                    valid_in_s <= '0';
                    if (denominator_s = x"00000000") then
                        error_s(3) <= '1';
                    end if;
                    if (valid_out_s = '1') then
                        if (quotient_s = x"00000001") then
                            div_result(fraction_num) <= '1';
                            if (remainder_s /= x"00000000") then
                                numerator_s <= remainder_s(30 DOWNTO 0) & '0';
                                valid_in_s <= '1';
                            else
                                state <= S_LATCH_DRIFT;
                            end if;
                        elsif (quotient_s = x"00000000") then
                            div_result(fraction_num) <= '0';
                            if (remainder_s /= x"00000000") then
                                numerator_s <= numerator_s(30 DOWNTO 0) & '0';
                                valid_in_s <= '1';
                            else
                                state <= S_LATCH_DRIFT;
                            end if;
                        else
                            error_s(2) <= '1';
                        end if;
                        
                        if (fraction_num /= 0) then
                            fraction_num <= fraction_num - 1;
                            numerator_s <= remainder_s(30 DOWNTO 0) & '0';
                        else
                            valid_in_s <= '0';
                            state <= S_LATCH_DRIFT;
                        end if;
                    end if;
                when S_LATCH_DRIFT =>
                    if ((FDX_neg = '1' and SDX_neg = '1') or (FDX_neg = '0' and SDX_neg = '0')) then
                        delta_drift <= signed(div_result);
                    else
                        div_result_neg := signed(div_result);
                        delta_drift <= -div_result_neg;
                    end if;
                    valid_in_s <= '0';
                    state <= S_CHECK_LOCK;
                when S_CHECK_LOCK =>
                    if ((SDX < 0) and (abs(delta_drift) < k_0_05_alpha)) then
                        have_lock_out <= '1';
                    else
                        delta_drift <= k_0_05_alpha;
                    end if;
                    state <= S_ADD_DRIFT;
                when S_ADD_DRIFT =>
                --TODO: See if we need overflow bit
                    drift_s <= drift_s + delta_drift;
                    state <= S_CORRECT_DRIFT;
                when S_CORRECT_DRIFT =>
                    if (drift_s > k_1_2_alpha) then
                        drift_s <= k_negative_1_2_alpha;
                    elsif (drift_s < k_negative_1_2_alpha) then
                        drift_s <= k_1_2_alpha;
                    end if;
                    state <= S_OUTPUT_NEW_DRIFT;
                when S_OUTPUT_NEW_DRIFT =>
                    FD1 <= (others=>'0');
                    FD2 <= (others=>'0');
                    FD3 <= (others=>'0');
                    FD4 <= (others=>'0');
                    
                    SD1 <= (others=>'0');
                    SD2 <= (others=>'0');
                    SD3 <= (others=>'0');
                    SD4 <= (others=>'0');
                    
                    top1 <= (others=>'0');
                    top2 <= (others=>'0');
                    top3 <= (others=>'0');
                    top4 <= (others=>'0');
                    
                    bot1 <= (others=>'0');
                    bot2 <= (others=>'0');
                    bot3 <= (others=>'0');
                    bot4 <= (others=>'0');
                    
                    drift_out <= std_logic_vector(drift_s);
                    new_phase_rdy          <= '1';
                    if (Nac2 /= 9) then
                        Nac2 <= Nac2 + 1;
                    else
                        Nac2 <= 0;
                    end if;
                    state <= S_IDLE;
                when others =>		
                    state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;
end architecture_cal_process;
