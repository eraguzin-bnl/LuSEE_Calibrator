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
    
    signal top1                           : signed(37 DOWNTO 0);
    signal bot1                           : signed(37 DOWNTO 0);
    signal top2                           : signed(37 DOWNTO 0);
    signal bot2                           : signed(37 DOWNTO 0);
    signal top3                           : signed(37 DOWNTO 0);
    signal bot3                           : signed(37 DOWNTO 0);
    signal top4                           : signed(37 DOWNTO 0);
    signal bot4                           : signed(37 DOWNTO 0);
    
    SIGNAL read_address                   : std_logic_vector(8 downto 0);
    SIGNAL write_address                  : std_logic_vector(8 downto 0);
    SIGNAL write_en                       : std_logic;
    SIGNAL error_stick_s                  : std_logic;
    SIGNAL error_s                        : std_logic_vector(6 DOWNTO 0);
    
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
    
    signal Nac2                           : integer range 0 to 9;

begin
    sig1_re_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig1_re_write_data,
        R_DATA   => sig1_re_read_data
        );
        
    sig1_im_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig1_im_write_data,
        R_DATA   => sig1_im_read_data
        );
        
        
    sig2_re_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig2_re_write_data,
        R_DATA   => sig2_re_read_data
        );
        
    sig2_im_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig2_im_write_data,
        R_DATA   => sig2_im_read_data
        );
        
    sig3_re_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig3_re_write_data,
        R_DATA   => sig3_re_read_data
        );
        
    sig3_im_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig3_im_write_data,
        R_DATA   => sig3_im_read_data
        );
    
    sig4_re_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig4_re_write_data,
        R_DATA   => sig4_re_read_data
        );
        
    sig4_im_accumulator : entity work.PF_TPSRAM_CAL_PROCESS
    PORT MAP( 
        CLK      => clk,
        R_ADDR   => read_address,
        W_EN     => write_en,
        W_ADDR   => write_address,
        W_DATA   => sig4_im_write_data,
        R_DATA   => sig4_im_read_data
        );
        
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
                
                sig1_re_write_data     <= (others=>'0');
                sig1_im_write_data     <= (others=>'0');
                sig2_re_write_data     <= (others=>'0');
                sig2_im_write_data     <= (others=>'0');
                sig3_re_write_data     <= (others=>'0');
                sig3_im_write_data     <= (others=>'0');
                sig4_re_write_data     <= (others=>'0');
                sig4_im_write_data     <= (others=>'0');
            else
                error_stick_s    <= error_stick;
                if (error_stick_s = '0') then
                    error_s <= (others=>'0');
                end if;
                write_en <= '0';
                fout_ready <= '0';
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
                        
                        if (Nac2 < 9) then
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
                            
                            foutreal1              <= std_logic_vector(sig1_re_read_data + signed(outreal1));
                            foutimag1              <= std_logic_vector(sig1_im_read_data + signed(outimag1));
                            foutreal2              <= std_logic_vector(sig2_re_read_data + signed(outreal2));
                            foutimag2              <= std_logic_vector(sig2_im_read_data + signed(outimag2));
                            foutreal3              <= std_logic_vector(sig3_re_read_data + signed(outreal3));
                            foutimag3              <= std_logic_vector(sig3_im_read_data + signed(outimag3));
                            foutreal4              <= std_logic_vector(sig4_re_read_data + signed(outreal4));
                            foutimag4              <= std_logic_vector(sig4_im_read_data + signed(outimag4));
        
                            fout_ready             <= '1';
                        end if;
                    else
                        error(0) <= '1';
                    end if;
                    
                    if (update_drift = '1') then
                    
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture_cal_process;
