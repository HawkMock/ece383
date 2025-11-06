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
--| FILENAME      : lab2_datapath.vhdl
--| AUTHOR(S)     : C1C Dustin Mock 
--| CREATED       : 2025-07-22
--| DESCRIPTION   : Lab2-compatible datapath wrapper. Preserves the original
--|                 Lab2 video/VGA/dvid pipeline. Maintains *player state*
--|                 (x,y,angle) synchronously and *packs it* onto the existing
--|                 trigger buses for a stateless scopeFace raycaster.
--|
--| DOCUMENTATION : ChatGPT was used at points to modify and review code.
--|                 Example files from the course (e.g., 2-bit color code)
--|                 were referenced for palette/tint ideas and style.
--|                 
--| TODO:          None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : video.vhd (unchanged), VGA.vhd (unchanged),
--|                dvid.vhd (unchanged), FlagRegister.vhd (Lab2),
--|                scopeFace.vhd (stateless combinational raycaster)
--|
--| NAMING CONVENTIONS :
--|    xb_<port>, xi_<port>, xo_<port>, b_, i_, o_, c_, f_, ff_, *_n, w_, g_, k_, v_, sm_, s_
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab2_datapath is
    Port (
        clk    : in  STD_LOGIC;
        reset_n: in  STD_LOGIC;

        -- (Unchanged) Audio/I2C ports preserved for top-level compatibility
        ac_mclk       : out STD_LOGIC;
        ac_adc_sdata  : in  STD_LOGIC;
        ac_dac_sdata  : out STD_LOGIC;
        ac_bclk       : out STD_LOGIC;
        ac_lrclk      : out STD_LOGIC;
        scl           : inout STD_LOGIC;
        sda           : inout STD_LOGIC;

        -- DVI/HDMI out (unchanged Lab2 path via video->VGA->dvid)
        tmds  : out  STD_LOGIC_VECTOR (3 downto 0);
        tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);

        -- Lab2 FSM handshakes (kept; neutral values)
        sw : out std_logic_vector(2 downto 0);
        cw : in  std_logic_vector (2 downto 0);

        -- Board IO
        btn   : in  STD_LOGIC_VECTOR(4 downto 0);
        switch: in  STD_LOGIC_VECTOR(3 downto 0);

        -- External bus (preserved; unused)
        exWrAddr: in  std_logic_vector(9 downto 0);
        exWen, exSel: in std_logic;
        LBus_out, Rbus_out : out std_logic_vector(15 downto 0);
        exLbus, exRbus     : in  std_logic_vector(15 downto 0);
        flagQ     : out std_logic;
        flagClear : in  std_logic
    );
end lab2_datapath;

architecture Behavioral of lab2_datapath is
    --------------------------------------------------------------------------
    -- k_ constants
    --------------------------------------------------------------------------
    constant k_div_50hz_max : unsigned(19 downto 0) := to_unsigned(1048575, 20); -- ~50 Hz
    constant k_step_shift   : integer := 5;  -- 1/32 cell per tick (>>5)
    constant k_max_x        : integer := 15; -- map 0..15
    constant k_max_y        : integer := 15;

    --------------------------------------------------------------------------
    -- Fixed-point and LUTs for movement (Q6.10 pos, Q1.15 dir)
    --------------------------------------------------------------------------
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

    --------------------------------------------------------------------------
    -- f_/w_ signals
    --------------------------------------------------------------------------
    signal f_div_50hz_cnt  : unsigned(19 downto 0) := (others => '0');
    signal f_tick_50hz     : std_logic := '0';

    -- Packed trigger vectors to video/scopeFace
    signal f_trigger_volt  : unsigned(9 downto 0) := (others => '0');
    signal f_trigger_time  : unsigned(9 downto 0) := (others => '0');

    -- VGA feedback (unused)
    signal w_row           : unsigned(9 downto 0);
    signal w_column        : unsigned(9 downto 0);

    -- Player state (Q6.10 pos, 16-dir index)
    signal f_px, f_py      : t_q6_10 := to_signed(3*1024,16); -- start near (3,3)
    signal f_ang_idx       : unsigned(3 downto 0) := (others => '0');

    -- Scope channels inert
    signal w_ch1           : std_logic := '0';
    signal w_ch2           : std_logic := '0';

    -- Components
    component FlagRegister is
        port(
            clk     : in std_logic;
            reset_n : in std_logic;
            set     : in std_logic;
            clear   : in std_logic;
            Q       : in std_logic;
            flagQ   : out std_logic
        );
    end component;

    component video is
        Port(
            clk          : in  STD_LOGIC;
            reset_n      : in  STD_LOGIC;
            tmds         : out STD_LOGIC_VECTOR (3 downto 0);
            tmdsb        : out STD_LOGIC_VECTOR (3 downto 0);
            trigger_time : in  unsigned(9 downto 0);
            trigger_volt : in  unsigned(9 downto 0);
            row          : out unsigned(9 downto 0);
            column       : out unsigned(9 downto 0);
            ch1          : in  std_logic;
            ch1_enb      : in  std_logic;
            ch2          : in  std_logic;
            ch2_enb      : in  std_logic
        );
    end component;

