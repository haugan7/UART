------------------------------------------------------------------------------/
-- (c) Copyright 1995-2013 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------------/
 library ieee;
     use ieee.std_logic_1164.all;
     use ieee.std_logic_misc.all;
     use IEEE.numeric_std.all;
     use ieee.std_logic_arith.all;
     use ieee.std_logic_unsigned.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- synthesis translate_on

entity  design_1_aurora_8b10b_0_0_support is
port (
    -- AXI TX Interface
    s_axi_tx_tdata         : in  std_logic_vector(31 downto 0);
    s_axi_tx_tkeep         : in std_logic_vector(3 downto 0);
    s_axi_tx_tvalid        : in  std_logic;
    s_axi_tx_tready        : out std_logic;
    s_axi_tx_tlast         : in  std_logic;


    -- AXI RX Interface
    m_axi_rx_tdata         : out std_logic_vector(31 downto 0);
    m_axi_rx_tkeep         : out std_logic_vector(3 downto 0);
    m_axi_rx_tvalid        : out std_logic;
    m_axi_rx_tlast         : out std_logic;



 
    -- GT Serial I/O
    rxp                    : in std_logic_vector(0 downto 0);
    rxn                    : in std_logic_vector(0 downto 0);

    txp                    : out std_logic_vector(0 downto 0);
    txn                    : out std_logic_vector(0 downto 0);

    -- GT Reference Clock Interface
    gt_refclk1_p             : in  std_logic;
    gt_refclk1_n             : in  std_logic;
    gt_refclk1_out           : out  std_logic;

    -- Error Detection Interface
 
    frame_err              : out std_logic;
    hard_err               : out std_logic;
    soft_err               : out std_logic;
    channel_up             : out std_logic;
    lane_up                : out std_logic_vector(0 downto 0);


    --CRC  status signals
    crc_pass_fail_n        : out std_logic;
    crc_valid              : out std_logic;


    -- System Interface
    user_clk_out           : out std_logic;
    sync_clk_out           : out std_logic;
    reset                  : in  std_logic;
    gt_reset               : in  std_logic;
    sys_reset_out          : out std_logic;
    gt_reset_out           : out  std_logic;  

    power_down             : in  std_logic;
    loopback               : in  std_logic_vector(2 downto 0);
    tx_lock                : out std_logic;
    init_clk_in            : in  std_logic;
    tx_resetdone_out       : out std_logic;
    rx_resetdone_out       : out std_logic;
    link_reset_out         : out std_logic;

    gt0_cplllock_out                     : out std_logic;


    ------------------------ TX Configurable Driver Ports ----------------------
    gt0_txpostcursor_in                         : in   std_logic_vector(4 downto 0);
    gt0_txprecursor_in                          : in   std_logic_vector(4 downto 0);
    ------------------ Transmit Ports - TX 8B/10B Encoder Ports ----------------
    gt0_txchardispmode_in                       : in   std_logic_vector(3 downto 0);
    gt0_txchardispval_in                        : in   std_logic_vector(3 downto 0);
    gt0_txdiffctrl_in                           : in   std_logic_vector(3 downto 0);
    gt0_txmaincursor_in                         : in   std_logic_vector(6 downto 0);
    ----------------- Transmit Ports - TX Polarity Control Ports ---------------
    gt0_txpolarity_in                           : in   std_logic;
    gt0_tx_buf_err_out                          : out  std_logic;
        ------------------ Transmit Ports - Pattern Generator Ports ----------------
    gt0_txprbsforceerr_in                       : in   std_logic;
    gt0_txprbssel_in                            : in   std_logic_vector(2 downto 0); 
        ------------------- Transmit Ports - TX Data Path interface -----------------
    gt0_txpcsreset_in                           : in   std_logic;
    gt0_txinhibit_in                            : in   std_logic;
    gt0_txpmareset_in                           : in   std_logic;
    gt0_txresetdone_out                         : out std_logic;
    gt0_txbufstatus_out                         : out  std_logic_vector(1 downto 0);

    gt0_rxlpmen_in                              : in   std_logic;
    gt0_rxcdrovrden_in                          : in   std_logic;
    gt0_rxdfelpmreset_in                        : in   std_logic;
    gt0_rxmonitorout_out                        : out  std_logic_vector(6 downto 0);
    gt0_rxmonitorsel_in                         : in   std_logic_vector(1 downto 0);
    gt0_rxcdrhold_in                            : in   std_logic;
    gt0_eyescanreset_in                         : in   std_logic;
    -------------------------- RX Margin Analysis Ports ------------------------
    gt0_eyescandataerror_out                    : out  std_logic;
    gt0_eyescantrigger_in                       : in   std_logic;
    gt0_rxbyteisaligned_out                     : out  std_logic;
    gt0_rxcommadet_out                          : out  std_logic;
        ------------------- Receive Ports - Pattern Checker Ports ------------------
    gt0_rxprbserr_out                           : out  std_logic;
    gt0_rxprbssel_in                            : in   std_logic_vector(2 downto 0);
        ------------------- Receive Ports - Pattern Checker ports ------------------
    gt0_rxprbscntreset_in                       : in   std_logic;
        ------------------- Receive Ports - RX Data Path interface -----------------
    gt0_rxpcsreset_in                           : in   std_logic;
    gt0_rxpmareset_in                           : in   std_logic;
    gt0_dmonitorout_out                         : out  std_logic_vector(7 downto 0);
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    gt0_rxbufreset_in                           : in   std_logic;
    gt0_rx_disp_err_out                         : out  std_logic_vector(3 downto 0);
    gt0_rx_not_in_table_out                     : out  std_logic_vector(3 downto 0);
    gt0_rx_realign_out                          : out  std_logic;
    gt0_rx_buf_err_out                          : out  std_logic;
    gt0_rxresetdone_out                         : out std_logic;
    gt0_rxbufstatus_out                         : out  std_logic_vector(2 downto 0);

    --DRP Ports
    drpclk_in                         : in   std_logic;
    drpaddr_in             : in   std_logic_vector(8 downto 0);
    drpdi_in               : in   std_logic_vector(15 downto 0);
    drpdo_out              : out  std_logic_vector(15 downto 0);
    drpen_in               : in   std_logic;
    drprdy_out             : out  std_logic;
    drpwe_in               : in   std_logic;
   
--__________COMMON PORTS _______________________________{
    ------------------------- Common Block - QPLL Ports ------------------------
      gt0_qplllock_out       :  out  std_logic;
      gt0_qpllrefclklost_out :  out  std_logic;
  gt_qpllclk_quad1_out      : out  std_logic;  
  gt_qpllrefclk_quad1_out   : out  std_logic;  
--____________________________COMMON PORTS _______________________________}

    pll_not_locked_out      : out  std_logic

 );

