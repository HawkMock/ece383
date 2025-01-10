----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2025 08:09:09 AM
-- Design Name: 
-- Module Name: priority_encoder - priority_encoder_arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity priority_encoder is
    Port ( i_input : in STD_LOGIC_VECTOR (3 downto 0);
           o_output : out STD_LOGIC_VECTOR (1 downto 0));
end priority_encoder;

architecture priority_encoder_arch of priority_encoder is

begin
    o_output(1) <= i_input(3) or i_input(2);
    o_output(0) <= i_input(3) or i_input(1);

end priority_encoder_arch;
