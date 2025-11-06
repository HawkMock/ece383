--+----------------------------------------------------------------------------
--|
--| FILENAME      : lab2.vhd
--| DESCRIPTION   : Top-level wrapper for datapath on Nexys Video.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab2 is
    Port (
        xi_clk      : in  STD_LOGIC;
        xi_reset_n  : in  STD_LOGIC;
        xi_switch   : in  STD_LOGIC_VECTOR(3 downto 0);
        xi_btn      : in  STD_LOGIC_VECTOR(4 downto 0);
        xo_tmds     : out STD_LOGIC_VECTOR (3 downto 0);
        xo_tmdsb    : out STD_LOGIC_VECTOR (3 downto 0);
        xo_led      : out std_logic_vector(7 downto 0)
    );
end lab2;

architecture behavior of lab2 is
    component lab2_datapath is
        Port (
            i_clk      : in  STD_LOGIC;
            i_reset_n  : in  STD_LOGIC;
            i_btn      : in  STD_LOGIC_VECTOR(4 downto 0);
            i_switch   : in  STD_LOGIC_VECTOR(3 downto 0);
            o_tmds     : out STD_LOGIC_VECTOR (3 downto 0);
            o_tmdsb    : out STD_LOGIC_VECTOR (3 downto 0);
            o_led      : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    u_datapath : lab2_datapath
        port map(
            i_clk      => xi_clk,
            i_reset_n  => xi_reset_n,
            i_btn      => xi_btn,
            i_switch   => xi_switch,
            o_tmds     => xo_tmds,
            o_tmdsb    => xo_tmdsb,
            o_led      => xo_led
        );
end behavior;
