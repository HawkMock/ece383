### Nexys Video Master XDC - Raycaster Project
### Board: Nexys Video Rev. A
### FPGA: XC7A200T-1SBG484C
### REVISION: Final corrected HDMI pin assignments.

## Clock Signal
set_property -dict { PACKAGE_PIN R4 IOSTANDARD LVCMOS33 } [get_ports { xi_clk }]; # 100MHz system clock
create_clock -period 10.000 [get_ports xi_clk]

## Buttons
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS12 } [get_ports { xi_reset_n }];
set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS12 } [get_ports { xi_btn[0] }]; # BTNU
set_property -dict { PACKAGE_PIN C22 IOSTANDARD LVCMOS12 } [get_ports { xi_btn[1] }]; # BTNL
set_property -dict { PACKAGE_PIN D22 IOSTANDARD LVCMOS12 } [get_ports { xi_btn[2] }]; # BTND
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS12 } [get_ports { xi_btn[3] }]; # BTNR
set_property -dict { PACKAGE_PIN B22 IOSTANDARD LVCMOS12 } [get_ports { xi_btn[4] }]; # BTNC

## Switches
set_property -dict { PACKAGE_PIN E22 IOSTANDARD LVCMOS12 } [get_ports { xi_switch[0] }];
set_property -dict { PACKAGE_PIN F21 IOSTANDARD LVCMOS12 } [get_ports { xi_switch[1] }];
set_property -dict { PACKAGE_PIN G21 IOSTANDARD LVCMOS12 } [get_ports { xi_switch[2] }];
set_property -dict { PACKAGE_PIN G22 IOSTANDARD LVCMOS12 } [get_ports { xi_switch[3] }];

## LEDs
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS25 } [get_ports { xo_led[0] }];
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS25 } [get_ports { xo_led[1] }];
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS25 } [get_ports { xo_led[2] }];
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS25 } [get_ports { xo_led[3] }];
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS25 } [get_ports { xo_led[4] }];
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS25 } [get_ports { xo_led[5] }];
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS25 } [get_ports { xo_led[6] }];
set_property -dict { PACKAGE_PIN Y13 IOSTANDARD LVCMOS25 } [get_ports { xo_led[7] }];

## HDMI Output Port (Corrected Pins per Nexys Video RM)
# DVI/HDMI Spec: TMDS_D2 = Red, TMDS_D1 = Green, TMDS_D0 = Blue
set_property -dict { PACKAGE_PIN W1  IOSTANDARD TMDS_33 } [get_ports { xo_tmds[0] }];  # TMDS_D0_P (Blue)
set_property -dict { PACKAGE_PIN Y1  IOSTANDARD TMDS_33 } [get_ports { xo_tmdsb[0] }]; # TMDS_D0_N (Blue)
set_property -dict { PACKAGE_PIN AA1 IOSTANDARD TMDS_33 } [get_ports { xo_tmds[1] }];  # TMDS_D1_P (Green)
set_property -dict { PACKAGE_PIN AB1 IOSTANDARD TMDS_33 } [get_ports { xo_tmdsb[1] }]; # TMDS_D1_N (Green)
set_property -dict { PACKAGE_PIN AB2 IOSTANDARD TMDS_33 } [get_ports { xo_tmds[2] }];  # TMDS_D2_P (Red) - CORRECTED
set_property -dict { PACKAGE_PIN AC2 IOSTANDARD TMDS_33 } [get_ports { xo_tmdsb[2] }]; # TMDS_D2_N (Red) - CORRECTED
set_property -dict { PACKAGE_PIN T1  IOSTANDARD TMDS_33 } [get_ports { xo_tmds[3] }];  # TMDS_CLK_P
set_property -dict { PACKAGE_PIN U1  IOSTANDARD TMDS_33 } [get_ports { xo_tmdsb[3] }]; # TMDS_CLK_N
