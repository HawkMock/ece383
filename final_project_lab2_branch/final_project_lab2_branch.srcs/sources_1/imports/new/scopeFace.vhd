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
--| FILENAME      : scopeFace.vhd
--| AUTHOR(S)     : C1C Dustin Mock 
--| CREATED       : 2025-10-19
--| DESCRIPTION   : Stateless, purely combinational column raycaster for Lab2.
--|                 Two debug views are available and can be forced via the
--|                 k_force_debug constant below, or selected with ch1_enb/
--|                 ch2_enb when wired:
--|                   Debug A: column/row ramp
--|                   Debug B: 8 FOV stripes
--|                 A white border is always overlaid on the active area to
--|                 validate row/column coverage.
--|
--| DOCUMENTATION : ChatGPT was used at points to modify and review code.
--|                 Example files from the course (e.g., 2-bit color code)
--|                 were referenced for palette/tint guidance.
--|                 
--| TODO:          None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : VGA.vhd, video.vhdl, synch_blank.vhd, dvid.vhd
--|
--+----------------------------------------------------------------------------
--| NAMING CONVENTIONS : xb_, xi_, xo_, b_, i_, o_, c_, f_, ff_, *_n, w_, g_, k_, v_, sm_, s_
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scopeFace is
    Port (
        i_row          : in  unsigned(9 downto 0);
        i_column       : in  unsigned(9 downto 0);
        i_trigger_volt : in  unsigned(9 downto 0); -- px[9:0], low2=angle[1:0]
        i_trigger_time : in  unsigned(9 downto 0); -- py[9:0], low2=angle[3:2]
        o_R            : out std_logic_vector(7 downto 0);
        o_G            : out std_logic_vector(7 downto 0);
        o_B            : out std_logic_vector(7 downto 0);
        i_ch1          : in  std_logic;            -- unused
        i_ch1_enb      : in  std_logic;            -- SW0: Debug A
        i_ch2          : in  std_logic;            -- unused
        i_ch2_enb      : in  std_logic             -- SW1: Debug B
    );
end scopeFace;

