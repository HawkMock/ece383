set_property SRC_FILE_INFO {cfile:X:/final_project_v4.srcs/constrs_1/new/nexys_hdmi.xdc rfile:../../../final_project_v4.srcs/constrs_1/new/nexys_hdmi.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R4      [get_ports sys_clock]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G4       [get_ports reset]
set_property src_info {type:XDC file:1 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V18      [get_ports usb_uart_rxd]  ;# FPGA RXD  <= FTDI TXD
set_property src_info {type:XDC file:1 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AA19     [get_ports usb_uart_txd]  ;# FPGA TXD  => FTDI RXD
set_property src_info {type:XDC file:1 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN  T1 [get_ports  hdmi_tx_clk_p]
set_property src_info {type:XDC file:1 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN  U1 [get_ports  hdmi_tx_clk_n]
set_property src_info {type:XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN  W1 [get_ports {hdmi_tx_d_p[0]}]
set_property src_info {type:XDC file:1 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN  Y1 [get_ports {hdmi_tx_d_n[0]}]
set_property src_info {type:XDC file:1 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AA1 [get_ports {hdmi_tx_d_p[1]}]
set_property src_info {type:XDC file:1 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AB1 [get_ports {hdmi_tx_d_n[1]}]
set_property src_info {type:XDC file:1 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AB3 [get_ports {hdmi_tx_d_p[2]}]
set_property src_info {type:XDC file:1 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN AB2 [get_ports {hdmi_tx_d_n[2]}]
set_property src_info {type:XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN B22 IOSTANDARD LVCMOS33 } [get_ports { btn[4] }]; # center
set_property src_info {type:XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D22 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; # down
set_property src_info {type:XDC file:1 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN C22 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; # left
set_property src_info {type:XDC file:1 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; # right
set_property src_info {type:XDC file:1 line:60 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; # up
