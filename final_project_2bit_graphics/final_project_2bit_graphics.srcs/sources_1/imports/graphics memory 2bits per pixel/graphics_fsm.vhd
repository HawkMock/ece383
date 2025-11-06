----------------------------------------------------------------------------------
-- Name:	George York
-- Date:	Spring 2020
-- File:    graphics_fsm.vhd
-- HW:	    State Machine to test the graphics memory
--          GRAPHIC MEMORY example: 2 bits per pixel, for 640x480 display, using 40 BRAMS
-- Pupr:	need to update!!!!.  
--
-- Doc:	Adapted from Dr Coulston's Lab exercise
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity graphics_fsm is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
		   fsmCol: out std_logic_vector(9 downto 0);
           fsmRow: out std_logic_vector(9 downto 0);
           fsmWen : out std_logic;
           fsmData: out std_logic_vector(15 downto 0));
end graphics_fsm;

architecture Behavioral of graphics_fsm is

	type state_type is (SWAP, DELAY, SET, CLEAR, INCCOL, LASTCOL, INCROW, LASTROW);
	signal state: state_type;
	signal writeCntr: unsigned(15 downto 0);
	signal row, col: unsigned(9 downto 0);
	signal Data: std_logic_vector(15 downto 0);
	signal Wen: std_logic;

begin
    fsmCol <= std_logic_vector(col);
    fsmRow <= std_logic_vector(row);
    fsmData <= Data;
    fsmWen <= Wen;
	-------------------------------------------------------------------------------
	-- Long delay counter
	-------------------------------------------------------------------------------	
	writeCounter: process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				writeCntr <= "0000000000000000";  -- change for graphics memory test
			else 
			    writeCntr <= writeCntr+1;
			end if;
		end if;
	end process;
		
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= SWAP;
				row <= "0000000000";
				col <= "0000000000";
				Data <= "0000000000000000";
				Wen <= '0';
			else 
				case state is
					when SWAP =>
						state <= DELAY;    -- Green Green Black Blue Blue Black Red Black 
						if (Data = "0000000000000000") then Data <= "1010001111000100"; else Data <= "0000000000000000"; end if;	
						row <= "0000000000";	
					when DELAY => 
						if (writeCntr = "0000000000000000") then state <= SET; end if;
					when SET =>
						state <= CLEAR;
						Wen <= '1';
					when CLEAR =>
						state <= INCCOL;
                        Wen <= '0';
                    when INCCOL =>
						state <= LASTCOL;
                        col <= col + 8;			--each word is 8 pixels, or 8 columns		
                    when LASTCOL =>  -- 640 
                        if (col = "1010000000") then state <= INCROW; else state <= DELAY; end if; 
                    when INCROW =>
                            state <= LASTROW;
                            row <= row + 1;
                            col <= "0000000000";                    
                   when LASTROW => -- 480 = "111100000"
                            if (row = "0111100000") then state <= SWAP; else state <= DELAY; end if;
				end case;
			end if;
		end if;
	end process;



end Behavioral;

