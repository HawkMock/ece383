--+----------------------------------------------------------------------------
--|
--| Engineer: Mike Field <hamster@snap.net.nz>
--| Modified: Claude 3.5 Sonnet (7-series ODDR and clean shifter)
--| MODIFIED    : 2025-11-05
--|
--| FILENAME      : dvid.vhd
--| DESCRIPTION   : Converts VGA planes into TMDS serial streams using
--|                 5x pixel clock and ODDR (7-series). Two bits are
--|                 emitted per 125 MHz cycle for 10-bit TMDS symbols.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- REQUIRED for 'unsigned'

library UNISIM;
use UNISIM.vcomponents.all;

entity dvid is
    Port (
        clk       : in  STD_LOGIC;  -- 5x pixel clock (e.g., 125 MHz)
        clk_n     : in  STD_LOGIC;  -- unused with ODDR (kept for compatibility)
        clk_pixel : in  STD_LOGIC;  -- pixel clock (e.g., 25 MHz)
        red_p     : in  STD_LOGIC_VECTOR (7 downto 0);
        green_p   : in  STD_LOGIC_VECTOR (7 downto 0);
        blue_p    : in  STD_LOGIC_VECTOR (7 downto 0);
        blank     : in  STD_LOGIC;
        hsync     : in  STD_LOGIC;
        vsync     : in  STD_LOGIC;
        red_s     : out STD_LOGIC;
        green_s   : out STD_LOGIC;
        blue_s    : out STD_LOGIC;
        clock_s   : out STD_LOGIC
    );
end dvid;

architecture Behavioral of dvid is
    component TDMS_encoder
        port(
            clk     : in  std_logic;
            data    : in  std_logic_vector(7 downto 0);
            c       : in  std_logic_vector(1 downto 0);
            blank   : in  std_logic;
            encoded : out std_logic_vector(9 downto 0)
        );
    end component;

    signal encoded_red, encoded_green, encoded_blue : std_logic_vector(9 downto 0);
    signal latched_red, latched_green, latched_blue : std_logic_vector(9 downto 0) := (others => '0');
    signal shift_red,   shift_green,   shift_blue   : std_logic_vector(9 downto 0) := (others => '0');
    signal shift_clock                                : std_logic_vector(9 downto 0) := "0000011111";

    signal c_blue   : std_logic_vector(1 downto 0);
    signal phase    : unsigned(2 downto 0) := (others => '0');  -- 0..4 (5 cycles x 2 bits = 10)

begin
    c_blue <= vsync & hsync;

    enc_r: TDMS_encoder port map(clk => clk_pixel, data => red_p,   c => "00",   blank => blank, encoded => encoded_red);
    enc_g: TDMS_encoder port map(clk => clk_pixel, data => green_p, c => "00",   blank => blank, encoded => encoded_green);
    enc_b: TDMS_encoder port map(clk => clk_pixel, data => blue_p,  c => c_blue, blank => blank, encoded => encoded_blue);

    -- Latch encoded words on pixel clock
    process(clk_pixel)
    begin
        if rising_edge(clk_pixel) then
            latched_red   <= encoded_red;
            latched_green <= encoded_green;
            latched_blue  <= encoded_blue;
        end if;
    end process;

    -- 5 phases of 125 MHz to emit 10 bits using ODDR D1/D2 per cycle
    process(clk)
    begin
        if rising_edge(clk) then
            if phase = "000" then
                shift_red   <= latched_red;
                shift_green <= latched_green;
                shift_blue  <= latched_blue;
                shift_clock <= "0000011111";
                phase       <= "001";
            else
                shift_red   <= "00" & shift_red(9 downto 2);
                shift_green <= "00" & shift_green(9 downto 2);
                shift_blue  <= "00" & shift_blue(9 downto 2);
                shift_clock <= "00" & shift_clock(9 downto 2);
                if phase = "100" then
                    phase <= "000";
                else
                    phase <= phase + 1;
                end if;
            end if;
        end if;
    end process;

    -- 7-series ODDR primitives
    ODDR_red   : ODDR generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC")
        port map(Q => red_s,   C => clk, CE => '1', D1 => shift_red(0),   D2 => shift_red(1),   R => '0', S => '0');

    ODDR_green : ODDR generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC")
        port map(Q => green_s, C => clk, CE => '1', D1 => shift_green(0), D2 => shift_green(1), R => '0', S => '0');

    ODDR_blue  : ODDR generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC")
        port map(Q => blue_s,  C => clk, CE => '1', D1 => shift_blue(0),  D2 => shift_blue(1),  R => '0', S => '0');

    ODDR_clock : ODDR generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC")
        port map(Q => clock_s, C => clk, CE => '1', D1 => shift_clock(0), D2 => shift_clock(1), R => '0', S => '0');

end Behavioral;
