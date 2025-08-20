## System clock (100 MHz on R4)
set_property PACKAGE_PIN R4      [get_ports sys_clock]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
#create_clock -name sys_clk_100 -period 10.000 [get_ports sys_clock]

## CPU reset button on G4 (Bank 35 is 1.5 V)
set_property PACKAGE_PIN G4       [get_ports reset]
set_property IOSTANDARD LVCMOS15  [get_ports reset]

## USB-UART (FPGA<->FTDI, correct mapping)
set_property IOSTANDARD LVCMOS33 [get_ports usb_uart_rxd]
set_property PACKAGE_PIN V18      [get_ports usb_uart_rxd]  ;# FPGA RXD  <= FTDI TXD

set_property IOSTANDARD LVCMOS33 [get_ports usb_uart_txd]
set_property PACKAGE_PIN AA19     [get_ports usb_uart_txd]  ;# FPGA TXD  => FTDI RXD

## HDMI Source (J8) TMDS outputs (keep these)
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_p}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_n}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_d_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_d_n[*]}]
set_property PACKAGE_PIN  T1 [get_ports  hdmi_tx_clk_p]
set_property PACKAGE_PIN  U1 [get_ports  hdmi_tx_clk_n]
set_property PACKAGE_PIN  W1 [get_ports {hdmi_tx_d_p[0]}]
set_property PACKAGE_PIN  Y1 [get_ports {hdmi_tx_d_n[0]}]
set_property PACKAGE_PIN AA1 [get_ports {hdmi_tx_d_p[1]}]
set_property PACKAGE_PIN AB1 [get_ports {hdmi_tx_d_n[1]}]
set_property PACKAGE_PIN AB3 [get_ports {hdmi_tx_d_p[2]}]
set_property PACKAGE_PIN AB2 [get_ports {hdmi_tx_d_n[2]}]

## I2C - comment these two unless you actually expose these ports
# set_property PACKAGE_PIN W5      [get_ports scl]
# set_property IOSTANDARD LVCMOS33 [get_ports scl]
# set_property PACKAGE_PIN V5      [get_ports sda]
# set_property IOSTANDARD LVCMOS33 [get_ports sda]

## --- Fix TIMING-6 / TIMING-7: unrelated clock domains
# If these clock names exist in your build, cut timing between them.
if {[llength [get_clocks -quiet clk_ref_200_system_clk_wiz_0_0]] && \
    [llength [get_clocks -quiet clk_pll_i_1]]} {
  set_clock_groups -asynchronous \
    -group [get_clocks clk_ref_200_system_clk_wiz_0_0] \
    -group [get_clocks clk_pll_i_1]
}

## --- Quiet "Missing input/output delay" on async board IO
# Buttons and reset: asynchronous to fabric
set_false_path -from [get_ports {btn[*]}]
set_false_path -from [get_ports reset]

# UART: board-level async (FTDI), not timed to sys_clock
set_false_path -from [get_ports usb_uart_rxd]
set_false_path -to   [get_ports usb_uart_txd]

# DDR3 reset_n is not a timed interface signal
if {[llength [get_ports -quiet DDR3_0_reset_n]]} {
  set_false_path -to [get_ports DDR3_0_reset_n]
}

# Optional: I2C lines, if you actually expose them
#if {[llength [get_ports -quiet scl]]} { set_false_path -from [get_ports scl] }
#if {[llength [get_ports -quiet sda]]} { set_false_path -from [get_ports sda] }

## Buttons / reset (3.3V)
set_property -dict { PACKAGE_PIN B22 IOSTANDARD LVCMOS33 } [get_ports { btn[4] }]; # center
set_property -dict { PACKAGE_PIN D22 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; # down
set_property -dict { PACKAGE_PIN C22 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; # left
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; # right
set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; # up
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports { reset_n }]; # cpu_resetn