end design_1_aurora_8b10b_0_0_support;


architecture STRUCTURE of design_1_aurora_8b10b_0_0_support is
  attribute core_generation_info           : string;
  attribute core_generation_info of STRUCTURE : architecture is "design_1_aurora_8b10b_0_0,aurora_8b10b_v11_1_7,{user_interface=AXI_4_Streaming,backchannel_mode=Sidebands,c_aurora_lanes=1,c_column_used=left,c_gt_clock_1=GTXQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=50000,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=125000,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,flow_mode=None,interface_mode=Framing,dataflow_config=Duplex}";

    component design_1_aurora_8b10b_0_0_core
        port   (
         -- TX Stream Interface
         S_AXI_TX_TDATA         : in  std_logic_vector(31 downto 0);
         S_AXI_TX_TKEEP         : in std_logic_vector(3 downto 0);
         S_AXI_TX_TVALID        : in  std_logic;
         S_AXI_TX_TREADY        : out std_logic;
         S_AXI_TX_TLAST         : in  std_logic;

         -- RX Stream Interface
         M_AXI_RX_TDATA         : out std_logic_vector(31 downto 0);
         M_AXI_RX_TKEEP         : out std_logic_vector(3 downto 0);
         M_AXI_RX_TVALID        : out std_logic;
         M_AXI_RX_TLAST         : out std_logic;

         -- GT Serial I/O
    RXP                    : in std_logic;
    RXN                    : in std_logic;
    TXP                    : out std_logic;
    TXN                    : out std_logic;

         -- GT Reference Clock Interface
         gt_refclk1           : in std_logic;

         -- Error Detection Interface
         HARD_ERR               : out std_logic;
         SOFT_ERR               : out std_logic;

         -- Status
         CHANNEL_UP             : out std_logic;
         LANE_UP             : out std_logic;

               
         FRAME_ERR              : out std_logic;


         -- CRC Status
         CRC_PASS_FAIL_N      : out std_logic;
         CRC_VALID            : out std_logic;


         -- System Interface

         USER_CLK         : in std_logic;
         SYNC_CLK         : in std_logic;
         GT_RESET         : in std_logic;
         RESET            : in std_logic;
         sys_reset_out    : out std_logic;
         POWER_DOWN       : in std_logic;
         LOOPBACK         : in std_logic_vector(2 downto 0);
         TX_OUT_CLK       : out std_logic;
         INIT_CLK_IN         : in  std_logic; 
         PLL_NOT_LOCKED      : in  std_logic;
         TX_RESETDONE_OUT    : out std_logic;
         RX_RESETDONE_OUT    : out std_logic;
         LINK_RESET_OUT      : out std_logic;
    gt0_cplllock_out                     : out std_logic;


    ------------------------ TX Configurable Driver Ports ----------------------
    gt0_txpostcursor_in                         : in   std_logic_vector(4 downto 0);
    gt0_txprecursor_in                          : in   std_logic_vector(4 downto 0);
    ------------------ Transmit Ports - TX 8B/10B Encoder Ports ----------------
    gt0_txchardispmode_in                       : in   std_logic_vector(3 downto 0);
    gt0_txchardispval_in                        : in   std_logic_vector(3 downto 0);
    gt0_txdiffctrl_in                           : in   std_logic_vector(3 downto 0);
    gt0_txmaincursor_in                         : in   std_logic_vector(6 downto 0);
    ----------------- Transmit Ports - TX Polarity Control Ports ---------------
    gt0_txpolarity_in                           : in   std_logic;
    gt0_tx_buf_err_out                          : out  std_logic;
        ------------------ Transmit Ports - Pattern Generator Ports ----------------
    gt0_txprbsforceerr_in                       : in   std_logic;
    gt0_txprbssel_in                            : in   std_logic_vector(2 downto 0); 
        ------------------- Transmit Ports - TX Data Path interface -----------------
    gt0_txpcsreset_in                           : in   std_logic;
    gt0_txinhibit_in                            : in   std_logic;
    gt0_txpmareset_in                           : in   std_logic;
    gt0_txresetdone_out                         : out std_logic;
    gt0_txbufstatus_out                         : out  std_logic_vector(1 downto 0);

    gt0_rxlpmen_in                              : in   std_logic;
    gt0_rxcdrovrden_in                          : in   std_logic;
    gt0_rxdfelpmreset_in                        : in   std_logic;
    gt0_rxmonitorout_out                        : out  std_logic_vector(6 downto 0);
    gt0_rxmonitorsel_in                         : in   std_logic_vector(1 downto 0);
    gt0_rxcdrhold_in                            : in   std_logic;
    gt0_eyescanreset_in                         : in   std_logic;
    -------------------------- RX Margin Analysis Ports ------------------------
    gt0_eyescandataerror_out                    : out  std_logic;
    gt0_eyescantrigger_in                       : in   std_logic;
    gt0_rxbyteisaligned_out                     : out  std_logic;
    gt0_rxcommadet_out                          : out  std_logic;
        ------------------- Receive Ports - Pattern Checker Ports ------------------
    gt0_rxprbserr_out                           : out  std_logic;
    gt0_rxprbssel_in                            : in   std_logic_vector(2 downto 0);
        ------------------- Receive Ports - Pattern Checker ports ------------------
    gt0_rxprbscntreset_in                       : in   std_logic;
        ------------------- Receive Ports - RX Data Path interface -----------------
    gt0_rxpcsreset_in                           : in   std_logic;
    gt0_rxpmareset_in                           : in   std_logic;
    gt0_dmonitorout_out                         : out  std_logic_vector(7 downto 0);
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    gt0_rxbufreset_in                           : in   std_logic;
    gt0_rx_disp_err_out                         : out  std_logic_vector(3 downto 0);
    gt0_rx_not_in_table_out                     : out  std_logic_vector(3 downto 0);
    gt0_rx_realign_out                          : out  std_logic;
    gt0_rx_buf_err_out                          : out  std_logic;
    gt0_rxresetdone_out                         : out std_logic;
    gt0_rxbufstatus_out                         : out  std_logic_vector(2 downto 0);

         drpclk_in                                             : in   std_logic;
    drpaddr_in             : in   std_logic_vector(8 downto 0);
    drpdi_in               : in   std_logic_vector(15 downto 0);
    drpdo_out              : out  std_logic_vector(15 downto 0);
    drpen_in               : in   std_logic;
    drprdy_out             : out  std_logic;
    drpwe_in               : in   std_logic;
   	
--------------------{
--__________COMMON PORTS _______________________________{
    ------------------------- Common Block - QPLL Ports ------------------------
      gt0_qplllock_in       :  in  std_logic;
      gt0_qpllrefclklost_in :  in  std_logic;
      gt0_qpllreset_out     :  out std_logic;
  gt_qpllclk_quad1_in      : in  std_logic;  
  gt_qpllrefclk_quad1_in   : in  std_logic;  
--____________________________COMMON PORTS _______________________________}
         TX_LOCK          : out std_logic
    );

    end component;


component design_1_aurora_8b10b_0_0_gt_common_wrapper
port
(
--____________________________COMMON PORTS ,_______________________________{
   gt_qpllclk_quad1_i    : out  std_logic;
   gt_qpllrefclk_quad1_i : out  std_logic;
--____________________________COMMON PORTS ,_______________________________}
    ---------------------- Common Block  - Ref Clock Ports ---------------------
    gt0_gtrefclk0_common_in    :  in  std_logic;
    ------------------------- Common Block - QPLL Ports ------------------------
    gt0_qplllock_out           : out std_logic;
    gt0_qplllockdetclk_in      : in  std_logic;
    gt0_qpllrefclklost_out     : out std_logic;
    gt0_qpllreset_in           : in  std_logic  

);
end component;


  component IBUFDS_GTE2
  port (
     O : out std_ulogic;
     ODIV2 : out std_ulogic;
     CEB : in std_ulogic;
     I : in std_ulogic;
     IB : in std_ulogic
       );
  end component;

    component BUFG

        port (

                O : out std_ulogic;
                I : in  std_ulogic

             );

    end component;

    component design_1_aurora_8b10b_0_0_CLOCK_MODULE
        port (
                GT_CLK                  : in std_logic;
                GT_CLK_LOCKED           : in std_logic;
                USER_CLK                : out std_logic;
                SYNC_CLK                : out std_logic;
                PLL_NOT_LOCKED          : out std_logic
             );
    end component;

    component design_1_aurora_8b10b_0_0_SUPPORT_RESET_LOGIC
        port (
                RESET                  : in std_logic;
                USER_CLK               : in std_logic;
                INIT_CLK_IN            : in std_logic;
                GT_RESET_IN            : in std_logic;
                SYSTEM_RESET           : out std_logic;
                GT_RESET_OUT           : out std_logic
             );
    end component;

  component  design_1_aurora_8b10b_0_0_cdc_sync is
    generic (
        C_CDC_TYPE                  : integer range 0 to 2 := 1                 ;
                                    -- 0 is pulse synch
                                    -- 1 is level synch
                                    -- 2 is ack based level sync
        C_RESET_STATE               : integer range 0 to 1 := 0                 ;
                                    -- 0 is reset not needed 
                                    -- 1 is reset needed 
        C_SINGLE_BIT                : integer range 0 to 1 := 1                 ; 
                                    -- 0 is bus input
                                    -- 1 is single bit input
        C_FLOP_INPUT                : integer range 0 to 1 := 0                 ;
        C_VECTOR_WIDTH              : integer range 0 to 32 := 32               ;
        C_MTBF_STAGES               : integer range 0 to 6 := 2                 
            -- Vector Data witdth
    );

    port (
        prmry_aclk                  : in  std_logic                             ;               --
        prmry_resetn                : in  std_logic                             ;               --
        prmry_in                    : in  std_logic                             ;               --
        prmry_vect_in               : in  std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)           ;               --
        prmry_ack                   : out std_logic                             ;
                                                                                                --
        scndry_aclk                 : in  std_logic                             ;               --
        scndry_resetn               : in  std_logic                             ;               --
                                                                                                --
        -- Primary to Secondary Clock Crossing                                                  --
        scndry_out                  : out std_logic                             ;               --
                                                                                                --
        scndry_vect_out             : out std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)                           --

    );
  end component;

