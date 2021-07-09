
################################################################
# This is a generated script based on design: MIPICSI2Reader
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
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source MIPICSI2Reader_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a35tftg256-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name MIPICSI2Reader

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

##################################################################
# DESIGN PROCs
##################################################################



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

  # Create ports
  set CLK [ create_bd_port -dir I -type clk -freq_hz 100000000 CLK ]
  set CLK200 [ create_bd_port -dir O -type clk CLK200 ]
  set ENABLED [ create_bd_port -dir I -type data ENABLED ]
  set MC_HSN [ create_bd_port -dir I -type clk -freq_hz 800000000 MC_HSN ]
  set MC_HSP [ create_bd_port -dir I -type clk -freq_hz 800000000 MC_HSP ]
  set MC_LPN [ create_bd_port -dir I -type clk -freq_hz 800000000 MC_LPN ]
  set MC_LPP [ create_bd_port -dir I -type clk -freq_hz 800000000 MC_LPP ]
  set MD_HSN [ create_bd_port -dir I -from 1 -to 0 -type data MD_HSN ]
  set MD_HSP [ create_bd_port -dir I -from 1 -to 0 MD_HSP ]
  set MD_LPN [ create_bd_port -dir I -from 1 -to 0 -type data MD_LPN ]
  set MD_LPP [ create_bd_port -dir I -from 1 -to 0 -type data MD_LPP ]
  set RESET [ create_bd_port -dir I -type rst RESET ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $RESET
  set TDATA [ create_bd_port -dir O -from 7 -to 0 -type data TDATA ]
  set TDEST [ create_bd_port -dir O -from 9 -to 0 -type data TDEST ]
  set TLAST [ create_bd_port -dir O -type data TLAST ]
  set TUSER [ create_bd_port -dir O -from 63 -to 0 -type data TUSER ]
  set TVALID [ create_bd_port -dir O -type data TVALID ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {114.829} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: mipi_csi2_rx_subsyst_1, and set properties
  set mipi_csi2_rx_subsyst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsyst_1 ]
  set_property -dict [ list \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CSI_CONTROLLER_REG_IF {false} \
   CONFIG.CSI_EMB_NON_IMG {false} \
   CONFIG.C_CSI_EN_ACTIVELANES {true} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_EN_7S_LINERATE_CHECK {false} \
   CONFIG.C_EN_CSI_V2_0 {true} \
   CONFIG.C_EXDES_BOARD {VCK190} \
   CONFIG.DPY_EN_REG_IF {false} \
   CONFIG.VFB_TU_WIDTH {64} \
 ] $mipi_csi2_rx_subsyst_1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net ENABLED_1 [get_bd_ports ENABLED] [get_bd_pins mipi_csi2_rx_subsyst_1/ctrl_core_en] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tready]
  connect_bd_net -net MC_HSN_1 [get_bd_ports MC_HSN] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_hs_n]
  connect_bd_net -net MC_HSP_1 [get_bd_ports MC_HSP] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_hs_p]
  connect_bd_net -net MC_LPN_1 [get_bd_ports MC_LPN] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_lp_n]
  connect_bd_net -net MC_LPP_1 [get_bd_ports MC_LPP] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_clk_lp_p]
  connect_bd_net -net MD_HSN_1 [get_bd_ports MD_HSN] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_data_hs_n]
  connect_bd_net -net MD_HSP_1 [get_bd_ports MD_HSP] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_data_hs_p]
  connect_bd_net -net MD_LPN_1 [get_bd_ports MD_LPN] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_data_lp_n]
  connect_bd_net -net MD_LPP_1 [get_bd_ports MD_LPP] [get_bd_pins mipi_csi2_rx_subsyst_1/mipi_phy_if_data_lp_p]
  connect_bd_net -net RESET_1 [get_bd_ports RESET] [get_bd_pins mipi_csi2_rx_subsyst_1/video_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports CLK200] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mipi_csi2_rx_subsyst_1/dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst_1/video_aclk]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_video_out_tdata [get_bd_ports TDATA] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tdata]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_video_out_tdest [get_bd_ports TDEST] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tdest]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_video_out_tlast [get_bd_ports TLAST] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tlast]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_video_out_tuser [get_bd_ports TUSER] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tuser]
  connect_bd_net -net mipi_csi2_rx_subsyst_1_video_out_tvalid [get_bd_ports TVALID] [get_bd_pins mipi_csi2_rx_subsyst_1/video_out_tvalid]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


