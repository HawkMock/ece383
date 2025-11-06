-- rtl/top_raymaze.vhd
-- Nexys Video first-person raycasting maze over HDMI/DVI
-- Primary 1280x720@60 (74.25 MHz pclk), fallback 640x480@60 (25.175 MHz pclk)
-- Pure VHDL-2008, numeric_std only

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_raymaze is
  generic (
    G_MODE_720P       : boolean := true;   -- true: 1280x720p60, false: 640x480p60
    G_FOV_DEG         : integer := 66;     -- field of view
    G_PLAYER_TICK_HZ  : integer := 100     -- movement/control tick
  );
  port (
    -- 100 MHz system clock
    clk_100mhz    : in  std_logic;
    -- Asynchronous pushbutton reset (CPU RESET button, active low on board) -> treat as async assert
    rst_n_btn     : in  std_logic;

    -- HDMI Source (J8) TMDS outputs (to TMDS141 buffer on board)
    tmds_d_p      : out std_logic_vector(2 downto 0);
    tmds_d_n      : out std_logic_vector(2 downto 0);
    tmds_clk_p    : out std_logic;
    tmds_clk_n    : out std_logic;

    -- HDMI Aux (source side): DDC I2C (optional), HPD detect (input from sink)
    ddc_scl_io    : inout std_logic; -- open-drain
    ddc_sda_io    : inout std_logic; -- open-drain
    hpd_in        : in  std_logic;   -- hot-plug detect from sink (monitor)

    -- User I/O
    sw            : in  std_logic_vector(7 downto 0);
    btn_u         : in  std_logic;
    btn_d         : in  std_logic;
    btn_l         : in  std_logic;
    btn_r         : in  std_logic;
    btn_c         : in  std_logic;
    led           : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of top_raymaze is
  ------------------------------------------------------------------------------
  -- Resets
  ------------------------------------------------------------------------------
  signal rst_async_n   : std_logic;
  signal rst_pix       : std_logic;  -- sync-deassert to pixel/fabric domain
  signal rst_fabric    : std_logic;

  ------------------------------------------------------------------------------
  -- Clocks
  ------------------------------------------------------------------------------
  signal clk_pix       : std_logic;  -- pixel clock (25.175 or 74.25 MHz)
  signal clk_tmds5x    : std_logic;  -- 5x pixel clock for DDR 10:1 TMDS serialization
  signal clk_lock      : std_logic;

  ------------------------------------------------------------------------------
  -- Video timing
  ------------------------------------------------------------------------------
  constant C_IS_720P   : boolean := G_MODE_720P;
  signal vtg_hsync     : std_logic;
  signal vtg_vsync     : std_logic;
  signal vtg_de        : std_logic;
  signal vtg_x         : unsigned(11 downto 0); -- up to 2200 for 720p
  signal vtg_y         : unsigned(11 downto 0); -- up to 1125 for 720p
  signal active_x      : unsigned(11 downto 0);
  signal active_y      : unsigned(11 downto 0);

  ------------------------------------------------------------------------------
  -- Raycaster outputs per column
  ------------------------------------------------------------------------------
  type colrec is record
    top_row    : unsigned(11 downto 0);
    bot_row    : unsigned(11 downto 0);
    base_col   : unsigned(7 downto 0);  -- 8-bit index/color
  end record;
  signal col_info      : colrec;

  ------------------------------------------------------------------------------
  -- Pixel/color path
  ------------------------------------------------------------------------------
  signal rgb_r8, rgb_g8, rgb_b8 : unsigned(7 downto 0);
  signal tmds_ce                : std_logic := '1';
  signal tmds_valid             : std_logic := '1';

  ------------------------------------------------------------------------------
  -- Control / movement
  ------------------------------------------------------------------------------
  signal btn_u_db, btn_d_db, btn_l_db, btn_r_db, btn_c_db : std_logic;
  signal player_x, player_y    : signed(15 downto 0); -- Q6.10 world coords
  signal player_th             : signed(15 downto 0); -- Q1.15 angle

  -- simple heartbeat
  signal hb_cnt : unsigned(23 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Reset handling: async assert, sync deassert
  ------------------------------------------------------------------------------
  rst_async_n <= rst_n_btn; -- external is active-low
  u_rst_sync_pix : entity work.reset_sync
    generic map (G_ACTIVE_LOW => true)
    port map (
      clk       => clk_pix,
      rst_async => not rst_async_n,
      rst_sync  => rst_pix
    );

  u_rst_sync_fabric : entity work.reset_sync
    generic map (G_ACTIVE_LOW => true)
    port map (
      clk       => clk_pix,
      rst_async => not rst_async_n,
      rst_sync  => rst_fabric
    );

  ------------------------------------------------------------------------------
  -- Clocks: generate pixel clock and 5x clock from 100 MHz
  ------------------------------------------------------------------------------
  u_clocks : entity work.clock_gen
    generic map (
      G_720P => C_IS_720P
    )
    port map (
      clk_in    => clk_100mhz,
      clk_pix   => clk_pix,
      clk_5x    => clk_tmds5x,
      locked    => clk_lock,
      rst_in    => '0'
    );

  ------------------------------------------------------------------------------
  -- Debounce user buttons in pixel clock domain
  ------------------------------------------------------------------------------
  u_db_u : entity work.debounce port map(clk=>clk_pix, rst=>rst_fabric, din=>btn_u, dout=>btn_u_db);
  u_db_d : entity work.debounce port map(clk=>clk_pix, rst=>rst_fabric, din=>btn_d, dout=>btn_d_db);
  u_db_l : entity work.debounce port map(clk=>clk_pix, rst=>rst_fabric, din=>btn_l, dout=>btn_l_db);
  u_db_r : entity work.debounce port map(clk=>clk_pix, rst=>rst_fabric, din=>btn_r, dout=>btn_r_db);
  u_db_c : entity work.debounce port map(clk=>clk_pix, rst=>rst_fabric, din=>btn_c, dout=>btn_c_db);

  ------------------------------------------------------------------------------
  -- Video Timing
  ------------------------------------------------------------------------------
  u_vtg : entity work.video_timing
    generic map (G_720P => C_IS_720P)
    port map (
      clk_pix  => clk_pix,
      rst      => rst_pix,
      hsync    => vtg_hsync,
      vsync    => vtg_vsync,
      de       => vtg_de,
      x        => vtg_x,
      y        => vtg_y,
      ax       => active_x,
      ay       => active_y
    );

  ------------------------------------------------------------------------------
  -- Movement/control tick and player state update
  ------------------------------------------------------------------------------
  u_ctrl : entity work.input_ctrl
    generic map (
      G_TICK_HZ   => G_PLAYER_TICK_HZ
    )
    port map (
      clk_pix     => clk_pix,
      rst         => rst_fabric,
      sw          => sw,
      btn_fwd     => btn_u_db,
      btn_back    => btn_d_db,
      btn_left    => btn_l_db,
      btn_right   => btn_r_db,
      btn_turn    => btn_c_db,
      player_x    => player_x,
      player_y    => player_y,
      player_th   => player_th
    );

  ------------------------------------------------------------------------------
  -- Column-by-column raycaster (no framebuffer)
  ------------------------------------------------------------------------------
  u_ray : entity work.raycaster_core
    generic map (
      G_720P     => C_IS_720P,
      G_FOV_DEG  => G_FOV_DEG
    )
    port map (
      clk        => clk_pix,
      rst        => rst_fabric,
      de         => vtg_de,
      ax         => active_x,
      ay         => active_y,
      player_x   => player_x,
      player_y   => player_y,
      player_th  => player_th,
      col_top    => col_info.top_row,
      col_bot    => col_info.bot_row,
      col_base   => col_info.base_col
    );

  ------------------------------------------------------------------------------
  -- Simple colorizer/shading + background
  ------------------------------------------------------------------------------
  u_col : entity work.colorizer
    port map (
      clk      => clk_pix,
      rst      => rst_fabric,
      de       => vtg_de,
      x        => active_x,
      y        => active_y,
      top_row  => col_info.top_row,
      bot_row  => col_info.bot_row,
      base_col => col_info.base_col,
      r8       => rgb_r8,
      g8       => rgb_g8,
      b8       => rgb_b8
    );

  ------------------------------------------------------------------------------
  -- HDMI TX (TMDS encode + DDR serialize). Start only if HPD is high.
  ------------------------------------------------------------------------------
  u_hdmi : entity work.hdmi_tx
    port map (
      clk_pix    => clk_pix,
      clk_5x     => clk_tmds5x,
      rst        => rst_pix,
      hsync      => vtg_hsync,
      vsync      => vtg_vsync,
      de         => vtg_de and hpd_in,  -- gate if no sink
      r8         => std_logic_vector(rgb_r8),
      g8         => std_logic_vector(rgb_g8),
      b8         => std_logic_vector(rgb_b8),
      tmds_d_p   => tmds_d_p,
      tmds_d_n   => tmds_d_n,
      tmds_clk_p => tmds_clk_p,
      tmds_clk_n => tmds_clk_n
    );

  ------------------------------------------------------------------------------
  -- Minimal I2C DDC: leave lines released (pull-ups on board side); optional
  ------------------------------------------------------------------------------
  ddc_scl_io <= 'Z';
  ddc_sda_io <= 'Z';

  ------------------------------------------------------------------------------
  -- Status LEDs: lock, HPD, mode, heartbeat
  ------------------------------------------------------------------------------
  process(clk_pix)
  begin
    if rising_edge(clk_pix) then
      if rst_fabric='1' then
        hb_cnt <= (others=>'0');
      else
        hb_cnt <= hb_cnt + 1;
      end if;
    end if;
  end process;

  led(0) <= clk_lock;
  led(1) <= hpd_in;
  led(2) <= '1' when C_IS_720P else '0';
  led(3) <= btn_u_db xor btn_d_db;
  led(4) <= btn_l_db xor btn_r_db;
  led(7 downto 5) <= std_logic_vector(hb_cnt(23 downto 21));

end architecture;
