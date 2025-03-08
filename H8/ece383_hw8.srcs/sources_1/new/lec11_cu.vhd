----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 08:44:09 AM
-- Design Name: 
-- Module Name: lec11_cu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment if using numeric functions
-- use IEEE.NUMERIC_STD.ALL;

entity lec11_cu is
    Port(   
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        cw     : out std_logic_vector(3 downto 0);
        sw     : in  std_logic;
        kbclk  : in  std_logic;
        busy   : out std_logic
    );
end lec11_cu;

architecture Behavioral of lec11_cu is
    -- Enumerated type for FSM states.
    type state_type is (
        idle, 
        wait_state,
        busy_init, 
        comp, 
        wait1, 
        shift, 
        wait2, 
        inc, 
        out_state
    );
    signal current_state, next_state : state_type;
begin

    -- Synchronous state register with asynchronous reset.
    process(clk, reset)
    begin
        if reset = '0' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state and output logic.
    process(current_state, kbclk, sw)
    begin
        -- Default assignments (will be overridden in each state)
        cw       <= "0000";
        busy     <= '0';
        next_state <= current_state;  -- default is to hold state

        case current_state is

            when idle =>
                cw   <= "0000";
                busy <= '0';
                next_state <= wait_state;  -- always transition to wait_state

            when wait_state =>
                cw   <= "0000";
                busy <= '0';
                -- Use kbclk to choose next state.
                if kbclk = '1' then
                    next_state <= wait_state;  -- remain in wait_state
                elsif kbclk = '0' then
                    next_state <= busy_init;
                end if;

            when busy_init =>
                cw   <= "0011";
                busy <= '1';
                next_state <= comp;  -- always move to comp

            when comp =>
                cw   <= "0000";
                busy <= '1';
                if sw = '1' then
                    next_state <= out_state;
                else  -- when sw = '0'
                    next_state <= wait1;
                end if;

            when wait1 =>
                cw   <= "0000";
                busy <= '1';
                if kbclk = '1' then
                    next_state <= wait1;  -- remain in wait1
                elsif kbclk = '0' then
                    next_state <= shift;
                end if;

            when shift =>
                cw   <= "0100";
                busy <= '1';
                next_state <= wait2;  -- always go to wait2

            when wait2 =>
                cw   <= "0000";
                busy <= '1';
                if kbclk = '1' then
                    next_state <= inc;
                elsif kbclk = '0' then
                    next_state <= wait2;  -- remain in wait2
                end if;

            when inc =>
                cw   <= "0001";
                busy <= '1';
                next_state <= comp;

            when out_state =>
                cw   <= "1000";
                busy <= '1';
                next_state <= idle;

            when others =>
                next_state <= idle;
        end case;
    end process;

end Behavioral;
