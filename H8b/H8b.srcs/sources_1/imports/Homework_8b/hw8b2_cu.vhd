--------------------------------------------------------------------
-- Name:	
-- Date:	
-- File:	hw8b2_cu.vhdl
-- HW:	    hw8b2
-- Crs:	    ECE 383
--
-- Purp:	testing writing and reading from BRAM
--
-- Documentation:	
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hw8b2_cu is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			cw: out STD_LOGIC_VECTOR(3 downto 0);
			sw: in STD_LOGIC;
			Ready: in std_logic);
end hw8b2_cu;

architecture behavior of hw8b2_cu is

	type state_type is (initC, cmp, wait1, wait2, store, read, inc, end_state);
	signal state: state_type;
	
begin
	
    state_process: process(clk)
	 begin
		if (rising_edge(clk)) then
			if (reset = '0') then 
				state <= initC;
			else
				case state is
					when initC =>
                        state <= cmp;
					when cmp =>
                        if (sw = '0') then -- (sw')
                            state <= wait1;
                        else -- (sw)
                            state <= end_state;
                        end if;
					when wait1 =>
					    if (Ready = '1') then -- (ready)
                            state <= store;
                        end if; -- (ready' does not change state)
					when wait2 =>
                        if (Ready = '0') then -- (ready')
                            state <= inc;
                        end if; -- (ready does not change state)
					when store =>
                        state <= read;
					when read =>
					    state <= wait2;
					when inc =>
					    state <= cmp;
					when end_state =>
					    state <= end_state;								
				end case;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------------
	--			OUTPUT EQUATIONS
	--	
	--		bits 3          bit 2			bit 1,0					             
	--		DataOut			WriteBRAM       Loop Counter		    
	--		0 - hold  		0 - hold        00 hold	        	    
	--		1 - load		1 - write    	01 count up				
	--		  		                        11 reset			    
	------------------------------------------------------------------------------	
	cw <= "0011" when state = initC else
	      "0100" when state = store else
	      "1000" when state = read  else
	      "0001" when state = inc   else
	      "0000"; --  state = cmp, wait1, wait2, end_state


	
end behavior;	