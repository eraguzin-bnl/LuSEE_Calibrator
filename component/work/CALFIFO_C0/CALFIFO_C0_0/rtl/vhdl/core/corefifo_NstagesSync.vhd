-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
--  Copyright 2011 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: doubleSync.v
--               
--
--
-- Revision Information:
-- Date     Description
--
-- SVN Revision Information:
-- SVN $Revision: 4805 $
-- SVN $Date: 2012-06-21 17:48:48 +0530 (Thu, 21 Jun 2012) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes:
--
-- ********************************************************************/
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_misc.all;

ENTITY CALFIFO_C0_CALFIFO_C0_0_corefifo_NstagesSync IS 
   GENERIC (
      -- --------------------------------------------------------------------------
      -- PARAMETER Declaration
      -- --------------------------------------------------------------------------
       NUM_STAGES  : integer := 2;    
      ADDRWIDTH    :  integer := 3);    
   PORT (
      clk                     : IN std_logic;   
      --rstn                    : IN std_logic; --commented in v3.0  
      arstn                    : IN std_logic;  --added in v3.0
      srstn                    : IN std_logic;  --added in v3.0 
-- --------------------------------------------------------------------------
-- I/O Declaration
-- --------------------------------------------------------------------------
----------
-- Inputs
----------

      inp                     : IN std_logic_vector(ADDRWIDTH DOWNTO 0);   
----------
-- Outputs
----------

      sync_out                : OUT std_logic_vector(ADDRWIDTH DOWNTO 0));   
END ENTITY CALFIFO_C0_CALFIFO_C0_0_corefifo_NstagesSync;

ARCHITECTURE translated OF CALFIFO_C0_CALFIFO_C0_0_corefifo_NstagesSync IS
type mem_array_type is array (NUM_STAGES - 1 downto 0) of std_logic_vector(ADDRWIDTH  downto 0);
	 
	 
	signal shift_reg : std_logic_vector(ADDRWIDTH DOWNTO 0); 
	signal shift_mem_reg : mem_array_type; 
attribute syn_preserve : boolean;	
attribute syn_preserve of shift_reg : signal is true;
 

begin
process(clk, arstn)
begin
    if( not arstn = '1') then
        shift_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
	  if (not srstn = '1') then
		 shift_reg <= (others => '0');   	
       -- sync_out <= (others => '0');
	  else
         shift_reg <= inp;
       -- sync_out <= shift_reg(NUM_STAGES - 1);
      end if;
    end if;
end process;

 shift_mem_reg(0) <= shift_reg;
 
process(clk, arstn)
begin
    if( not arstn = '1') then
        shift_mem_reg(NUM_STAGES - 1 downto 1)  <= (others => (others => '0'));
    elsif (clk'event and clk = '1') then
	  if (not srstn = '1') then
		 shift_mem_reg(NUM_STAGES - 1 downto 1)  <= (others => (others => '0'));   	
       -- sync_out <= (others => '0');
	  else
         shift_mem_reg(NUM_STAGES - 1 downto 1) <= shift_mem_reg(NUM_STAGES - 2 downto 0);
       -- sync_out <= shift_reg(NUM_STAGES - 1);
      end if;
    end if;
end process;

sync_out <= shift_mem_reg(NUM_STAGES - 1);
  
END ARCHITECTURE translated;
