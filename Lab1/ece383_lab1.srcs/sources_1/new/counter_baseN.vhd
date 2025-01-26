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
--| DESCRIPTION   : This file implements base N counter. It will count up to
--|                 N then roll over to 0.
--|
--| DOCUMENTATION : Used ChatGPT to implement generic:
--|                 https://chatgpt.com/share/67928cd6-285c-8012-8ea8-5e3a163fc26d
--| TODO:           None
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
use IEEE.NUMERIC_STD.ALL;

entity counter_baseN is
    generic (
        g_base : natural := 5; -- Default base is 5
        g_bits : natural := 3  -- Default bit width for base 5
    );
    Port (
        i_clk : in STD_LOGIC;
        i_reset : in STD_LOGIC;
        i_ctrl : in STD_LOGIC;
        o_Q : out unsigned (g_bits - 1 downto 0)
    );
end counter_baseN;

architecture counter_baseN_arch of counter_baseN is
    -- Signal declarations
    signal w_processQ: unsigned (g_bits - 1 downto 0) := (others => '0');
    constant k_base_minus_one : unsigned (g_bits - 1 downto 0) := to_unsigned(g_base - 1, g_bits);
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
