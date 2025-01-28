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
--| FILENAME      : synch_blank.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-27
--| DESCRIPTION   : This file implements a calculator to determine when the horizontal
--|                 and vertical synch signals should be set and reset.
--|
--| DOCUMENTATION : None
--|                 
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

entity synch_blank is
    Port ( i_clk : in STD_LOGIC;
           i_reset_n : in STD_LOGIC;
           o_h_synch : out STD_LOGIC;
           o_h_blank : out STD_LOGIC;
           o_v_sync : out STD_LOGIC;
           o_v_blank : out STD_LOGIC;
           i_column : in unsigned(9 downto 0);
           i_row : in unsigned(9 downto 0) );
end synch_blank;

architecture synch_blank_arch of synch_blank is
   
begin

  -- Horizontal sync: '0' when 656 <= i_column < 752, otherwise '1'
  o_h_synch <= '0' when (i_column >= 656 and i_column < 752) else
               '1';

  -- Horizontal blank: '1' when i_column < 640, otherwise '0'
  o_h_blank <= '1' when (i_column < 640) else
               '0';

  -- Vertical sync: '0' when 490 <= i_row < 492, otherwise '1'
  o_v_sync <= '0' when (i_row >= 490 and i_row < 492) else
              '1';

  -- Vertical blank: '1' when i_row < 480, otherwise '0'
  o_v_blank <= '1' when (i_row < 480) else
               '0';

end synch_blank_arch;
