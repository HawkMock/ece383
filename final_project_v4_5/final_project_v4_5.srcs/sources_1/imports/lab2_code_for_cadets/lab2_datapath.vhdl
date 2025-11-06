--+----------------------------------------------------------------------------
--|
--| FILENAME      : lab2_datapath.vhd
--| AUTHOR(S)     : C1C Dustin Mock
--| MODIFIED      : 2025-11-05 (50 Hz tick fix, constants sanitised)
--| DESCRIPTION   : Player state, packing, and video path top.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab2_datapath is
    Port (
        i_clk     : in  STD_LOGIC;                        -- 100 MHz
        i_reset_n : in  STD_LOGIC;
        i_btn     : in  STD_LOGIC_VECTOR(4 downto 0);
        i_switch  : in  STD_LOGIC_VECTOR(3 downto 0);
        o_tmds    : out STD_LOGIC_VECTOR (3 downto 0);
        o_tmdsb   : out STD_LOGIC_VECTOR (3 downto 0);
        o_led     : out std_logic_vector(7 downto 0)
    );
end lab2_datapath;

architecture Behavioral of lab2_datapath is
    -- Constants
    constant k_div_50hz_max : unsigned(19 downto 0) := to_unsigned(1_999_999, 20); -- 100MHz/2M = 50Hz
    constant k_step_shift   : integer := 5;  -- 1/32 cell per tick
    constant k_max_x        : integer := 15;
    constant k_max_y        : integer := 15;
    constant k_start_q610   : integer := 1536; -- 1.5 * 1024

    -- Types
    subtype t_q6_10 is signed(15 downto 0);
    subtype t_q1_15 is signed(15 downto 0);

    type t_lut16 is array(0 to 15) of t_q1_15;
    constant k_cos16 : t_lut16 := (
        to_signed( 32767,16), to_signed( 30273,16), to_signed( 23170,16), to_signed( 12540,16),
        to_signed(     0,16), to_signed(-12540,16), to_signed(-23170,16), to_signed(-30273,16),
        to_signed(-32768,16), to_signed(-30273,16), to_signed(-23170,16), to_signed(-12540,16),
        to_signed(     0,16), to_signed( 12540,16), to_signed( 23170,16), to_signed( 30273,16)
    );
    constant k_sin16 : t_lut16 := (
        to_signed(     0,16), to_signed( 12540,16), to_signed( 23170,16), to_signed( 30273,16),
        to_signed( 32767,16), to_signed( 30273,16), to_signed( 23170,16), to_signed( 12540,16),
        to_signed(     0,16), to_signed(-12540,16), to_signed(-23170,16), to_signed(-30273,16),
        to_signed(-32768,16), to_signed(-30273,16), to_signed(-23170,16), to_signed(-12540,16)
    );

    -- Signals
    signal f_div_50hz_cnt  : unsigned(19 downto 0) := (others => '0');
    signal f_tick_50hz     : std_logic := '0';

    signal f_px, f_py      : t_q6_10 := to_signed(k_start_q610, 16);
    signal f_ang_idx       : unsigned(3 downto 0) := "0100";

    signal w_trigger_volt  : unsigned(9 downto 0);
    signal w_trigger_time  : unsigned(9 downto 0);

    signal w_row           : unsigned(9 downto 0);
    signal w_column        : unsigned(9 downto 0);

    component video is
        Port(
            i_clk          : in  STD_LOGIC;
            i_reset_n      : in  STD_LOGIC;
            i_trigger_time : in  unsigned(9 downto 0);
            i_trigger_volt : in  unsigned(9 downto 0);
            i_ch1_enb      : in  std_logic;
            i_ch2_enb      : in  std_logic;
            o_tmds         : out STD_LOGIC_VECTOR (3 downto 0);
            o_tmdsb        : out STD_LOGIC_VECTOR (3 downto 0);
            o_row          : out unsigned(9 downto 0);
            o_column       : out unsigned(9 downto 0)
        );
    end component;

