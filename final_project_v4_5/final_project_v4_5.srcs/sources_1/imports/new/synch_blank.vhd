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
--| MODIFIED      : 2025-11-04 (Header update by Claude 3.5 Sonnet)
--| DESCRIPTION   : Generates horizontal and vertical sync and blank signals
--|                 for VGA timing (640x480 @ 60Hz).
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

entity synch_blank is
    Port (
        i_clk     : in  std_logic;
        i_reset_n : in  std_logic;
        o_h_synch : out STD_LOGIC;
        o_h_blank : out STD_LOGIC;
        o_v_synch : out STD_LOGIC;
        o_v_blank : out STD_LOGIC;
        i_column  : in  unsigned(9 downto 0);
        i_row     : in  unsigned(9 downto 0)
    );
end synch_blank;

architecture synch_blank_arch of synch_blank is
begin
    -- Horizontal sync: '0' when 656 <= column < 752
    o_h_synch <= '0' when (i_column >= 656 and i_column < 752) else '1';

    -- Horizontal blank: '0' during active area (column < 640)
    o_h_blank <= '0' when (i_column < 640) else '1';

    -- Vertical sync: '0' when 490 <= row < 492
    o_v_synch <= '0' when (i_row >= 490 and i_row < 492) else '1';

    -- Vertical blank: '0' during active area (row < 480)
    o_v_blank <= '0' when (i_row < 480) else '1';

end synch_blank_arch;
