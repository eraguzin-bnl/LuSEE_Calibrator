library ieee;
use ieee.std_logic_1164.all;
use iEEE.std_logIC_ARITH.all;
use IEEE.STD_LOgic_unsigned.all;
entity division is
generic (g_architecture: integer range 0 to 1 := 0;
G_NUM_BITS: integer range 8 to 64 := 18;
G_DEN_BITS: integer range 8 to 64 := 18;
G_LATENCY_FACTOR: integer := 1); port (reset_i: in std_logic;
sys_clk_i: in STD_LOGIC;
NUM_I: in std_logic_vector(G_NUM_BITS-1 downto 0);
DEN_I: in STD_LOGIC_vector(g_den_bits-1 downto 0);
start_i: in STD_LOGIC;
done_o: out STD_LOGIC;
Q_O: out STD_logic_vector(g_num_bits-1 downto 0);
r_o: out STD_LOGIC_VECTOR(G_DEN_BITS-1 downto 0));
end DIVISION;

architecture DIVision of division is

component DIVISION_SEQ
generic (o: integer := 16;
L: INTEGER := 8;
GRAIn: INTEger := 1);
port (RESET_I: in STD_LOGIC;
sys_clk_i: in std_logic;
NUM_I: in std_logic_vector(O-1 downto 0);
dEN_I: in STD_LOGIc_vector(l-1 downto 0);
start_i: in std_logic;
DONE_O: out std_loGIC;
q_o: out std_loGIC_VECTOR(O-1 downto 0);
r_o: out std_lOGIC_VECTOR(l-1 downto 0));
end component;

component DIVISION_PIPE
generic (O: INTEGER := 16;
l: integer := 8;
I: INTEGER := 1);
port (RESET_I: in STD_LOGIC;
sys_clk_i: in STD_Logic;
NUM_i: in std_logic_veCTOR(O-1 downto 0);
DEN_I: in std_logic_vector(l-1 downto 0);
q_o: out std_logiC_VECTOR(o-1 downto 0);
R_O: out std_logic_vector(l-1 downto 0));
end component;

begin
OL:
if G_ARCHITECTURE = 0
generate
ll: DIVision_seq
generic map (o => G_NUM_BITS,
L => G_DEn_bits,
grain => G_LATENCY_FACTOR)
port map (reset_i => RESET_I,
sys_clk_i => SYS_CLK_I,
NUM_I => NUM_I,
DEN_I => DEN_I,
START_I => start_i,
done_o => done_o,
q_o => Q_O,
r_o => r_o);
end generate;
il:
if G_ARCHITECTURE = 1
generate
DONE_O <= '0';
oi: division_pipe
generic map (o => G_NUM_BITS,
L => g_den_bits,
i => G_LATENCY_FACTOR)
port map (reset_I => RESET_I,
SYS_CLK_i => SYS_CLK_I,
NUM_I => NUM_i,
DEN_I => den_i,
q_o => q_o,
r_o => r_o);
end generate;
end divisION;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;
entity division_seq is
generic (O: intEGER := 16;
L: INTEGER := 8;
GRAIN: integer := 1); port (reset_i: in std_logic;
SYS_CLK_I: in STD_LOGIC;
num_i: in STD_LOGIC_VECTOR(o-1 downto 0);
DEN_I: in std_logiC_VECTOR(L-1 downto 0);
start_i: in STd_logic;
DONE_O: out std_logic;
Q_O: out std_logic_vector(O-1 downto 0);
r_o: out STD_LOGIC_VECTOR(L-1 downto 0));
end division_SEQ;

architecture division_seq of DIVISION_SEQ is

component COND_ADD_DIV
generic (l: inTEGER := 8);
port (A_I: in std_logic_vecTOR(L-1 downto 0);
B_I: in std_logic_vector(L-1 downto 0);
ADD_I: in std_logic;
out_o: out STD_LOGIC_VECTOR(L-1 downto 0));
end component;

component ADD_SUB_DIV is
generic (l: integer := 8);
port (A_I: in std_logic_vector(L downto 0);
B_I: in std_logic_vector(L downto 0);
add_sub_i: in STD_LOGIC;
OUT_O: out STD_LOGIC_vector(l downto 0));
end component;

constant LI: STD_LOGIC_VECTOR(L-1 downto 0) := ( others => '0');

type ii is (O0,L0,i0);

signal o1: ii;

type L1 is array (0 to grain) of STD_logic_vector(l downto 0);

signal I1: L1;

signal ool: l1;

signal Lol: STD_LOGIC_VECTOR(Grain downto 0);

signal IOl: integer range 0 to o+1;

signal oll: std_logic;

signal lll: std_logic;

signal ILL: std_logic_vector(L downto 0);

signal oIL: std_logic_vector(L downto 0);

signal LIL: std_logic_vecTOR(l downto 0);

signal IIL: std_logic_vector(l-1 downto 0);

signal o0l: STD_LOGIC_VECTOR(L-1 downto 0);

signal l0l: STd_logic_vector(O-1 downto 0);

signal I0L: std_logic_vecTOR(O-1 downto 0);

