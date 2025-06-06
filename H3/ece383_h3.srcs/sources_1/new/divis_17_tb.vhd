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
--| FILENAME      : divis_17.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-14
--| DESCRIPTION   : This file implements a testbench for a component which determines
--|                 if the input is divisible by 17. It does this by checking symmetry
--|                 of the 8 bit input number. It returns 1 if true (divisible) and 0
--|                 if false.
--|
--| DOCUMENTATION : Test bench generated by ChatGPT.
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
use IEEE.NUMERIC_STD.ALL;

entity divis_17_tb is
-- No ports in testbench entity
end divis_17_tb;

architecture test_bench of divis_17_tb is
    signal tb_input      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tb_divisible  : STD_LOGIC;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.divis_17
        port map (
            i_input => tb_input,
            o_divisible => tb_divisible
        );

    -- Test process
    stim_proc: process
    begin
        -- Test numbers under 7
        for i in 0 to 7 loop
            tb_input <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns;
        end loop;
        
        -- Test numbers near 17
        for i in 14 to 20 loop
            tb_input <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns;
        end loop;

        -- Test first five multiples of 17
        for i in 0 to 4 loop
            tb_input <= std_logic_vector(to_unsigned(i * 17, 8));
            wait for 10 ns;
        end loop;

        -- Test the 5 largest 8-bit numbers
        for i in 251 to 255 loop
            tb_input <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns;
        end loop;

        -- Wait for final signal propagation
        wait for 10 ns;

        -- End simulation
        wait;
    end process stim_proc;

end test_bench;
