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
           o_R : out  std_logic_vector(7 downto 0);
           o_G : out  std_logic_vector(7 downto 0);
           o_B : out  std_logic_vector(7 downto 0);
           color: in  std_logic_vector(23 downto 0)
           );
end scopeFace;

architecture scopeFace_arch of scopeFace is

begin
    --|====> Assign Outputs <====|--
    o_R <= color(23 downto 16);
    o_G <= color(15 downto 8);
    o_B <= color(7 downto 0);

end scopeFace_arch;