begin
i1(0) <= OIL;
lol(grain) <= LLL;
lil <= ool(GRAIN-1);
O1L:
process (sys_cLK_I,reset_i)
begin
if RESEt_i = '0' then
o1 <= O0;
done_o <= '0';
lll <= '0';
oll <= '0';
IOL <= 0;
oil <= ( others => '0');
i0l <= ( others => '0');
L0L <= ( others => '0');
ill <= ( others => '0');
iil <= ( others => '0');
Q_O <= ( others => '0');
r_o <= ( others => '0');
elsif rising_edge(sys_clk_i) then
case O1 is
when O0 =>
dONE_O <= '0';
IOL <= 0;
if START_I = '1' then
OIL <= li&NUM_I(o-1);
i0l <= NUM_I;
ill <= '0'&den_I;
LLL <= '0';
o1 <= L0;
end if;
when l0 =>
iol <= iol+1;
OIL <= LIl(l-1 downto 0)&i0l(O-1-GRAIN);
L0L <= l0l(o-1-grain downto 0)&LOL(GRAIN-1 downto 0);
i0L <= i0l(o-1-GRAIN downto 0)&I0L(o-1 downto O-grain);
LLL <= lil(L);
if (iOL = O/GRAIN-1) then
iil <= lil(L-1 downto 0);
OLL <= lil(L);
q_o <= not (l0L(O-1-grain downto 0)&LOL(grain-1 downto 0));
O1 <= i0;
end if;
when I0 =>
r_o <= O0L;
DONE_O <= '1';
O1 <= o0;
end case;
end if;
end process;
L1l:
for I1L in 0 to GRAIN-1
generate
ooi: ADD_SUB_DIV
generic map (l => L)
port map (a_i => I1(I1L),
B_I => ill,
ADD_SUB_I => LOL(GRAIN-i1l),
out_o => ool(i1L));
LOL(grain-i1l-1) <= OOL(I1l)(L);
I1(i1l+1) <= OOL(i1l)(L-1 downto 0)&i0l(O-2-I1L);
end generate;
LOI: COND_ADD_DIV
generic map (l => l)
port map (A_I => IIL,
b_i => ILl(l-1 downto 0),
ADD_I => oll,
out_o => o0l);
end divISION_SEQ;

library IEEE;
use IEEE.stD_LOGIC_1164.all;
use ieee.STD_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity DIVISIon_pipe is
generic (o: INTEGer := 16;
l: integer := 8;
i: integer := 1); port (RESET_I: in STD_LOGIC;
Sys_clk_i: in STD_LOGIC;
num_i: in STD_LOGIC_VECTOR(o-1 downto 0);
den_i: in STD_LOGIC_Vector(l-1 downto 0);
q_o: out STD_LOGIC_VECTOR(O-1 downto 0);
R_O: out std_logic_vector(l-1 downto 0));
end DIVISION_Pipe;

architecture DIvision_pipe of DIVISION_PIPE is

component cond_add_DIV is
generic (L: iNTEGER := 8);
port (a_i: in stD_LOGIC_VECTOR(L-1 downto 0);
B_I: in std_logic_vector(l-1 downto 0);
add_i: in STD_LOGIC;
OUT_O: out std_logic_vector(l-1 downto 0));
end component;

component radix4_CELL_DIV is
generic (L: integer := 8);
port (R_I: in std_logic_vector(l downto 0);
Y_I: in std_logic_vector(L downto 0);
y3_i: in std_logic_vECTOR(L+1 downto 0);
X1_I: in std_logic;
x0_I: in std_logic;
n_qneg_o: out std_logiC_VECTOR(1 downto 0);
new_r_o: out STD_LOGIC_VECTor(l downto 0));
end component;

signal iOI: std_logic_vector(l-1 downto 0);

type oli is array (0 to o/2-1) of STD_LOGIC_VECTOR(l downto 0);

signal lli: oli;

signal ILI: OLI;

signal ill: oli;

type oii is array (0 to o/2-1) of STD_LOGIC_VECTOR(L+1 downto 0);

signal lii: oii;

type III is array (0 to O/2-1) of STD_logic_vector(O-1 downto 0);

signal o0i: Iii;

signal l0i: III;

