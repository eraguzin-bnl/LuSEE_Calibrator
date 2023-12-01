----------------------------------------------------------------------
-- Created by SmartDesign Fri Dec  1 16:07:56 2023
-- Version: 2022.3 2022.3.0.8
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Component Description (Tcl) 
----------------------------------------------------------------------
--# Exporting Component Description of CALFIFO_C0 to TCL
--# Family: PolarFire
--# Part Number: MPF300TS-1FCG1152I
--# Create and Configure the core component CALFIFO_C0
--create_and_configure_core -core_vlnv {Actel:DirectCore:COREFIFO:3.0.101} -component_name {CALFIFO_C0} -params {\
--"AE_STATIC_EN:false"  \
--"AEVAL:4"  \
--"AF_STATIC_EN:false"  \
--"AFVAL:60"  \
--"CTRL_TYPE:3"  \
--"DIE_SIZE:15"  \
--"ECC:0"  \
--"ESTOP:true"  \
--"FSTOP:true"  \
--"FWFT:false"  \
--"NUM_STAGES:2"  \
--"OVERFLOW_EN:false"  \
--"PIPE:2"  \
--"PREFETCH:false"  \
--"RAM_OPT:0"  \
--"RDCNT_EN:false"  \
--"RDEPTH:512"  \
--"RE_POLARITY:0"  \
--"READ_DVALID:false"  \
--"RWIDTH:12"  \
--"SYNC:1"  \
--"SYNC_RESET:1"  \
--"UNDERFLOW_EN:false"  \
--"WDEPTH:512"  \
--"WE_POLARITY:0"  \
--"WRCNT_EN:false"  \
--"WRITE_ACK:false"  \
--"WWIDTH:12"   }
--# Exporting Component Description of CALFIFO_C0 to TCL done

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library polarfire;
use polarfire.all;
library COREFIFO_LIB;
use COREFIFO_LIB.all;
----------------------------------------------------------------------
-- CALFIFO_C0 entity declaration
----------------------------------------------------------------------
entity CALFIFO_C0 is
    -- Port list
    port(
        -- Inputs
        CLK     : in  std_logic;
        DATA    : in  std_logic_vector(11 downto 0);
        RE      : in  std_logic;
        RESET_N : in  std_logic;
        WE      : in  std_logic;
        -- Outputs
        EMPTY   : out std_logic;
        FULL    : out std_logic;
        Q       : out std_logic_vector(11 downto 0)
        );
