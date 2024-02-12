-- (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: sintef.no:sintef_ip:axi_s_chain_link_switch:1.0
-- IP Revision: 18

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_axi_s_chain_link_swi_0_0 IS
  PORT (
    frame1_start_pulse : OUT STD_LOGIC;
    frame2_start_pulse : OUT STD_LOGIC;
    fifo_filled_flag_a1 : OUT STD_LOGIC;
    fifo_filled_flag_a2 : OUT STD_LOGIC;
    fifo_filled_flag_b1 : OUT STD_LOGIC;
    fifo_filled_flag_b2 : OUT STD_LOGIC;
    stream_switch_state_1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    stream_switch_state_2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    link1_wait : IN STD_LOGIC;
    link2_wait : IN STD_LOGIC;
    link1_flush : IN STD_LOGIC;
    link2_flush : IN STD_LOGIC;
    axis_aclk : IN STD_LOGIC;
    axis_aresetn : IN STD_LOGIC;
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    link_in1_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    link_in1_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    link_in1_axis_tlast : IN STD_LOGIC;
    link_in1_axis_tvalid : IN STD_LOGIC;
    link_in1_axis_tready : OUT STD_LOGIC;
    link_out1_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    link_out1_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    link_out1_axis_tlast : OUT STD_LOGIC;
    link_out1_axis_tvalid : OUT STD_LOGIC;
    link_out1_axis_tready : IN STD_LOGIC;
    node_in1_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    node_in1_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    node_in1_axis_tlast : OUT STD_LOGIC;
    node_in1_axis_tvalid : OUT STD_LOGIC;
    node_in1_axis_tready : IN STD_LOGIC;
    node_out1_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    node_out1_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    node_out1_axis_tlast : IN STD_LOGIC;
    node_out1_axis_tvalid : IN STD_LOGIC;
    node_out1_axis_tready : OUT STD_LOGIC;
    link_in2_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    link_in2_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    link_in2_axis_tlast : IN STD_LOGIC;
    link_in2_axis_tvalid : IN STD_LOGIC;
    link_in2_axis_tready : OUT STD_LOGIC;
    link_out2_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    link_out2_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    link_out2_axis_tlast : OUT STD_LOGIC;
    link_out2_axis_tvalid : OUT STD_LOGIC;
    link_out2_axis_tready : IN STD_LOGIC;
    node_in2_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    node_in2_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    node_in2_axis_tlast : OUT STD_LOGIC;
    node_in2_axis_tvalid : OUT STD_LOGIC;
    node_in2_axis_tready : IN STD_LOGIC;
    node_out2_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    node_out2_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    node_out2_axis_tlast : IN STD_LOGIC;
    node_out2_axis_tvalid : IN STD_LOGIC;
    node_out2_axis_tready : OUT STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC
  );
END design_1_axi_s_chain_link_swi_0_0;

ARCHITECTURE design_1_axi_s_chain_link_swi_0_0_arch OF design_1_axi_s_chain_link_swi_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_axi_s_chain_link_swi_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT axi_s_chain_link_switch IS
    GENERIC (
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      LINK_FIFO_SIZE : INTEGER;
      LINK_FIFO_FILLED_FLAG_LEVEL_A : INTEGER;
      LINK_FIFO_FILLED_FLAG_LEVEL_B : INTEGER;
      CONFIG_REGISTER_DEFAULTVALUE : STD_LOGIC_VECTOR(31 DOWNTO 0);
      C_AXIS_DATA_WIDTH : INTEGER
    );
    PORT (
      frame1_start_pulse : OUT STD_LOGIC;
      frame2_start_pulse : OUT STD_LOGIC;
      fifo_filled_flag_a1 : OUT STD_LOGIC;
      fifo_filled_flag_a2 : OUT STD_LOGIC;
      fifo_filled_flag_b1 : OUT STD_LOGIC;
      fifo_filled_flag_b2 : OUT STD_LOGIC;
      stream_switch_state_1 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      stream_switch_state_2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      link1_wait : IN STD_LOGIC;
      link2_wait : IN STD_LOGIC;
      link1_flush : IN STD_LOGIC;
      link2_flush : IN STD_LOGIC;
      axis_aclk : IN STD_LOGIC;
      axis_aresetn : IN STD_LOGIC;
      s_axi_aclk : IN STD_LOGIC;
      s_axi_aresetn : IN STD_LOGIC;
      link_in1_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      link_in1_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      link_in1_axis_tlast : IN STD_LOGIC;
      link_in1_axis_tvalid : IN STD_LOGIC;
      link_in1_axis_tready : OUT STD_LOGIC;
      link_out1_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      link_out1_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      link_out1_axis_tlast : OUT STD_LOGIC;
      link_out1_axis_tvalid : OUT STD_LOGIC;
      link_out1_axis_tready : IN STD_LOGIC;
      node_in1_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      node_in1_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      node_in1_axis_tlast : OUT STD_LOGIC;
      node_in1_axis_tvalid : OUT STD_LOGIC;
      node_in1_axis_tready : IN STD_LOGIC;
      node_out1_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      node_out1_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      node_out1_axis_tlast : IN STD_LOGIC;
      node_out1_axis_tvalid : IN STD_LOGIC;
      node_out1_axis_tready : OUT STD_LOGIC;
      link_in2_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      link_in2_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      link_in2_axis_tlast : IN STD_LOGIC;
      link_in2_axis_tvalid : IN STD_LOGIC;
      link_in2_axis_tready : OUT STD_LOGIC;
      link_out2_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      link_out2_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      link_out2_axis_tlast : OUT STD_LOGIC;
      link_out2_axis_tvalid : OUT STD_LOGIC;
      link_out2_axis_tready : IN STD_LOGIC;
      node_in2_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      node_in2_axis_tkeep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      node_in2_axis_tlast : OUT STD_LOGIC;
      node_in2_axis_tvalid : OUT STD_LOGIC;
      node_in2_axis_tready : IN STD_LOGIC;
      node_out2_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      node_out2_axis_tkeep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      node_out2_axis_tlast : IN STD_LOGIC;
      node_out2_axis_tvalid : IN STD_LOGIC;
      node_out2_axis_tready : OUT STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC
    );
  END COMPONENT axi_s_chain_link_switch;
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_1_axi_s_chain_link_swi_0_0_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi AWPROT";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_axi_awaddr: SIGNAL IS "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS" & 
" 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF node_out2_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out2_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF node_out2_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out2_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF node_out2_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out2_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF node_out2_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out2_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF node_out2_axis_tdata: SIGNAL IS "XIL_INTERFACENAME node_out2_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF node_out2_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out2_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF node_in2_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in2_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF node_in2_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in2_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF node_in2_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in2_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF node_in2_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in2_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF node_in2_axis_tdata: SIGNAL IS "XIL_INTERFACENAME node_in2_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF node_in2_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in2_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF link_out2_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out2_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF link_out2_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out2_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF link_out2_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out2_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF link_out2_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out2_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF link_out2_axis_tdata: SIGNAL IS "XIL_INTERFACENAME link_out2_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF link_out2_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out2_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF link_in2_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in2_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF link_in2_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in2_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF link_in2_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in2_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF link_in2_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in2_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF link_in2_axis_tdata: SIGNAL IS "XIL_INTERFACENAME link_in2_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF link_in2_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in2_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF node_out1_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out1_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF node_out1_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out1_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF node_out1_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out1_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF node_out1_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out1_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF node_out1_axis_tdata: SIGNAL IS "XIL_INTERFACENAME node_out1_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF node_out1_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 node_out1_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF node_in1_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in1_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF node_in1_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in1_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF node_in1_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in1_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF node_in1_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in1_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF node_in1_axis_tdata: SIGNAL IS "XIL_INTERFACENAME node_in1_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF node_in1_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 node_in1_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF link_out1_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out1_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF link_out1_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out1_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF link_out1_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out1_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF link_out1_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out1_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF link_out1_axis_tdata: SIGNAL IS "XIL_INTERFACENAME link_out1_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF link_out1_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 link_out1_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF link_in1_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in1_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF link_in1_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in1_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF link_in1_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in1_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF link_in1_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in1_axis TKEEP";
  ATTRIBUTE X_INTERFACE_PARAMETER OF link_in1_axis_tdata: SIGNAL IS "XIL_INTERFACENAME link_in1_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF link_in1_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 link_in1_axis TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_axi_aresetn: SIGNAL IS "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_axi_aclk: SIGNAL IS "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aresetn: SIGNAL IS "XIL_INTERFACENAME axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axis_aclk: SIGNAL IS "XIL_INTERFACENAME axis_aclk, ASSOCIATED_RESET axis_aresetn, ASSOCIATED_BUSIF link_in2_axis:link_in1_axis:link_out1_axis:link_out2_axis:node_in1_axis:node_in2_axis:node_out1_axis:node_out2_axis, FREQ_HZ 125000000, PHASE 0, CLK_DOMAIN design_1_aurora_8b10b_0_0_user_clk_out, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 axis_aclk CLK";
BEGIN
  U0 : axi_s_chain_link_switch
    GENERIC MAP (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 5,
      LINK_FIFO_SIZE => 2048,
      LINK_FIFO_FILLED_FLAG_LEVEL_A => 256,
      LINK_FIFO_FILLED_FLAG_LEVEL_B => 128,
      CONFIG_REGISTER_DEFAULTVALUE => X"04000400",
      C_AXIS_DATA_WIDTH => 32
    )
    PORT MAP (
      frame1_start_pulse => frame1_start_pulse,
      frame2_start_pulse => frame2_start_pulse,
      fifo_filled_flag_a1 => fifo_filled_flag_a1,
      fifo_filled_flag_a2 => fifo_filled_flag_a2,
      fifo_filled_flag_b1 => fifo_filled_flag_b1,
      fifo_filled_flag_b2 => fifo_filled_flag_b2,
      stream_switch_state_1 => stream_switch_state_1,
      stream_switch_state_2 => stream_switch_state_2,
      link1_wait => link1_wait,
      link2_wait => link2_wait,
      link1_flush => link1_flush,
      link2_flush => link2_flush,
      axis_aclk => axis_aclk,
      axis_aresetn => axis_aresetn,
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      link_in1_axis_tdata => link_in1_axis_tdata,
      link_in1_axis_tkeep => link_in1_axis_tkeep,
      link_in1_axis_tlast => link_in1_axis_tlast,
      link_in1_axis_tvalid => link_in1_axis_tvalid,
      link_in1_axis_tready => link_in1_axis_tready,
      link_out1_axis_tdata => link_out1_axis_tdata,
      link_out1_axis_tkeep => link_out1_axis_tkeep,
      link_out1_axis_tlast => link_out1_axis_tlast,
      link_out1_axis_tvalid => link_out1_axis_tvalid,
      link_out1_axis_tready => link_out1_axis_tready,
      node_in1_axis_tdata => node_in1_axis_tdata,
      node_in1_axis_tkeep => node_in1_axis_tkeep,
      node_in1_axis_tlast => node_in1_axis_tlast,
      node_in1_axis_tvalid => node_in1_axis_tvalid,
      node_in1_axis_tready => node_in1_axis_tready,
      node_out1_axis_tdata => node_out1_axis_tdata,
      node_out1_axis_tkeep => node_out1_axis_tkeep,
      node_out1_axis_tlast => node_out1_axis_tlast,
      node_out1_axis_tvalid => node_out1_axis_tvalid,
      node_out1_axis_tready => node_out1_axis_tready,
      link_in2_axis_tdata => link_in2_axis_tdata,
      link_in2_axis_tkeep => link_in2_axis_tkeep,
      link_in2_axis_tlast => link_in2_axis_tlast,
      link_in2_axis_tvalid => link_in2_axis_tvalid,
      link_in2_axis_tready => link_in2_axis_tready,
      link_out2_axis_tdata => link_out2_axis_tdata,
      link_out2_axis_tkeep => link_out2_axis_tkeep,
      link_out2_axis_tlast => link_out2_axis_tlast,
      link_out2_axis_tvalid => link_out2_axis_tvalid,
      link_out2_axis_tready => link_out2_axis_tready,
      node_in2_axis_tdata => node_in2_axis_tdata,
      node_in2_axis_tkeep => node_in2_axis_tkeep,
      node_in2_axis_tlast => node_in2_axis_tlast,
      node_in2_axis_tvalid => node_in2_axis_tvalid,
      node_in2_axis_tready => node_in2_axis_tready,
      node_out2_axis_tdata => node_out2_axis_tdata,
      node_out2_axis_tkeep => node_out2_axis_tkeep,
      node_out2_axis_tlast => node_out2_axis_tlast,
      node_out2_axis_tvalid => node_out2_axis_tvalid,
      node_out2_axis_tready => node_out2_axis_tready,
      s_axi_awaddr => s_axi_awaddr,
      s_axi_awprot => s_axi_awprot,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      s_axi_wdata => s_axi_wdata,
      s_axi_wstrb => s_axi_wstrb,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wready => s_axi_wready,
      s_axi_bresp => s_axi_bresp,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bready => s_axi_bready,
      s_axi_araddr => s_axi_araddr,
      s_axi_arprot => s_axi_arprot,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      s_axi_rdata => s_axi_rdata,
      s_axi_rresp => s_axi_rresp,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rready => s_axi_rready
    );
END design_1_axi_s_chain_link_swi_0_0_arch;
