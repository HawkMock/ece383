--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
--Date        : Mon Aug 18 21:21:27 2025
--Host        : C26-5CG2151GFM running 64-bit major release  (build 9200)
--Command     : generate_target system_wrapper.bd
--Design      : system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_wrapper is
  port (
    DDR3_0_addr : out STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR3_0_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR3_0_cas_n : out STD_LOGIC;
    DDR3_0_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    DDR3_0_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_ras_n : out STD_LOGIC;
    DDR3_0_reset_n : out STD_LOGIC;
    DDR3_0_we_n : out STD_LOGIC;
    btn : in STD_LOGIC_VECTOR ( 4 downto 0 );
    hdmi_tx_clk_n : out STD_LOGIC;
    hdmi_tx_clk_p : out STD_LOGIC;
    hdmi_tx_d_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    hdmi_tx_d_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    reset : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC
  );
end system_wrapper;

architecture STRUCTURE of system_wrapper is
  component system is
  port (
    hdmi_tx_d_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    hdmi_tx_clk_n : out STD_LOGIC;
    hdmi_tx_d_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    hdmi_tx_clk_p : out STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    sys_clock : in STD_LOGIC;
    reset : in STD_LOGIC;
    DDR3_0_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    DDR3_0_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_addr : out STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR3_0_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR3_0_ras_n : out STD_LOGIC;
    DDR3_0_cas_n : out STD_LOGIC;
    DDR3_0_we_n : out STD_LOGIC;
    DDR3_0_reset_n : out STD_LOGIC;
    DDR3_0_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_0_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_0_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    btn : in STD_LOGIC_VECTOR ( 4 downto 0 );
    reset_n : in STD_LOGIC
  );
  end component system;
begin
system_i: component system
     port map (
      DDR3_0_addr(14 downto 0) => DDR3_0_addr(14 downto 0),
      DDR3_0_ba(2 downto 0) => DDR3_0_ba(2 downto 0),
      DDR3_0_cas_n => DDR3_0_cas_n,
      DDR3_0_ck_n(0) => DDR3_0_ck_n(0),
      DDR3_0_ck_p(0) => DDR3_0_ck_p(0),
      DDR3_0_cke(0) => DDR3_0_cke(0),
      DDR3_0_dm(1 downto 0) => DDR3_0_dm(1 downto 0),
      DDR3_0_dq(15 downto 0) => DDR3_0_dq(15 downto 0),
      DDR3_0_dqs_n(1 downto 0) => DDR3_0_dqs_n(1 downto 0),
      DDR3_0_dqs_p(1 downto 0) => DDR3_0_dqs_p(1 downto 0),
      DDR3_0_odt(0) => DDR3_0_odt(0),
      DDR3_0_ras_n => DDR3_0_ras_n,
      DDR3_0_reset_n => DDR3_0_reset_n,
      DDR3_0_we_n => DDR3_0_we_n,
      btn(4 downto 0) => btn(4 downto 0),
      hdmi_tx_clk_n => hdmi_tx_clk_n,
      hdmi_tx_clk_p => hdmi_tx_clk_p,
      hdmi_tx_d_n(2 downto 0) => hdmi_tx_d_n(2 downto 0),
      hdmi_tx_d_p(2 downto 0) => hdmi_tx_d_p(2 downto 0),
      reset => reset,
      reset_n => reset_n,
      sys_clock => sys_clock,
      usb_uart_rxd => usb_uart_rxd,
      usb_uart_txd => usb_uart_txd
    );
end STRUCTURE;
