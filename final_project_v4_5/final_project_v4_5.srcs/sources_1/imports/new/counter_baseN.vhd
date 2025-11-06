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
--| FILENAME      : counter_baseN.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-23
--| MODIFIED      : 2025-11-04 (Header update by Claude 3.5 Sonnet)
--| DESCRIPTION   : Generic base-N counter. Counts from 0 to N-1 then rolls over.
--|
--| DOCUMENTATION : Original by C2C Dustin Mock, header standardized by
--|                 Claude 3.5 Sonnet (Anthropic).
--|                 
--| TODO          : None
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_baseN is
    generic (
        g_base    : natural := 5;
        g_bits    : natural := 3;
        g_initial : natural := 0
    );
    Port (
        i_clk   : in  std_logic;
        i_reset : in  std_logic;
        i_ctrl  : in  std_logic;
        o_Q     : out unsigned(g_bits-1 downto 0)
    );
end counter_baseN;

architecture counter_baseN_arch of counter_baseN is
    signal w_processQ : unsigned(g_bits-1 downto 0) := to_unsigned(g_initial, g_bits);
    constant k_base_minus_one : unsigned(g_bits-1 downto 0) := to_unsigned(g_base - 1, g_bits);
begin
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '0' then
                w_processQ <= (others => '0');
            elsif (w_processQ < k_base_minus_one and i_ctrl = '1') then
                w_processQ <= w_processQ + 1;
            elsif (w_processQ = k_base_minus_one and i_ctrl = '1') then
                w_processQ <= (others => '0');
            end if;
        end if;
    end process;

    o_Q <= w_processQ;

end counter_baseN_arch;
