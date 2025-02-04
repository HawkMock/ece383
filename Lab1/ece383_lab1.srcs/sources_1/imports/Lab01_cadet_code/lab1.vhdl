----------------------------------------------------------------------------------
--	Put proper documentation here
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab1 is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           btn: in  STD_LOGIC_VECTOR(4 downto 0);
           switch: in STD_LOGIC_VECTOR(1 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end lab1;

architecture structure of lab1 is

    signal trigger_time, trigger_volt, row, column: unsigned(9 downto 0) := (others => '0');
    signal ch1_wave, ch2_wave: std_logic;
    
    signal debounced_btn: std_logic_vector(4 downto 0);
    signal counter_50Hz: unsigned(19 downto 0) := (others => '0');
    signal tick_50Hz: std_logic := '0';

    component video is
        Port ( clk : in  STD_LOGIC;
               reset_n : in  STD_LOGIC;
               tmds : out  STD_LOGIC_VECTOR (3 downto 0);
               tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
               trigger_time: in unsigned(9 downto 0);
               trigger_volt: in unsigned (9 downto 0);
               row: out unsigned(9 downto 0);
               column: out unsigned(9 downto 0);
               ch1: in std_logic;
               ch1_enb: in std_logic;
               ch2: in std_logic;
               ch2_enb: in std_logic);
    end component;

    -- Debounce FSM
    component debounce_fsm is
        Port ( clk : in STD_LOGIC;
               reset_n : in STD_LOGIC;
               btn_in : in STD_LOGIC;
               btn_out : out STD_LOGIC);
    end component;

begin

    -- Instantiate debouncer FSMs for each button
    debounce_btn0: debounce_fsm port map (clk => clk, reset_n => reset_n, btn_in => btn(0), btn_out => debounced_btn(0));
    debounce_btn1: debounce_fsm port map (clk => clk, reset_n => reset_n, btn_in => btn(1), btn_out => debounced_btn(1));
    debounce_btn2: debounce_fsm port map (clk => clk, reset_n => reset_n, btn_in => btn(2), btn_out => debounced_btn(2));
    debounce_btn3: debounce_fsm port map (clk => clk, reset_n => reset_n, btn_in => btn(3), btn_out => debounced_btn(3));

    -- Adjust trigger_time and trigger_volt when button is pressed at 50Hz
    process(clk)
    begin
        if rising_edge(clk) then
            if btn(0) = '1' then
                trigger_volt <= trigger_volt + 1;
            elsif btn(2) = '1' then
                trigger_volt <= trigger_volt - 1;
            end if;

            if btn(3) = '1' then
                trigger_time <= trigger_time + 1;
            elsif btn(1) = '1' then
                trigger_time <= trigger_time - 1;
            end if;
        end if;
    end process;
    
    -- Implement waveform logic
    ch1_wave <= '1' when (row = column) else '0'; -- y = x
    ch2_wave <= '1' when (row = 440 - column) else '0'; -- y = -x + 440

    -- Instantiate video module
    video_inst: video port map( 
        clk => clk,
        reset_n => reset_n,
        tmds => tmds,
        tmdsb => tmdsb,
        trigger_time => trigger_time,
        trigger_volt => trigger_volt,
        row => row, 
        column => column,
        ch1 => ch1_wave,
        ch1_enb => switch(0),
        ch2 => ch2_wave,
        ch2_enb => switch(1));

end structure;

