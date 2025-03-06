--------------------------------------------------------------------
-- Name:    George York (modified)
-- Date:    Feb 2, 2021 (modified per new spec)
-- File:    button_debounce.vhdl
-- HW:      Template for HW7
-- Crs:     ECE 383
--
-- Purp:    Button debouncer using a three-state FSM with a timer.
--          The FSM states (unpressed, timer, pressed) follow:
--
--          State 0 (unpressed):
--             if button=0, remain unpressed;
--             if button=1, transition to timer.
--
--          State 1 (timer):
--             While the timer (counter) is less than threshold (20 counts),
--             remain in timer.
--             When count ≥20:
--                if button=0, go to unpressed;
--                if button=1, go to pressed.
--
--          State 2 (pressed):
--             If button=1, remain pressed (action=1);
--             if button=0, transition to timer (to debounce the release).
--
--          Note: For a real 20ms delay at 100KHz you'd use 2000 counts.
--------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity button_debounce is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        button : in  std_logic;
        action : out std_logic
    );
end button_debounce;

architecture behavior of button_debounce is

   component lec10
      generic ( N: integer := 4 );
      port(
         clk   : in  std_logic;
         reset : in  std_logic;
         crtl  : in  std_logic_vector(1 downto 0);
         D     : in  unsigned(N-1 downto 0);
         Q     : out unsigned(N-1 downto 0)
      );
   end component;

    ----------------------------------------------------------------------------
    --  Define the three states: unpressed (0), timer (1), pressed (2)
    ----------------------------------------------------------------------------
    type state_type is (unpressed, timer, pressed);
    signal state      : state_type;
    signal prev_state : state_type;  -- to detect transitions

    ----------------------------------------------------------------------------
    --  Control word for counter:
    --    "11" => reset (load D),
    --    "01" => increment,
    --    "00" => hold.
    ----------------------------------------------------------------------------
    signal cw : std_logic_vector(1 downto 0) := (others => '0');

    ----------------------------------------------------------------------------
    --  We'll generate a one-cycle "timer reset" pulse when entering the timer state.
    ----------------------------------------------------------------------------
    signal timer_rst : std_logic := '0';

    ----------------------------------------------------------------------------
    --  Use a 5-bit counter for the timer (threshold = 20 counts).
    ----------------------------------------------------------------------------
    constant N         : integer := 11;
    constant THRESHOLD : unsigned(N-1 downto 0) := to_unsigned(20000, N);

    signal D : unsigned(N-1 downto 0) := (others => '0');
    signal Q : unsigned(N-1 downto 0);

    ----------------------------------------------------------------------------
    --  Comparator: produce '1' when Q is less than THRESHOLD.
    ----------------------------------------------------------------------------
    signal less : std_logic;
begin

    ----------------------------------------------------------------------------
    --  Process to record previous state (updated every clock cycle)
    ----------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            prev_state <= state;
        end if;
    end process;

    ----------------------------------------------------------------------------
    --  Generate a pulse (timer_rst) when entering the timer state.
    ----------------------------------------------------------------------------
    timer_rst <= '1' when (state = timer and prev_state /= timer) else '0';

    ----------------------------------------------------------------------------
    --  Counter control word (cw):
    --    When unpressed, reset counter.
    --    When entering timer, issue a one-cycle reset.
    --    While in timer (after reset), increment the counter.
    --    In the pressed state, reset the counter.
    ----------------------------------------------------------------------------
    cw <= "11" when (state = unpressed) else
          "11" when (state = timer and timer_rst = '1') else
          "01" when (state = timer) else
          "11";

    ----------------------------------------------------------------------------
    --  Instantiate the counter component (lec10)
    ----------------------------------------------------------------------------
    delay_counter: lec10
        generic map (
            N => N
        )
        port map (
            clk   => clk,
            reset => reset,
            crtl  => cw,
            D     => D,
            Q     => Q
        );

    -- For reset loads, tie D to zero.
    D <= (others => '0');

    ----------------------------------------------------------------------------
    --  Comparator: "less" is '1' when Q < THRESHOLD.
    ----------------------------------------------------------------------------
    less <= '1' when Q < THRESHOLD else '0';

    ----------------------------------------------------------------------------
    --  FSM: State Machine Process
    ----------------------------------------------------------------------------
    state_process: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                state <= unpressed;
            else
                case state is
                    ----------------------------------------------------------------
                    -- State 0: unpressed
                    --    button = 0: remain unpressed (output 0)
                    --    button = 1: go to timer state (output 0)
                    ----------------------------------------------------------------
                    when unpressed =>
                        if button = '1' then
                            state <= timer;
                        else
                            state <= unpressed;
                        end if;

                    ----------------------------------------------------------------
                    -- State 1: timer
                    --    While counter Q is less than threshold (i.e. count ≤20)
                    --    remain in timer.
                    --    When Q ≥ THRESHOLD:
                    --         if button = 0, go to unpressed;
                    --         if button = 1, go to pressed.
                    ----------------------------------------------------------------
                    when timer =>
                        if less = '1' then
                            state <= timer;
                        else  -- Q ≥ THRESHOLD
                            if button = '0' then
                                state <= unpressed;
                            else
                                state <= pressed;
                            end if;
                        end if;

                    ----------------------------------------------------------------
                    -- State 2: pressed
                    --    button = 1: remain pressed (output 1)
                    --    button = 0: transition to timer (to debounce the release)
                    ----------------------------------------------------------------
                    when pressed =>
                        if button = '0' then
                            state <= timer;
                        else
                            state <= pressed;
                        end if;

                    when others =>
                        state <= unpressed;
                end case;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    --  Output Equation:
    --    action = '1' only when in the pressed state.
    ----------------------------------------------------------------------------
    action <= '1' when state = pressed and prev_state = timer else '0';

end behavior;