begin
    --------------------------------------------------------------------------
    -- 50 Hz tick
    --------------------------------------------------------------------------
    p_div_50hz : process(clk, reset_n)
    begin
        if reset_n = '0' then
            f_div_50hz_cnt <= (others => '0');
            f_tick_50hz    <= '0';
        elsif rising_edge(clk) then
            if f_div_50hz_cnt = k_div_50hz_max then
                f_div_50hz_cnt <= (others => '0');
                f_tick_50hz    <= '1';
            else
                f_div_50hz_cnt <= f_div_50hz_cnt + 1;
                f_tick_50hz    <= '0';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Player state update (synchronous, deterministic)
    --------------------------------------------------------------------------
    p_player : process(clk, reset_n)
        variable v_dx, v_dy : t_q6_10;
    begin
        if reset_n = '0' then
            f_px      <= to_signed(3*1024,16);
            f_py      <= to_signed(3*1024,16);
            f_ang_idx <= (others => '0');
        elsif rising_edge(clk) then
            if f_tick_50hz = '1' then
                -- turn
                if btn(1) = '1' then
                    f_ang_idx <= f_ang_idx - 1;
                elsif btn(3) = '1' then
                    f_ang_idx <= f_ang_idx + 1;
                end if;

                -- move
                if (btn(0) = '1') or (btn(2) = '1') then
                    v_dx := resize(shift_right(k_cos16(to_integer(f_ang_idx)), k_step_shift), 16);
                    v_dy := resize(shift_right(k_sin16(to_integer(f_ang_idx)), k_step_shift), 16);
                    if btn(2) = '1' then  -- back
                        f_px <= f_px - v_dx;
                        f_py <= f_py - v_dy;
                    else                  -- forward
                        f_px <= f_px + v_dx;
                        f_py <= f_py + v_dy;
                    end if;
                end if;

                -- crude bounds clamp to 0..15.999
                if f_px < to_signed(0,16) then f_px <= to_signed(0,16); end if;
                if f_py < to_signed(0,16) then f_py <= to_signed(0,16); end if;
                if f_px > to_signed(k_max_x*1024,16) then f_px <= to_signed(k_max_x*1024,16); end if;
                if f_py > to_signed(k_max_y*1024,16) then f_py <= to_signed(k_max_y*1024,16); end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Pack state onto trigger buses (stateless scopeFace will decode)
    --  trigger_volt[9:0] = px[15:6]  (Q4.6)  with bits[1:0] overwritten by angle[1:0]
    --  trigger_time[9:0] = py[15:6]  (Q4.6)  with bits[1:0] overwritten by angle[3:2]
    --------------------------------------------------------------------------
    p_pack : process(f_px, f_py, f_ang_idx)
        variable v_px_q46 : unsigned(9 downto 0);
        variable v_py_q46 : unsigned(9 downto 0);
        variable v_a      : unsigned(3 downto 0);
    begin
        v_px_q46 := unsigned(std_logic_vector(f_px(15 downto 6)));
        v_py_q46 := unsigned(std_logic_vector(f_py(15 downto 6)));
        v_a      := f_ang_idx;

        v_px_q46(1 downto 0) := v_a(1 downto 0);
        v_py_q46(1 downto 0) := v_a(3 downto 2);

        f_trigger_volt <= v_px_q46;
        f_trigger_time <= v_py_q46;
    end process;

    --------------------------------------------------------------------------
    -- Video path (unchanged)
    --------------------------------------------------------------------------
    u_video: video
        port map(
            clk          => clk,
            reset_n      => reset_n,
            tmds         => tmds,
            tmdsb        => tmdsb,
            trigger_time => f_trigger_time,
            trigger_volt => f_trigger_volt,
            row          => w_row,
            column       => w_column,
            ch1          => w_ch1,
            ch1_enb      => switch(0),
            ch2          => w_ch2,
            ch2_enb      => switch(1)
        );

    --------------------------------------------------------------------------
    -- Lab2 FSM/bus compatibility
    --------------------------------------------------------------------------
    sw        <= "000";
    LBus_out  <= (others => '0');
    RBus_out  <= (others => '0');

    u_flag: FlagRegister
        port map(
            clk     => clk,
            reset_n => reset_n,
            set     => '0',
            clear   => flagClear,
            Q       => '0',
            flagQ   => flagQ
        );

    -- Inert audio/I2C
    ac_mclk      <= '0';
    ac_dac_sdata <= '0';
    ac_bclk      <= '0';
    ac_lrclk     <= '0';
end Behavioral;
