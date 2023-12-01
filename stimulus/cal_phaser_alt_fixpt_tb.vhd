-- -------------------------------------------------------------
-- 
-- File Name: /u/home/eraguzin/matlab/LNspec/matlab/codegen/cal_phaser_alt/hdlsrc/cal_phaser_alt_fixpt_tb.vhd
-- Created: 2023-11-22 11:57:46
-- 
-- Generated by MATLAB 9.12, MATLAB Coder 5.4 and HDL Coder 3.20
-- 
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Design base rate: 1
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        1
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- calbin                        ce_out        1
-- phase_cor_re                  ce_out        1
-- phase_cor_im                  ce_out        1
-- kar_out                       ce_out        1
-- tick_out                      ce_out        1
-- readyout                      ce_out        1
-- update_drift                  ce_out        1
-- readycal                      ce_out        1
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: cal_phaser_alt_fixpt_tb
-- Source Path: 
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_textio.ALL;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY STD;
USE STD.textio.ALL;
USE work.cal_phaser_alt_fixpt_tb_pkg.ALL;

ENTITY cal_phaser_alt_fixpt_tb IS
END cal_phaser_alt_fixpt_tb;


ARCHITECTURE rtl OF cal_phaser_alt_fixpt_tb IS

  -- Component Declarations
  COMPONENT cal_phaser_alt_fixpt
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          bin_in                          :   IN    std_logic_vector(11 DOWNTO 0);  -- ufix12
          cal_drift                       :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En46
          readyin                         :   IN    std_logic;
          ce_out                          :   OUT   std_logic;
          calbin                          :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          phase_cor_re                    :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
          phase_cor_im                    :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En30
          kar_out                         :   OUT   std_logic_vector(15 DOWNTO 0);  -- uint16
          tick_out                        :   OUT   std_logic_vector(1 DOWNTO 0);  -- sfix2
          readyout                        :   OUT   std_logic;
          update_drift                    :   OUT   std_logic;
          readycal                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : cal_phaser_alt_fixpt
    USE ENTITY work.cal_phaser_alt_fixpt(rtl);

  -- Signals
  SIGNAL clk                              : std_logic;
  SIGNAL reset                            : std_logic;
  SIGNAL enb                              : std_logic;
  SIGNAL readycal_done                    : std_logic;  -- ufix1
  SIGNAL rdEnb                            : std_logic;
  SIGNAL readycal_done_enb                : std_logic;  -- ufix1
  SIGNAL calbin_addr                      : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL readycal_lastAddr                : std_logic;  -- ufix1
  SIGNAL resetn                           : std_logic;
  SIGNAL check7_done                      : std_logic;  -- ufix1
  SIGNAL update_drift_done                : std_logic;  -- ufix1
  SIGNAL update_drift_done_enb            : std_logic;  -- ufix1
  SIGNAL update_drift_lastAddr            : std_logic;  -- ufix1
  SIGNAL check6_done                      : std_logic;  -- ufix1
  SIGNAL readyout_done                    : std_logic;  -- ufix1
  SIGNAL readyout_done_enb                : std_logic;  -- ufix1
  SIGNAL readyout_lastAddr                : std_logic;  -- ufix1
  SIGNAL check5_done                      : std_logic;  -- ufix1
  SIGNAL tick_out_done                    : std_logic;  -- ufix1
  SIGNAL tick_out_done_enb                : std_logic;  -- ufix1
  SIGNAL tick_out_lastAddr                : std_logic;  -- ufix1
  SIGNAL check4_done                      : std_logic;  -- ufix1
  SIGNAL kar_out_done                     : std_logic;  -- ufix1
  SIGNAL kar_out_done_enb                 : std_logic;  -- ufix1
  SIGNAL kar_out_lastAddr                 : std_logic;  -- ufix1
  SIGNAL check3_done                      : std_logic;  -- ufix1
  SIGNAL phase_cor_re_done                : std_logic;  -- ufix1
  SIGNAL phase_cor_re_done_enb            : std_logic;  -- ufix1
  SIGNAL phase_cor_re_lastAddr            : std_logic;  -- ufix1
  SIGNAL check2_done                      : std_logic;  -- ufix1
  SIGNAL calbin_done                      : std_logic;  -- ufix1
  SIGNAL calbin_done_enb                  : std_logic;  -- ufix1
  SIGNAL calbin_active                    : std_logic;  -- ufix1
  SIGNAL bin_in_addr                      : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL readyin_addr_delay_1             : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL tb_enb                           : std_logic;
  SIGNAL rawData_readyin                  : std_logic;
  SIGNAL holdData_readyin                 : std_logic;
  SIGNAL readyin_offset                   : std_logic;
  SIGNAL readyin                          : std_logic;
  SIGNAL cal_drift_addr_delay_1           : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL rawData_cal_drift                : unsigned(31 DOWNTO 0);  -- ufix32_En46
  SIGNAL holdData_cal_drift               : unsigned(31 DOWNTO 0);  -- ufix32_En46
  SIGNAL cal_drift_offset                 : unsigned(31 DOWNTO 0);  -- ufix32_En46
  SIGNAL cal_drift                        : unsigned(31 DOWNTO 0);  -- ufix32_En46
  SIGNAL cal_drift_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL bin_in_active                    : std_logic;  -- ufix1
  SIGNAL bin_in_enb                       : std_logic;  -- ufix1
  SIGNAL bin_in_addr_delay_1              : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL rawData_bin_in                   : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL holdData_bin_in                  : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL bin_in_offset                    : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL bin_in_1                         : unsigned(11 DOWNTO 0);  -- ufix12
  SIGNAL bin_in_2                         : std_logic_vector(11 DOWNTO 0);  -- ufix12
  SIGNAL snkDone                          : std_logic;
  SIGNAL snkDonen                         : std_logic;
  SIGNAL ce_out                           : std_logic;
  SIGNAL calbin                           : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL phase_cor_re                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL phase_cor_im                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL kar_out                          : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL tick_out                         : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL readyout                         : std_logic;
  SIGNAL update_drift                     : std_logic;
  SIGNAL readycal                         : std_logic;
  SIGNAL calbin_enb                       : std_logic;  -- ufix1
  SIGNAL calbin_lastAddr                  : std_logic;  -- ufix1
  SIGNAL check1_done                      : std_logic;  -- ufix1
  SIGNAL calbin_unsigned                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL calbin_addr_delay_1              : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL calbin_expected                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL calbin_ref                       : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL calbin_testFailure               : std_logic;  -- ufix1
  SIGNAL phase_cor_re_signed              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_re_addr_delay_1        : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL phase_cor_re_expected            : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_re_ref                 : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_re_testFailure         : std_logic;  -- ufix1
  SIGNAL phase_cor_im_signed              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_im_expected            : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_im_ref                 : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL phase_cor_im_testFailure         : std_logic;  -- ufix1
  SIGNAL kar_out_unsigned                 : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL kar_out_addr_delay_1             : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL kar_out_expected                 : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL kar_out_ref                      : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL kar_out_testFailure              : std_logic;  -- ufix1
  SIGNAL tick_out_signed                  : signed(1 DOWNTO 0);  -- sfix2
  SIGNAL tick_out_addr_delay_1            : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL tick_out_expected                : signed(1 DOWNTO 0);  -- sfix2
  SIGNAL tick_out_ref                     : signed(1 DOWNTO 0);  -- sfix2
  SIGNAL tick_out_testFailure             : std_logic;  -- ufix1
  SIGNAL readyout_addr_delay_1            : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL readyout_expected                : std_logic;
  SIGNAL readyout_ref                     : std_logic;
  SIGNAL readyout_testFailure             : std_logic;  -- ufix1
  SIGNAL update_drift_addr_delay_1        : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL update_drift_expected            : std_logic;
  SIGNAL update_drift_ref                 : std_logic;
  SIGNAL update_drift_testFailure         : std_logic;  -- ufix1
  SIGNAL readycal_addr_delay_1            : unsigned(24 DOWNTO 0);  -- ufix25
  SIGNAL readycal_expected                : std_logic;
  SIGNAL readycal_ref                     : std_logic;
  SIGNAL readycal_testFailure             : std_logic;  -- ufix1
  SIGNAL testFailure                      : std_logic;  -- ufix1

