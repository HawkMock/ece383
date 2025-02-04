library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_fsm is
    Port ( 
        clk : in STD_LOGIC;
        reset_n : in STD_LOGIC;
        btn_in : in STD_LOGIC;
        btn_out : out STD_LOGIC
    );
end debounce_fsm;

architecture Behavioral of debounce_fsm is

    -- State definitions
    type state_type is (STABLE_0, WAIT_0, STABLE_1, WAIT_1);
    signal current_state, next_state : state_type;

    -- Counter for debounce delay
    signal counter : unsigned(19 downto 0) := (others => '0'); -- 20-bit counter for delay
    constant DEBOUNCE_TIME : unsigned(19 downto 0) := to_unsigned(999999, 20); -- Assuming 50MHz clock, debounce time = 20ms

begin

    -- State transition process (sequential logic)
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                current_state <= STABLE_0;
                counter <= (others => '0');
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Next-state logic (combinational logic)
    process(current_state, btn_in, counter)
    begin
        next_state <= current_state; -- Default is to stay in the same state

        case current_state is
            when STABLE_0 =>
                if btn_in = '1' then
                    next_state <= WAIT_1;
                end if;
            
            when WAIT_1 =>
                if counter = DEBOUNCE_TIME then
                    next_state <= STABLE_1;
                end if;
            
            when STABLE_1 =>
                if btn_in = '0' then
                    next_state <= WAIT_0;
                end if;

            when WAIT_0 =>
                if counter = DEBOUNCE_TIME then
                    next_state <= STABLE_0;
                end if;

        end case;
    end process;

    -- Counter logic (increments only in WAIT states)
    process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' or current_state = STABLE_0 or current_state = STABLE_1 then
                counter <= (others => '0'); -- Reset counter
            elsif current_state = WAIT_0 or current_state = WAIT_1 then
                if counter < DEBOUNCE_TIME then
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    -- Output logic
    btn_out <= '1' when current_state = STABLE_1 else '0';

end Behavioral;
