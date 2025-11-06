-- rtl/reset_sync.vhd
library ieee;
use ieee.std_logic_1164.all;

entity reset_sync is
  generic ( G_ACTIVE_LOW : boolean := true );
  port (
    clk       : in  std_logic;
    rst_async : in  std_logic;  -- active-high async reset into this block
    rst_sync  : out std_logic   -- active-high synchronous reset
  );
end entity;

architecture rtl of reset_sync is
  signal ff1, ff2 : std_logic := '1';
begin
  process(clk, rst_async)
  begin
    if rst_async='1' then
      ff1 <= '1';
      ff2 <= '1';
    elsif rising_edge(clk) then
      ff1 <= '0';
      ff2 <= ff1;
    end if;
  end process;
  rst_sync <= ff2;
end architecture;
