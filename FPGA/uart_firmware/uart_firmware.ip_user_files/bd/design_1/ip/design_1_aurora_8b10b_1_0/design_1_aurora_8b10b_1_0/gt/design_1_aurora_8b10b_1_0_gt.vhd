------------------------------------------------------------------------------/
-- (c) Copyright 2008 Xilinx, Inc. All rights reserved.
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
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
--***************************** Entity Declaration ****************************

entity design_1_aurora_8b10b_1_0_gt is
generic
(
    -- Simulation attributes
    GT_SIM_GTRESET_SPEEDUP    : string     :=  "FALSE";        -- Set to "TRUE" to speed up sim reset
    RX_DFE_KL_CFG2_IN         : bit_vector :=   X"301148AC";
    PMA_RSV_IN                : bit_vector :=   X"00018480";
    PCS_RSVD_ATTR_IN          : bit_vector :=   X"000000000000"
);
port
(
    ---------------------------------- Channel ---------------------------------
    QPLLCLK_IN                              : in   std_logic;
    QPLLREFCLK_IN                           : in   std_logic;
    ---------------- Channel - Dynamic Reconfiguration Port (DRP) --------------
    DRPADDR_IN                              : in   std_logic_vector(8 downto 0);
    DRPCLK_IN                               : in   std_logic;
    DRPDI_IN                                : in   std_logic_vector(15 downto 0);
    DRPDO_OUT                               : out  std_logic_vector(15 downto 0);
    DRPEN_IN                                : in   std_logic;
    DRPRDY_OUT                              : out  std_logic;
    DRPWE_IN                                : in   std_logic;
    ------------------------- Channel - Ref Clock Ports ------------------------
    GTREFCLK0_IN                            : in   std_logic;
    -------------------------------- Channel PLL -------------------------------
    CPLLFBCLKLOST_OUT                       : out  std_logic;
    CPLLLOCK_OUT                            : out  std_logic;
    CPLLLOCKDETCLK_IN                       : in   std_logic;
    CPLLREFCLKLOST_OUT                      : out  std_logic;
    CPLLRESET_IN                            : in   std_logic;
    ------------------------------- Eye Scan Ports -----------------------------
    EYESCANDATAERROR_OUT                    : out  std_logic;
    eyescantrigger_in                       : in   std_logic;
    ------------------------ Loopback and Powerdown Ports ----------------------
    LOOPBACK_IN                             : in   std_logic_vector(2 downto 0);
    RXPD_IN                                 : in   std_logic_vector(1 downto 0);
    TXPD_IN                                 : in   std_logic_vector(1 downto 0);
    ------------------------------- Receive Ports ------------------------------
    eyescanreset_in                         : in   std_logic;
    RXUSERRDY_IN                            : in   std_logic;
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA_OUT                       : out  std_logic_vector(3 downto 0);
    RXCHARISK_OUT                           : out  std_logic_vector(3 downto 0);
    RXDISPERR_OUT                           : out  std_logic_vector(3 downto 0);
    RXNOTINTABLE_OUT                        : out  std_logic_vector(3 downto 0);
    ------------------- Receive Ports - Pattern Checker Ports ------------------
    rxprbserr_out                           : out  std_logic;
    rxprbssel_in                            : in   std_logic_vector(2 downto 0);
    ------------------- Receive Ports - Pattern Checker ports ------------------
    rxprbscntreset_in                       : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT_OUT                         : out  std_logic_vector(1 downto 0);
    -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
    rxbyteisaligned_out                     : out  std_logic;
    RXBYTEREALIGN_OUT                       : out  std_logic;
    rxcommadet_out                          : out  std_logic;
    RXMCOMMAALIGNEN_IN                      : in   std_logic;
    RXPCOMMAALIGNEN_IN                      : in   std_logic;
    --------------------- Receive Ports - RX Equalizer Ports -------------------
    RXDFEAGCHOLD_IN                         : in   std_logic;
    RXDFELFHOLD_IN                          : in   std_logic;
    rxdfelpmreset_in                        : in   std_logic;
    rxmonitorout_out                        : out  std_logic_vector(6 downto 0);
    rxmonitorsel_in                         : in   std_logic_vector(1 downto 0);
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTRXRESET_IN                            : in   std_logic;
    rxpcsreset_in                           : in   std_logic;
    RXPMARESET_IN                           : in   std_logic;
    RXDATA_OUT                              : out  std_logic_vector(31 downto 0);
    RXOUTCLK_OUT                            : out  std_logic;
    RXUSRCLK_IN                             : in   std_logic;
    RXUSRCLK2_IN                            : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTXRXN_IN                               : in   std_logic;
    GTXRXP_IN                               : in   std_logic;
    RXCDRLOCK_OUT                           : out  std_logic;
    dmonitorout_out                         : out  std_logic_vector(7 downto 0);
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    rxbufreset_in                           : in   std_logic;
    RXBUFSTATUS_OUT                         : out  std_logic_vector(2 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    RXRESETDONE_OUT                         : out  std_logic;
    ------------------------ TX Configurable Driver Ports ----------------------
    txpostcursor_in                         : in   std_logic_vector(4 downto 0);
    txprecursor_in                          : in   std_logic_vector(4 downto 0);
    -------------------- Receive Ports - RX Margin Analysis ports ----------------
    rxlpmen_in                              : in   std_logic;
    rxcdrovrden_in                          : in   std_logic;
    rxcdrhold_in                            : in   std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    RXPOLARITY_IN                           : in   std_logic;
    ------------------------------- Transmit Ports -----------------------------
    TXUSERRDY_IN                            : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    txchardispmode_in                       : in   std_logic_vector(3 downto 0);
    txchardispval_in                        : in   std_logic_vector(3 downto 0);
    TXCHARISK_IN                            : in   std_logic_vector(3 downto 0);
    ------------ Transmit Ports - TX Buffer and Phase Alignment Ports ----------
    TXBUFSTATUS_OUT                         : out  std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTTXRESET_IN                            : in   std_logic;
    TXDATA_IN                               : in   std_logic_vector(31 downto 0);
    TXOUTCLK_OUT                            : out  std_logic;
    TXOUTCLKFABRIC_OUT                      : out  std_logic;
    TXOUTCLKPCS_OUT                         : out  std_logic;
    TXUSRCLK_IN                             : in   std_logic;
    TXUSRCLK2_IN                            : in   std_logic;
    --------------------- Transmit Ports - PCI Express Ports -------------------
    txelecidle_in                           : in   std_logic;
    ------------------ Transmit Ports - Pattern Generator Ports ----------------
    txprbsforceerr_in                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTXTXN_OUT                              : out  std_logic;
    GTXTXP_OUT                              : out  std_logic;
    txdiffctrl_in                           : in   std_logic_vector(3 downto 0);
    txmaincursor_in                         : in   std_logic_vector(6 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    txpcsreset_in                           : in   std_logic;
    txpmareset_in                           : in   std_logic;
    txinhibit_in                            : in   std_logic;
    TXRESETDONE_OUT                         : out  std_logic;
    ------------------ Transmit Ports - pattern Generator Ports ----------------
    txprbssel_in                            : in   std_logic_vector(2 downto 0);
    ----------------- Transmit Ports - TX Polarity Control Ports ---------------
    txpolarity_in                           : in   std_logic

);


end design_1_aurora_8b10b_1_0_gt;

architecture MAPPED of design_1_aurora_8b10b_1_0_gt is

  attribute core_generation_info        : string;
attribute core_generation_info of MAPPED : architecture is "design_1_aurora_8b10b_1_0,aurora_8b10b_v11_1_7,{user_interface=AXI_4_Streaming,backchannel_mode=Sidebands,c_aurora_lanes=1,c_column_used=left,c_gt_clock_1=GTXQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=50000,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=125000,c_simplex=false,c_simplex_mode=TX,c_stream=false,c_ufc=false,flow_mode=None,interface_mode=Framing,dataflow_config=Duplex}";

 
--**************************** Signal Declarations ****************************

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;



    -- RX Datapath signals
    signal rxdata_i                         :   std_logic_vector(63 downto 0);   
    signal rxchariscomma_float_i            :   std_logic_vector(3 downto 0);
    signal rxcharisk_float_i                :   std_logic_vector(3 downto 0);
    signal rxdisperr_float_i                :   std_logic_vector(3 downto 0);
    signal rxnotintable_float_i             :   std_logic_vector(3 downto 0);
 


    -- TX Datapath signals
    signal txdata_i                         :   std_logic_vector(63 downto 0);

    signal    rxpmaresetdone_t                : std_logic;

    attribute equivalent_register_removal: string; 
    signal cpllpd_wait    :   std_logic_vector(95 downto 0)  := x"FFFFFFFFFFFFFFFFFFFFFFFF";
    signal cpllreset_wait :   std_logic_vector(127 downto 0) := x"000000000000000000000000000000FF";
    attribute equivalent_register_removal of cpllpd_wait : signal is "no";
    attribute equivalent_register_removal of cpllreset_wait : signal is "no";
    signal    cpllpd_ovrd_i    :std_logic ;
    signal    cpllreset_ovrd_i :std_logic ;
    signal    cpll_reset_i     :std_logic ;
    signal    cpllreset_sync   :std_logic ;
    signal    cpll_pd_i        :std_logic ;
    signal    cpllpd_sync      :std_logic ;
    signal    ack_i            : std_logic;
    signal    flag             : std_logic := '0';
    signal    flag2            : std_logic := '0';
    signal    ack_flag         : std_logic := '0';
    -- Internal Signals
    signal data_sync1 : std_logic;
    signal data_sync2 : std_logic;
    signal data_sync3 : std_logic;
    signal data_sync4 : std_logic;
    signal data_sync5 : std_logic;
    signal data_sync6 : std_logic;

    signal ack_sync1 : std_logic;
    signal ack_sync2 : std_logic;
    signal ack_sync3 : std_logic;
    signal ack_sync4 : std_logic;
    signal ack_sync5 : std_logic;
    signal ack_sync6 : std_logic;

    -- These attributes will stop timing errors being reported in back annotated
    -- SDF simulation.
    attribute ASYNC_REG                       : string;
    attribute ASYNC_REG of data_sync_reg1    : label is "true";
    attribute ASYNC_REG of data_sync_reg2    : label is "true";
    attribute ASYNC_REG of data_sync_reg3    : label is "true";
    attribute ASYNC_REG of data_sync_reg4    : label is "true";
    attribute ASYNC_REG of data_sync_reg5    : label is "true";
    attribute ASYNC_REG of data_sync_reg6    : label is "true";

    -- These attributes will stop XST translating the desired flip-flops into an
    -- SRL based shift register.
    attribute shreg_extract                   : string;
    attribute shreg_extract of data_sync_reg1 : label is "no";
    attribute shreg_extract of data_sync_reg2 : label is "no";
    attribute shreg_extract of data_sync_reg3 : label is "no";
    attribute shreg_extract of data_sync_reg4 : label is "no";
    attribute shreg_extract of data_sync_reg5 : label is "no";
    attribute shreg_extract of data_sync_reg6 : label is "no";

    attribute ASYNC_REG of ack_sync_reg1    : label is "true";
    attribute ASYNC_REG of ack_sync_reg2    : label is "true";
    attribute ASYNC_REG of ack_sync_reg3    : label is "true";
    attribute ASYNC_REG of ack_sync_reg4    : label is "true";
    attribute ASYNC_REG of ack_sync_reg5    : label is "true";
    attribute ASYNC_REG of ack_sync_reg6    : label is "true";

    -- These attributes will stop XST translating the desired flip-flops into an
    -- SRL based shift register.
    attribute shreg_extract of ack_sync_reg1 : label is "no";
    attribute shreg_extract of ack_sync_reg2 : label is "no";
    attribute shreg_extract of ack_sync_reg3 : label is "no";
    attribute shreg_extract of ack_sync_reg4 : label is "no";
    attribute shreg_extract of ack_sync_reg5 : label is "no";
    attribute shreg_extract of ack_sync_reg6 : label is "no";

--******************************** Main Body of Code***************************
                    
begin                   

    ---------------------------  Static signal Assignments ---------------------

    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';

    -------------------  GT Datapath byte mapping  -----------------

    RXDATA_OUT    <=   rxdata_i(31 downto 0);

    txdata_i    <=   (tied_to_ground_vec_i(31 downto 0) & TXDATA_IN);



    ----------------------------- GTXE2 Instance  --------------------------

    gtxe2_i :GTXE2_CHANNEL
    generic map
    (

        --_______________________ Simulation-Only Attributes ___________________

        SIM_RECEIVER_DETECT_PASS   =>      ("TRUE"),
        SIM_RESET_SPEEDUP          =>      (GT_SIM_GTRESET_SPEEDUP),
        SIM_TX_EIDLE_DRIVE_LEVEL   =>      ("X"),
        SIM_CPLLREFCLK_SEL         =>      ("001"),
        SIM_VERSION                =>      ("4.0"),
     

       ------------------Comma Detection and Alignment---------------
        ALIGN_COMMA_DOUBLE                      =>     ("FALSE"),
        ALIGN_COMMA_ENABLE                      =>     ("1111111111"),
        ALIGN_COMMA_WORD                        =>     (2),
        ALIGN_MCOMMA_DET                        =>     ("TRUE"),
        ALIGN_MCOMMA_VALUE                      =>     ("1010000011"),
        ALIGN_PCOMMA_DET                        =>     ("TRUE"),
        ALIGN_PCOMMA_VALUE                      =>     ("0101111100"),
        DEC_MCOMMA_DETECT                       =>     ("TRUE"),
        DEC_PCOMMA_DETECT                       =>     ("TRUE"),
        DEC_VALID_COMMA_ONLY                    =>     ("FALSE"),
        SHOW_REALIGN_COMMA                      =>     ("TRUE"),
        RX_DISPERR_SEQ_MATCH                    =>     ("TRUE"),
        RXSLIDE_AUTO_WAIT                       =>     (7),
        RXSLIDE_MODE                            =>     ("OFF"),
        RX_SIG_VALID_DLY                        =>     (10),

       ------------------------Channel Bonding----------------------
        CBCC_DATA_SOURCE_SEL                    =>     ("DECODED"),
        CHAN_BOND_KEEP_ALIGN                    =>     ("FALSE"),
        CHAN_BOND_MAX_SKEW                      =>     (7),
        CHAN_BOND_SEQ_LEN                       =>     (1),
        CHAN_BOND_SEQ_1_1                       =>     ("0101111100"),
        CHAN_BOND_SEQ_1_2                       =>     ("0000000000"),
        CHAN_BOND_SEQ_1_3                       =>     ("0000000000"),
        CHAN_BOND_SEQ_1_4                       =>     ("0000000000"),
        CHAN_BOND_SEQ_1_ENABLE                  =>     ("0001"),
        CHAN_BOND_SEQ_2_1                       =>     ("0000000000"),
        CHAN_BOND_SEQ_2_2                       =>     ("0000000000"),
        CHAN_BOND_SEQ_2_3                       =>     ("0000000000"),
        CHAN_BOND_SEQ_2_4                       =>     ("0000000000"),
        CHAN_BOND_SEQ_2_ENABLE                  =>     ("0000"),
        CHAN_BOND_SEQ_2_USE                     =>     ("FALSE"),
        FTS_DESKEW_SEQ_ENABLE                   =>     ("1111"),
        FTS_LANE_DESKEW_CFG                     =>     ("1111"),
        FTS_LANE_DESKEW_EN                      =>     ("FALSE"),

       ------------------------Clock Correction----------------------
        CLK_COR_KEEP_IDLE                       =>     ("FALSE"),
        CLK_COR_MAX_LAT                         =>     (31),
        CLK_COR_MIN_LAT                         =>     (24),
        CLK_COR_PRECEDENCE                      =>     ("TRUE"),
        CLK_CORRECT_USE                         =>     ("TRUE"),
        CLK_COR_REPEAT_WAIT                     =>     (0),
        CLK_COR_SEQ_LEN                         =>     (4),
        CLK_COR_SEQ_1_1                         =>     ("0111110111"),
        CLK_COR_SEQ_1_2                         =>     ("0111110111"),
        CLK_COR_SEQ_1_3                         =>     ("0111110111"),
        CLK_COR_SEQ_1_4                         =>     ("0111110111"),
        CLK_COR_SEQ_1_ENABLE                    =>     ("1111"),
        CLK_COR_SEQ_2_1                         =>     ("0100000000"),
        CLK_COR_SEQ_2_2                         =>     ("0100000000"),
        CLK_COR_SEQ_2_3                         =>     ("0100000000"),
        CLK_COR_SEQ_2_4                         =>     ("0100000000"),
        CLK_COR_SEQ_2_ENABLE                    =>     ("1111"),
        CLK_COR_SEQ_2_USE                       =>     ("FALSE"),

       ----------------------------CHANNEL PLL----------------------------
        CPLL_CFG                                =>     (x"BC07DC"),
        CPLL_FBDIV                              =>     (4),
        CPLL_FBDIV_45                           =>     (5),
        CPLL_INIT_CFG                           =>     (x"00001E"),
        CPLL_LOCK_CFG                           =>     (x"01E8"),
        CPLL_REFCLK_DIV                         =>     (1),
        RXOUT_DIV                               =>     (1),
        TXOUT_DIV                               =>     (1),

       ---------------------------EYESCAN----------------------------
        ES_CONTROL                              =>     ("000000"),
        ES_ERRDET_EN                            =>     ("FALSE"),
        ES_EYE_SCAN_EN                          =>     ("TRUE"),
        ES_HORZ_OFFSET                          =>     (x"000"),
        ES_PMA_CFG                              =>     ("0000000000"),
        ES_PRESCALE                             =>     ("00000"),
        ES_QUALIFIER                            =>     (x"00000000000000000000"),
        ES_QUAL_MASK                            =>     (x"00000000000000000000"),
        ES_SDATA_MASK                           =>     (x"00000000000000000000"),
        ES_VERT_OFFSET                          =>     ("000000000"),
        OUTREFCLK_SEL_INV                       =>     ("11"),
        PCS_PCIE_EN                             =>     ("FALSE"),
        PCS_RSVD_ATTR                           =>     (PCS_RSVD_ATTR_IN),
        PMA_RSV                                 =>     (PMA_RSV_IN),
        PMA_RSV2                                =>     (x"2050"),
        PMA_RSV3                                =>     ("00"),
        PMA_RSV4                                =>     (x"00000000"),
        RX_BIAS_CFG                             =>     ("000000000100"),
        DMONITOR_CFG                            =>     (x"000A00"),

       -------------RX Elastic Buffer and Phase alignment------------
        RXBUF_ADDR_MODE                         =>     ("FULL"),
        RXBUF_EIDLE_HI_CNT                      =>     ("1000"),
        RXBUF_EIDLE_LO_CNT                      =>     ("0000"),
        RXBUF_EN                                =>     ("TRUE"),
        RX_BUFFER_CFG                           =>     ("000000"),
        RXBUF_RESET_ON_CB_CHANGE                =>     ("TRUE"),
        RXBUF_RESET_ON_COMMAALIGN               =>     ("FALSE"),
        RXBUF_RESET_ON_EIDLE                    =>     ("FALSE"),
        RXBUF_RESET_ON_RATE_CHANGE              =>     ("TRUE"),
        RXBUFRESET_TIME                         =>     ("00001"),
        RXBUF_THRESH_OVFLW                      =>     (61),
        RXBUF_THRESH_OVRD                       =>     ("FALSE"),
        RXBUF_THRESH_UNDFLW                     =>     (4),
        RXDLY_CFG                               =>     (x"001F"),
        RXDLY_LCFG                              =>     (x"030"),
        RXDLY_TAP_CFG                           =>     (x"0000"),
        RXPH_CFG                                =>     (x"000000"),
        RXPHDLY_CFG                             =>     (x"084020"),
        RXPH_MONITOR_SEL                        =>     ("00000"),
        RX_XCLK_SEL                             =>     ("RXREC"),

       ----------RX Driver,OOB signalling,Coupling and Eq.,CDR-------
        RXCDR_CFG                               =>     (x"03000023FF20400020"),
        RXCDRFREQRESET_TIME                     =>     ("00001"),
        RXCDR_FR_RESET_ON_EIDLE                 =>     ('0'),
        RXCDR_HOLD_DURING_EIDLE                 =>     ('0'),
        RXCDR_LOCK_CFG                          =>     ("010101"),
        RXCDR_PH_RESET_ON_EIDLE                 =>     ('0'),
        RXCDRPHRESET_TIME                       =>     ("00001"),
        RXOOB_CFG                               =>     ("0000110"),

       -------------------------RX Interface-------------------------
        RX_INT_DATAWIDTH                        =>     (1),
        RX_DATA_WIDTH                           =>     (40),
        RX_CLKMUX_PD                            =>     ('1'),
        RX_CLK25_DIV                            =>     (5),
        RX_CM_SEL                               =>     ("11"),
        RX_CM_TRIM                              =>     ("010"),
        RX_DDI_SEL                              =>     ("000000"),
        RX_DEBUG_CFG                            =>     ("000000000000"),

       --------------RX Decision Feedback Equalizer(DFE)-------------
        RX_DEFER_RESET_BUF_EN                   =>     ("TRUE"),
        RX_DFE_GAIN_CFG                         =>     (x"020FEA"),
        RX_DFE_H2_CFG                           =>     ("000000000000"),
        RX_DFE_H3_CFG                           =>     ("000001000000"),
        RX_DFE_H4_CFG                           =>     ("00011110000"),
        RX_DFE_H5_CFG                           =>     ("00011100000"),
        RX_DFE_LPM_HOLD_DURING_EIDLE            =>     ('0'),
        RX_DFE_KL_CFG                           =>     ("0000011111110"),
        RX_DFE_LPM_CFG                          =>     (x"0954"),
        RX_OS_CFG                               =>     ("0000010000000"),
        RX_DFE_UT_CFG                           =>     ("10001111000000000"),
        RX_DFE_VP_CFG                           =>     ("00011111100000011"),
        RXDFELPMRESET_TIME                      =>     ("0001111"),
        RXLPM_HF_CFG                            =>     ("00000011110000"),
        RXLPM_LF_CFG                            =>     ("00000011110000"),

       -------------------------RX Gearbox---------------------------
        RXGEARBOX_EN                            =>     ("FALSE"),
        GEARBOX_MODE                            =>     ("000"),
        RXISCANRESET_TIME                       =>     ("00001"),
        RXPCSRESET_TIME                         =>     ("00001"),
        RXPMARESET_TIME                         =>     ("00011"),

       -------------------------PRBS Detection-----------------------
        RXPRBS_ERR_LOOPBACK                     =>     ('0'),

       -------------RX Attributes for PCI Express/SATA/SAS----------
        PD_TRANS_TIME_FROM_P2                   =>     (x"03c"),
        PD_TRANS_TIME_NONE_P2                   =>     (x"19"),
        PD_TRANS_TIME_TO_P2                     =>     (x"64"),
        SAS_MAX_COM                             =>     (64),
        SAS_MIN_COM                             =>     (36),
        SATA_BURST_SEQ_LEN                      =>     ("0101"),
        SATA_BURST_VAL                          =>     ("100"),
        SATA_CPLL_CFG                           =>     ("VCO_3000MHZ"),
        SATA_EIDLE_VAL                          =>     ("100"),
        SATA_MAX_BURST                          =>     (8),
        SATA_MAX_INIT                           =>     (21),
        SATA_MAX_WAKE                           =>     (7),
        SATA_MIN_BURST                          =>     (4),
        SATA_MIN_INIT                           =>     (12),
        SATA_MIN_WAKE                           =>     (4),
        TERM_RCAL_CFG                           =>     ("10000"),
        TERM_RCAL_OVRD                          =>     ('0'),
        TRANS_TIME_RATE                         =>     (x"0E"),
        TST_RSV                                 =>     (x"00000000"),

       --------------TX Buffering and Phase Alignment----------------
        TXBUF_EN                                =>     ("TRUE"),
        TXBUF_RESET_ON_RATE_CHANGE              =>     ("TRUE"),
        TXDLY_CFG                               =>     (x"001F"),
        TXDLY_LCFG                              =>     (x"030"),
        TXDLY_TAP_CFG                           =>     (x"0000"),
        TXPH_CFG                                =>     (x"0780"),
        TXPHDLY_CFG                             =>     (x"084020"),
        TXPH_MONITOR_SEL                        =>     ("00000"),
        TX_XCLK_SEL                             =>     ("TXOUT"),

       -------------------------TX Interface-------------------------
        TX_DATA_WIDTH                           =>     (40),
        TX_DEEMPH0                              =>     ("00000"),
        TX_DEEMPH1                              =>     ("00000"),
        TX_INT_DATAWIDTH                        =>     (1),
        TX_CLKMUX_PD                            =>     ('1'),
        TX_CLK25_DIV                            =>     (5),

       ----------------TX Driver and OOB Signalling------------------
        TX_EIDLE_ASSERT_DELAY                   =>     ("110"),
        TX_EIDLE_DEASSERT_DELAY                 =>     ("100"),
        TX_LOOPBACK_DRIVE_HIZ                   =>     ("FALSE"),
        TX_MAINCURSOR_SEL                       =>     ('0'),
        TX_DRIVE_MODE                           =>     ("DIRECT"),

       -------------------------TX Gearbox---------------------------
        TXGEARBOX_EN                            =>     ("FALSE"),

       ------------------TX Attributes for PCI Express---------------
        TX_MARGIN_FULL_0                        =>     ("1001110"),
        TX_MARGIN_FULL_1                        =>     ("1001001"),
        TX_MARGIN_FULL_2                        =>     ("1000101"),
        TX_MARGIN_FULL_3                        =>     ("1000010"),
        TX_MARGIN_FULL_4                        =>     ("1000000"),
        TX_MARGIN_LOW_0                         =>     ("1000110"),
        TX_MARGIN_LOW_1                         =>     ("1000100"),
        TX_MARGIN_LOW_2                         =>     ("1000010"),
        TX_MARGIN_LOW_3                         =>     ("1000000"),
        TX_MARGIN_LOW_4                         =>     ("1000000"),
        TXPCSRESET_TIME                         =>     ("00001"),
        TXPMARESET_TIME                         =>     ("00001"),
        TX_QPI_STATUS_EN                        =>     ('0'),
        TX_RXDETECT_CFG                         =>     (x"1832"),
        TX_RXDETECT_REF                         =>     ("100"),
        UCODEER_CLR                             =>     ('0'),
        RX_DFE_KL_CFG2                          =>     (RX_DFE_KL_CFG2_IN),
        RX_DFE_XYD_CFG                          =>     ("0000000000000"),
        TX_PREDRIVER_MODE                       =>     ('0')


    )
    port map
    (
                      ---------------------------------- Channel ---------------------------------
        CFGRESET                        =>      tied_to_ground_i,
        CLKRSVD                         =>      "0000",
        DMONITOROUT                     =>      dmonitorout_out,
        GTRESETSEL                      =>      tied_to_ground_i,
        GTRSVD                          =>      "0000000000000000",
        QPLLCLK                         =>      QPLLCLK_IN,
        QPLLREFCLK                      =>      QPLLREFCLK_IN,
        RESETOVRD                       =>      tied_to_ground_i,
        ---------------- Channel - Dynamic Reconfiguration Port (DRP) --------------
        DRPADDR                         =>      DRPADDR_IN,
        DRPCLK                          =>      DRPCLK_IN,
        DRPDI                           =>      DRPDI_IN,
        DRPDO                           =>      DRPDO_OUT,
        DRPEN                           =>      DRPEN_IN,
        DRPRDY                          =>      DRPRDY_OUT,
        DRPWE                           =>      DRPWE_IN,
        ------------------------- Channel - Ref Clock Ports ------------------------
        GTGREFCLK                       =>      tied_to_ground_i,
        GTNORTHREFCLK0                  =>      tied_to_ground_i,
        GTNORTHREFCLK1                  =>      tied_to_ground_i,
        GTREFCLK0                       =>      GTREFCLK0_IN,
        GTREFCLK1                       =>      tied_to_ground_i,
        GTREFCLKMONITOR                 =>      open,
        GTSOUTHREFCLK0                  =>      tied_to_ground_i,
        GTSOUTHREFCLK1                  =>      tied_to_ground_i,
        -------------------------------- Channel PLL -------------------------------
        CPLLFBCLKLOST                   =>      CPLLFBCLKLOST_OUT,
        CPLLLOCK                        =>      CPLLLOCK_OUT,
        CPLLLOCKDETCLK                  =>      CPLLLOCKDETCLK_IN,
        CPLLLOCKEN                      =>      tied_to_vcc_i,
        CPLLPD                          =>      cpll_pd_i,
        CPLLREFCLKLOST                  =>      CPLLREFCLKLOST_OUT,
        CPLLREFCLKSEL                   =>      "001",
        CPLLRESET                       =>      cpll_reset_i,
        ------------------------------- Eye Scan Ports -----------------------------
        EYESCANDATAERROR                =>      EYESCANDATAERROR_OUT,
        EYESCANMODE                     =>      tied_to_ground_i,
        EYESCANRESET                    =>      eyescanreset_in,
        EYESCANTRIGGER                  =>      eyescantrigger_in,
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK                        =>      LOOPBACK_IN,
        RXPD                            =>      RXPD_IN,
        TXPD                            =>      TXPD_IN,
        ----------------------------- PCS Reserved Ports ---------------------------
        PCSRSVDIN                       =>      "0000000000000000",
        PCSRSVDIN2                      =>      "00000",
        PCSRSVDOUT                      =>      open,
        ----------------------------- PMA Reserved Ports ---------------------------
        PMARSVDIN                       =>      "00000",
        PMARSVDIN2                      =>      "00000",
        ------------------------------- Receive Ports ------------------------------
        RXQPIEN                         =>      tied_to_ground_i,
        RXQPISENN                       =>      open,
        RXQPISENP                       =>      open,
        RXSYSCLKSEL                     =>      "00",
        RXUSERRDY                       =>      RXUSERRDY_IN,
        -------------- Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
        RXDATAVALID                     =>      open,
        RXGEARBOXSLIP                   =>      tied_to_ground_i,
        RXHEADER                        =>      open,
        RXHEADERVALID                   =>      open,
        RXSTARTOFSEQ                    =>      open,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RX8B10BEN                       =>      tied_to_vcc_i,
        RXCHARISCOMMA(7 downto 4)       =>      rxchariscomma_float_i,
        RXCHARISCOMMA(3 downto 0)       =>      RXCHARISCOMMA_OUT,
        RXCHARISK(7 downto 4)           =>      rxcharisk_float_i,
        RXCHARISK(3 downto 0)           =>      RXCHARISK_OUT,
        RXDISPERR(7 downto 4)           =>      rxdisperr_float_i,
        RXDISPERR(3 downto 0)           =>      RXDISPERR_OUT,
        RXNOTINTABLE(7 downto 4)        =>      rxnotintable_float_i,
        RXNOTINTABLE(3 downto 0)        =>      RXNOTINTABLE_OUT,
        ------------------- Receive Ports - Channel Bonding Ports ------------------
        RXCHANBONDSEQ                   =>      open,
        RXCHBONDEN                      =>      tied_to_ground_i,
        RXCHBONDI                       =>      "00000",
        RXCHBONDLEVEL                   =>      tied_to_ground_vec_i(2 downto 0),
        RXCHBONDMASTER                  =>      tied_to_ground_i,
        RXCHBONDO                       =>      open,
        RXCHBONDSLAVE                   =>      tied_to_ground_i,
        ------------------- Receive Ports - Channel Bonding Ports  -----------------
        RXCHANISALIGNED                 =>      open,
        RXCHANREALIGN                   =>      open,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT                     =>      RXCLKCORCNT_OUT,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        RXBYTEISALIGNED                 =>      rxbyteisaligned_out,
        RXBYTEREALIGN                   =>      RXBYTEREALIGN_OUT,
        RXCOMMADET                      =>      rxcommadet_out,
        RXCOMMADETEN                    =>      tied_to_vcc_i,
        RXMCOMMAALIGNEN                 =>      RXMCOMMAALIGNEN_IN,
        RXPCOMMAALIGNEN                 =>      RXPCOMMAALIGNEN_IN,
        RXSLIDE                         =>      tied_to_ground_i,
        ----------------------- Receive Ports - PRBS Detection ---------------------
        RXPRBSCNTRESET                  =>      rxprbscntreset_in,
        RXPRBSERR                       =>      rxprbserr_out,
        RXPRBSSEL                       =>      rxprbssel_in,
        ------------------- Receive Ports - RX Data Path interface -----------------
        GTRXRESET                       =>      GTRXRESET_IN,
        RXDATA                          =>      rxdata_i,
        RXOUTCLK                        =>      RXOUTCLK_OUT,
        RXOUTCLKFABRIC                  =>      open,
        RXOUTCLKPCS                     =>      open,
        RXOUTCLKSEL                     =>      "010",
        RXPCSRESET                      =>      rxpcsreset_in,
        RXPMARESET                      =>      RXPMARESET_IN,
        RXUSRCLK                        =>      RXUSRCLK_IN,
        RXUSRCLK2                       =>      RXUSRCLK2_IN,
        ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
        RXDFEAGCHOLD                    =>      RXDFEAGCHOLD_IN,
        RXDFEAGCOVRDEN                  =>      tied_to_ground_i,
        RXDFECM1EN                      =>      tied_to_ground_i,
        RXDFELFHOLD                     =>      RXDFELFHOLD_IN,
        RXDFELFOVRDEN                   =>      tied_to_vcc_i,
        RXDFELPMRESET                   =>      rxdfelpmreset_in,
        RXDFETAP2HOLD                   =>      tied_to_ground_i,
        RXDFETAP2OVRDEN                 =>      tied_to_ground_i,
        RXDFETAP3HOLD                   =>      tied_to_ground_i,
        RXDFETAP3OVRDEN                 =>      tied_to_ground_i,
        RXDFETAP4HOLD                   =>      tied_to_ground_i,
        RXDFETAP4OVRDEN                 =>      tied_to_ground_i,
        RXDFETAP5HOLD                   =>      tied_to_ground_i,
        RXDFETAP5OVRDEN                 =>      tied_to_ground_i,
        RXDFEUTHOLD                     =>      tied_to_ground_i,
        RXDFEUTOVRDEN                   =>      tied_to_ground_i,
        RXDFEVPHOLD                     =>      tied_to_ground_i,
        RXDFEVPOVRDEN                   =>      tied_to_ground_i,
        RXDFEVSEN                       =>      tied_to_ground_i,
        RXDFEXYDEN                      =>      tied_to_vcc_i,
        RXDFEXYDHOLD                    =>      tied_to_ground_i,
        RXDFEXYDOVRDEN                  =>      tied_to_ground_i,
        RXMONITOROUT                    =>      rxmonitorout_out,
        RXMONITORSEL                    =>      rxmonitorsel_in,
        RXOSHOLD                        =>      tied_to_ground_i,
        RXOSOVRDEN                      =>      tied_to_ground_i,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        GTXRXN                          =>      GTXRXN_IN,
        GTXRXP                          =>      GTXRXP_IN,
        RXCDRFREQRESET                  =>      tied_to_ground_i,
        RXCDRHOLD                       =>      rxcdrhold_in,
        RXCDRLOCK                       =>      RXCDRLOCK_OUT,
        RXCDROVRDEN                     =>      rxcdrovrden_in,
        RXCDRRESET                      =>      tied_to_ground_i,
        RXCDRRESETRSV                   =>      tied_to_ground_i,
        RXELECIDLE                      =>      open,
        RXELECIDLEMODE                  =>      "11",
        RXLPMEN                         =>      rxlpmen_in,
        RXLPMHFHOLD                     =>      tied_to_ground_i,
        RXLPMHFOVRDEN                   =>      tied_to_ground_i,
        RXLPMLFHOLD                     =>      tied_to_ground_i,
        RXLPMLFKLOVRDEN                 =>      tied_to_ground_i,
        RXOOBRESET                      =>      tied_to_ground_i,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        RXBUFRESET                      =>      rxbufreset_in,
        RXBUFSTATUS                     =>      RXBUFSTATUS_OUT,
        RXDDIEN                         =>      tied_to_ground_i,
        RXDLYBYPASS                     =>      tied_to_vcc_i,
        RXDLYEN                         =>      tied_to_ground_i,
        RXDLYOVRDEN                     =>      tied_to_ground_i,
        RXDLYSRESET                     =>      tied_to_ground_i,
        RXDLYSRESETDONE                 =>      open,
        RXPHALIGN                       =>      tied_to_ground_i,
        RXPHALIGNDONE                   =>      open,
        RXPHALIGNEN                     =>      tied_to_ground_i,
        RXPHDLYPD                       =>      tied_to_ground_i,
        RXPHDLYRESET                    =>      tied_to_ground_i,
        RXPHMONITOR                     =>      open,
        RXPHOVRDEN                      =>      tied_to_ground_i,
        RXPHSLIPMONITOR                 =>      open,
        RXSTATUS                        =>      open,
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        RXRATE                          =>      tied_to_ground_vec_i(2 downto 0),
        RXRATEDONE                      =>      open,
        RXRESETDONE                     =>      RXRESETDONE_OUT,
        -------------- Receive Ports - RX Pipe Control for PCI Express -------------
        PHYSTATUS                       =>      open,
        RXVALID                         =>      open,
        ----------------- Receive Ports - RX Polarity Control Ports ----------------
        RXPOLARITY                      =>      RXPOLARITY_IN,
        --------------------- Receive Ports - RX Ports for SATA --------------------
        RXCOMINITDET                    =>      open,
        RXCOMSASDET                     =>      open,
        RXCOMWAKEDET                    =>      open,
        ------------------------------- Transmit Ports -----------------------------
        SETERRSTATUS                    =>      tied_to_ground_i,
        TSTIN                           =>      "11111111111111111111",
        TSTOUT                          =>      open,
        TXPHDLYTSTCLK                   =>      tied_to_ground_i,
        TXPOSTCURSOR                    =>      txpostcursor_in,
        TXPOSTCURSORINV                 =>      tied_to_ground_i,
        TXPRECURSOR                     =>      txprecursor_in,
        TXPRECURSORINV                  =>      tied_to_ground_i,
        TXQPIBIASEN                     =>      tied_to_ground_i,
        TXQPISENN                       =>      open,
        TXQPISENP                       =>      open,
        TXQPISTRONGPDOWN                =>      tied_to_ground_i,
        TXQPIWEAKPUP                    =>      tied_to_ground_i,
        TXSYSCLKSEL                     =>      "00",
        TXUSERRDY                       =>      TXUSERRDY_IN,
        -------------- Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
        TXGEARBOXREADY                  =>      open,
        TXHEADER                        =>      tied_to_ground_vec_i(2 downto 0),
        TXSEQUENCE                      =>      tied_to_ground_vec_i(6 downto 0),
        TXSTARTSEQ                      =>      tied_to_ground_i,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TX8B10BBYPASS                   =>      tied_to_ground_vec_i(7 downto 0),
        TX8B10BEN                       =>      tied_to_vcc_i,
        TXCHARDISPMODE(7 downto 4)           =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPMODE(3 downto 0)           =>      txchardispmode_in,
        TXCHARDISPVAL(7 downto 4)           =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPVAL(3 downto 0)           =>      txchardispval_in,
        TXCHARISK(7 downto 4)           =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARISK(3 downto 0)           =>      TXCHARISK_IN,
        ------------ Transmit Ports - TX Buffer and Phase Alignment Ports ----------
        TXBUFSTATUS                     =>      TXBUFSTATUS_OUT,
        TXDLYBYPASS                     =>      tied_to_vcc_i,
        TXDLYEN                         =>      tied_to_ground_i,
        TXDLYHOLD                       =>      tied_to_ground_i,
        TXDLYOVRDEN                     =>      tied_to_ground_i,
        TXDLYSRESET                     =>      tied_to_ground_i,
        TXDLYSRESETDONE                 =>      open,
        TXDLYUPDOWN                     =>      tied_to_ground_i,
        TXPHALIGN                       =>      tied_to_ground_i,
        TXPHALIGNDONE                   =>      open,
        TXPHALIGNEN                     =>      tied_to_ground_i,
        TXPHDLYPD                       =>      tied_to_ground_i,
        TXPHDLYRESET                    =>      tied_to_ground_i,
        TXPHINIT                        =>      tied_to_ground_i,
        TXPHINITDONE                    =>      open,
        TXPHOVRDEN                      =>      tied_to_ground_i,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        GTTXRESET                       =>      GTTXRESET_IN,
        TXDATA                          =>      txdata_i,
        TXOUTCLK                        =>      TXOUTCLK_OUT,
        TXOUTCLKFABRIC                  =>      TXOUTCLKFABRIC_OUT,
        TXOUTCLKPCS                     =>      TXOUTCLKPCS_OUT,
        TXOUTCLKSEL                     =>      "010",
        TXPCSRESET                      =>      txpcsreset_in,
        TXPMARESET                      =>      txpmareset_in,
        TXUSRCLK                        =>      TXUSRCLK_IN,
        TXUSRCLK2                       =>      TXUSRCLK2_IN,
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        GTXTXN                          =>      GTXTXN_OUT,
        GTXTXP                          =>      GTXTXP_OUT,
        TXBUFDIFFCTRL                   =>      "100",
        TXDIFFCTRL                      =>      txdiffctrl_in,
        TXDIFFPD                        =>      tied_to_ground_i,
        TXINHIBIT                       =>      txinhibit_in,
        TXMAINCURSOR                    =>      txmaincursor_in,
        TXPDELECIDLEMODE                =>      tied_to_ground_i,
        TXPISOPD                        =>      tied_to_ground_i,
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        TXRATE                          =>      tied_to_ground_vec_i(2 downto 0),
        TXRATEDONE                      =>      open,
        TXRESETDONE                     =>      TXRESETDONE_OUT,
        --------------------- Transmit Ports - TX PRBS Generator -------------------
        TXPRBSFORCEERR                  =>      txprbsforceerr_in,
        TXPRBSSEL                       =>      txprbssel_in,
        -------------------- Transmit Ports - TX Polarity Control ------------------
        TXPOLARITY                      =>      txpolarity_in,
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TXDEEMPH                        =>      tied_to_ground_i,
        TXDETECTRX                      =>      tied_to_ground_i,
        TXELECIDLE                      =>      txelecidle_in,
        TXMARGIN                        =>      tied_to_ground_vec_i(2 downto 0),
        TXSWING                         =>      tied_to_ground_i,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TXCOMFINISH                     =>      open,
        TXCOMINIT                       =>      tied_to_ground_i,
        TXCOMSAS                        =>      tied_to_ground_i,
        TXCOMWAKE                       =>      tied_to_ground_i

    );



    process( gtrefclk0_in )
    begin
        if(gtrefclk0_in'event and gtrefclk0_in = '1') then 
           cpllpd_wait <= cpllpd_wait(94 downto 0) & '0';
           cpllreset_wait <= cpllreset_wait(126 downto 0) & '0';
         end if;
    end process;

cpllpd_ovrd_i <= cpllpd_wait(95);
cpllreset_ovrd_i <= cpllreset_wait(127);

cpll_pd_i <= cpllpd_ovrd_i;

process (cplllockdetclk_in)
begin
if(cplllockdetclk_in'event and cplllockdetclk_in = '1') then 
  if(CPLLRESET_IN = '1' and ack_flag = '0') then
    flag <= not flag;
    flag2 <= '1';
  else
    flag <= flag; 
    flag2 <= '0';
end if;
end if;
end process;


process (cplllockdetclk_in)
begin
if(cplllockdetclk_in'event and cplllockdetclk_in = '1') then 
  if(flag2 = '1') then
   ack_flag <= '1';
 elsif(ack_i = '1') then
   ack_flag <= '0';
 end if;
end if;
end process;


  data_sync_reg1 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => flag,
    Q    => data_sync1
  );

 data_sync_reg2 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => data_sync1,
    Q    => data_sync2
  );

 data_sync_reg3 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => data_sync2,
    Q    => data_sync3
  );

 data_sync_reg4 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => data_sync3,
    Q    => data_sync4
  );

 data_sync_reg5 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => data_sync4,
    Q    => data_sync5
  );  

  data_sync_reg6 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => gtrefclk0_in,
    D    => data_sync5,
    Q    => data_sync6
  );
cpllreset_sync <= data_sync6 xor data_sync5;

  ack_sync_reg1 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => data_sync6,
    Q    => ack_sync1
  );

 ack_sync_reg2 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => ack_sync1,
    Q    => ack_sync2
  );

 ack_sync_reg3 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => ack_sync2,
    Q    => ack_sync3
  );

 ack_sync_reg4 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => ack_sync3,
    Q    => ack_sync4
  );

 ack_sync_reg5 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => ack_sync4,
    Q    => ack_sync5
  );  

  ack_sync_reg6 : FD
  generic map (
    INIT => '0'
  )
  port map (
    C    => cplllockdetclk_in,
    D    => ack_sync5,
    Q    => ack_sync6
  );

ack_i <= ack_sync5 xor ack_sync6;
cpll_reset_i <= cpllreset_sync or cpllreset_ovrd_i;

 end MAPPED;


