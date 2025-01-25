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
--| DESCRIPTION   : This file implements a scancode decoder test bench.
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
--|    Files     : scancode_decoder.vhd
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

entity scancode_decoder_tb is
end scancode_decoder_tb;

architecture behavior of scancode_decoder_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component scancode_decoder
        Port (
            i_scancode : in STD_LOGIC_VECTOR (7 downto 0);
            o_decoded_value : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal i_scancode : STD_LOGIC_VECTOR (7 downto 0);
    signal o_decoded_value : STD_LOGIC_VECTOR (3 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: scancode_decoder
        Port map (
            i_scancode => i_scancode,
            o_decoded_value => o_decoded_value
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test scancode for "0"
        i_scancode <= x"45";
        wait for 10 ns;
        assert o_decoded_value = "0000" report "Test failed for scancode 45 (0)" severity error;

        -- Test scancode for "1"
        i_scancode <= x"16";
        wait for 10 ns;
        assert o_decoded_value = "0001" report "Test failed for scancode 16 (1)" severity error;

        -- Test scancode for "2"
        i_scancode <= x"1E";
        wait for 10 ns;
        assert o_decoded_value = "0010" report "Test failed for scancode 1E (2)" severity error;

        -- Test scancode for "3"
        i_scancode <= x"26";
        wait for 10 ns;
        assert o_decoded_value = "0011" report "Test failed for scancode 26 (3)" severity error;

        -- Test scancode for "4"
        i_scancode <= x"25";
        wait for 10 ns;
        assert o_decoded_value = "0100" report "Test failed for scancode 25 (4)" severity error;

        -- Test scancode for "5"
        i_scancode <= x"2E";
        wait for 10 ns;
        assert o_decoded_value = "0101" report "Test failed for scancode 2E (5)" severity error;

        -- Test scancode for "6"
        i_scancode <= x"36";
        wait for 10 ns;
        assert o_decoded_value = "0110" report "Test failed for scancode 36 (6)" severity error;

        -- Test scancode for "7"
        i_scancode <= x"3D";
        wait for 10 ns;
        assert o_decoded_value = "0111" report "Test failed for scancode 3D (7)" severity error;

        -- Test scancode for "8"
        i_scancode <= x"3E";
        wait for 10 ns;
        assert o_decoded_value = "1000" report "Test failed for scancode 3E (8)" severity error;

        -- Test scancode for "9"
        i_scancode <= x"46";
        wait for 10 ns;
        assert o_decoded_value = "1001" report "Test failed for scancode 46 (9)" severity error;

        -- End of tests
        wait;
    end process;

end behavior;
