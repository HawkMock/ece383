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
--| AUTHOR(S)     : C1C Dustin Mock, Architect AI
--| CREATED       : 2025-08-10
--| DESCRIPTION   : Heavily pipelined (3-stage) column-based raycaster. This
--|                 version adds a second pipeline stage to guarantee timing
--|                 closure by breaking the critical path into three smaller,
--|                 manageable segments.
--|
--| DOCUMENTATION : Google Gemini was used at points to modify or review code.
--|                 
--| TODO:           None.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scopeFace is
    Port (
        i_clk          : in  STD_LOGIC;
        i_reset_n      : in  STD_LOGIC;
        i_row          : in  unsigned(9 downto 0);
        i_column       : in  unsigned(9 downto 0);
        i_trigger_volt : in  unsigned(9 downto 0);
        i_trigger_time : in  unsigned(9 downto 0);
        i_ch1_enb      : in  std_logic;
        i_ch2_enb      : in  std_logic;
        o_R            : out std_logic_vector(7 downto 0);
        o_G            : out std_logic_vector(7 downto 0);
        o_B            : out std_logic_vector(7 downto 0)
    );
end scopeFace;

architecture scopeFace_arch of scopeFace is
    constant k_w_active : integer := 640;
    constant k_h_active : integer := 480;
    constant k_h_mid    : integer := k_h_active / 2;
    constant k_force_debug : integer := 0;
    constant k_max_iter : integer := 31;
    
    subtype t_q6_10 is signed(15 downto 0);
    subtype t_q1_15 is signed(15 downto 0);
    subtype t_u10 is unsigned(9 downto 0);
    type t_lut16 is array(0 to 15) of t_q1_15;
    type t_map is array(0 to 15, 0 to 15) of std_logic;
    type t_height_lut is array(0 to k_max_iter) of integer;

    -- **FIXED**: Fully specified constant definitions
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
    constant k_map : t_map := (
        ('1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1'),
        ('1','0','0','0','0','0','0','0','0','1','0','0','0','0','0','1'),
        ('1','0','1','1','0','1','0','1','0','1','0','1','0','1','0','1'),
        ('1','0','0','0','0','0','0','1','0','0','0','1','0','1','0','1'),
        ('1','1','1','0','1','1','0','1','1','1','0','1','1','1','0','1'),
        ('1','0','0','0','0','1','0','0','0','1','0','0','0','0','0','1'),
        ('1','0','1','1','0','1','1','1','0','1','1','1','1','1','0','1'),
        ('1','0','0','0','0','0','0','0','0','0','0','0','0','0','0','1'),
        ('1','0','1','1','1','1','0','1','1','1','1','1','0','1','1','1'),
        ('1','0','0','0','0','0','0','1','0','0','0','0','0','1','0','1'),
        ('1','1','1','1','1','1','0','1','0','1','0','1','0','1','0','1'),
        ('1','0','0','0','0','0','0','0','0','1','0','1','0','1','0','1'),
        ('1','0','1','0','1','0','1','1','0','1','0','1','0','0','0','1'),
        ('1','0','1','0','1','0','0','0','0','1','0','0','0','1','0','1'),
        ('1','0','1','0','0','0','0','1','0','0','0','1','0','0','0','1'),
        ('1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1')
    );
    constant k_height_lut : t_height_lut := (
        480, 480, 480, 240, 160, 120, 96, 80, 68, 60, 53, 48, 43, 40, 36, 34,
         32,  30,  28,  26,  25,  24, 23, 22, 21, 20, 19, 18, 18, 17, 16, 16
    );
    
    function f_clamp10(i_val : integer) return t_u10 is
        variable v_val : integer := i_val;
    begin
        if v_val < 0 then v_val := 0; elsif v_val > 1023 then v_val := 1023; end if;
        return to_unsigned(v_val, 10);
    end function;
    function f_abs_q15(i_val : t_q1_15) return unsigned is
        variable v_val : signed(15 downto 0) := i_val;
    begin
        if v_val < 0 then v_val := -v_val; end if;
        return unsigned(v_val);
    end function;

    -- Stage 1 -> 2 signals
    signal c_hit         : std_logic;
    signal c_dist_steps  : natural range 0 to k_max_iter;
    signal c_side        : std_logic;
    signal c_step_x      : integer range -1 to 1;
    signal c_step_y      : integer range -1 to 1;

    -- Stage 2 pipeline registers (ff_)
    signal ff_hit         : std_logic;
    signal ff_dist_steps  : natural range 0 to k_max_iter;
    signal ff_side        : std_logic;
    signal ff_step_x      : integer range -1 to 1;
    signal ff_step_y      : integer range -1 to 1;

    -- Stage 2 -> 3 signals
    signal c_top_u10      : t_u10;
    signal c_bot_u10      : t_u10;

    -- Stage 3 pipeline registers (fff_)
    signal fff_hit        : std_logic;
    signal fff_side       : std_logic;
    signal fff_step_x     : integer range -1 to 1;
    signal fff_step_y     : integer range -1 to 1;
    signal fff_top_u10    : t_u10;
    signal fff_bot_u10    : t_u10;
    signal fff_row        : unsigned(9 downto 0);

