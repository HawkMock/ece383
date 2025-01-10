----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2025 08:09:09 AM
-- Design Name: 
-- Module Name: priority_encoder_tb - test_bench
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This testbench tests the priority_encoder module by simulating all possible input 
-- combinations and verifying the output.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

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