end CALFIFO_C0;
----------------------------------------------------------------------
-- CALFIFO_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CALFIFO_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CALFIFO_C0_CALFIFO_C0_0_COREFIFO   -   Actel:DirectCore:COREFIFO:3.0.101
component CALFIFO_C0_CALFIFO_C0_0_COREFIFO
    generic( 
        AE_STATIC_EN : integer := 0 ;
        AEVAL        : integer := 4 ;
        AF_STATIC_EN : integer := 0 ;
        AFVAL        : integer := 60 ;
        CTRL_TYPE    : integer := 3 ;
        DIE_SIZE     : integer := 15 ;
        ECC          : integer := 0 ;
        ESTOP        : integer := 1 ;
        FAMILY       : integer := 26 ;
        FSTOP        : integer := 1 ;
        FWFT         : integer := 0 ;
        NUM_STAGES   : integer := 2 ;
        OVERFLOW_EN  : integer := 0 ;
        PIPE         : integer := 2 ;
        PREFETCH     : integer := 0 ;
        RAM_OPT      : integer := 0 ;
        RDCNT_EN     : integer := 0 ;
        RDEPTH       : integer := 512 ;
        RE_POLARITY  : integer := 0 ;
        READ_DVALID  : integer := 0 ;
        RWIDTH       : integer := 12 ;
        SYNC         : integer := 1 ;
        SYNC_RESET   : integer := 1 ;
        UNDERFLOW_EN : integer := 0 ;
        WDEPTH       : integer := 512 ;
        WE_POLARITY  : integer := 0 ;
        WRCNT_EN     : integer := 0 ;
        WRITE_ACK    : integer := 0 ;
        WWIDTH       : integer := 12 
        );
    -- Port list
    port(
        -- Inputs
        CLK        : in  std_logic;
        DATA       : in  std_logic_vector(11 downto 0);
        MEMRD      : in  std_logic_vector(11 downto 0);
        RCLOCK     : in  std_logic;
        RE         : in  std_logic;
        RESET_N    : in  std_logic;
        RRESET_N   : in  std_logic;
        WCLOCK     : in  std_logic;
        WE         : in  std_logic;
        WRESET_N   : in  std_logic;
        -- Outputs
        AEMPTY     : out std_logic;
        AFULL      : out std_logic;
        DB_DETECT  : out std_logic;
        DVLD       : out std_logic;
        EMPTY      : out std_logic;
        FULL       : out std_logic;
        MEMRADDR   : out std_logic_vector(8 downto 0);
        MEMRE      : out std_logic;
        MEMWADDR   : out std_logic_vector(8 downto 0);
        MEMWD      : out std_logic_vector(11 downto 0);
        MEMWE      : out std_logic;
        OVERFLOW   : out std_logic;
        Q          : out std_logic_vector(11 downto 0);
        RDCNT      : out std_logic_vector(9 downto 0);
        SB_CORRECT : out std_logic;
        UNDERFLOW  : out std_logic;
        WACK       : out std_logic;
        WRCNT      : out std_logic_vector(9 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal EMPTY_net_0 : std_logic;
signal FULL_net_0  : std_logic;
signal Q_net_0     : std_logic_vector(11 downto 0);
signal FULL_net_1  : std_logic;
signal EMPTY_net_1 : std_logic;
signal Q_net_1     : std_logic_vector(11 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net     : std_logic;
signal MEMRD_const_net_0: std_logic_vector(11 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net           <= '0';
 MEMRD_const_net_0 <= B"000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 FULL_net_1     <= FULL_net_0;
 FULL           <= FULL_net_1;
 EMPTY_net_1    <= EMPTY_net_0;
 EMPTY          <= EMPTY_net_1;
 Q_net_1        <= Q_net_0;
 Q(11 downto 0) <= Q_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CALFIFO_C0_0   -   Actel:DirectCore:COREFIFO:3.0.101
CALFIFO_C0_0 : CALFIFO_C0_CALFIFO_C0_0_COREFIFO
    generic map( 
        AE_STATIC_EN => ( 0 ),
        AEVAL        => ( 4 ),
        AF_STATIC_EN => ( 0 ),
        AFVAL        => ( 60 ),
        CTRL_TYPE    => ( 3 ),
        DIE_SIZE     => ( 15 ),
        ECC          => ( 0 ),
        ESTOP        => ( 1 ),
        FAMILY       => ( 26 ),
        FSTOP        => ( 1 ),
        FWFT         => ( 0 ),
        NUM_STAGES   => ( 2 ),
        OVERFLOW_EN  => ( 0 ),
        PIPE         => ( 2 ),
        PREFETCH     => ( 0 ),
        RAM_OPT      => ( 0 ),
        RDCNT_EN     => ( 0 ),
        RDEPTH       => ( 512 ),
        RE_POLARITY  => ( 0 ),
        READ_DVALID  => ( 0 ),
        RWIDTH       => ( 12 ),
        SYNC         => ( 1 ),
        SYNC_RESET   => ( 1 ),
        UNDERFLOW_EN => ( 0 ),
        WDEPTH       => ( 512 ),
        WE_POLARITY  => ( 0 ),
        WRCNT_EN     => ( 0 ),
        WRITE_ACK    => ( 0 ),
        WWIDTH       => ( 12 )
        )
    port map( 
        -- Inputs
        CLK        => CLK,
        WCLOCK     => GND_net, -- tied to '0' from definition
        RCLOCK     => GND_net, -- tied to '0' from definition
        RESET_N    => RESET_N,
        WRESET_N   => GND_net, -- tied to '0' from definition
        RRESET_N   => GND_net, -- tied to '0' from definition
        WE         => WE,
        RE         => RE,
        DATA       => DATA,
        MEMRD      => MEMRD_const_net_0, -- tied to X"0" from definition
        -- Outputs
        FULL       => FULL_net_0,
        EMPTY      => EMPTY_net_0,
        AFULL      => OPEN,
        AEMPTY     => OPEN,
        OVERFLOW   => OPEN,
        UNDERFLOW  => OPEN,
        WACK       => OPEN,
        DVLD       => OPEN,
        MEMWE      => OPEN,
        MEMRE      => OPEN,
        SB_CORRECT => OPEN,
        DB_DETECT  => OPEN,
        Q          => Q_net_0,
        WRCNT      => OPEN,
        RDCNT      => OPEN,
        MEMWADDR   => OPEN,
        MEMRADDR   => OPEN,
        MEMWD      => OPEN 
        );

end RTL;