------------  Wire declarations
--------------------{
    ------------------------- Common Block - QPLL Ports ------------------------
signal gt0_qplllock_i         : std_logic;
signal gt0_qpllrefclklost_i   : std_logic;
signal gt0_qpllreset_i        : std_logic;
signal                      gt_qpllclk_quad1_i  :  std_logic;
signal                      gt_qpllrefclk_quad1_i  :  std_logic;
--------------------}
signal               gt_refclk1    :   std_logic;

signal               tx_out_clk_i            :  std_logic;
signal               user_clk_i              :  std_logic;
signal               sync_clk_i              :  std_logic;
signal               pll_not_locked_i        :  std_logic;
signal               tx_lock_i               :  std_logic;

signal               init_clk_i              :  std_logic;
signal               tx_resetdone_i          :  std_logic;
signal               rx_resetdone_i          :  std_logic;
signal               link_reset_i            :  std_logic;
signal               system_reset_i          :  std_logic;
signal               gt_reset_i              :  std_logic;
signal               drpclk_i                :  std_logic;
signal               reset_sync_user_clk     : std_logic;
signal               gt_reset_sync_init_clk  : std_logic;
begin

 --*********************************Main Body of Code**********************************

      IBUFDS_GTE2_CLK1 :  IBUFDS_GTE2
      port map (
           I     => gt_refclk1_p,
           IB    => gt_refclk1_n,
           CEB   => '0',
           O     => gt_refclk1,
           ODIV2 => OPEN);


  drpclk_i <= drpclk_in;

    init_clk_i <= init_clk_in;
    -- Instantiate a clock module for clock division

    clock_module_i : design_1_aurora_8b10b_0_0_CLOCK_MODULE
        port map (
                    GT_CLK              => tx_out_clk_i,
                    GT_CLK_LOCKED       => tx_lock_i,
                    USER_CLK            => user_clk_i,
                    SYNC_CLK            => sync_clk_i,
                    PLL_NOT_LOCKED      => pll_not_locked_i
                 );

  --  outputs
  gt_reset_out          <=  gt_reset_i;
  gt_refclk1_out        <=  gt_refclk1;
  sync_clk_out          <=  sync_clk_i;
  user_clk_out          <=  user_clk_i;
  pll_not_locked_out    <=  pll_not_locked_i;
  tx_lock               <=  tx_lock_i;
  tx_resetdone_out      <=  tx_resetdone_i;
  rx_resetdone_out      <=  rx_resetdone_i;
  link_reset_out        <=  link_reset_i;

