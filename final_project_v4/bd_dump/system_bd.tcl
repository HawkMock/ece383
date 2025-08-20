
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "CRITICAL WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been changes to the IP between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the functionality and configuration of the design."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tsbg484-1
   set_property BOARD_PART digilentinc.com:nexys_video:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:microblaze:*\
xilinx.com:ip:lmb_bram_if_cntlr:*\
xilinx.com:ip:microblaze_mcs:*\
xilinx.com:ip:axi_uartlite:*\
xilinx.com:ip:axi_timer:*\
xilinx.com:ip:axi_intc:*\
xilinx.com:ip:axi_vdma:*\
xilinx.com:ip:v_tc:*\
xilinx.com:ip:v_axi4s_vid_out:*\
digilentinc.com:ip:rgb2dvi:*\
xilinx.com:ip:util_vector_logic:*\
xilinx.com:ip:mig_7series:*\
xilinx.com:ip:mdm:*\
xilinx.com:ip:blk_mem_gen:*\
xilinx.com:ip:lmb_v10:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10 ilmb_v10 ]

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr dlmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr


  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr ilmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr


  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen lmb_bram ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins dlmb_v10/LMB_M] [get_bd_intf_pins DLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ilmb_v10/LMB_M] [get_bd_intf_pins ILMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1  [get_bd_pins SYS_Rst] \
  [get_bd_pins dlmb_v10/SYS_Rst] \
  [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] \
  [get_bd_pins ilmb_v10/SYS_Rst] \
  [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins LMB_Clk] \
  [get_bd_pins dlmb_v10/LMB_Clk] \
  [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] \
  [get_bd_pins ilmb_v10/LMB_Clk] \
  [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set usb_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 usb_uart ]


  # Create ports
  set hdmi_tx_d_n [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_n ]
  set hdmi_tx_clk_n [ create_bd_port -dir O -type clk hdmi_tx_clk_n ]
  set hdmi_tx_d_p [ create_bd_port -dir O -from 2 -to 0 hdmi_tx_d_p ]
  set hdmi_tx_clk_p [ create_bd_port -dir O -type clk hdmi_tx_clk_p ]
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 100000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset
  set reset_0 [ create_bd_port -dir I -type rst reset_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {120.405} \
    CONFIG.CLKOUT1_PHASE_ERROR {90.340} \
    CONFIG.CLKOUT2_JITTER {161.591} \
    CONFIG.CLKOUT2_PHASE_ERROR {90.340} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25.2} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {115.328} \
    CONFIG.CLKOUT3_PHASE_ERROR {90.340} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {126} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
    CONFIG.CLK_OUT1_PORT {clk_sys} \
    CONFIG.CLK_OUT2_PORT {pix_clk} \
    CONFIG.CLK_OUT3_PORT {ser_clk} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {11.375} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {11.375} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {45} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {9} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.RESET_BOARD_INTERFACE {reset} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $clk_wiz_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]
  set_property -dict [list \
    CONFIG.RESET_BOARD_INTERFACE {reset} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $proc_sys_reset_0


  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze microblaze_0 ]
  set_property -dict [list \
    CONFIG.C_CACHE_BYTE_SIZE {16384} \
    CONFIG.C_DCACHE_BYTE_SIZE {16384} \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_AXI {1} \
    CONFIG.C_I_LMB {1} \
    CONFIG.C_USE_DCACHE {1} \
    CONFIG.C_USE_ICACHE {1} \
  ] $microblaze_0


  # Create instance: lmb_bram_if_cntlr_0, and set properties
  set lmb_bram_if_cntlr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr lmb_bram_if_cntlr_0 ]

  # Create instance: microblaze_mcs_0, and set properties
  set microblaze_mcs_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze_mcs microblaze_mcs_0 ]
  set_property -dict [list \
    CONFIG.CLK_BOARD_INTERFACE {sys_clock} \
    CONFIG.RESET_BOARD_INTERFACE {reset} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $microblaze_mcs_0


  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {6} \
    CONFIG.NUM_SI {4} \
  ] $axi_interconnect_0


  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite axi_uartlite_0 ]
  set_property -dict [list \
    CONFIG.UARTLITE_BOARD_INTERFACE {usb_uart} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_uartlite_0


  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer axi_timer_0 ]

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc axi_intc_0 ]

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma axi_vdma_0 ]
  set_property CONFIG.c_m_axis_mm2s_tdata_width {24} $axi_vdma_0


  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc v_tc_0 ]

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out v_axi4s_vid_out_0 ]

  # Create instance: rst_pix, and set properties
  set rst_pix [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_pix ]
  set_property -dict [list \
    CONFIG.RESET_BOARD_INTERFACE {reset} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $rst_pix


  # Create instance: rgb2dvi_0, and set properties
  set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi rgb2dvi_0 ]
  set_property CONFIG.kGenerateSerialClk {false} $rgb2dvi_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_0 ]
  set_property CONFIG.C_OPERATION {not} $util_vector_logic_0


  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series mig_7series_0 ]
  set_property CONFIG.RESET_BOARD_INTERFACE {reset} $mig_7series_0


  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm mdm_1 ]

  # Create instance: reset_inv_0, and set properties
  set reset_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic reset_inv_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $reset_inv_0


  # Create instance: lmb_bram_if_cntlr_0_bram, and set properties
  set lmb_bram_if_cntlr_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen lmb_bram_if_cntlr_0_bram ]

  # Create instance: rst_mig_7series_0_100M, and set properties
  set rst_mig_7series_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_mig_7series_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_intc_0/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins v_tc_0/ctrl]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports usb_uart] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_0_BRAM_PORT [get_bd_intf_pins lmb_bram_if_cntlr_0_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr_0/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins microblaze_0/M_AXI_DC] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins microblaze_0/M_AXI_IC] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IP [get_bd_intf_pins microblaze_0/M_AXI_IP] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]

  # Create port connections
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tdata  [get_bd_pins axi_vdma_0/m_axis_mm2s_tdata] \
  [get_bd_pins v_axi4s_vid_out_0/s_axis_video_tdata]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tlast  [get_bd_pins axi_vdma_0/m_axis_mm2s_tlast] \
  [get_bd_pins v_axi4s_vid_out_0/s_axis_video_tlast]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tuser  [get_bd_pins axi_vdma_0/m_axis_mm2s_tuser] \
  [get_bd_pins v_axi4s_vid_out_0/s_axis_video_tuser]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tvalid  [get_bd_pins axi_vdma_0/m_axis_mm2s_tvalid] \
  [get_bd_pins v_axi4s_vid_out_0/s_axis_video_tvalid]
  connect_bd_net -net clk_wiz_0_locked  [get_bd_pins clk_wiz_0/locked] \
  [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net clk_wiz_0_pix_clk  [get_bd_pins clk_wiz_0/pix_clk] \
  [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] \
  [get_bd_pins v_axi4s_vid_out_0/aclk] \
  [get_bd_pins rst_pix/slowest_sync_clk] \
  [get_bd_pins v_tc_0/clk] \
  [get_bd_pins rgb2dvi_0/PixelClk]
  connect_bd_net -net clk_wiz_0_ser_clk  [get_bd_pins clk_wiz_0/ser_clk] \
  [get_bd_pins rgb2dvi_0/SerialClk]
  connect_bd_net -net mdm_1_debug_sys_rst  [get_bd_pins mdm_1/Debug_SYS_Rst] \
  [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins clk_wiz_0/clk_sys] \
  [get_bd_pins microblaze_0/Clk] \
  [get_bd_pins microblaze_0_local_memory/LMB_Clk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins axi_interconnect_0/S00_ACLK] \
  [get_bd_pins axi_intc_0/s_axi_aclk] \
  [get_bd_pins axi_interconnect_0/M00_ACLK] \
  [get_bd_pins axi_interconnect_0/ACLK] \
  [get_bd_pins axi_timer_0/s_axi_aclk] \
  [get_bd_pins axi_interconnect_0/M01_ACLK] \
  [get_bd_pins axi_uartlite_0/s_axi_aclk] \
  [get_bd_pins axi_interconnect_0/M02_ACLK] \
  [get_bd_pins axi_vdma_0/s_axi_lite_aclk] \
  [get_bd_pins axi_interconnect_0/M03_ACLK] \
  [get_bd_pins v_tc_0/s_axi_aclk] \
  [get_bd_pins axi_interconnect_0/M04_ACLK] \
  [get_bd_pins axi_interconnect_0/S01_ACLK] \
  [get_bd_pins axi_interconnect_0/S02_ACLK] \
  [get_bd_pins axi_interconnect_0/S03_ACLK] \
  [get_bd_pins mig_7series_0/clk_ref_i] \
  [get_bd_pins mig_7series_0/sys_clk_i]
  connect_bd_net -net mig_7series_0_mmcm_locked  [get_bd_pins mig_7series_0/mmcm_locked] \
  [get_bd_pins rst_mig_7series_0_100M/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk  [get_bd_pins mig_7series_0/ui_clk] \
  [get_bd_pins axi_interconnect_0/M05_ACLK] \
  [get_bd_pins rst_mig_7series_0_100M/slowest_sync_clk]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst  [get_bd_pins mig_7series_0/ui_clk_sync_rst] \
  [get_bd_pins rst_mig_7series_0_100M/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset  [get_bd_pins proc_sys_reset_0/bus_struct_reset] \
  [get_bd_pins microblaze_0_local_memory/SYS_Rst]
  connect_bd_net -net proc_sys_reset_0_mb_reset  [get_bd_pins proc_sys_reset_0/mb_reset] \
  [get_bd_pins microblaze_0/Reset]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins axi_interconnect_0/S00_ARESETN] \
  [get_bd_pins axi_intc_0/s_axi_aresetn] \
  [get_bd_pins axi_interconnect_0/M00_ARESETN] \
  [get_bd_pins axi_interconnect_0/ARESETN] \
  [get_bd_pins axi_timer_0/s_axi_aresetn] \
  [get_bd_pins axi_interconnect_0/M01_ARESETN] \
  [get_bd_pins axi_uartlite_0/s_axi_aresetn] \
  [get_bd_pins axi_interconnect_0/M02_ARESETN] \
  [get_bd_pins axi_interconnect_0/M03_ARESETN] \
  [get_bd_pins v_tc_0/s_axi_aresetn] \
  [get_bd_pins axi_interconnect_0/M04_ARESETN] \
  [get_bd_pins axi_interconnect_0/S01_ARESETN] \
  [get_bd_pins axi_interconnect_0/S02_ARESETN] \
  [get_bd_pins axi_interconnect_0/S03_ARESETN]
  connect_bd_net -net reset_0_1  [get_bd_ports reset_0] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in] \
  [get_bd_pins rst_pix/ext_reset_in] \
  [get_bd_pins microblaze_mcs_0/Reset] \
  [get_bd_pins mig_7series_0/sys_rst]
  connect_bd_net -net reset_1  [get_bd_ports reset] \
  [get_bd_pins reset_inv_0/Op1]
  connect_bd_net -net reset_inv_0_Res  [get_bd_pins reset_inv_0/Res] \
  [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_n  [get_bd_pins rgb2dvi_0/TMDS_Clk_n] \
  [get_bd_ports hdmi_tx_clk_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Clk_p  [get_bd_pins rgb2dvi_0/TMDS_Clk_p] \
  [get_bd_ports hdmi_tx_clk_p]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_n  [get_bd_pins rgb2dvi_0/TMDS_Data_n] \
  [get_bd_ports hdmi_tx_d_n]
  connect_bd_net -net rgb2dvi_0_TMDS_Data_p  [get_bd_pins rgb2dvi_0/TMDS_Data_p] \
  [get_bd_ports hdmi_tx_d_p]
  connect_bd_net -net rst_mig_7series_0_100M_peripheral_aresetn  [get_bd_pins rst_mig_7series_0_100M/peripheral_aresetn] \
  [get_bd_pins mig_7series_0/aresetn] \
  [get_bd_pins axi_interconnect_0/M05_ARESETN]
  connect_bd_net -net rst_pix_peripheral_reset  [get_bd_pins rst_pix/peripheral_reset] \
  [get_bd_pins v_axi4s_vid_out_0/aresetn] \
  [get_bd_pins axi_vdma_0/axi_resetn] \
  [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sys_clock_1  [get_bd_ports sys_clock] \
  [get_bd_pins clk_wiz_0/clk_in1] \
  [get_bd_pins microblaze_mcs_0/Clk]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins rgb2dvi_0/aRst]
  connect_bd_net -net v_axi4s_vid_out_0_s_axis_video_tready  [get_bd_pins v_axi4s_vid_out_0/s_axis_video_tready] \
  [get_bd_pins axi_vdma_0/m_axis_mm2s_tready]
  connect_bd_net -net v_axi4s_vid_out_0_vid_active_video  [get_bd_pins v_axi4s_vid_out_0/vid_active_video] \
  [get_bd_pins rgb2dvi_0/vid_pVDE]
  connect_bd_net -net v_axi4s_vid_out_0_vid_data  [get_bd_pins v_axi4s_vid_out_0/vid_data] \
  [get_bd_pins rgb2dvi_0/vid_pData]
  connect_bd_net -net v_axi4s_vid_out_0_vid_hsync  [get_bd_pins v_axi4s_vid_out_0/vid_hsync] \
  [get_bd_pins rgb2dvi_0/vid_pHSync]
  connect_bd_net -net v_axi4s_vid_out_0_vid_vsync  [get_bd_pins v_axi4s_vid_out_0/vid_vsync] \
  [get_bd_pins rgb2dvi_0/vid_pVSync]

  # Create address segments
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs v_tc_0/ctrl/Reg] -force

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"1.30583",
   "Default View_TopLeft":"-107,-1340",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.8.0 2024-04-26 e1825d835c VDI=44 GEI=38 GUI=JA:21.0
#  -string -flagsOSRD
preplace port port-id_hdmi_tx_clk_n -pg 1 -lvl 5 -x 2010 -y -240 -defaultsOSRD
preplace port port-id_hdmi_tx_clk_p -pg 1 -lvl 5 -x 2010 -y -270 -defaultsOSRD
preplace portBus hdmi_tx_d_n -pg 1 -lvl 5 -x 2010 -y -300 -defaultsOSRD
preplace portBus hdmi_tx_d_p -pg 1 -lvl 5 -x 2010 -y -210 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 2 -x 790 -y 400 -defaultsOSRD
preplace inst proc_sys_reset_0 -pg 1 -lvl 4 -x 1770 -y 540 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 3 -x 1270 -y -510 -defaultsOSRD
preplace inst lmb_bram_if_cntlr_0 -pg 1 -lvl 2 -x 790 -y 0 -defaultsOSRD
preplace inst microblaze_mcs_0 -pg 1 -lvl 1 -x 320 -y 980 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 1 -x 320 -y 790 -defaultsOSRD
preplace inst axi_uartlite_0 -pg 1 -lvl 1 -x 320 -y 190 -defaultsOSRD
preplace inst axi_timer_0 -pg 1 -lvl 1 -x 320 -y -270 -defaultsOSRD
preplace inst axi_intc_0 -pg 1 -lvl 1 -x 320 -y -90 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 2 -x 790 -y -870 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 1 -x 320 -y -530 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 1 -x 320 -y -880 -defaultsOSRD
preplace inst rst_pix -pg 1 -lvl 1 -x 320 -y -1160 -defaultsOSRD
preplace inst rgb2dvi_0 -pg 1 -lvl 2 -x 790 -y -250 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 2 -x 790 -y -630 -defaultsOSRD
preplace inst mig_7series_0 -pg 1 -lvl 4 -x 1770 -y -150 -defaultsOSRD
preplace inst microblaze_0_local_memory -pg 1 -lvl 4 -x 1770 -y -680 -defaultsOSRD
preplace inst mdm_1 -pg 1 -lvl 2 -x 790 -y -510 -defaultsOSRD
preplace netloc axi_vdma_0_m_axis_mm2s_tdata 1 0 3 90 -1290 NJ -1290 1020
preplace netloc axi_vdma_0_m_axis_mm2s_tlast 1 0 3 130 -1270 NJ -1270 970
preplace netloc axi_vdma_0_m_axis_mm2s_tuser 1 0 3 70 -1300 NJ -1300 1040
preplace netloc axi_vdma_0_m_axis_mm2s_tvalid 1 0 3 110 -1280 NJ -1280 990
preplace netloc clk_wiz_0_locked 1 2 2 970 580 NJ
preplace netloc clk_wiz_0_pix_clk 1 0 3 80 -700 580 -90 970
preplace netloc clk_wiz_0_ser_clk 1 1 2 610 -80 980
preplace netloc mdm_1_debug_sys_rst 1 2 2 1000 560 NJ
preplace netloc microblaze_0_Clk 1 2 2 1030 570 1590
preplace netloc proc_sys_reset_0_bus_struct_reset 1 3 2 1600 -770 1940
preplace netloc proc_sys_reset_0_mb_reset 1 2 3 1040 -820 NJ -820 1950
preplace netloc rgb2dvi_0_TMDS_Clk_n 1 2 3 980J -810 NJ -810 1990J
preplace netloc rgb2dvi_0_TMDS_Clk_p 1 2 3 990J -800 NJ -800 1980J
preplace netloc rgb2dvi_0_TMDS_Data_n 1 2 3 1010J -790 NJ -790 1970J
preplace netloc rgb2dvi_0_TMDS_Data_p 1 2 3 1020J -780 NJ -780 1960J
preplace netloc rst_pix_peripheral_reset 1 0 2 100 -1060 600
preplace netloc util_vector_logic_0_Res 1 1 2 610 -690 970
preplace netloc v_axi4s_vid_out_0_s_axis_video_tready 1 0 3 140 -1260 NJ -1260 980
preplace netloc v_axi4s_vid_out_0_vid_active_video 1 1 1 530 -970n
preplace netloc v_axi4s_vid_out_0_vid_data 1 1 1 590 -950n
preplace netloc v_axi4s_vid_out_0_vid_hsync 1 1 1 520 -930n
preplace netloc v_axi4s_vid_out_0_vid_vsync 1 1 1 510 -910n
preplace netloc microblaze_0_debug 1 2 1 N -520
preplace netloc microblaze_0_dlmb_1 1 3 1 1500 -710n
preplace netloc microblaze_0_ilmb_1 1 3 1 1510 -690n
preplace netloc v_tc_0_vtiming_out 1 0 2 120 -1050 500
levelinfo -pg 1 -210 320 790 1270 1770 2010
pagesize -pg 1 -db -bbox -sgen -210 -1340 3470 1220
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