begin
    -- 50 Hz enable
    process(i_clk, i_reset_n)
    begin
        if i_reset_n = '0' then
            f_div_50hz_cnt <= (others => '0');
            f_tick_50hz    <= '0';
        elsif rising_edge(i_clk) then
            if f_div_50hz_cnt = k_div_50hz_max then
                f_div_50hz_cnt <= (others => '0');
                f_tick_50hz    <= '1';
            else
                f_div_50hz_cnt <= f_div_50hz_cnt + 1;
                f_tick_50hz    <= '0';
            end if;
        end if;
    end process;

    -- Player state
    process(i_clk, i_reset_n)
        variable v_dx, v_dy     : t_q6_10;
        variable v_next_px, v_next_py: t_q6_10;
    begin
        if i_reset_n = '0' then
            f_px      <= to_signed(k_start_q610, 16);
            f_py      <= to_signed(k_start_q610, 16);
            f_ang_idx <= "0100";
        elsif rising_edge(i_clk) then
            if f_tick_50hz = '1' then
                -- turn
                if i_btn(1) = '1' then
                    f_ang_idx <= f_ang_idx - 1;
                elsif i_btn(3) = '1' then
                    f_ang_idx <= f_ang_idx + 1;
                end if;

                v_next_px := f_px;
                v_next_py := f_py;

                -- move
                if (i_btn(0) = '1') or (i_btn(2) = '1') then
                    v_dx := resize(shift_right(k_cos16(to_integer(f_ang_idx)), k_step_shift), 16);
                    v_dy := resize(shift_right(k_sin16(to_integer(f_ang_idx)), k_step_shift), 16);
                    if i_btn(2) = '1' then
                        v_next_px := f_px - v_dx;
                        v_next_py := f_py - v_dy;
                    else
                        v_next_px := f_px + v_dx;
                        v_next_py := f_py + v_dy;
                    end if;
                end if;

                -- clamp 0 .. (15*1024-1)
                if v_next_px < 0 then 
                    f_px <= to_signed(0, 16);
                elsif v_next_px > to_signed(k_max_x*1024 - 1, 16) then 
                    f_px <= to_signed(k_max_x*1024 - 1, 16);
                else 
                    f_px <= v_next_px;
                end if;

                if v_next_py < 0 then 
                    f_py <= to_signed(0, 16);
                elsif v_next_py > to_signed(k_max_y*1024 - 1, 16) then 
                    f_py <= to_signed(k_max_y*1024 - 1, 16);
                else 
                    f_py <= v_next_py;
                end if;
            end if;
        end if;
    end process;

    -- Pack state (Q4.6 + 4-bit angle across two words)
    process(f_px, f_py, f_ang_idx)
        variable v_px_q46 : unsigned(9 downto 0);
        variable v_py_q46 : unsigned(9 downto 0);
    begin
        v_px_q46 := unsigned(f_px(15 downto 6));
        v_py_q46 := unsigned(f_py(15 downto 6));
        v_px_q46(1 downto 0) := f_ang_idx(1 downto 0);
        v_py_q46(1 downto 0) := f_ang_idx(3 downto 2);
        w_trigger_volt <= v_px_q46;
        w_trigger_time <= v_py_q46;
    end process;

    -- Video
    u_video: video
        port map(
            i_clk          => i_clk,
            i_reset_n      => i_reset_n,
            o_tmds         => o_tmds,
            o_tmdsb        => o_tmdsb,
            i_trigger_time => w_trigger_time,
            i_trigger_volt => w_trigger_volt,
            o_row          => w_row,
            o_column       => w_column,
            i_ch1_enb      => i_switch(0),
            i_ch2_enb      => i_switch(1)
        );

    -- LEDs
    o_led(3 downto 0) <= std_logic_vector(f_ang_idx);
    o_led(7 downto 4) <= std_logic_vector(f_px(13 downto 10));  -- integer X

end Behavioral;
