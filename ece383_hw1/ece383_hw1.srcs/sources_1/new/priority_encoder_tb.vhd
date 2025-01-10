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
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : priority_encoder.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-06
--| DESCRIPTION   : This file tests a priority encoder. It should output (in binary
--|                 the index of the leftmost '1' bit of the input.
--|
--| DOCUMENTATION : Used ChatGPT to generate test bench.
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
--| NAMING CONVENSIONS :
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

entity priority_encoder_tb is
--  Port ( );
end priority_encoder_tb;

architecture test_bench of priority_encoder_tb is

    -- Declare the component of the module under test
    component priority_encoder is
        Port ( i_input : in STD_LOGIC_VECTOR (3 downto 0);
               o_output : out STD_LOGIC_VECTOR (1 downto 0));
    end component;

    -- Declare signals to connect to the module under test
    signal tb_i_input : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal tb_o_output : STD_LOGIC_VECTOR(1 downto 0);

begin

    -- Instantiate the module under test (MUT)
    uut: priority_encoder
        port map (
            i_input => tb_i_input,
            o_output => tb_o_output
        );

    -- Test process to apply stimulus
    test_process: process
    begin
        -- Test case 1: i_input = "0000" -> Don't care about output (commented out)
        tb_i_input <= "0000"; wait for 10 ns;
--        assert tb_o_output = "00" report "Test case 1 failed" severity error;

        -- Test case 2: i_input = "0001" -> Expect o_output = "00"
        tb_i_input <= "0001"; wait for 10 ns;
        assert tb_o_output = "00" report "Test case 2 failed" severity error;

        -- Test case 3: i_input = "0010" -> Expect o_output = "01"
        tb_i_input <= "0010"; wait for 10 ns;
        assert tb_o_output = "01" report "Test case 3 failed" severity error;

        -- Test case 4: i_input = "0011" -> Expect o_output = "01"
        tb_i_input <= "0011"; wait for 10 ns;
        assert tb_o_output = "01" report "Test case 4 failed" severity error;

        -- Test case 5: i_input = "0100" -> Expect o_output = "10"
        tb_i_input <= "0100"; wait for 10 ns;
        assert tb_o_output = "10" report "Test case 5 failed" severity error;

        -- Test case 6: i_input = "0101" -> Expect o_output = "10"
        tb_i_input <= "0101"; wait for 10 ns;
        assert tb_o_output = "10" report "Test case 6 failed" severity error;

        -- Test case 7: i_input = "0110" -> Expect o_output = "10"
        tb_i_input <= "0110"; wait for 10 ns;
        assert tb_o_output = "10" report "Test case 7 failed" severity error;

        -- Test case 8: i_input = "0111" -> Expect o_output = "10"
        tb_i_input <= "0111"; wait for 10 ns;
        assert tb_o_output = "10" report "Test case 8 failed" severity error;

        -- Test case 9: i_input = "1000" -> Expect o_output = "11"
        tb_i_input <= "1000"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 9 failed" severity error;

        -- Test case 10: i_input = "1001" -> Expect o_output = "11"
        tb_i_input <= "1001"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 10 failed" severity error;

        -- Test case 11: i_input = "1010" -> Expect o_output = "11"
        tb_i_input <= "1010"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 11 failed" severity error;

        -- Test case 12: i_input = "1011" -> Expect o_output = "11"
        tb_i_input <= "1011"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 12 failed" severity error;

        -- Test case 13: i_input = "1100" -> Expect o_output = "11"
        tb_i_input <= "1100"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 13 failed" severity error;

        -- Test case 14: i_input = "1101" -> Expect o_output = "11"
        tb_i_input <= "1101"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 14 failed" severity error;

        -- Test case 15: i_input = "1110" -> Expect o_output = "11"
        tb_i_input <= "1110"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 15 failed" severity error;

        -- Test case 16: i_input = "1111" -> Expect o_output = "11"
        tb_i_input <= "1111"; wait for 10 ns;
        assert tb_o_output = "11" report "Test case 16 failed" severity error;

        wait; -- wait forever after running all tests
    end process;

end test_bench;