architecture scopeFace_arch of scopeFace is
    -- Screen constants (VGA timing in Lab2)
    constant k_w_active  : integer := 640;
    constant k_h_active  : integer := 480;
    constant k_h_mid     : integer := k_h_active/2;

    -- Debug control: 0=raycaster, 1=ramp, 2=stripes (override switches)
    constant k_force_debug : integer := 1;  -- << set to 1 to force ramp test

    -- Fixed-point types
    subtype t_q6_10 is signed(15 downto 0);
    subtype t_q1_15 is signed(15 downto 0);
    subtype t_u10   is unsigned(9 downto 0);

    -- 16-dir trig LUT (Q1.15)
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

    -- Simple 16×16 maze (1=wall)
    type t_map is array(0 to 15, 0 to 15) of std_logic_vector(3 downto 0);
    constant k_map : t_map := (
        (x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"1",x"0",x"0",x"0",x"1",x"0",x"0",x"1",x"0",x"1",x"0",x"1",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"1",x"0",x"0",x"0",x"1",x"0",x"0",x"1",x"0",x"1",x"0",x"1",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"0",x"1",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"1"),
        (x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1",x"1")
    );

    -- helpers
    function f_abs_q15(a : t_q1_15) return unsigned is
        variable v_s : signed(15 downto 0) := a;
    begin
        if v_s < 0 then v_s := -v_s; end if;
        return unsigned(v_s);
    end function;

    function clamp10(i_x : integer) return t_u10 is
        variable v_x : integer := i_x;
    begin
        if v_x < 0 then v_x := 0;
        elsif v_x > 1023 then v_x := 1023;
        end if;
        return to_unsigned(v_x, 10);
    end function;

    constant k_max_iter : integer := 24;  -- keep logic shallow
    constant k_fov_bins : integer := 8;   -- coarse FOV across screen

begin
    ----------------------------------------------------------------------------
    -- Purely combinational pixel shader with two debug modes
    ----------------------------------------------------------------------------
    p_shader : process(i_row, i_column, i_trigger_volt, i_trigger_time, i_ch1_enb, i_ch2_enb)
        -- decoded state
        variable v_px_q46, v_py_q46 : unsigned(9 downto 0);
        variable v_ang              : unsigned(3 downto 0);
        variable v_px, v_py         : t_q6_10;
        -- col/FOV
        variable v_col_idx          : integer;
        variable v_bin, v_ridx      : integer;
        variable v_dirx, v_diry     : t_q1_15;
        variable v_absdx, v_absdy   : unsigned(15 downto 0);
        -- DDA
        variable v_cell_x, v_cell_y : integer;
        variable v_accx, v_accy     : unsigned(31 downto 0);
        variable v_steps            : integer;
        variable v_hit              : boolean;
        variable v_side_x           : boolean;
        -- results
        variable v_height, v_top_v, v_bot_v : integer;
        variable v_face4            : std_logic_vector(3 downto 0);
        variable v_top10, v_bot10   : t_u10;
        -- output color
        variable v_R, v_G, v_B      : std_logic_vector(7 downto 0);
        -- debug temps
        variable v_col8, v_row8, v_xor8 : std_logic_vector(7 downto 0);
        -- effective debug mode (constant can override switches)
        variable v_dbg_mode         : integer;
    begin
        -- defaults (ceiling)
        v_R := x"10"; v_G := x"10"; v_B := x"18";

        -- choose debug source
        if    (k_force_debug = 1) then v_dbg_mode := 1;
        elsif (k_force_debug = 2) then v_dbg_mode := 2;
        elsif (i_ch1_enb = '1')   then v_dbg_mode := 1; -- ramp via SW0 when wired
        elsif (i_ch2_enb = '1')   then v_dbg_mode := 2; -- stripes via SW1 when wired
        else                           v_dbg_mode := 0;
        end if;

        -- Debug A: column/row ramp
        if (v_dbg_mode = 1) then
            v_col8 := std_logic_vector(i_column(7 downto 0));
            v_row8 := std_logic_vector(i_row(7 downto 0));
            v_xor8 := v_col8 xor v_row8;
            v_R := v_col8; v_G := v_row8; v_B := v_xor8;

        -- Debug B: 8 FOV stripes
        elsif (v_dbg_mode = 2) then
            v_col_idx := to_integer(i_column);
            v_bin  := (v_col_idx * k_fov_bins) / k_w_active;
            case v_bin is
                when 0 => v_R := x"FF"; v_G := x"00"; v_B := x"00";
                when 1 => v_R := x"FF"; v_G := x"80"; v_B := x"00";
                when 2 => v_R := x"FF"; v_G := x"FF"; v_B := x"00";
                when 3 => v_R := x"00"; v_G := x"FF"; v_B := x"00";
                when 4 => v_R := x"00"; v_G := x"FF"; v_B := x"FF";
                when 5 => v_R := x"00"; v_G := x"80"; v_B := x"FF";
                when 6 => v_R := x"00"; v_G := x"00"; v_B := x"FF";
                when others => v_R := x"80"; v_G := x"00"; v_B := x"FF";
            end case;

        -- Else: normal raycaster path
        else
            -- -------- decode packed state (from datapath) --------
            v_px_q46 := i_trigger_volt;
            v_py_q46 := i_trigger_time;
            v_ang    := i_trigger_time(1 downto 0) & i_trigger_volt(1 downto 0); -- [3:2]|[1:0]

            -- rebuild Q6.10 approx from Q4.6 (drop 6 LSBs)
            v_px := signed(std_logic_vector(v_px_q46 & "000000"));
            v_py := signed(std_logic_vector(v_py_q46 & "000000"));

            -- -------- per-column FOV spread --------
            v_col_idx := to_integer(i_column);                       -- 0..639 in active
            v_bin  := (v_col_idx * k_fov_bins) / k_w_active - (k_fov_bins/2);
            v_ridx := (to_integer(v_ang) + v_bin) mod 16;
            if v_ridx < 0 then v_ridx := v_ridx + 16; end if;

            v_dirx  := k_cos16(v_ridx);
            v_diry  := k_sin16(v_ridx);
            v_absdx := f_abs_q15(v_dirx);
            v_absdy := f_abs_q15(v_diry);

            -- -------- DDA (bounded, synth-friendly) --------
            v_cell_x := to_integer(shift_right(v_px,10));
            v_cell_y := to_integer(shift_right(v_py,10));
            v_accx   := (others => '0');
            v_accy   := (others => '0');
            v_steps  := 0;
            v_hit    := false;
            v_side_x := false;

            for v_i in 0 to k_max_iter-1 loop
                if v_accx <= v_accy then
                    if v_dirx >= 0 then v_cell_x := v_cell_x + 1; else v_cell_x := v_cell_x - 1; end if;
                    v_accx := v_accx + resize(v_absdy,32);
                    v_side_x := true;
                else
                    if v_diry >= 0 then v_cell_y := v_cell_y + 1; else v_cell_y := v_cell_y - 1; end if;
                    v_accy := v_accy + resize(v_absdx,32);
                    v_side_x := false;
                end if;

                -- check hit at the *new* cell; if hit, record steps and exit
                if (v_cell_x < 0) or (v_cell_x > 15) or (v_cell_y < 0) or (v_cell_y > 15) then
                    v_steps := v_i + 1; v_hit := true; exit;
                elsif k_map(v_cell_y, v_cell_x) /= x"0" then
                    v_steps := v_i + 1; v_hit := true; exit;
                else
                    v_steps := v_i + 1; -- keep progress
                end if;
            end loop;

            -- -------- height from steps (coarse; clamp) --------
            if (v_steps = 0) then
                v_height := k_h_active - 1;
            else
                v_height := 360 / (v_steps + 8);
                if v_height < 4 then v_height := 4; end if;
                if v_height > (k_h_active-2) then v_height := k_h_active-2; end if;
            end if;

            v_top_v := k_h_mid - (v_height/2);
            v_bot_v := k_h_mid + (v_height/2);
            if v_top_v < 0 then v_top_v := 0; end if;
            if v_bot_v > (k_h_active-1) then v_bot_v := k_h_active-1; end if;

            -- face tint
            if v_side_x then
                if v_dirx >= 0 then v_face4 := "0011"; else v_face4 := "0001"; end if; -- E/W
            else
                if v_diry >= 0 then v_face4 := "1110"; else v_face4 := "1000"; end if; -- S/N
            end if;

            v_top10 := clamp10(v_top_v);
            v_bot10 := clamp10(v_bot_v);

            -- -------- shade current pixel row --------
            if (i_row >= v_top10) and (i_row <= v_bot10) then
                case v_face4 is
                    when "1000" => v_R := x"CC"; v_G := x"20"; v_B := x"20"; -- North
                    when "0001" => v_R := x"20"; v_G := x"40"; v_B := x"CC"; -- West
                    when "0011" => v_R := x"20"; v_G := x"CC"; v_B := x"40"; -- East
                    when others => v_R := x"CC"; v_G := x"CC"; v_B := x"40"; -- South/other
                end case;
            elsif (i_row > v_bot10) then
                v_R := x"20"; v_G := x"20"; v_B := x"28";                     -- floor
            end if;
        end if;

        -- Always-on diagnostics: draw a white border around active area
        if (to_integer(i_column) = 0) or (to_integer(i_column) = k_w_active-1) or
           (to_integer(i_row)    = 0) or (to_integer(i_row)    = k_h_active-1) then
            v_R := x"FF"; v_G := x"FF"; v_B := x"FF";
        end if;

        -- Drive outputs
        o_R <= v_R; o_G <= v_G; o_B <= v_B;
    end process;

end scopeFace_arch;
