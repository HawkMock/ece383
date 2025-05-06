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
--| FILENAME      : VGA.vhd
--| AUTHOR(S)     : C2C Dustin Mock
--| CREATED       : 2025-01-24
--| DESCRIPTION   : This file implements the VGA portion of Lab1.
--|                 It instantiates 2 counters which count up to
--|                 800 and 525 to keep track of columns and rows
--|                 respectively.
--|
--| DOCUMENTATION : Used ChatGPT to implement generic:
--|                 https://chatgpt.com/share/67928cd6-285c-8012-8ea8-5e3a163fc26d
--| TODO:           Implement scopeFace (keeps track of what pixels
--|                 belong at each column-row combo).
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENTIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGA is
	Port(	i_clk: in  STD_LOGIC;
			i_reset_n : in  STD_LOGIC;
			o_h_synch : out  STD_LOGIC;
			o_v_synch : out  STD_LOGIC; 
			o_blank : out  STD_LOGIC;
			o_R: out STD_LOGIC_VECTOR(7 downto 0);
			o_G: out STD_LOGIC_VECTOR(7 downto 0);
			o_B: out STD_LOGIC_VECTOR(7 downto 0);
			o_row: out unsigned(9 downto 0);
			o_column: out unsigned(9 downto 0);
			color: in std_logic_vector(23 downto 0)
        );
end VGA;

architecture VGA_arch of VGA is
    --+====> Signal declarations <=====+--
    signal w_column: unsigned(9 downto 0) := (others => '0');
    signal w_row: unsigned(9 downto 0) := (others => '0');
    signal w_ctrl_column: STD_LOGIC := '1';
    signal w_ctrl_row: STD_LOGIC := '0';
    signal col_prev : unsigned(9 downto 0) := (others => '0');
    signal w_h_blank : STD_LOGIC := '1';
    signal w_v_blank : STD_LOGIC := '1';

    -- Signals for scopeFace outputs
    signal w_R: std_logic_vector(7 downto 0);
    signal w_G: std_logic_vector(7 downto 0);
    signal w_B: std_logic_vector(7 downto 0);
    
    --+====> Component declarations <=====+--
    component counter_baseN is
        generic (
            g_base   : natural := 5;
            g_bits   : natural := 3;
            g_initial: natural := 0
        );
        port (
            i_clk   : in  std_logic;
            i_reset : in  std_logic;
            i_ctrl  : in  std_logic;
            o_Q     : out unsigned(g_bits-1 downto 0)
        );
    end component;
    
    component synch_blank is
        port (
            i_clk     : in  std_logic;
            i_reset_n : in  std_logic;
            o_h_synch : out STD_LOGIC;
            o_h_blank : out STD_LOGIC;
            o_v_synch : out STD_LOGIC;
            o_v_blank : out STD_LOGIC;
            i_column  : in unsigned(9 downto 0);
            i_row     : in unsigned(9 downto 0)
        );
    end component;

begin
    --+====> Instantiate counters <=====+--
    column_counter : counter_baseN
        generic map (
            g_base    => 800,
            g_bits    => 10,
            g_initial => 0
        )
        port map (
            i_clk   => i_clk,
            i_reset => i_reset_n,
            i_ctrl  => w_ctrl_column,
            o_Q     => w_column
        );
        
    row_counter : counter_baseN
        generic map (
            g_base    => 525,
            g_bits    => 10,
            g_initial => 520
        )
        port map (
            i_clk   => i_clk,
            i_reset => i_reset_n,
            i_ctrl  => w_ctrl_row,
            o_Q     => w_row
        );
        
    --+====> Instantiate synch/blank module <=====+--
    synch_blank_inst : synch_blank
        port map (
            i_clk     => i_clk,
            i_reset_n => i_reset_n,
            o_h_synch => o_h_synch,
            o_h_blank => w_h_blank,
            o_v_synch => o_v_synch,
            o_v_blank => w_v_blank,
            i_column  => w_column,
            i_row     => w_row
        );

    --+====> Set w_ctrl_row when w_column = 799 <=====+--
    process(i_clk)
    begin
        if falling_edge(i_clk) then
            if (w_column = to_unsigned(799, 10)) then
                w_ctrl_row <= '1';
            else
                w_ctrl_row <= '0';
            end if;
        end if;
    end process;

    --+====> Output Assignments <=====+--
    o_row    <= w_row;
    o_column <= w_column;
    o_blank  <= '1' when (w_h_blank = '1' or w_v_blank = '1') else '0';

    -- Assign colors from raycastlib to VGA outputs
    o_R <= color(23 downto 16);
    o_G <= color(15 downto 8);
    o_B <= color(7 downto 0);

end VGA_arch;

