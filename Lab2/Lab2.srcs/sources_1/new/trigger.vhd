library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trigger is
    generic (
        bits          : integer := 10;
        initial_value : integer := 300;
        max_value     : integer := 600;
        min_value     : integer := 20;
        delta         : integer := 10
    );
    port (
        clk     : in  STD_LOGIC;
        reset_n : in  STD_LOGIC;
        btn_inc : in  STD_LOGIC;
        btn_dec : in  STD_LOGIC;
        value   : out unsigned(bits-1 downto 0)
    );
end trigger;

architecture Behavioral of trigger is
    signal current_value : unsigned(bits-1 downto 0) := to_unsigned(initial_value, bits);
begin
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            current_value <= to_unsigned(initial_value, bits);
        elsif rising_edge(clk) then
            if btn_inc = '1' then
                if current_value + to_unsigned(delta, bits) <= to_unsigned(max_value, bits) then
                    current_value <= current_value + to_unsigned(delta, bits);
                else
                    current_value <= to_unsigned(max_value, bits);
                end if;
            elsif btn_dec = '1' then
                if current_value >= to_unsigned(min_value + delta, bits) then
                    current_value <= current_value - to_unsigned(delta, bits);
                else
                    current_value <= to_unsigned(min_value, bits);
                end if;
            end if;
        end if;
    end process;
    
    value <= current_value;
end Behavioral;