--____________________________COMMON PORTS _______________________________
--    ------------------------- Common Block - QPLL Ports ------------------------
  gt0_qplllock_out         <= gt0_qplllock_i;
  gt0_qpllrefclklost_out   <= gt0_qpllrefclklost_i;
  gt_qpllclk_quad1_out  <= gt_qpllclk_quad1_i ;
  gt_qpllrefclk_quad1_out  <= gt_qpllrefclk_quad1_i ;

 reset_sync_user_clk_cdc_sync : design_1_aurora_8b10b_0_0_cdc_sync
   generic map
     (
       c_cdc_type        => 1,   
       c_flop_input      => 0,  
       c_reset_state     => 0,  
       c_single_bit      => 1,  
       c_vector_width    => 2,  
       c_mtbf_stages     => 5 
     )
  port map
     (
       prmry_aclk        => '0'                ,
       prmry_resetn      => '1'                ,
       prmry_in          => reset              ,
       prmry_vect_in     => "00"               ,
       scndry_aclk       => user_clk_i         ,
       scndry_resetn     => '1'                ,
       prmry_ack         => open               ,
       scndry_out        => reset_sync_user_clk,
       scndry_vect_out   => open           
     );

 gt_reset_cdc_sync : design_1_aurora_8b10b_0_0_cdc_sync
   generic map
     (
       c_cdc_type        => 1,   
       c_flop_input      => 0,  
       c_reset_state     => 0,  
       c_single_bit      => 1,  
       c_vector_width    => 2,  
       c_mtbf_stages     => 6 
     )
  port map
     (
       prmry_aclk        => '0'                   ,
       prmry_resetn      => '1'                   ,
       prmry_in          => gt_reset              ,
       prmry_vect_in     => "00"                  ,
       scndry_aclk       => init_clk_i            ,
       scndry_resetn     => '1'                   ,
       prmry_ack         => open                  ,
       scndry_out        => gt_reset_sync_init_clk,
       scndry_vect_out   => open           
     );

    support_reset_logic_i : design_1_aurora_8b10b_0_0_SUPPORT_RESET_LOGIC
        port map (
                   RESET               =>  reset_sync_user_clk,
                   USER_CLK            =>  user_clk_i,
                   INIT_CLK_IN         =>  init_clk_i,
                   GT_RESET_IN         =>  gt_reset_sync_init_clk,
                   SYSTEM_RESET        =>  system_reset_i,
                   GT_RESET_OUT        =>  gt_reset_i
                 );