begin
lli(0) <= ( others => '0');
i0i:
process (SYS_CLK_I,reSET_I)
begin
if reset_i = '0' then
ill(0) <= ( others => '0');
LII(0) <= ( others => '0');
O0I(0) <= ( others => '0');
Q_O <= ( others => '0');
r_o <= ( others => '0');
elsif rising_edgE(sys_clk_i) then
ILL(0) <= ('0'&den_i);
LII(0) <= ('0'&den_I)+('0'&DEN_I&'0');
o0i(0) <= num_i;
Q_O <= not L0I(o/2-1);
R_O <= ioi;
end if;
end process;
O1i:
for i1l in 0 to o/2-2
generate
l1i:
if (i1l+1) mod i /= 0
generate
LLI(I1l+1) <= ILi(I1L);
ill(i1L+1) <= ill(i1l);
LII(I1l+1) <= lii(I1L);
o0i(I1L+1) <= o0i(i1l);
L0I(i1l+1)(o-1 downto o-2-I1L*2) <= L0I(I1L)(o-1 downto o-2-i1l*2);
end generate;
i1i:
if (I1L+1) mod I = 0
generate
OO0:
process (syS_CLK_I,reset_i)
begin
if RESET_I = '0' then
lli(i1l+1) <= ( others => '0');
ILL(i1l+1) <= ( others => '0');
LII(I1L+1) <= ( others => '0');
o0i(i1l+1) <= ( others => '0');
L0I(i1l+1)(o-1 downto o-2-I1L*2) <= ( others => '0');
elsif rising_edge(Sys_clk_i) then
LLI(i1l+1) <= ILI(i1l);
ill(I1L+1) <= ILL(I1L);
LII(i1l+1) <= lii(I1L);
O0I(i1l+1) <= O0I(i1l);
l0I(I1l+1)(O-1 downto o-2-i1l*2) <= l0i(I1L)(o-1 downto O-2-I1L*2);
end if;
end process;
end generate;
end generate;
LO0:
for I1L in 0 to O/2-1
generate
io0: radix4_cell_div
generic map (L => L)
port map (r_i => lli(I1L),
Y_I => ILL(i1l),
y3_i => LIi(I1l),
x1_i => o0i(i1L)(o-1-I1L*2),
X0_I => o0i(I1l)(O-2-i1L*2),
N_QNEG_O => L0I(I1L)(O-1-i1l*2 downto o-2-I1l*2),
NEW_R_O => ILI(i1l));
end generate;
loi: COND_ADD_DIv
generic map (L => L)
port map (a_i => ILI(O/2-1)(l-1 downto 0),
B_i => ILl(O/2-1)(L-1 downto 0),
add_i => ili(O/2-1)(L),
out_o => IOI);
end division_pipe;

library IEEE;
use IEEE.std_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIgned.all;
entity ADD_SUB_DIV is
generic (L: INTEGER := 8); port (A_I: in std_logic_vector(l downto 0);
B_I: in STD_LOGIC_vector(L downto 0);
add_sub_i: in STD_LOGIC;
out_O: out STD_LOGIC_vector(l downto 0));
end ADD_SUB_DIV;

architecture ADD_sub_div of ADD_SUB_DIV is

begin
OL0:
process (aDD_SUB_I,a_i,b_I)
begin
if add_sub_i = '1' then
out_o <= A_i+b_i;
else
out_o <= A_I-b_i;
end if;
end process;
end ADD_Sub_div;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.STD_LOGIC_unsigned.all;
entity COND_ADD_DIV is
generic (L: INTEGER := 8); port (A_I: in std_logic_vector(L-1 downto 0);
B_I: in STD_logic_vector(l-1 downto 0);
add_i: in STd_logic;
OUT_O: out STD_LOgic_vector(l-1 downto 0));
end COND_ADD_DIV;

architecture cond_add_div of COND_ADD_DIV is

begin
ll0:
process (add_i,A_I,b_i)
begin
if ADD_I = '1' then
ouT_O <= a_i+b_i;
else
OUT_O <= a_i;
end if;
end process;
end COND_add_div;

library ieee;
use IEEe.STD_LOGIC_1164.all;
use ieee.STd_logic_arith.all;
use ieee.STd_logic_unsigned.all;
entity RADIX4_CELL_div is
generic (L: INteger := 8); port (R_I: in std_logiC_VECTOR(l downto 0);
Y_I: in std_logic_vector(L downto 0);
y3_i: in STD_LOGIC_VECTOR(l+1 downto 0);
X1_I: in STD_LOGIC;
x0_i: in sTD_LOGIC;
N_QNEG_O: out STD_LOgic_vector(1 downto 0);
NEW_R_O: out STD_LOGIC_Vector(l downto 0));
end radix4_cell_div;

architecture radix4_cell_div of RADIX4_cell_div is

signal il0: std_logic_vector(l+1 downto 0);

signal oi0: STD_LOGIC_VECTOR(l+1 downto 0);

signal LI0: std_logic_vector(L+1 downto 0);

signal ii0: std_logiC_VECTOR(l+1 downto 0);

signal O00: STD_LOGIC;

begin
o00 <= r_i(l);
il0 <= r_i(L-1 downto 0)&X1_I&x0_i;
OI0 <= (R_i&x1_i)+(Y_I) when O00 = '1' else
(O00&y_i)+not (r_i&x1_i);
II0 <= (il0+Y3_I) when o00 = '1' else
(IL0)-(y3_i);
li0 <= (IL0+Y_I) when O00 = '1' else
(il0)-(o00&y_i);
L00:
process (OI0,li0,II0)
begin
if (oI0(L) = '1') then
new_r_o <= II0(l downto 0);
N_QNEG_O(0) <= II0(L);
else
NEW_R_O <= li0(L downto 0);
N_Qneg_o(0) <= LI0(l);
end if;
end process;
I00:
process (O00,oi0)
begin
if (o00 = '1') then
n_qneg_o(1) <= oi0(l);
else
N_QNEG_O(1) <= not oi0(l);
end if;
end process;
end radix4_cell_div;
