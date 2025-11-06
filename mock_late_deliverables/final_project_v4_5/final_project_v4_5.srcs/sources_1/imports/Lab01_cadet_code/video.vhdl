--+----------------------------------------------------------------------------
--|
--| FILENAME      : video.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| MODIFIED      : 2025-11-05 (TMDS lane mapping and port name fixes)
--| DESCRIPTION   : Video pipeline top. Generates pixel/serial clocks,
--|                 drives VGA pipeline, then serializes via dvid.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity video is
    Port (
        i_clk          : in  STD_LOGIC;                        -- 100 MHz
        i_reset_n      : in  STD_LOGIC;
        o_tmds         : out STD_LOGIC_VECTOR (3 downto 0);
        o_tmdsb        : out STD_LOGIC_VECTOR (3 downto 0);
        i_trigger_time : in  unsigned(9 downto 0);
        i_trigger_volt : in  unsigned(9 downto 0);
        o_row          : out unsigned(9 downto 0);
        o_column       : out unsigned(9 downto 0);
        i_ch1_enb      : in  std_logic;
        i_ch2_enb      : in  std_logic
    );
end video;

architecture structure of video is
    signal w_red, w_green, w_blue : STD_LOGIC_VECTOR(7 downto 0);
    signal w_pixel_clk, w_serialize_clk, w_serialize_clk_n : STD_LOGIC;
    signal w_blank, w_h_sync, w_v_sync : STD_LOGIC;
    signal w_clock_s, w_red_s, w_green_s, w_blue_s : STD_LOGIC;

    component VGA is
        Port(   
            i_clk          : in  STD_LOGIC;
            i_reset_n      : in  STD_LOGIC;
            o_h_synch      : out STD_LOGIC;
            o_v_synch      : out STD_LOGIC; 
            o_blank        : out STD_LOGIC;
            o_R            : out STD_LOGIC_VECTOR(7 downto 0);
            o_G            : out STD_LOGIC_VECTOR(7 downto 0);
            o_B            : out STD_LOGIC_VECTOR(7 downto 0);
            i_trigger_time : in  unsigned(9 downto 0);
            i_trigger_volt : in  unsigned(9 downto 0);
            o_row          : out unsigned(9 downto 0);
            o_column       : out unsigned(9 downto 0);
            i_ch1_enb      : in  std_logic;
            i_ch2_enb      : in  std_logic
        );
    end component;

    component clk_wiz_0 is
        Port (
            clk_in1  : in  STD_LOGIC;
            clk_out1 : out STD_LOGIC;  -- 25 MHz
            clk_out2 : out STD_LOGIC;  -- 125 MHz
            clk_out3 : out STD_LOGIC;  -- 125 MHz (phase)
            resetn   : in  STD_LOGIC
        );
    end component;   

begin
    mmcm_adv_inst_display_clocks: clk_wiz_0
        Port Map (
            clk_in1  => i_clk,
            clk_out1 => w_pixel_clk,
            clk_out2 => w_serialize_clk,
            clk_out3 => w_serialize_clk_n,
            resetn   => i_reset_n
        );

    vga_inst: VGA
        port map(	
            i_clk          => w_pixel_clk,
            i_reset_n      => i_reset_n,
            o_h_synch      => w_h_sync,
            o_v_synch      => w_v_sync,
            o_blank        => w_blank,
            o_R            => w_red,
            o_G            => w_green,
            o_B            => w_blue,
            i_trigger_volt => i_trigger_volt, 
            i_trigger_time => i_trigger_time,
            o_row          => o_row,
            o_column       => o_column,
            i_ch1_enb      => i_ch1_enb,
            i_ch2_enb      => i_ch2_enb
        );

    dvid_inst: entity work.dvid 
        port map(
            clk       => w_serialize_clk,
            clk_n     => w_serialize_clk_n, 
            clk_pixel => w_pixel_clk,
            red_p     => w_red,
            green_p   => w_green,
            blue_p    => w_blue,
            blank     => w_blank,
            hsync     => w_h_sync,
            vsync     => w_v_sync,
            red_s     => w_red_s,
            green_s   => w_green_s,
            blue_s    => w_blue_s,
            clock_s   => w_clock_s
        );

    -- TMDS lane mapping: [2]=Red, [1]=Green, [0]=Blue, [3]=Clock
    OBUFDS_blue  : OBUFDS port map (O => o_tmds(0),  OB => o_tmdsb(0),  I => w_blue_s);
    OBUFDS_green : OBUFDS port map (O => o_tmds(1),  OB => o_tmdsb(1),  I => w_green_s);
    OBUFDS_red   : OBUFDS port map (O => o_tmds(2),  OB => o_tmdsb(2),  I => w_red_s);
    OBUFDS_clock : OBUFDS port map (O => o_tmds(3),  OB => o_tmdsb(3),  I => w_clock_s);

end structure;