-------- instance of _gt_common_wrapper ---{
gt_common_support : design_1_aurora_8b10b_0_0_gt_common_wrapper

port map
(
--____________________________COMMON PORTS ,_______________________________{
  gt_qpllclk_quad1_i      => gt_qpllclk_quad1_i ,
  gt_qpllrefclk_quad1_i   => gt_qpllrefclk_quad1_i ,
    ---------------------- Common Block  - Ref Clock Ports ---------------------
      gt0_gtrefclk0_common_in  =>  gt_refclk1,

    ------------------------- Common Block - QPLL Ports ------------------------
      gt0_qplllock_out        => gt0_qplllock_i,
      gt0_qplllockdetclk_in   => init_clk_i,
      gt0_qpllrefclklost_out  => gt0_qpllrefclklost_i ,
      gt0_qpllreset_in  =>  gt0_qpllreset_i 
--____________________________COMMON PORTS ,_______________________________}
);


-------- instance of _gt_common_wrapper ---}

     design_1_aurora_8b10b_0_0_core_i : design_1_aurora_8b10b_0_0_core
     port map (
        -- AXI TX Interface
        s_axi_tx_tdata               => s_axi_tx_tdata,
        s_axi_tx_tkeep               => s_axi_tx_tkeep,
        s_axi_tx_tvalid              => s_axi_tx_tvalid,
        s_axi_tx_tlast               => s_axi_tx_tlast,
        s_axi_tx_tready              => s_axi_tx_tready,

        -- AXI RX Interface
        m_axi_rx_tdata               => m_axi_rx_tdata,
        m_axi_rx_tkeep               => m_axi_rx_tkeep,
        m_axi_rx_tvalid              => m_axi_rx_tvalid,
        m_axi_rx_tlast               => m_axi_rx_tlast,


        -- GT Serial I/O
        rxp                          => rxp(0),
        rxn                          => rxn(0),
        txp                          => txp(0),
        txn                          => txn(0),

        -- GT Reference Clock Interface
        gt_refclk1                   => gt_refclk1,
        -- Error Detection Interface
        frame_err                    => frame_err,

        -- Error Detection Interface
        hard_err                     => hard_err,
        soft_err                     => soft_err,

        -- Status
        channel_up                   => channel_up,
        lane_up                      => lane_up(0),


	--CRC Status
	crc_pass_fail_n              => crc_pass_fail_n,
        crc_valid                    => crc_valid,


        -- System Interface
        user_clk                     => user_clk_i,
        sync_clk                     => sync_clk_i,
        reset                        => system_reset_i,
        sys_reset_out                => sys_reset_out,
        power_down                   => power_down,
        loopback                     => loopback,
        gt_reset                     => gt_reset_i,
        tx_lock                      => tx_lock_i,
        init_clk_in                  => init_clk_i,
        pll_not_locked               => pll_not_locked_i,
	tx_resetdone_out             => tx_resetdone_i,
	rx_resetdone_out             => rx_resetdone_i,
        link_reset_out               => link_reset_i,

         gt0_cplllock_out                   => gt0_cplllock_out, 


        ------------------------ TX Configurable Driver Ports ----------------------
         gt0_txpostcursor_in                => gt0_txpostcursor_in,
         gt0_txprecursor_in                 => gt0_txprecursor_in,
        ------------------ Transmit Ports - TX 8B/10B Encoder Ports ----------------
         gt0_txchardispmode_in              => gt0_txchardispmode_in,
         gt0_txchardispval_in               => gt0_txchardispval_in,
         gt0_txdiffctrl_in                  => gt0_txdiffctrl_in,
         gt0_txmaincursor_in                => gt0_txmaincursor_in,
        ----------------- Transmit Ports - TX Polarity Control Ports ---------------
         gt0_txpolarity_in                  => gt0_txpolarity_in,
         gt0_tx_buf_err_out                 => gt0_tx_buf_err_out,
        ------------------ Transmit Ports - Pattern Generator Ports ----------------
        gt0_txprbsforceerr_in           => gt0_txprbsforceerr_in,
        gt0_txprbssel_in                => gt0_txprbssel_in,
        ------------------- Transmit Ports - TX Data Path interface -----------------
        gt0_txpcsreset_in               => gt0_txpcsreset_in,
        gt0_txinhibit_in                => gt0_txinhibit_in,
        gt0_txpmareset_in               => gt0_txpmareset_in,
        gt0_txresetdone_out             => gt0_txresetdone_out,
        gt0_txbufstatus_out             => gt0_txbufstatus_out,


        -------------------------- RX Margin Analysis Ports ------------------------
         gt0_eyescanreset_in                => gt0_eyescanreset_in,
         gt0_eyescandataerror_out           => gt0_eyescandataerror_out,
         gt0_eyescantrigger_in              => gt0_eyescantrigger_in,

         gt0_rxlpmen_in                     => gt0_rxlpmen_in,
         gt0_rxcdrovrden_in                 => gt0_rxcdrovrden_in,
         gt0_rxdfelpmreset_in               => gt0_rxdfelpmreset_in,
         gt0_rxmonitorout_out               => gt0_rxmonitorout_out,
         gt0_rxmonitorsel_in                => gt0_rxmonitorsel_in,
         gt0_rxcdrhold_in                   => gt0_rxcdrhold_in,
         gt0_rxbyteisaligned_out            => gt0_rxbyteisaligned_out,
         gt0_rxcommadet_out                 => gt0_rxcommadet_out,
         gt0_rx_disp_err_out                => gt0_rx_disp_err_out,
         gt0_rx_not_in_table_out            => gt0_rx_not_in_table_out,
         gt0_rx_realign_out                 => gt0_rx_realign_out,
         gt0_rx_buf_err_out                 => gt0_rx_buf_err_out,
        ------------------- Receive Ports - Pattern Checker Ports ------------------
        gt0_rxprbserr_out               => gt0_rxprbserr_out,
        gt0_rxprbssel_in                => gt0_rxprbssel_in,
        ------------------- Receive Ports - Pattern Checker ports ------------------
        gt0_rxprbscntreset_in           => gt0_rxprbscntreset_in,
        ------------------- Receive Ports - RX Data Path interface -----------------
        gt0_rxpcsreset_in               => gt0_rxpcsreset_in,
        gt0_rxpmareset_in               => gt0_rxpmareset_in,
        gt0_dmonitorout_out             => gt0_dmonitorout_out,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        gt0_rxbufreset_in               => gt0_rxbufreset_in,
        gt0_rxresetdone_out             => gt0_rxresetdone_out,
        gt0_rxbufstatus_out             => gt0_rxbufstatus_out,

        drpclk_in                            => drpclk_i,
        drpaddr_in                   => drpaddr_in,
        drpen_in                     => drpen_in,
        drpdi_in                     => drpdi_in,
        drprdy_out                   => drprdy_out, 
        drpdo_out                    => drpdo_out,
        drpwe_in                     => drpwe_in,
--------------------{
--__________COMMON PORTS _______________________________{
    ------------------------- Common Block - QPLL Ports ------------------------
      gt0_qplllock_in        =>  gt0_qplllock_i,
      gt0_qpllrefclklost_in  =>  gt0_qpllrefclklost_i,
      gt0_qpllreset_out      =>  gt0_qpllreset_i,
  gt_qpllclk_quad1_in      => gt_qpllclk_quad1_i ,
  gt_qpllrefclk_quad1_in   => gt_qpllrefclk_quad1_i ,
--____________________________COMMON PORTS ,_______________________________}
--------------------}
        tx_out_clk                   => tx_out_clk_i

     );

 end STRUCTURE; 
