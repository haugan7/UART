-------------------------------------------------------------------------------
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
-- Module design_1_aurora_8b10b_0_0_GT_WRAPPER
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.Vcomponents.ALL;

--***************************** Entity Declaration ****************************

entity design_1_aurora_8b10b_0_0_multi_gt is
generic
(
    QPLL_FBDIV_TOP                 : integer  := 40;

    -- Simulation attributes
    WRAPPER_SIM_GTRESET_SPEEDUP     : string     :=  "FALSE";        -- Set to "TRUE" to speed up sim reset
    RX_DFE_KL_CFG2_IN               : bit_vector :=  X"301148AC";
    PMA_RSV_IN                      : bit_vector :=  x"00018480"
);
port
(
--____________________________COMMON PORTS ,_______________________________{
   gt_qpllclk_quad1_i    : in  std_logic;
   gt_qpllrefclk_quad1_i : in  std_logic;
--____________________________COMMON PORTS _______________________________}


    --_________________________________________________________________________
    --_________________________________________________________________________
    --GT0 
    --____________________________CHANNEL PORTS________________________________
    ---------------- Channel - Dynamic Reconfiguration Port (DRP) --------------
    GT0_DRPADDR_IN                          : in   std_logic_vector(8 downto 0);
    GT0_DRPCLK_IN                           : in   std_logic;
    GT0_DRPDI_IN                            : in   std_logic_vector(15 downto 0);
    GT0_DRPDO_OUT                           : out  std_logic_vector(15 downto 0);
    GT0_DRPEN_IN                            : in   std_logic;
    GT0_DRPRDY_OUT                          : out  std_logic;
    GT0_DRPWE_IN                            : in   std_logic;
    ------------------------- Channel - Ref Clock Ports ------------------------
    GT0_GTREFCLK0_IN                        : in   std_logic;
    -------------------------------- Channel PLL -------------------------------
    GT0_CPLLFBCLKLOST_OUT                   : out  std_logic;
    GT0_CPLLLOCK_OUT                        : out  std_logic;
    GT0_CPLLLOCKDETCLK_IN                   : in   std_logic;
    GT0_CPLLREFCLKLOST_OUT                  : out  std_logic;
    GT0_CPLLRESET_IN                        : in   std_logic;
    ------------------------ Loopback and Powerdown Ports ----------------------
    GT0_LOOPBACK_IN                         : in   std_logic_vector(2 downto 0);
    GT0_RXPD_IN                             : in   std_logic_vector(1 downto 0);
    GT0_TXPD_IN                             : in   std_logic_vector(1 downto 0);
    ------------------------------- Receive Ports ------------------------------
    GT0_eyescanreset_in                     : in   std_logic;
    GT0_RXUSERRDY_IN                        : in   std_logic;
    -------------------------- RX Margin Analysis Ports ------------------------
    GT0_eyescandataerror_out                : out  std_logic;
    GT0_eyescantrigger_in                   : in   std_logic;
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GT0_RXCHARISCOMMA_OUT                   : out  std_logic_vector(3 downto 0);
    GT0_RXCHARISK_OUT                       : out  std_logic_vector(3 downto 0);
    GT0_RXDISPERR_OUT                       : out  std_logic_vector(3 downto 0);
    GT0_RXNOTINTABLE_OUT                    : out  std_logic_vector(3 downto 0);
    ------------------- Receive Ports - Pattern Checker Ports ------------------
    GT0_rxprbserr_out                       : out  std_logic;
    GT0_rxprbssel_in                        : in   std_logic_vector(2 downto 0);
    ------------------- Receive Ports - Pattern Checker ports ------------------
    GT0_rxprbscntreset_in                   : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GT0_RXCLKCORCNT_OUT                     : out  std_logic_vector(1 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GT0_rxbyteisaligned_out                 : out  std_logic;
    GT0_RXBYTEREALIGN_OUT                   : out  std_logic;
    GT0_rxcommadet_out                      : out  std_logic;
    GT0_RXMCOMMAALIGNEN_IN                  : in   std_logic;
    GT0_RXPCOMMAALIGNEN_IN                  : in   std_logic;
    --------------------- Receive Ports - RX Equalizer Ports -------------------
    GT0_RXDFEAGCHOLD_IN                     : in   std_logic;
    GT0_RXDFELFHOLD_IN                      : in   std_logic;
    GT0_rxdfelpmreset_in                    : in   std_logic;
    GT0_rxmonitorout_out                    : out  std_logic_vector(6 downto 0);
    GT0_rxmonitorsel_in                     : in   std_logic_vector(1 downto 0);
    ------------------- Receive Ports - RX Data Path interface -----------------
    GT0_GTRXRESET_IN                        : in   std_logic;
    GT0_RXPCSRESET_IN                       : in   std_logic;
    GT0_RXPMARESET_IN                       : in   std_logic;
    GT0_RXDATA_OUT                          : out  std_logic_vector(31 downto 0);
    GT0_RXOUTCLK_OUT                        : out  std_logic;
    GT0_RXUSRCLK_IN                         : in   std_logic;
    GT0_RXUSRCLK2_IN                        : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GT0_GTXRXN_IN                           : in   std_logic;
    GT0_GTXRXP_IN                           : in   std_logic;
    GT0_RXCDRLOCK_OUT                       : out  std_logic;
    GT0_dmonitorout_out                     : out  std_logic_vector(7 downto 0);
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GT0_rxbufreset_in                       : in   std_logic;
    GT0_RXBUFSTATUS_OUT                     : out  std_logic_vector(2 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GT0_RXRESETDONE_OUT                     : out  std_logic;
    ------------------------ TX Configurable Driver Ports ----------------------
    GT0_txpostcursor_in                     : in   std_logic_vector(4 downto 0);
    GT0_txprecursor_in                      : in   std_logic_vector(4 downto 0);
    -------------------- Receive Ports - RX Margin Analysis ports ----------------
    GT0_rxlpmen_in                          : in   std_logic;
    GT0_rxcdrovrden_in                      : in   std_logic;
    GT0_rxcdrhold_in                        : in   std_logic;
    ----------------- Receive Ports - RX Polarity Control Ports ----------------
    GT0_RXPOLARITY_IN                       : in   std_logic;
    ------------------------------- Transmit Ports -----------------------------
    GT0_TXUSERRDY_IN                        : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GT0_txchardispmode_in                   : in   std_logic_vector(3 downto 0);
    GT0_txchardispval_in                    : in   std_logic_vector(3 downto 0);
    GT0_TXCHARISK_IN                        : in   std_logic_vector(3 downto 0);
    ------------ Transmit Ports - TX Buffer and Phase Alignment Ports ----------
    GT0_TXBUFSTATUS_OUT                     : out  std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GT0_GTTXRESET_IN                        : in   std_logic;
    GT0_TXDATA_IN                           : in   std_logic_vector(31 downto 0);
    GT0_TXOUTCLK_OUT                        : out  std_logic;
    GT0_TXOUTCLKFABRIC_OUT                  : out  std_logic;
    GT0_TXOUTCLKPCS_OUT                     : out  std_logic;
    GT0_TXUSRCLK_IN                         : in   std_logic;
    GT0_TXUSRCLK2_IN                        : in   std_logic;
    --------------------- Transmit Ports - PCI Express Ports -------------------
    GT0_txelecidle_in                       : in   std_logic;
    ------------------ Transmit Ports - Pattern Generator Ports ----------------
    GT0_txprbsforceerr_in                   : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GT0_GTXTXN_OUT                          : out  std_logic;
    GT0_GTXTXP_OUT                          : out  std_logic;
    GT0_txdiffctrl_in                       : in   std_logic_vector(3 downto 0);
    GT0_txmaincursor_in                     : in   std_logic_vector(6 downto 0);
    ----------------- Transmit Ports - TX Polarity Control Ports ---------------
    GT0_txpolarity_in                       : in   std_logic;
    ------------------ Transmit Ports - pattern Generator Ports ----------------
    GT0_txprbssel_in                        : in   std_logic_vector(2 downto 0);
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GT0_txpcsreset_in                       : in   std_logic;
    GT0_txinhibit_in                        : in   std_logic;
    GT0_txpmareset_in                       : in   std_logic;
    GT0_TXRESETDONE_OUT                     : out  std_logic

);


end design_1_aurora_8b10b_0_0_multi_gt;
   
architecture MAPPED of design_1_aurora_8b10b_0_0_multi_gt is

--***********************************Parameter Declarations********************

    constant DLY : time := 1 ns;

--***************************** Signal Declarations *****************************

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;

--*************************** Component Declarations **************************
component design_1_aurora_8b10b_0_0_gt is
generic
(
    -- Simulation attributes
    GT_SIM_GTRESET_SPEEDUP    : string   := "FALSE";
    RX_DFE_KL_CFG2_IN         : bit_vector :=   X"3010D90C";
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
    txinhibit_in                            : in   std_logic;
    txpmareset_in                           : in   std_logic;
    TXRESETDONE_OUT                         : out  std_logic;
    ------------------ Transmit Ports - pattern Generator Ports ----------------
    txprbssel_in                            : in   std_logic_vector(2 downto 0);
    ----------------- Transmit Ports - TX Polarity Control Ports ---------------
    txpolarity_in                           : in   std_logic

);

end component;

--********************************* Main Body of Code**************************

begin                      

    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';

    --------------------------- GT Instances  -------------------------------  

    --_________________________________________________________________________
    --_________________________________________________________________________
    --GT0
    gt0_design_1_aurora_8b10b_0_0_i : design_1_aurora_8b10b_0_0_gt
    generic map
    (
        -- Simulation attributes
        GT_SIM_GTRESET_SPEEDUP => WRAPPER_SIM_GTRESET_SPEEDUP,
        RX_DFE_KL_CFG2_IN      =>  RX_DFE_KL_CFG2_IN,
        PMA_RSV_IN             =>  PMA_RSV_IN,
        PCS_RSVD_ATTR_IN       =>  X"000000000000"
    )
    port map
    (
        ---------------------------------- Channel ---------------------------------
        QPLLCLK_IN                     => gt_qpllclk_quad1_i,
        QPLLREFCLK_IN                  => gt_qpllrefclk_quad1_i,
        ---------------- Channel - Dynamic Reconfiguration Port (DRP) --------------
        DRPADDR_IN                      =>      GT0_DRPADDR_IN,
        DRPCLK_IN                       =>      GT0_DRPCLK_IN,
        DRPDI_IN                        =>      GT0_DRPDI_IN,
        DRPDO_OUT                       =>      GT0_DRPDO_OUT,
        DRPEN_IN                        =>      GT0_DRPEN_IN,
        DRPRDY_OUT                      =>      GT0_DRPRDY_OUT,
        DRPWE_IN                        =>      GT0_DRPWE_IN,
        ------------------------- Channel - Ref Clock Ports ------------------------
        GTREFCLK0_IN                    =>      GT0_GTREFCLK0_IN,
        -------------------------------- Channel PLL -------------------------------
        CPLLFBCLKLOST_OUT               =>      GT0_CPLLFBCLKLOST_OUT,
        CPLLLOCK_OUT                    =>      GT0_CPLLLOCK_OUT,
        CPLLLOCKDETCLK_IN               =>      GT0_CPLLLOCKDETCLK_IN,
        CPLLREFCLKLOST_OUT              =>      GT0_CPLLREFCLKLOST_OUT,
        CPLLRESET_IN                    =>      GT0_CPLLRESET_IN,
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK_IN                     =>      GT0_LOOPBACK_IN,
        RXPD_IN                         =>      GT0_RXPD_IN,
        TXPD_IN                         =>      GT0_TXPD_IN,
        ------------------------------- Receive Ports ------------------------------
        eyescanreset_in                 =>      gt0_eyescanreset_in,
        RXUSERRDY_IN                    =>      GT0_RXUSERRDY_IN,
        -------------------------- RX Margin Analysis Ports ------------------------
        eyescandataerror_out            =>      gt0_eyescandataerror_out,
        eyescantrigger_in               =>      gt0_eyescantrigger_in,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA_OUT               =>      GT0_RXCHARISCOMMA_OUT,
        RXCHARISK_OUT                   =>      GT0_RXCHARISK_OUT,
        RXDISPERR_OUT                   =>      GT0_RXDISPERR_OUT,
        RXNOTINTABLE_OUT                =>      GT0_RXNOTINTABLE_OUT,
        ------------------- Receive Ports - Pattern Checker Ports ------------------
        rxprbserr_out                   =>      gt0_rxprbserr_out,
        rxprbssel_in                    =>      gt0_rxprbssel_in,
        ------------------- Receive Ports - Pattern Checker ports ------------------
        rxprbscntreset_in               =>      gt0_rxprbscntreset_in,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT_OUT                 =>      GT0_RXCLKCORCNT_OUT,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        rxbyteisaligned_out             =>      gt0_rxbyteisaligned_out,
        RXBYTEREALIGN_OUT               =>      GT0_RXBYTEREALIGN_OUT,
        rxcommadet_out                  =>      gt0_rxcommadet_out,
        RXMCOMMAALIGNEN_IN              =>      GT0_RXMCOMMAALIGNEN_IN,
        RXPCOMMAALIGNEN_IN              =>      GT0_RXPCOMMAALIGNEN_IN,
        ----------------------- Receive Ports - RX Equalizer Ports -----------------
        RXDFEAGCHOLD_IN                 =>      GT0_RXDFEAGCHOLD_IN,
        RXDFELFHOLD_IN                  =>      GT0_RXDFELFHOLD_IN,
        rxdfelpmreset_in                =>      GT0_rxdfelpmreset_in,
        rxmonitorout_out                =>      GT0_rxmonitorout_out,
        rxmonitorsel_in                 =>      GT0_rxmonitorsel_in,
        ------------------- Receive Ports - RX Data Path interface -----------------
        GTRXRESET_IN                    =>      GT0_GTRXRESET_IN,
        rxpcsreset_in                   =>      gt0_rxpcsreset_in,
        RXPMARESET_IN                   =>      GT0_RXPMARESET_IN,
        RXDATA_OUT                      =>      GT0_RXDATA_OUT,
        RXOUTCLK_OUT                    =>      GT0_RXOUTCLK_OUT,
        RXUSRCLK_IN                     =>      GT0_RXUSRCLK_IN,
        RXUSRCLK2_IN                    =>      GT0_RXUSRCLK2_IN,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        GTXRXN_IN                       =>      GT0_GTXRXN_IN,
        GTXRXP_IN                       =>      GT0_GTXRXP_IN,
        RXCDRLOCK_OUT                   =>      GT0_RXCDRLOCK_OUT,
        dmonitorout_out                 =>      gt0_dmonitorout_out,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        rxbufreset_in                   =>      gt0_rxbufreset_in,
        RXBUFSTATUS_OUT                 =>      GT0_RXBUFSTATUS_OUT,
        ------------------------ Receive Ports - RX PLL Ports ----------------------
        RXRESETDONE_OUT                 =>      GT0_RXRESETDONE_OUT,
        ------------------------ TX Configurable Driver Ports ----------------------
        txpostcursor_in                 =>       gt0_txpostcursor_in,
        txprecursor_in                  =>       gt0_txprecursor_in,
        -------------------- Receive Ports - RX Margin Analysis ports ----------------
        rxlpmen_in                      =>       gt0_rxlpmen_in,
        rxcdrovrden_in                  =>       gt0_rxcdrovrden_in,
        rxcdrhold_in                    =>       gt0_rxcdrhold_in,
        ----------------- Receive Ports - RX Polarity Control Ports ----------------
        RXPOLARITY_IN                   =>      GT0_RXPOLARITY_IN,
        ------------------------------- Transmit Ports -----------------------------
        TXUSERRDY_IN                    =>      GT0_TXUSERRDY_IN,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        txchardispmode_in               =>      gt0_txchardispmode_in,
        txchardispval_in                =>      gt0_txchardispval_in,
        TXCHARISK_IN                    =>      GT0_TXCHARISK_IN,
        ------------ Transmit Ports - TX Buffer and Phase Alignment Ports ----------
        TXBUFSTATUS_OUT                 =>      GT0_TXBUFSTATUS_OUT,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        GTTXRESET_IN                    =>      GT0_GTTXRESET_IN,
        TXDATA_IN                       =>      GT0_TXDATA_IN,
        TXOUTCLK_OUT                    =>      GT0_TXOUTCLK_OUT,
        TXOUTCLKFABRIC_OUT              =>      GT0_TXOUTCLKFABRIC_OUT,
        TXOUTCLKPCS_OUT                 =>      GT0_TXOUTCLKPCS_OUT,
        TXUSRCLK_IN                     =>      GT0_TXUSRCLK_IN,
        TXUSRCLK2_IN                    =>      GT0_TXUSRCLK2_IN,
        --------------------- Transmit Ports - PCI Express Ports -------------------
        txelecidle_in                   =>      gt0_txelecidle_in,
        ------------------ Transmit Ports - Pattern Generator Ports ----------------
        txprbsforceerr_in               =>      gt0_txprbsforceerr_in,
        ---------------- Transmit Ports - TX Driver and OOB signaling --------------
        GTXTXN_OUT                      =>      GT0_GTXTXN_OUT,
        GTXTXP_OUT                      =>      GT0_GTXTXP_OUT,
        txdiffctrl_in                   =>      gt0_txdiffctrl_in,
        txmaincursor_in                 =>      gt0_txmaincursor_in,
        ----------------------- Transmit Ports - TX PLL Ports ----------------------
        txpcsreset_in                   =>      gt0_txpcsreset_in,
        txinhibit_in                    =>      GT0_txinhibit_in,
        txpmareset_in                   =>      gt0_txpmareset_in,
        TXRESETDONE_OUT                 =>      GT0_TXRESETDONE_OUT,
        ------------------ Transmit Ports - pattern Generator Ports ----------------
        txprbssel_in                    =>      gt0_txprbssel_in,
        ----------------- Transmit Ports - TX Polarity Control Ports ---------------
        txpolarity_in                   =>      gt0_txpolarity_in

    );


end MAPPED;
