----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2025 11:29:56 AM
-- Design Name: 
-- Module Name: scopeFace - scopeFace_arch
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
use IEEE.NUMERIC_STD.ALL;


entity scopeFace is
    Port ( i_row : in  unsigned(9 downto 0);
           i_column : in  unsigned(9 downto 0);
           i_trigger_volt: in unsigned (9 downto 0);
           i_trigger_time: in unsigned (9 downto 0);
           o_R : out  std_logic_vector(7 downto 0);
           o_G : out  std_logic_vector(7 downto 0);
           o_B : out  std_logic_vector(7 downto 0);
           i_ch1: in std_logic;
           i_ch1_enb: in std_logic;
           i_ch2: in std_logic;
           i_ch2_enb: in std_logic);
end scopeFace;

architecture scopeFace_arch of scopeFace is
    signal w_color: STD_LOGIC_VECTOR(23 downto 0) := x"000000";

begin
    -- Assign color logic
    w_color <= x"FFFF00" when (i_ch1 = '1' and i_ch1_enb = '1') else  -- Channel 1, yellow
               x"0000FF" when (i_ch2 = '1' and i_ch2_enb = '1') else  -- Channel 2, blue
               x"FFFF00" when ((unsigned(i_column) - 20 - 5 + 220 + unsigned(i_trigger_volt)) <= unsigned(i_row) and
                              unsigned(i_row) <= (resize(220 + unsigned(i_trigger_volt), 10) - resize(unsigned(i_column) - 20 - 5, 10)) and
                              unsigned(i_column) >= 20 and unsigned(i_column) <= 30) else -- Trigger voltage arrow
               x"FFFF00" when ((unsigned(i_row) - 20 - 5 + 320 + unsigned(i_trigger_time)) <= unsigned(i_column) and
                              unsigned(i_column) <= (resize(320 + unsigned(i_trigger_time), 10) - resize(unsigned(i_row) - 20 - 5, 10)) and
                              unsigned(i_row) >= 20 and unsigned(i_row) <= 30) else -- Trigger time arrow
               x"ECECEC" when (((unsigned(i_column) - 20) mod 60 = 0) or ((unsigned(i_row) - 20) mod 50 = 0)) and
                              (20 <= unsigned(i_row) and unsigned(i_row) <= 420) and
                              (20 <= unsigned(i_column) and unsigned(i_column) <= 620) else -- Grid
               x"8383FF" when ((unsigned(i_row) - 20) mod 10 = 0) and (318 <= unsigned(i_column) and unsigned(i_column) <= 322) and
                              (20 <= unsigned(i_row) and unsigned(i_row) <= 420) else -- Hatch marks on y-axis
               x"83FF83" when ((unsigned(i_column) - 20) mod 15 = 0) and (218 <= unsigned(i_row) and unsigned(i_row) <= 222) and
                              (20 <= unsigned(i_column) and unsigned(i_column) <= 620) else -- Hatch marks on x-axis
               x"000000"; -- Default color

    -- Assigning color outputs
    o_R <= w_color(23 downto 16);
    o_G <= w_color(15 downto 8);
    o_B <= w_color(7 downto 0);

end scopeFace_arch;
