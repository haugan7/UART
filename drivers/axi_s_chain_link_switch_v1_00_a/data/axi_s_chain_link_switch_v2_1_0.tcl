##############################################################################
## Filename:          P:\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/axi_s_chain_link_switch_v1_00_a/data/axi_s_chain_link_switch_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue May 03 16:33:01 2016 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "axi_s_chain_link_switch" "C_BASEADDR" "C_HIGHADDR" "C_AXIS_DATA_WIDTH" "LINK_FIFO_SIZE" "LINK_FIFO_FILLED_FLAG_LEVEL_A" "LINK_FIFO_FILLED_FLAG_LEVEL_B" "CONFIG_REGISTER_DEFAULT_VALUE"
}
