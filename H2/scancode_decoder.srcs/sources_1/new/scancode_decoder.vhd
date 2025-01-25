--+----------------------------------------------------------------------------
--| 
--| 2025 United States Air Force Academy
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--+----------------------------------------------------------------------------
--|
--| FILENAME      : scancode_decoder.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-06
--| DESCRIPTION   : This file implements a scancode decoder.
--                  Converts scancode, representing a keypress of a decimal digit, into its 4-bit 
--                  value. For example, if scancode = 2516, the scancode for the character "4", 
--                  then the converter should output decoded_value = 0100_2. Assume that the 
--                  inputs are always legal hexadecimal scancodes.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENTIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scancode_decoder is
    Port ( i_scancode : in STD_LOGIC_VECTOR (7 downto 0);
           o_decoded_value : out STD_LOGIC_VECTOR (3 downto 0));
end scancode_decoder;

architecture scancode_decoder_arch of scancode_decoder is

begin
    o_decoded_value <= "0000" when i_scancode = x"45" else
                       "0001" when i_scancode = x"16" else
                       "0010" when i_scancode = x"1E" else
                       "0011" when i_scancode = x"26" else
                       "0100" when i_scancode = x"25" else
                       "0101" when i_scancode = x"2E" else
                       "0110" when i_scancode = x"36" else
                       "0111" when i_scancode = x"3D" else
                       "1000" when i_scancode = x"3E" else
                       "1001" when i_scancode = x"46" else
                       "1111"; -- Default or invalid scancode

end scancode_decoder_arch;