BEGIN
  u_cal_phaser_alt_fixpt : cal_phaser_alt_fixpt
    PORT MAP( clk => clk,
              reset => reset,
              clk_enable => enb,
              bin_in => bin_in_2,  -- ufix12
              cal_drift => cal_drift_1,  -- ufix32_En46
              readyin => readyin,
              ce_out => ce_out,
              calbin => calbin,  -- ufix10
              phase_cor_re => phase_cor_re,  -- sfix32_En30
              phase_cor_im => phase_cor_im,  -- sfix32_En30
              kar_out => kar_out,  -- uint16
              tick_out => tick_out,  -- sfix2
              readyout => readyout,
              update_drift => update_drift,
              readycal => readycal
              );
              
  u_cal_phaser_lusee : entity work.cal_phaser
    PORT MAP( clk => clk,
              reset => reset,
              bin_in => bin_in_2,  -- ufix12
              cal_drift => cal_drift_1,  -- ufix32_En46
              readyin => readyin,
              calbin => open,  -- ufix10
              phase_cor_re => open,  -- sfix32_En30
              phase_cor_im => open,  -- sfix32_En30
              kar_out => open,  -- uint16
              readyout => open,
              update_drift => open,
              readycal => open
              );

  readycal_done_enb <= readycal_done AND rdEnb;

  
  readycal_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  readycal_done <= readycal_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_7_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check7_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF readycal_done_enb = '1' THEN
        check7_done <= readycal_done;
      END IF;
    END IF;
  END PROCESS checkDone_7_process;

  update_drift_done_enb <= update_drift_done AND rdEnb;

  
  update_drift_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  update_drift_done <= update_drift_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_6_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check6_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF update_drift_done_enb = '1' THEN
        check6_done <= update_drift_done;
      END IF;
    END IF;
  END PROCESS checkDone_6_process;

  readyout_done_enb <= readyout_done AND rdEnb;

  
  readyout_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  readyout_done <= readyout_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_5_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check5_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF readyout_done_enb = '1' THEN
        check5_done <= readyout_done;
      END IF;
    END IF;
  END PROCESS checkDone_5_process;

  tick_out_done_enb <= tick_out_done AND rdEnb;

  
  tick_out_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  tick_out_done <= tick_out_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_4_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check4_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF tick_out_done_enb = '1' THEN
        check4_done <= tick_out_done;
      END IF;
    END IF;
  END PROCESS checkDone_4_process;

  kar_out_done_enb <= kar_out_done AND rdEnb;

  
  kar_out_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  kar_out_done <= kar_out_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_3_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check3_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF kar_out_done_enb = '1' THEN
        check3_done <= kar_out_done;
      END IF;
    END IF;
  END PROCESS checkDone_3_process;

  phase_cor_re_done_enb <= phase_cor_re_done AND rdEnb;

  
  phase_cor_re_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  phase_cor_re_done <= phase_cor_re_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_2_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check2_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF phase_cor_re_done_enb = '1' THEN
        check2_done <= phase_cor_re_done;
      END IF;
    END IF;
  END PROCESS checkDone_2_process;

  calbin_done_enb <= calbin_done AND rdEnb;

  
  calbin_active <= '1' WHEN calbin_addr /= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  readyin_addr_delay_1 <= bin_in_addr AFTER 1 ns;

  -- Data source for readyin
  readyin_fileread: PROCESS (readyin_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "readyin.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    rawData_readyin <= read_data;
  END PROCESS readyin_fileread;

  -- holdData reg for readyin
  stimuli_readyin_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_readyin <= 'X';
    ELSIF clk'event AND clk = '1' THEN
      holdData_readyin <= rawData_readyin;
    END IF;
  END PROCESS stimuli_readyin_process;

  stimuli_readyin_1: PROCESS (rawData_readyin, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      readyin_offset <= holdData_readyin;
    ELSE
      readyin_offset <= rawData_readyin;
    END IF;
  END PROCESS stimuli_readyin_1;

  readyin <= readyin_offset AFTER 2 ns;

  cal_drift_addr_delay_1 <= bin_in_addr AFTER 1 ns;

  -- Data source for cal_drift
  cal_drift_fileread: PROCESS (cal_drift_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "cal_drift.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(31 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    rawData_cal_drift <= unsigned(read_data(31 DOWNTO 0));
  END PROCESS cal_drift_fileread;

  -- holdData reg for cal_drift
  stimuli_cal_drift_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_cal_drift <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_cal_drift <= rawData_cal_drift;
    END IF;
  END PROCESS stimuli_cal_drift_process;

  stimuli_cal_drift_1: PROCESS (rawData_cal_drift, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      cal_drift_offset <= holdData_cal_drift;
    ELSE
      cal_drift_offset <= rawData_cal_drift;
    END IF;
  END PROCESS stimuli_cal_drift_1;

  cal_drift <= cal_drift_offset AFTER 2 ns;

  cal_drift_1 <= std_logic_vector(cal_drift);

  
  bin_in_active <= '1' WHEN bin_in_addr /= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  bin_in_enb <= bin_in_active AND (rdEnb AND tb_enb);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 26214399
  bin_in_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      bin_in_addr <= to_unsigned(16#0000000#, 25);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF bin_in_enb = '1' THEN
        IF bin_in_addr >= to_unsigned(16#18FFFFF#, 25) THEN 
          bin_in_addr <= to_unsigned(16#0000000#, 25);
        ELSE 
          bin_in_addr <= bin_in_addr + to_unsigned(16#0000001#, 25);
        END IF;
      END IF;
    END IF;
  END PROCESS bin_in_process;


  bin_in_addr_delay_1 <= bin_in_addr AFTER 1 ns;

  -- Data source for bin_in
  bin_in_fileread: PROCESS (bin_in_addr_delay_1, tb_enb, rdEnb)
    FILE fp: TEXT open READ_MODE is "bin_in.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(11 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF rdEnb = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    rawData_bin_in <= unsigned(read_data(11 DOWNTO 0));
  END PROCESS bin_in_fileread;

  -- holdData reg for bin_in
  stimuli_bin_in_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      holdData_bin_in <= (OTHERS => 'X');
    ELSIF clk'event AND clk = '1' THEN
      holdData_bin_in <= rawData_bin_in;
    END IF;
  END PROCESS stimuli_bin_in_process;

  stimuli_bin_in_1: PROCESS (rawData_bin_in, rdEnb)
  BEGIN
    IF rdEnb = '0' THEN
      bin_in_offset <= holdData_bin_in;
    ELSE
      bin_in_offset <= rawData_bin_in;
    END IF;
  END PROCESS stimuli_bin_in_1;

  bin_in_1 <= bin_in_offset AFTER 2 ns;

  bin_in_2 <= std_logic_vector(bin_in_1);

  snkDonen <=  NOT snkDone;

  resetn <=  NOT reset;

  tb_enb <= resetn AND snkDonen;

  
  rdEnb <= tb_enb WHEN snkDone = '0' ELSE
      '0';

  enb <= rdEnb AFTER 2 ns;

  reset_gen: PROCESS 
  BEGIN
    reset <= '1';
    WAIT FOR 20 ns;
    WAIT UNTIL clk'event AND clk = '1';
    WAIT FOR 2 ns;
    reset <= '0';
    WAIT;
  END PROCESS reset_gen;

  clk_gen: PROCESS 
  BEGIN
    clk <= '1';
    WAIT FOR 5 ns;
    clk <= '0';
    WAIT FOR 5 ns;
    IF snkDone = '1' THEN
      clk <= '1';
      WAIT FOR 5 ns;
      clk <= '0';
      WAIT FOR 5 ns;
      WAIT;
    END IF;
  END PROCESS clk_gen;

  calbin_enb <= ce_out AND calbin_active;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 26214399
  calbin_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      calbin_addr <= to_unsigned(16#0000000#, 25);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF calbin_enb = '1' THEN
        IF calbin_addr >= to_unsigned(16#18FFFFF#, 25) THEN 
          calbin_addr <= to_unsigned(16#0000000#, 25);
        ELSE 
          calbin_addr <= calbin_addr + to_unsigned(16#0000001#, 25);
        END IF;
      END IF;
    END IF;
  END PROCESS calbin_1_process;


  
  calbin_lastAddr <= '1' WHEN calbin_addr >= to_unsigned(16#18FFFFF#, 25) ELSE
      '0';

  calbin_done <= calbin_lastAddr AND resetn;

  -- Delay to allow last sim cycle to complete
  checkDone_1_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      check1_done <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF calbin_done_enb = '1' THEN
        check1_done <= calbin_done;
      END IF;
    END IF;
  END PROCESS checkDone_1_process;

  snkDone <= check7_done AND (check6_done AND (check5_done AND (check4_done AND (check3_done AND (check1_done AND check2_done)))));

  calbin_unsigned <= unsigned(calbin);

  calbin_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for calbin_expected
  calbin_expected_fileread: PROCESS (calbin_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "calbin_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(11 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    calbin_expected <= unsigned(read_data(9 DOWNTO 0));
  END PROCESS calbin_expected_fileread;

  calbin_ref <= calbin_expected;

  calbin_unsigned_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      calbin_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND calbin_unsigned /= calbin_ref THEN
        calbin_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in calbin_unsigned: Expected " & to_hex(calbin_ref) & (" Actual " & to_hex(calbin_unsigned))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS calbin_unsigned_checker;

  phase_cor_re_signed <= signed(phase_cor_re);

  phase_cor_re_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for phase_cor_re_expected
  phase_cor_re_expected_fileread: PROCESS (phase_cor_re_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "phase_cor_re_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(31 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    phase_cor_re_expected <= signed(read_data(31 DOWNTO 0));
  END PROCESS phase_cor_re_expected_fileread;

  phase_cor_re_ref <= phase_cor_re_expected;

  phase_cor_re_signed_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      phase_cor_re_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND phase_cor_re_signed /= phase_cor_re_ref THEN
        phase_cor_re_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in phase_cor_re_signed: Expected " & to_hex(phase_cor_re_ref) & (" Actual " & to_hex(phase_cor_re_signed))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS phase_cor_re_signed_checker;

  phase_cor_im_signed <= signed(phase_cor_im);

  -- Data source for phase_cor_im_expected
  phase_cor_im_expected_fileread: PROCESS (phase_cor_re_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "phase_cor_im_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(31 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    phase_cor_im_expected <= signed(read_data(31 DOWNTO 0));
  END PROCESS phase_cor_im_expected_fileread;

  phase_cor_im_ref <= phase_cor_im_expected;

  phase_cor_im_signed_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      phase_cor_im_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND phase_cor_im_signed /= phase_cor_im_ref THEN
        phase_cor_im_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in phase_cor_im_signed: Expected " & to_hex(phase_cor_im_ref) & (" Actual " & to_hex(phase_cor_im_signed))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS phase_cor_im_signed_checker;

  kar_out_unsigned <= unsigned(kar_out);

  kar_out_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for kar_out_expected
  kar_out_expected_fileread: PROCESS (kar_out_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "kar_out_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(15 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    kar_out_expected <= unsigned(read_data(15 DOWNTO 0));
  END PROCESS kar_out_expected_fileread;

  kar_out_ref <= kar_out_expected;

  kar_out_unsigned_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      kar_out_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND kar_out_unsigned /= kar_out_ref THEN
        kar_out_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in kar_out_unsigned: Expected " & to_hex(kar_out_ref) & (" Actual " & to_hex(kar_out_unsigned))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS kar_out_unsigned_checker;

  tick_out_signed <= signed(tick_out);

  tick_out_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for tick_out_expected
  tick_out_expected_fileread: PROCESS (tick_out_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "tick_out_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic_vector(3 DOWNTO 0);

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      HREAD(l, read_data);
    END IF;
    tick_out_expected <= signed(read_data(1 DOWNTO 0));
  END PROCESS tick_out_expected_fileread;

  tick_out_ref <= tick_out_expected;

  tick_out_signed_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      tick_out_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND tick_out_signed /= tick_out_ref THEN
        tick_out_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in tick_out_signed: Expected " & to_hex(tick_out_ref) & (" Actual " & to_hex(tick_out_signed))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS tick_out_signed_checker;

  readyout_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for readyout_expected
  readyout_expected_fileread: PROCESS (readyout_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "readyout_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    readyout_expected <= read_data;
  END PROCESS readyout_expected_fileread;

  readyout_ref <= readyout_expected;

  readyout_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      readyout_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND readyout /= readyout_ref THEN
        readyout_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in readyout: Expected " & to_hex(readyout_ref) & (" Actual " & to_hex(readyout))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS readyout_checker;

  update_drift_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for update_drift_expected
  update_drift_expected_fileread: PROCESS (update_drift_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "update_drift_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    update_drift_expected <= read_data;
  END PROCESS update_drift_expected_fileread;

  update_drift_ref <= update_drift_expected;

  update_drift_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      update_drift_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND update_drift /= update_drift_ref THEN
        update_drift_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in update_drift: Expected " & to_hex(update_drift_ref) & (" Actual " & to_hex(update_drift))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS update_drift_checker;

  readycal_addr_delay_1 <= calbin_addr AFTER 1 ns;

  -- Data source for readycal_expected
  readycal_expected_fileread: PROCESS (readycal_addr_delay_1, tb_enb, ce_out)
    FILE fp: TEXT open READ_MODE is "readycal_expected.dat";
    VARIABLE l: LINE;
    VARIABLE read_data: std_logic;

  BEGIN
    IF tb_enb /= '1' THEN
    ELSIF ce_out = '1' AND NOT ENDFILE(fp) THEN
      READLINE(fp, l);
      READ(l, read_data);
    END IF;
    readycal_expected <= read_data;
  END PROCESS readycal_expected_fileread;

  readycal_ref <= readycal_expected;

  readycal_checker: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      readycal_testFailure <= '0';
    ELSIF clk'event AND clk = '1' THEN
      IF ce_out = '1' AND readycal /= readycal_ref THEN
        readycal_testFailure <= '1';
        ASSERT FALSE
          REPORT "Error in readycal: Expected " & to_hex(readycal_ref) & (" Actual " & to_hex(readycal))
          SEVERITY ERROR;
      END IF;
    END IF;
  END PROCESS readycal_checker;

  testFailure <= readycal_testFailure OR (update_drift_testFailure OR (readyout_testFailure OR (tick_out_testFailure OR (kar_out_testFailure OR (phase_cor_im_testFailure OR (calbin_testFailure OR phase_cor_re_testFailure))))));

  completed_msg: PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF snkDone = '1' THEN
        IF testFailure = '0' THEN
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (PASSED)**************"
            SEVERITY NOTE;
        ELSE
          ASSERT FALSE
            REPORT "**************TEST COMPLETED (FAILED)**************"
            SEVERITY NOTE;
        END IF;
      END IF;
    END IF;
  END PROCESS completed_msg;

END rtl;