begin

    p_raycast_stage1 : process(i_column, i_trigger_volt, i_trigger_time)
        variable v_px, v_py     : t_q6_10;
        variable v_ang_idx      : unsigned(3 downto 0);
        variable v_col_idx      : integer range 0 to k_w_active-1;
        variable v_ray_ang_idx  : natural range 0 to 15;
        variable v_dirx, v_diry : t_q1_15;
        variable v_map_x, v_map_y     : integer range -1 to 16;
        variable v_step_x, v_step_y   : integer range -1 to 1;
        variable v_side_dist_x, v_side_dist_y : unsigned(31 downto 0);
        variable v_delta_dist_x, v_delta_dist_y : unsigned(15 downto 0);
        variable v_hit          : boolean;
        variable v_side         : std_logic;
        variable v_dist_steps   : natural range 0 to k_max_iter;
    begin
        v_ang_idx := i_trigger_time(1 downto 0) & i_trigger_volt(1 downto 0);
        v_px := signed(i_trigger_volt(9 downto 2) & "00000000");
        v_py := signed(i_trigger_time(9 downto 2) & "00000000");

        v_col_idx     := to_integer(i_column);
        v_ray_ang_idx := (to_integer(v_ang_idx) + (v_col_idx - k_w_active/2)/80) mod 16;
        v_dirx := k_cos16(v_ray_ang_idx);
        v_diry := k_sin16(v_ray_ang_idx);
        
        v_map_x := to_integer(shift_right(v_px, 10));
        v_map_y := to_integer(shift_right(v_py, 10));
        v_hit   := false;
        v_dist_steps := 0;
        v_delta_dist_x := f_abs_q15(v_diry);
        v_delta_dist_y := f_abs_q15(v_dirx);

        if v_dirx < 0 then
            v_step_x := -1;
            v_side_dist_x := resize(unsigned(v_px(9 downto 0)) * v_delta_dist_x, 32);
        else
            v_step_x := 1;
            v_side_dist_x := resize((not unsigned(v_px(9 downto 0))) * v_delta_dist_x, 32);
        end if;
        if v_diry < 0 then
            v_step_y := -1;
            v_side_dist_y := resize(unsigned(v_py(9 downto 0)) * v_delta_dist_y, 32);
        else
            v_step_y := 1;
            v_side_dist_y := resize((not unsigned(v_py(9 downto 0))) * v_delta_dist_y, 32);
        end if;
        
        for i in 0 to k_max_iter-1 loop
            if not v_hit then
                if v_side_dist_x < v_side_dist_y then
                    v_side_dist_x := v_side_dist_x + resize(shift_left(v_delta_dist_x, 10), 32);
                    v_map_x := v_map_x + v_step_x;
                    v_side  := '1';
                else
                    v_side_dist_y := v_side_dist_y + resize(shift_left(v_delta_dist_y, 10), 32);
                    v_map_y := v_map_y + v_step_y;
                    v_side  := '0';
                end if;
                if (v_map_x >= 0 and v_map_x <= 15 and v_map_y >= 0 and v_map_y <= 15) then
                    if k_map(v_map_y, v_map_x) = '1' then v_hit := true; end if;
                else v_hit := true;
                end if;
                v_dist_steps := i + 1;
            end if;
        end loop;
        
        if v_hit then c_hit <= '1'; else c_hit <= '0'; end if;
        c_dist_steps  <= v_dist_steps;
        c_side        <= v_side;
        c_step_x      <= v_step_x;
        c_step_y      <= v_step_y;
    end process p_raycast_stage1;

    p_pipeline_stage2 : process(i_clk, i_reset_n)
        variable v_height, v_top, v_bot : integer;
    begin
        if i_reset_n = '0' then
            ff_hit        <= '0';
            ff_dist_steps <= 0;
            ff_side       <= '0';
            ff_step_x     <= 0;
            ff_step_y     <= 0;
            c_top_u10     <= (others => '1');
            c_bot_u10     <= (others => '0');
        elsif rising_edge(i_clk) then
            ff_hit        <= c_hit;
            ff_dist_steps <= c_dist_steps;
            ff_side       <= c_side;
            ff_step_x     <= c_step_x;
            ff_step_y     <= c_step_y;

            v_height := k_height_lut(ff_dist_steps);
            v_top    := k_h_mid - (v_height / 2);
            v_bot    := k_h_mid + (v_height / 2);
            c_top_u10 <= f_clamp10(v_top);
            c_bot_u10 <= f_clamp10(v_bot);
        end if;
    end process p_pipeline_stage2;

    p_pipeline_stage3 : process(i_clk, i_reset_n)
        variable v_R, v_G, v_B : std_logic_vector(7 downto 0);
    begin
        if i_reset_n = '0' then
            fff_hit     <= '0';
            fff_side    <= '0';
            fff_step_x  <= 0;
            fff_step_y  <= 0;
            fff_top_u10 <= (others => '1');
            fff_bot_u10 <= (others => '0');
            fff_row     <= (others => '0');
            o_R <= (others => '0');
            o_G <= (others => '0');
            o_B <= (others => '0');
        elsif rising_edge(i_clk) then
            fff_hit     <= ff_hit;
            fff_side    <= ff_side;
            fff_step_x  <= ff_step_x;
            fff_step_y  <= ff_step_y;
            fff_top_u10 <= c_top_u10;
            fff_bot_u10 <= c_bot_u10;
            fff_row     <= i_row;

            v_R := x"10"; v_G := x"10"; v_B := x"18";

            if (fff_hit = '1') and (fff_row >= fff_top_u10) and (fff_row <= fff_bot_u10) then
                if fff_side = '1' then
                    if fff_step_x = 1 then v_R := x"20"; v_G := x"CC"; v_B := x"40"; else v_R := x"20"; v_G := x"40"; v_B := x"CC"; end if;
                else
                    if fff_step_y = 1 then v_R := x"CC"; v_G := x"CC"; v_B := x"40"; else v_R := x"CC"; v_G := x"20"; v_B := x"20"; end if;
                end if;
            elsif (fff_row > fff_bot_u10) then
                v_R := x"20"; v_G := x"20"; v_B := x"28";
            end if;
            
            o_R <= v_R;
            o_G <= v_G;
            o_B <= v_B;
        end if;
    end process p_pipeline_stage3;

end scopeFace_arch;
