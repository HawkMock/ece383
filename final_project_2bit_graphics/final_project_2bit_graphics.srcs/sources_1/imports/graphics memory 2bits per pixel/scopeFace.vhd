----------------------------------------------------------------------------------
-- Name:	George York
-- Date:	Spring 2020
-- File: scopeFace.vhd
-- HW:	Lab 1 
-- Pupr:	Scope Face component entity description for Lab 1.  This component sweeps
--			acrossthe display from left to right, and then return to the left side of 
--			the next lower row. The VGA interface determines the color of each pixel
--			on this journey with the help of the scopeFace component.
-- Doc:	Adapted from Dr Coulston's Lab exercise
-- 	


--		Total scope display is 640x480

--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scopeFace is
    Port ( row : in  unsigned (9 downto 0);
           column : in  unsigned (9 downto 0);
           r : out  std_logic_vector(7 downto 0);
           g : out  std_logic_vector(7 downto 0);
           b : out  std_logic_vector(7 downto 0);
           ch1 : in  STD_LOGIC;
           ch1_enb : in  STD_LOGIC;
           ch2 : in  STD_LOGIC;
           ch2_enb : in  STD_LOGIC);
end scopeFace;

architecture Behavioral of scopeFace is



begin

    r <= "11111111" when ((ch2 = '0') and (ch1 = '1')) else "00000000";
    g <= "11111111" when ((ch2 = '1') and (ch1 = '0')) else "00000000";
    b <= "11111111" when ((ch2 = '1') and (ch1 = '1')) else "00000000";

end Behavioral;

