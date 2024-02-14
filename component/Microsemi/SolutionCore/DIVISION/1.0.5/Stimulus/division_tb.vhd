--=================================================================================================
-- File Name                           : division_tb.vhd

-- Description                         : This module implements the test environment for
--                                       the Division block

-- Targeted device                     : Microsemi-SoC
-- Author                              : India Solutions Team
--
-- SVN Revision Information            :
-- SVN $Revision                       :
-- SVN $Date                           :
--
-- COPYRIGHT 2016 BY MICROSEMI
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
--
--=================================================================================================

--=================================================================================================
-- Libraries
--=================================================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

use work.coreparameters.all;

--=================================================================================================
-- division_tb entity declaration
--=================================================================================================
entity testbench is

end testbench;
--=================================================================================================
-- division_tb architecture body
--=================================================================================================
architecture behavioral of testbench is

  component DIVISION
    generic(
      g_ARCHITECTURE   : integer range 0 to 1  := 0;
      g_NUM_BITS       : integer range 8 to 64 := 16;
      g_DEN_BITS       : integer range 8 to 64 := 8;
      g_LATENCY_FACTOR : integer               := 1
      );
    port(
      reset_i   : in  std_logic;
      sys_clk_i : in  std_logic;
      num_i     : in  std_logic_vector (g_NUM_BITS-1 downto 0);
      den_i     : in  std_logic_vector (g_DEN_BITS-1 downto 0);
      start_i   : in  std_logic;        --INITIALIZATION, CAPTURE INPUT DATA
      done_o    : out std_logic;        --FINISH SIGNAL
      q_o       : out std_logic_vector (g_NUM_BITS-1 downto 0);
      r_o       : out std_logic_vector (g_DEN_BITS-1 downto 0)
      );
  end component;
--=================================================================================================
-- Signal declarations
--=================================================================================================
  signal reset_tb         : std_logic                                 := '0';
  signal sys_clk_tb       : std_logic                                 := '0';
  signal start_tb         : std_logic                                 := '0';
  signal done_tb          : std_logic;
  signal num_tb           : std_logic_vector(g_NUM_BITS-1 downto 0)   := (others => '1');
  signal den_tb           : std_logic_vector(g_DEN_BITS-1 downto 0)   := (others => '1');
  signal num_prod         : std_logic_vector(2*g_NUM_BITS-1 downto 0) := (others => '1');
  signal den_prod         : std_logic_vector(2*g_DEN_BITS-1 downto 0) := (others => '1');
  signal num_factor       : std_logic_vector(g_NUM_BITS-1 downto 0);
  signal den_factor       : std_logic_vector(g_DEN_BITS-1 downto 0);
  signal num_step         : std_logic_vector(g_NUM_BITS-1 downto 0);
  signal den_step         : std_logic_vector(g_DEN_BITS-1 downto 0);
  signal q_tb             : std_logic_vector(g_NUM_BITS-1 downto 0);
  signal r_tb             : std_logic_vector(g_DEN_BITS-1 downto 0);
  constant g_ARCHITECTURE : integer                                   := 0;
  constant SYSCLK_PERIOD  : time                                      := 100 ns;
  constant SETUP_TIME     : time                                      := 10 ns;
  signal I                : integer                                   := 0;
  signal J                : integer                                   := 1;
--========================================================
-- File read operations
--========================================================
--NA--
--========================================================
-- File write operations
--========================================================
--NA--
--========================================================
-- Procedure Declarations
--========================================================
begin
--------------------------------------------------------------------------
-- Name       : RESET_GEN_PROC
-- Description: PROCESS generates the reset signal
--------------------------------------------------------------------------
  RESET_GEN_PROC :
  process
    variable vhdl_initial : boolean := true;
  begin
    if (vhdl_initial) then
      reset_tb <= '0';
      wait for (SYSCLK_PERIOD * 10);
      reset_tb <= '1';
      if(g_ARCHITECTURE = 1)then
        report "Testbench for pipeline architecture";
      else
        report "Testbench for sequential architecture";
      end if;
      wait;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : CLOCK_GEN
-- Description: Logic generates 10 Mhz clock
--------------------------------------------------------------------------
  sys_clk_tb <= not sys_clk_tb after (SYSCLK_PERIOD / 2.0);

--------------------------------------------------------------------------
-- Name       : TEST_DATA_GEN_PROC
-- Description: Generates test data for validating division
--------------------------------------------------------------------------
  TEST_DATA_GEN_PROC_SEQ : if g_ARCHITECTURE = 0 generate
    process
    begin
      wait for (SYSCLK_PERIOD);
      for I in 0 to 255 loop
        for J in 1 to 255 loop
          num_prod <= CONV_STD_LOGIC_VECTOR (I, g_NUM_BITS) * num_factor;
          den_prod <= CONV_STD_LOGIC_VECTOR (J, g_DEN_BITS) * den_factor;
          num_tb   <= num_prod(g_NUM_BITS-1 downto 0);
          den_tb   <= den_prod(g_DEN_BITS-1 downto 0);
          start_tb <= '1';
          wait for SYSCLK_PERIOD;
          start_tb <= '0';
          wait for (g_NUM_BITS/g_LATENCY_FACTOR+2)*SYSCLK_PERIOD;
        end loop;
      end loop;
      wait for 3 * SYSCLK_PERIOD;
    end process;
  end generate;

  TEST_DATA_GEN_PROC_PIPE : if g_ARCHITECTURE = 1 generate
    process
    begin
      wait for (SYSCLK_PERIOD);
      for I in 0 to 255 loop
        for J in 1 to 255 loop
          num_prod <= CONV_STD_LOGIC_VECTOR (I, g_NUM_BITS) * num_factor;
          den_prod <= CONV_STD_LOGIC_VECTOR (J, g_DEN_BITS) * den_factor;
          num_tb   <= num_prod(g_NUM_BITS-1 downto 0);
          den_tb   <= den_prod(g_DEN_BITS-1 downto 0);
          start_tb <= '1';
          wait for SYSCLK_PERIOD;
          start_tb <= '0';
        end loop;
      end loop;
      wait for 3 * SYSCLK_PERIOD;
    end process;
  end generate;

  num_step(g_NUM_BITS-1 downto g_NUM_BITS-7) <= (others => '0');
  num_step(g_NUM_BITS-8)                     <= '1';
  num_step(g_NUM_BITS-9 downto 0)            <= (others => '0');
  num_factor                                 <= num_step;

  den_step(g_DEN_BITS-1 downto g_DEN_BITS-7) <= (others => '0');
  den_step(g_DEN_BITS-8)                     <= '1';
  den_step(g_DEN_BITS-9 downto 0)            <= (others => '0');
  den_factor                                 <= den_step;

--=================================================================================================
-- Component Instantiations
--=================================================================================================
-------------------------------------------------
-- DIVISION_SEQ_INST
-------------------------------------------------       
  DIVISION_SEQ_INST : DIVISION
    generic map(
      g_ARCHITECTURE   => g_ARCHITECTURE,
      g_NUM_BITS       => g_NUM_BITS,
      g_DEN_BITS       => g_DEN_BITS,
      g_LATENCY_FACTOR => g_LATENCY_FACTOR
      )
    port map(
      reset_i   => reset_tb,
      sys_clk_i => sys_clk_tb,
      num_i     => num_tb,
      den_i     => den_tb,
      start_i   => start_tb,
      done_o    => done_tb,
      q_o       => q_tb,
      r_o       => r_tb
      );

end behavioral;
