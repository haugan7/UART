------------------------------------------------------------------------------/
-- (c) Copyright 2013 Xilinx, Inc. All rights reserved.
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
library IEEE;
  use IEEE.numeric_std.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_misc.all;
  use ieee.std_logic_1164.all;

library UNISIM;
  use UNISIM.Vcomponents.ALL;

--***************************** Entity Declaration ****************************

entity design_1_aurora_8b10b_0_0_gt_common_wrapper is
generic
(
    -- Simulation attributes
    WRAPPER_SIM_GTRESET_SPEEDUP    : string   := "FALSE" -- Set to "TRUE" to speed up sim reset
);
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

end design_1_aurora_8b10b_0_0_gt_common_wrapper;
  
architecture STRUCTURE of design_1_aurora_8b10b_0_0_gt_common_wrapper is

--*************************Logic to set Attribute QPLL_FB_DIV*****************************
    impure function conv_qpll_fbdiv_top (qpllfbdiv_top : in integer) return bit_vector is
    begin
       if (qpllfbdiv_top = 16) then
         return "0000100000";
       elsif (qpllfbdiv_top = 20) then
         return "0000110000" ;
       elsif (qpllfbdiv_top = 32) then
         return "0001100000" ;
       elsif (qpllfbdiv_top = 40) then
         return "0010000000" ;
       elsif (qpllfbdiv_top = 64) then
         return "0011100000" ;
       elsif (qpllfbdiv_top = 66) then
         return "0101000000" ;
       elsif (qpllfbdiv_top = 80) then
         return "0100100000" ;
       elsif (qpllfbdiv_top = 100) then
         return "0101110000" ;
       else
         return "0000000000" ;
       end if;
    end function;

    impure function conv_qpll_fbdiv_ratio (qpllfbdiv_top : in integer) return bit is
    begin
       if (qpllfbdiv_top = 16) then
         return '1';
       elsif (qpllfbdiv_top = 20) then
         return '1' ;
       elsif (qpllfbdiv_top = 32) then
         return '1' ;
       elsif (qpllfbdiv_top = 40) then
         return '1' ;
       elsif (qpllfbdiv_top = 64) then
         return '1' ;
       elsif (qpllfbdiv_top = 66) then
         return '0' ;
       elsif (qpllfbdiv_top = 80) then
         return '1' ;
       elsif (qpllfbdiv_top = 100) then
         return '1' ;
       else
         return '1' ;
       end if;
    end function;

    constant   QPLL_FBDIV_TOP   :   integer  := 40;
    constant   QPLL_FBDIV_IN    :   bit_vector(9 downto 0) := conv_qpll_fbdiv_top(QPLL_FBDIV_TOP);
    constant   QPLL_FBDIV_RATIO :   bit := conv_qpll_fbdiv_ratio(QPLL_FBDIV_TOP);

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;

--********************************* Main Body of Code**************************

begin                      

--********************************* Main Body of Code**************************
    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';


    --_________________________________________________________________________
    --_________________________________________________________________________
    --_________________________GTXE2_COMMON____________________________________
gtxe2_common_i : GTXE2_COMMON
    generic map
    (
            -- Simulation attributes
            SIM_RESET_SPEEDUP    => WRAPPER_SIM_GTRESET_SPEEDUP,
            SIM_QPLLREFCLK_SEL   => ("001"),
            SIM_VERSION          => ("4.0"),


       ------------------COMMON BLOCK Attributes---------------
        BIAS_CFG                                =>     (x"0000040000001000"),
        COMMON_CFG                              =>     (x"00000000"),
        QPLL_CFG                                =>     (x"06801C1"),
        QPLL_CLKOUT_CFG                         =>     ("0000"),
        QPLL_COARSE_FREQ_OVRD                   =>     ("010000"),
        QPLL_COARSE_FREQ_OVRD_EN                =>     ('0'),
        QPLL_CP                                 =>     ("0000011111"),
        QPLL_CP_MONITOR_EN                      =>     ('0'),
        QPLL_DMONITOR_SEL                       =>     ('0'),
        QPLL_FBDIV                              =>     (QPLL_FBDIV_IN),
        QPLL_FBDIV_MONITOR_EN                   =>     ('0'),
        QPLL_FBDIV_RATIO                        =>     (QPLL_FBDIV_RATIO),
        QPLL_INIT_CFG                           =>     (x"000006"),
        QPLL_LOCK_CFG                           =>     (x"21E8"),
        QPLL_LPF                                =>     ("1111"),
        QPLL_REFCLK_DIV                         =>     (1)

       
    )
    port map
    (
        ------------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
        DRPADDR                         =>      tied_to_ground_vec_i(7 downto 0),
        DRPCLK                          =>      tied_to_ground_i,
        DRPDI                           =>      tied_to_ground_vec_i(15 downto 0),
        DRPDO                           =>      open,
        DRPEN                           =>      tied_to_ground_i,
        DRPRDY                          =>      open,
        DRPWE                           =>      tied_to_ground_i,
        ---------------------- Common Block  - Ref Clock Ports ---------------------
        GTGREFCLK                       =>      tied_to_ground_i,
        GTNORTHREFCLK0                  =>      tied_to_ground_i,
        GTNORTHREFCLK1                  =>      tied_to_ground_i,
        GTREFCLK0                       =>      gt0_gtrefclk0_common_in,
        GTREFCLK1                       =>      tied_to_ground_i,
        GTSOUTHREFCLK0                  =>      tied_to_ground_i,
        GTSOUTHREFCLK1                  =>      tied_to_ground_i,
        ------------------------- Common Block - QPLL Ports ------------------------
        QPLLDMONITOR                    =>      open,
        QPLLFBCLKLOST                   =>      open,
        QPLLLOCK                        =>      gt0_qplllock_out,
        QPLLLOCKDETCLK                  =>      gt0_qplllockdetclk_in,
        QPLLLOCKEN                      =>      tied_to_vcc_i,
        QPLLOUTCLK                     => gt_qpllclk_quad1_i,
        QPLLOUTREFCLK                  => gt_qpllrefclk_quad1_i,
        QPLLOUTRESET                    =>      tied_to_ground_i,
        QPLLPD                          =>      tied_to_vcc_i,
        QPLLREFCLKLOST                  =>      gt0_qpllrefclklost_out,
        QPLLREFCLKSEL                   =>      "001",
        QPLLRESET                       =>      gt0_qpllreset_in,
        QPLLRSVD1                       =>      "0000000000000000",
        QPLLRSVD2                       =>      "11111",
        REFCLKOUTMONITOR                =>      open,
        ----------------------------- Common Block Ports ---------------------------
        BGBYPASSB                       =>      tied_to_vcc_i,
        BGMONITORENB                    =>      tied_to_vcc_i,
        BGPDB                           =>      tied_to_vcc_i,
        BGRCALOVRD                      =>      "11111",
        PMARSVD                         =>      "00000000",
        RCALENB                         =>      tied_to_vcc_i

    );

end STRUCTURE;
 
