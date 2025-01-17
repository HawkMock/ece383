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
--| FILENAME      : base5_counter.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-15
--| DESCRIPTION   : This file implements base 5 counter. It will count up to
--|                 roll over to 0.
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity base5_counter is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_ctrl : in STD_LOGIC;
           o_Q : out unsigned (2 downto 0));
end base5_counter;

architecture base5_counter_arch of base5_counter is
     -- Signal declarations
     signal w_processQ: unsigned (2 downto 0) := (others => '0');
begin
    --+----------------------------------------------------+--
    --|         clk     ctrl    reset   Q+                 |--
    --|         0, 1,   x       x       Q                  |--
    --|         falling                                    |--
    --|         rising  x       0       0                  |--
    --|         rising  0       1       Q                  |--
    --|         rising  1       1       Q + 1 mod 5        |--
    --+----------------------------------------------------+--
    process(i_clk)
    begin
        if (rising_edge(i_clk)) then
            if (i_reset = '0') then
                w_processQ <= (others => '0');
            elsif ((w_processQ < 4) and (i_ctrl = '1')) then
                w_processQ <= w_processQ + 1;
            elsif ((w_processQ(2) = '1') and (i_ctrl = '1')) then
                w_processQ <= (others => '0');
            end if;
        end if;
    end process;
    
    o_Q <= w_processQ;
    
end base5_counter_arch;
