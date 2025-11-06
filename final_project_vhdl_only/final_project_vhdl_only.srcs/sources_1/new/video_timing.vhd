-- rtl/video_timing.vhd
-- Generates HS/VS/DE and active coordinates for 720p60 or 640x480@60

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video_timing is
  generic ( G_720P : boolean := true );
  port (
    clk_pix : in  std_logic;
    rst     : in  std_logic;
    hsync   : out std_logic;
    vsync   : out std_logic;
    de      : out std_logic;
    x       : out unsigned(11 downto 0); -- total counters
    y       : out unsigned(11 downto 0);
    ax      : out unsigned(11 downto 0); -- active area coords
    ay      : out unsigned(11 downto 0)
  );
end entity;

architecture rtl of video_timing is
  -- 1280x720@60 (CEA-861)
  constant H_ACTIVE_720 : integer := 1280;
  constant H_FP_720     : integer := 110;
  constant H_SYNC_720   : integer := 40;
  constant H_BP_720     : integer := 220;
  constant H_TOTAL_720  : integer := H_ACTIVE_720 + H_FP_720 + H_SYNC_720 + H_BP_720; -- 1650
  constant V_ACTIVE_720 : integer := 720;
  constant V_FP_720     : integer := 5;
  constant V_SYNC_720   : integer := 5;
  constant V_BP_720     : integer := 20;
  constant V_TOTAL_720  : integer := V_ACTIVE_720 + V_FP_720 + V_SYNC_720 + V_BP_720; -- 750

  -- 640x480@60 (VGA)
  constant H_ACTIVE_VGA : integer := 640;
  constant H_FP_VGA     : integer := 16;
  constant H_SYNC_VGA   : integer := 96;
  constant H_BP_VGA     : integer := 48;
  constant H_TOTAL_VGA  : integer := 800;
  constant V_ACTIVE_VGA : integer := 480;
  constant V_FP_VGA     : integer := 10;
  constant V_SYNC_VGA   : integer := 2;
  constant V_BP_VGA     : integer := 33;
  constant V_TOTAL_VGA  : integer := 525;

  signal hcnt, vcnt : unsigned(11 downto 0);
  signal de_i, hs_i, vs_i : std_logic;

  -- Mode select
  function sel(b:boolean; a,bv:integer) return integer is
  begin
    if b then return a; else return bv; end if;
  end function;

  constant H_ACTIVE : integer := sel(G_720P, H_ACTIVE_720, H_ACTIVE_VGA);
  constant H_FP     : integer := sel(G_720P, H_FP_720,     H_FP_VGA);
  constant H_SYNC   : integer := sel(G_720P, H_SYNC_720,   H_SYNC_VGA);
  constant H_BP     : integer := sel(G_720P, H_BP_720,     H_BP_VGA);
  constant H_TOTAL  : integer := sel(G_720P, H_TOTAL_720,  H_TOTAL_VGA);

  constant V_ACTIVE : integer := sel(G_720P, V_ACTIVE_720, V_ACTIVE_VGA);
  constant V_FP     : integer := sel(G_720P, V_FP_720,     V_FP_VGA);
  constant V_SYNC   : integer := sel(G_720P, V_SYNC_720,   V_SYNC_VGA);
  constant V_BP     : integer := sel(G_720P, V_BP_720,     V_BP_VGA);
  constant V_TOTAL  : integer := sel(G_720P, V_TOTAL_720,  V_TOTAL_VGA);

begin
  process(clk_pix)
  begin
    if rising_edge(clk_pix) then
      if rst='1' then
        hcnt <= (others=>'0');
        vcnt <= (others=>'0');
      else
        if hcnt = to_unsigned(H_TOTAL-1, hcnt'length) then
          hcnt <= (others=>'0');
          if vcnt = to_unsigned(V_TOTAL-1, vcnt'length) then
            vcnt <= (others=>'0');
          else
            vcnt <= vcnt + 1;
          end if;
        else
          hcnt <= hcnt + 1;
        end if;
      end if;
    end if;
  end process;

  -- Syncs (positive polarity for 720p per CEA; negative for VGA)
  hs_i <= '1' when (to_integer(hcnt) >= (H_ACTIVE + H_FP) and to_integer(hcnt) < (H_ACTIVE + H_FP + H_SYNC)) else '0';
  vs_i <= '1' when (to_integer(vcnt) >= (V_ACTIVE + V_FP) and to_integer(vcnt) < (V_ACTIVE + V_FP + V_SYNC)) else '0';
  if_vga: if not G_720P generate
    hsync <= not hs_i;
    vsync <= not vs_i;
  end generate;
  if_720: if G_720P generate
    hsync <= hs_i;
    vsync <= vs_i;
  end generate;

  de_i <= '1' when (to_integer(hcnt) < H_ACTIVE and to_integer(vcnt) < V_ACTIVE) else '0';

  de <= de_i;
  x  <= hcnt;
  y  <= vcnt;

  ax <= hcnt;
  ay <= vcnt;

end architecture;
