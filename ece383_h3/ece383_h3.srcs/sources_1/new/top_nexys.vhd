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
--| FILENAME      : top_nexys.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-14
--| DESCRIPTION   : This file implements the top-level module for the Nexys board.
--|                 It connects the divis_17 component to an LED output.
--|
--+----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_nexys is
    port (
--        clk     : in std_logic;                -- Clock input
        sw      : in std_logic_vector(7 downto 0); -- 8-bit switch input
        led     : out std_logic                  -- Single LED output
    );
end top_nexys;

architecture top_nexys_arch of top_nexys is

    -- Signal declarations
    signal w_divisible : std_logic;

begin

    -- Instantiate divis_17 component
    divis_17_inst : entity work.divis_17
        port map (
            i_input => sw,
            o_divisible => w_divisible
        );

    -- Connect the output of divis_17 to the LED
    led <= w_divisible;

end top_nexys_arch;
