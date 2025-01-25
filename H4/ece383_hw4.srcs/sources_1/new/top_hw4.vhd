----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2025 09:00:13 PM
-- Design Name: 
-- Module Name: top_hw4 - top_hw4_arch
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_hw4 is
    Port ( clk, reset : in STD_LOGIC;
           ctrl : in STD_LOGIC;
           Q1, Q0 : out unsigned (2 downto 0));
end top_hw4;

architecture top_hw4_arch of top_hw4 is
    -- signal declarations
    signal w_Q0 : unsigned (2 downto 0);
    signal w_ctrl_1 : STD_LOGIC;
    
    -- component declarations
    component base5_counter
        Port ( i_clk : in STD_LOGIC;
               i_reset : in STD_LOGIC;
               i_ctrl : in STD_LOGIC;
               o_Q : out unsigned (2 downto 0));
    end component;
    
begin

    -- Instantiate 2 counters
    base5_counter_inst0 : base5_counter
        Port map (
            i_clk => clk,
            i_reset => reset,
            i_ctrl => ctrl,
            o_Q => w_Q0
        );
        
    base5_counter_inst1 : base5_counter
        Port map (
            i_clk => clk,
            i_reset => reset,
            i_ctrl => w_ctrl_1,
            o_Q => Q1
        );
        
    -- glue logic
    w_ctrl_1 <= '1' when (w_Q0(2) = '1') and (ctrl = '1') else '0';
    Q0 <= w_Q0;

end top_hw4_arch;
