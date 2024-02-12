
-- axi_s_frame_append switch IP module.
-- It contains:
-- Two unidirectional axi stream changeover switches, one for each directon.
-- one axi lite register array for configurtion and monitoring.   
 
-- the line switches un on a common stream clock. 
-- The axi register array runs on a separate system bus clock. 
 
-- Author: Kjell Ljøkelsøy Sintef Energy.  2016. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library xpm;
--use xpm.vcomponents.all;

--use work.axi_register_array;
--use work.axi_s_chain_link_switch;
use work.all;





entity axi_s_chain_link_switch is
	generic (

		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5;	


		LINK_FIFO_SIZE 					: integer := 2048;  -- Size of transfer fifo and node input fifo
		LINK_FIFO_FILLED_FLAG_LEVEL_A	: integer := 256;   -- threshold for fifo fill level signal A 
		LINK_FIFO_FILLED_FLAG_LEVEL_B	: integer := 128; 	-- threshold for fifo fill level signal B 

		CONFIG_REGISTER_DEFAULTVALUE   : std_logic_vector(31 downto 0) := X"04000400"; -- Sets default value in register.  X04000400 : local in out enabled, transfer disabled.
		
		-- Parameters of Axis interface
		C_AXIS_DATA_WIDTH				: integer := 32	

	);
	port (

		-- Signals synchronous to system clock.
		frame1_start_pulse 	:  out std_logic := '0';	-- High for one clock cycle at the start of a new frame at the link input. Synchronous to sys_clk  
		frame2_start_pulse 	:  out std_logic := '0'; 		 

				
		-- Signals synchronous to link clock.
		fifo_filled_flag_a1 : out std_logic;	-- fifo fill level indicato. '1': Above threshold A    
		fifo_filled_flag_a2 : out std_logic;
		fifo_filled_flag_b1 : out std_logic;   -- fifo fill level indicato. '1': Above threshold B      
		fifo_filled_flag_b2 : out std_logic;
		
		stream_switch_state_1 : out std_logic_vector (2-1 downto 0);   -- Diagnostics signal. State of the changeover switch.
		stream_switch_state_2 : out std_logic_vector (2-1 downto 0);	
		
		link1_wait 			: in std_logic := '0'; --  flow control '1' halts transmission on link out 
		link2_wait 			: in std_logic := '0';
	
		link1_flush 		: in std_logic := '0';		--   '1' Flushes trasfer fifo, input fifo and output. 		
		link2_flush 		: in std_logic := '0';		--   '1' Flushes trasfer fifo, input fifo and output. 	
		
		-- clocks, reset
		axis_aclk			: in std_logic;		-- link clock
		axis_aresetn		: in std_logic;
		
		s_axi_aclk			: in std_logic;			-- system clock.
		s_axi_aresetn		: in std_logic;			
		
		
		-- axi stream link and node interfaces for bidirectional link 1 
		
		link_in1_axis_tdata		: in std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0); --:= (others => '1');
		--	link_in1_axis_tstrb	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in1_axis_tkeep		: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in1_axis_tlast		: in std_logic; -- :='0';
		link_in1_axis_tvalid	: in std_logic; -- :='0';
		link_in1_axis_tready	: out std_logic;
		
		
		link_out1_axis_tdata	: out std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0):= (others => '1');
		--	link_out1_axis_tstrb	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_out1_axis_tkeep	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');	
		link_out1_axis_tlast	: out std_logic := '0';
		link_out1_axis_tvalid 	: out std_logic;	
		link_out1_axis_tready	: in std_logic := '1';
		
		node_in1_axis_tdata		: out std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0);
		--	node_in1_axis_tstrb	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in1_axis_tkeep		: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in1_axis_tlast		: out std_logic;
		node_in1_axis_tvalid	: out std_logic;
		node_in1_axis_tready	: in std_logic := '1';
		
		
		node_out1_axis_tdata	: in std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0);
		--		node_out1_axis_tstrb	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out1_axis_tkeep	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out1_axis_tlast	: in std_logic := '0';
		node_out1_axis_tvalid	: in std_logic := '0'; 
		node_out1_axis_tready	: out std_logic;
	
		
		-- axi stream link and node interfaces for bidirectional link 2 
		
		link_in2_axis_tdata		: in std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0); --:= (others => '1');
		--	link_in2_axis_tstrb	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in2_axis_tkeep		: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in2_axis_tlast		: in std_logic; -- :='0';
		link_in2_axis_tvalid	: in std_logic :='0';
		link_in2_axis_tready	: out std_logic;
		
		
		link_out2_axis_tdata	: out std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0):= (others => '1');
		--	link_out2_axis_tstrb	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_out2_axis_tkeep	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');	
		link_out2_axis_tlast	: out std_logic := '0';
		link_out2_axis_tvalid 	: out std_logic;	
		link_out2_axis_tready	: in std_logic := '1';
		
		node_in2_axis_tdata		: out std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0);
		--	node_in2_axis_tstrb	: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in2_axis_tkeep		: out std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in2_axis_tlast		: out std_logic;
		node_in2_axis_tvalid	: out std_logic;
		node_in2_axis_tready	: in std_logic := '1';
		
		
		node_out2_axis_tdata	: in std_logic_vector(C_AXIS_DATA_WIDTH-1 downto 0);
		--		node_out2_axis_tstrb	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out2_axis_tkeep	: in std_logic_vector((C_AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out2_axis_tlast	: in std_logic := '0';
		node_out2_axis_tvalid	: in std_logic; 
		node_out2_axis_tready	: out std_logic;
		
		-- axi bus interface for the register array. 				

		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata		: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb		: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp		: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata		: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp		: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic


	);
end axi_s_chain_link_switch;

architecture arch_imp of axi_s_chain_link_switch is



--***************************************************************************************************************
	

	constant NUMBER_OF_REGISTERS    : integer              := 6;	
	constant REG_SIGNED				: integer              := 0;	  -- 0: unsigned 1 signed				 
	constant REGISTER_WIDTH			: integer := C_S_AXI_DATA_WIDTH;
	

	
	-- register definitions.
	constant  STATUSREG_REGNR	                   : integer := 0;
	constant  CONFIGREG_REGNR	                   : integer := 1;	 
	
	
	constant  NODE_FIFO_FILL_LEVEL1_REGNR	       : integer := 2;	 
	constant  NODE_FIFO_FILL_LEVEL2_REGNR	       : integer := 3;
		 
	constant  TRANSFER_FIFO_FILL_LEVEL1_2_REGNR    : integer := 4;
	constant  TRANSFER_FIFO_FILL_LEVEL2_1_REGNR    : integer := 5;
			 
	
	-- bit allocation Status reg.



	constant  LINK_OUT_WAITING_1_BITNR	           : integer := 0;   -- 1: Transfer of data at link out is blocked.  Flow control. No data loss. 

	constant  ACTIVE_TRANSFER_FRAME_1_BITNR	       : integer := 2;   -- 1: Frame from the link input is being transferred to link out or is waiting. 
	constant  ACTIVE_NODE_OUT_FRAME_1_BITNR	       : integer := 3;   -- 1: Frame from node is being transferred or is waiting.

	constant  SWITCH_STATE_1_START_BITNR	      : integer  := 4;    -- State of the changeover switch.  2 bit signal: 0: idle 1: node out 2: transfer fifo
	
	constant  TRANSFER_FIFO_FILLED_A1_BITNR	       : integer := 8;	 -- 1: Transfer fifo from link to changeover switch is filled to flag threshold level A. 
	constant  TRANSFER_FIFO_FILLED_B1_BITNR	       : integer := 9;   --  1: Transfer fifo from link to changeover switch is filled to flag threshold level B. 
	
	constant  NODE_FIFO_FILLED_A1_BITNR            : integer := 10; -- 1: Node input fifo is filled to flag threshold level A. 
	constant  NODE_FIFO_FILLED_B1_BITNR            : integer := 11;	-- 1: Node input fifo is filled to flag threshold level A. 	

	constant  TRANSFER_FIFO_FULL_1_BITNR           : integer := 12; -- 1: Transfer fifo from link to changeover switch is full. 
    constant  NODE_FIFO_FULL_1_BITNR       	       : integer := 13;	-- 1: Node input fifo is full.	
	
	constant  LINK_FLUSH_1_BITNR	              : integer := 15;  -- 1: Hardware input signal is set. Flushes both node and transfer fifo.

  
    	
	-- bit allocation Config reg.

    
    constant  LINK_OUT_WAITING_2_BITNR            : integer := 16;  
    
    constant  ACTIVE_TRANSFER_FRAME_2_BITNR       : integer := 18;
    constant  ACTIVE_NODE_OUT_FRAME_2_BITNR       : integer := 19;

    constant  SWITCH_STATE_2_START_BITNR          : integer  := 20;
    
    constant  TRANSFER_FIFO_FILLED_A2_BITNR       : integer := 24;    
    constant  TRANSFER_FIFO_FILLED_B2_BITNR       : integer := 25;
    
    constant  NODE_FIFO_FILLED_A2_BITNR           : integer := 26;
    constant  NODE_FIFO_FILLED_B2_BITNR           : integer := 27;        

    constant  TRANSFER_FIFO_FULL_2_BITNR           : integer := 28;
    constant  NODE_FIFO_FULL_2_BITNR               : integer := 29;        
    
    constant  LINK_FLUSH_2_BITNR                  : integer := 31; -- hardware input
    
      
	------
	
	constant LINK_OUT_WAIT1_BITNR : integer := 0;  -- 1: Blocks transfer of data at link out.  Flow control. No data loss. 
	constant LINK_OUT_WAIT2_BITNR : integer := 16;
		
	constant SET_CHANGEOVER_SWITCH1_TO_NONE_BITNR : integer := 1; -- soft disable
	constant SET_CHANGEOVER_SWITCH2_TO_NONE_BITNR : integer := 17;
	
	
	constant NODE_OUT1_DISABLE_BITNR : integer := 8;
	constant NODE_OUT2_DISABLE_BITNR : integer := 24;
	
	constant NODE_IN1_FIFO_DISABLE_BITNR : integer := 9;
	constant NODE_IN2_FIFO_DISABLE_BITNR : integer := 25;
	
	
	constant LINK1_2_IN_OUT_TRANSFER_DISABLE_BITNR : integer := 10;
	constant LINK2_1_IN_OUT_TRANSFER_DISABLE_BITNR : integer := 26;


	constant FIFO1_INPUT_HANDSHAKE_BITNR : integer := 12;
	constant FIFO2_INPUT_HANDSHAKE_BITNR : integer := 28;	
		
	constant SWITCH_STATE_SIZE : integer := 2;	
		
	--=============================================================================================================
	signal  load						:	std_logic_vector( NUMBER_OF_REGISTERS-1 downto 0) := (others => '0');
	signal register_array_write_vec		:   std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Register values. 
	signal register_array_read_vec 		:   std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0');  -- Values that the processor reads.
	signal register_array_init_vec 		:   std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Initial values loaded at reset
	signal register_array_load_vec 		:   std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Values loaded when load flags are set.
	signal register_write_a	 			:   std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register A. 
	signal register_write_b	 			:   std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register B. 
	signal register_write_c	 			:   std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register C.  
	signal register_write_d	 			:   std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register D. 


	type register_array_type is array (NUMBER_OF_REGISTERS - 1 downto 0) of std_logic_vector(REGISTER_WIDTH - 1 downto 0);

	signal register_array_read   		: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
	signal register_array_write 		: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
	signal register_array_init 			: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
	signal register_array_load 			: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.
	
	
	signal frame_start_toggle_axis1 	:  std_logic := '0';
	signal frame_start_toggle_axis2		:  std_logic := '0';		
	
	constant SYNCH_TOGGLE_ARRAY_SIZE :  integer := 4;
		
	signal frame_start_toggle_synch1 :  std_logic_vector( SYNCH_TOGGLE_ARRAY_SIZE-1 downto 0)  := (others =>'0');		
	signal frame_start_toggle_synch2 :  std_logic_vector( SYNCH_TOGGLE_ARRAY_SIZE-1 downto 0)  := (others =>'0');		

	
	signal node_fifo_filled_flag_a1 		:  std_logic := '0';	-- node input fifo has reached treahold level. 
   	signal node_fifo_filled_flag_b1         :  std_logic := '0';
    signal node_fifo_full_flag1             :  std_logic := '0';     --  node input fifo is full. 
    signal transfer_fifo_filled_flag_a1     :  std_logic := '0';      -- transfer fifo has reached treahold level. 
    signal transfer_fifo_filled_flag_b1     :  std_logic := '0';
    signal transfer_fifo_full_flag1         :  std_logic := '0';     -- Either transfer fifo is full. 

	signal node_fifo_filled_flag_a2 		:  std_logic := '0';	-- node input fifo has reached treahold level. 
   	signal node_fifo_filled_flag_b2         :  std_logic := '0';
    signal node_fifo_full_flag2             :  std_logic := '0';     --  node input fifo is full. 
    signal transfer_fifo_filled_flag_a2     :  std_logic := '0';      -- transfer fifo has reached treahold level. 
    signal transfer_fifo_filled_flag_b2     :  std_logic := '0';
    signal transfer_fifo_full_flag2         :  std_logic := '0';     


	signal statusreg		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal statusreg_axi	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal statusreg_synch1	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal statusreg_synch2	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');


	signal configreg		: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal configreg_axi	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal configreg_synch1	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal configreg_synch2	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');



	
	signal link1_2_in_out_transfer_disable  :  std_logic := '0';
	signal link2_1_in_out_transfer_disable  :  std_logic := '0';		
			
	signal node_in_fifo_disable1  :  std_logic := '0';
	signal node_in_fifo_disable2  :  std_logic := '0';		
		
	signal node_out_disable1  :  std_logic := '0';
	signal node_out_disable2  :  std_logic := '0';		
	
	
	signal link_out_wait1  :  std_logic := '0';
	signal link_out_wait2  :  std_logic := '0';		
							
	signal set_changeover_switch_to_none1  :  std_logic := '0';
	signal set_changeover_switch_to_none2  :  std_logic := '0';
	
	
	signal 	fifo1_full_handshake 		:  std_logic := '0'; 		-- '0' Keeps tready on, overwrites fifo. - Looses data, but does not stall the  other fifo. '1' Ssets trady to '0' stops writing to FIFO, does not wirh we\hen Aurora is used as input.
	signal 	fifo2_full_handshake 		:  std_logic := '0'; 		-- '0' Keeps tready on, overwrites fifo. - Looses data, but does not stall the  other fifo. '1' Ssets trady to '0' stops writing to FIFO, does not wirh we\hen Aurora is used as input.

	
	

	signal active_node_out_frame1  :  std_logic := '0';
	signal active_node_out_frame2  :  std_logic := '0';
	signal active_transfer_frame1  :  std_logic := '0';
	signal active_transfer_frame2  :  std_logic := '0';
	
	
	signal frame1_start_pulse_axis  :  std_logic := '0';
	signal frame2_start_pulse_axis  :  std_logic := '0';
	
	signal fifo_full_flag1  :  std_logic := '0';
	signal fifo_full_flag2  :  std_logic := '0';
	

		-- Diagnostics signals.
	signal	transfer_fifo_fill_level_1_2        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	node_fifo_fill_level_1           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
    signal  switch_state_1                    :  std_logic_vector (SWITCH_STATE_SIZE-1 downto 0):= (others =>'0'); 

	signal	transfer_fifo_fill_level_2_1        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0) := (others =>'0'); 
	signal	node_fifo_fill_level_2           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
    signal  switch_state_2                    :  std_logic_vector (SWITCH_STATE_SIZE-1 downto 0):= (others =>'0'); 


	signal	transfer_fifo_fill_level_1_2_sync2        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	node_fifo_fill_level_1_sync2           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	transfer_fifo_fill_level_2_1_sync2        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	node_fifo_fill_level_2_sync2           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 

	signal	transfer_fifo_fill_level_1_2_sync1        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	node_fifo_fill_level_1_sync1           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	transfer_fifo_fill_level_2_1_sync1        :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 
	signal	node_fifo_fill_level_2_sync1           :  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0):= (others =>'0'); 

    signal 		link_in1_axis_tready_m	:  std_logic;
    signal 		link_in2_axis_tready_m	:  std_logic;	
    
    
    signal s_axi_areset  :  std_logic := '1'; -- active high resets
    signal axis_areset  :  std_logic := '1';
    	
   	
 	
--------------------------------------------------------------------------------


begin

-----------------------------------------------------------------------------------------------
-- active high reset signals
    s_axi_areset <= not  s_axi_aresetn;
    axis_areset <= not axis_aresetn;


-- external signals 

    link_in1_axis_tready <= link_in1_axis_tready_m;
    link_in2_axis_tready <= link_in2_axis_tready_m;

	fifo_filled_flag_a1 <= '1' when node_fifo_filled_flag_a1 = '1' or transfer_fifo_filled_flag_a1 = '1' else '0';
	fifo_filled_flag_b1 <= '1' when node_fifo_filled_flag_b1 = '1' or transfer_fifo_filled_flag_b1 = '1' else '0';
	fifo_filled_flag_a2 <= '1' when node_fifo_filled_flag_a2 = '1' or transfer_fifo_filled_flag_a2 = '1' else '0';
	fifo_filled_flag_b2 <= '1' when node_fifo_filled_flag_b2 = '1' or transfer_fifo_filled_flag_b2 = '1' else '0';

	
    stream_switch_state_1 <= switch_state_1;
    stream_switch_state_2 <= switch_state_2;    	
	
	--Connection of status and config flags. 



	-- register connections. 

	 register_array_init(CONFIGREG_REGNR)	<= std_logic_vector(resize(unsigned(CONFIG_REGISTER_DEFAULTVALUE),C_S_AXI_DATA_WIDTH)); 
	
	
	configreg_axi <= register_array_write(CONFIGREG_REGNR); 

	register_array_read(STATUSREG_REGNR) <= statusreg_axi;
	register_array_read(CONFIGREG_REGNR) <= register_array_write(CONFIGREG_REGNR);
	
	register_array_read(NODE_FIFO_FILL_LEVEL1_REGNR) <= node_fifo_fill_level_1_sync2;	
	register_array_read(NODE_FIFO_FILL_LEVEL2_REGNR) <= node_fifo_fill_level_2_sync2;
	
	register_array_read(TRANSFER_FIFO_FILL_LEVEL1_2_REGNR) <= transfer_fifo_fill_level_1_2_sync2;
	register_array_read(TRANSFER_FIFO_FILL_LEVEL2_1_REGNR) <= transfer_fifo_fill_level_2_1_sync2;


	
	-----
	-- bit connections status register. 
	

    statusreg(LINK_OUT_WAITING_1_BITNR) <= link1_wait;
    statusreg(LINK_OUT_WAITING_2_BITNR) <= link2_wait;    
        
    statusreg(ACTIVE_TRANSFER_FRAME_1_BITNR) <= active_transfer_frame1;
    statusreg(ACTIVE_TRANSFER_FRAME_2_BITNR) <= active_transfer_frame2;
        
    statusreg(ACTIVE_NODE_OUT_FRAME_1_BITNR) <= active_node_out_frame1;
    statusreg(ACTIVE_NODE_OUT_FRAME_2_BITNR) <= active_node_out_frame2;
    
    statusreg(SWITCH_STATE_1_START_BITNR + SWITCH_STATE_SIZE -1 downto SWITCH_STATE_1_START_BITNR)  <= switch_state_1;
    statusreg(SWITCH_STATE_2_START_BITNR + SWITCH_STATE_SIZE -1 downto SWITCH_STATE_2_START_BITNR)  <= switch_state_2;
   
    statusreg(TRANSFER_FIFO_FILLED_A1_BITNR) <= transfer_fifo_filled_flag_a1;    
    statusreg(TRANSFER_FIFO_FILLED_A2_BITNR) <= transfer_fifo_filled_flag_a2;

    statusreg(TRANSFER_FIFO_FILLED_B1_BITNR) <= transfer_fifo_filled_flag_b1;    
    statusreg(TRANSFER_FIFO_FILLED_B2_BITNR) <= transfer_fifo_filled_flag_b2;

    statusreg(NODE_FIFO_FILLED_A1_BITNR) <= node_fifo_filled_flag_a1;
    statusreg(NODE_FIFO_FILLED_A2_BITNR) <= node_fifo_filled_flag_a2;
    
    statusreg(NODE_FIFO_FILLED_B1_BITNR) <= node_fifo_filled_flag_b1;
    statusreg(NODE_FIFO_FILLED_B2_BITNR) <= node_fifo_filled_flag_b2;
 
    statusreg(TRANSFER_FIFO_FULL_1_BITNR) <= transfer_fifo_full_flag1;
    statusreg(TRANSFER_FIFO_FULL_2_BITNR) <= transfer_fifo_full_flag2;
    
    statusreg(NODE_FIFO_FULL_1_BITNR) <= node_fifo_full_flag1;
    statusreg(NODE_FIFO_FULL_2_BITNR) <= node_fifo_full_flag2;
  
    statusreg(LINK_FLUSH_1_BITNR) <= link1_flush;
    statusreg(LINK_FLUSH_2_BITNR) <= link2_flush;    
        

	------- 
	-- bit connection config register. Combined with external signals.
	
	link1_2_in_out_transfer_disable <= '1' when  link1_flush = '1' or  link2_flush = '1' or  configreg(LINK1_2_IN_OUT_TRANSFER_DISABLE_BITNR) = '1' else '0';
	link2_1_in_out_transfer_disable <= '1' when  link1_flush = '1' or  link2_flush = '1' or  configreg(LINK2_1_IN_OUT_TRANSFER_DISABLE_BITNR) = '1' else '0';
	
	node_in_fifo_disable1 <= '1' when  link1_flush = '1' or  configreg(NODE_IN1_FIFO_DISABLE_BITNR) = '1' else '0';
	node_in_fifo_disable2 <= '1' when  link2_flush = '1' or  configreg(NODE_IN2_FIFO_DISABLE_BITNR) = '1' else '0';
	
	node_out_disable1 <= '1' when  link1_flush = '1' or configreg(NODE_OUT1_DISABLE_BITNR) = '1' else '0';
	node_out_disable2 <= '1' when  link2_flush = '1' or configreg(NODE_OUT2_DISABLE_BITNR) = '1' else '0';
	
	set_changeover_switch_to_none1  <= '1' when configreg(SET_CHANGEOVER_SWITCH1_TO_NONE_BITNR) = '1' else '0';
	set_changeover_switch_to_none2  <= '1' when configreg(SET_CHANGEOVER_SWITCH2_TO_NONE_BITNR) = '1' else '0';

	-- Flow control both from hardware and software. 
		
	link_out_wait1 <= '1' when  link1_wait = '1' or configreg(LINK_OUT_WAIT1_BITNR) = '1' else '0';
	link_out_wait2 <= '1' when  link2_wait = '1' or configreg(LINK_OUT_WAIT2_BITNR) = '1' else '0';
	


	fifo1_full_handshake  <= '1' when configreg(FIFO1_INPUT_HANDSHAKE_BITNR) = '1' else '0';
	fifo2_full_handshake  <= '1' when configreg(FIFO2_INPUT_HANDSHAKE_BITNR) = '1' else '0';	


	
	------------------------------------------------------------------------------------------------------

	register_array : entity axi_register_array
	generic map (
	
	REGISTER_WIDTH => REGISTER_WIDTH,
	NUMBER_OF_REGISTERS => NUMBER_OF_REGISTERS,
	REG_SIGNED => REG_SIGNED,
	 
	C_S_AXI_ADDR_WIDTH 	=> C_S_AXI_ADDR_WIDTH,
	C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH 
		)
	port map(
	
	load => load,
	register_array_write_vec => register_array_write_vec,
	register_array_read_vec => register_array_read_vec,
	register_array_init_vec => register_array_init_vec,
	register_array_load_vec => register_array_load_vec,
	register_write_a => register_write_a,
	register_write_b => register_write_b,
	register_write_c => register_write_c,
	register_write_d => register_write_d,

	s_axi_aclk		=> s_axi_aclk,
	s_axi_aresetn	=> s_axi_aresetn,
	
	s_axi_awaddr	=> s_axi_awaddr,
	s_axi_awprot	=> s_axi_awprot,
	s_axi_awvalid	=> s_axi_awvalid,
	s_axi_awready	=> s_axi_awready,
	s_axi_wdata		=> s_axi_wdata,
	s_axi_wstrb		=> s_axi_wstrb,
	s_axi_wvalid	=> s_axi_wvalid,
	s_axi_wready	=> s_axi_wready,
	s_axi_bresp		=> s_axi_bresp,
	s_axi_bvalid	=> s_axi_bvalid,
	s_axi_bready	=> s_axi_bready,
	s_axi_araddr	=> s_axi_araddr,
	s_axi_arprot	=> s_axi_arprot,
	s_axi_arvalid	=> s_axi_arvalid,
	s_axi_arready	=> s_axi_arready,
	s_axi_rdata		=> s_axi_rdata,
	s_axi_rresp		=> s_axi_rresp,
	s_axi_rvalid	=> s_axi_rvalid,	
	s_axi_rready	=> s_axi_rready	 
	);
	
--  Recreating register arrays from flat std_logic_vectors in the entity interface.  

	Reg_generate : for n in 0 to NUMBER_OF_REGISTERS -1 generate 
		
			register_array_write(n) <= register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n);
				
			register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_read(n);
			register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_init(n);
			register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_load(n);
		
			
		end generate;	





        -------------------------------------------------------------------------------------
        
        
axi_s_frame_simplex_switch_from1_to2 :  entity axi_s_frame_simplex_switch 
	generic map (
	
			LINK_FIFO_SIZE 	=> LINK_FIFO_SIZE,
			LINK_FIFO_FILLED_FLAG_LEVEL_A => LINK_FIFO_FILLED_FLAG_LEVEL_A,
			LINK_FIFO_FILLED_FLAG_LEVEL_B => LINK_FIFO_FILLED_FLAG_LEVEL_B,	
			AXIS_DATA_WIDTH 	=> C_AXIS_DATA_WIDTH 			
			)
	port map (

		active_node_out_frame 			=> active_node_out_frame2,
		active_transfer_frame 			=> active_transfer_frame2,
		
		node_fifo_filled_flag_a 		=> node_fifo_filled_flag_a1,	
		node_fifo_filled_flag_b 		=> node_fifo_filled_flag_b1,
		node_fifo_full_flag 			=> node_fifo_full_flag1,

		transfer_fifo_filled_flag_a 	=> transfer_fifo_filled_flag_a1,	
		transfer_fifo_filled_flag_b 	=> transfer_fifo_filled_flag_b1,
		transfer_fifo_full_flag 		=> transfer_fifo_full_flag1,
		
		
		transfer_fifo_fill_level        => transfer_fifo_fill_level_1_2,          	
		node_fifo_fill_level            => node_fifo_fill_level_1, 
		switch_state	                => switch_state_2,
			
		link_in_out_transfer_disable 	=> link1_2_in_out_transfer_disable, 
		node_in_fifo_disable 			=> node_in_fifo_disable1,
		node_out_disable  				=> node_out_disable2,
		fifo_full_handshake 			=> fifo1_full_handshake,
		set_changeover_switch_to_none 	=> set_changeover_switch_to_none2,
		link_out_wait					=>	link_out_wait2,
		
		---
		link_in_axis_tready	=> link_in1_axis_tready_m,
		link_in_axis_tdata	=> link_in1_axis_tdata,
		--	link_in_axis_tstrb	=> link_in1_axis_tstrb,
		link_in_axis_tkeep	=> link_in1_axis_tkeep,
		link_in_axis_tlast	=> link_in1_axis_tlast,
		link_in_axis_tvalid	=> link_in1_axis_tvalid,
		
		
		link_out_axis_tvalid	=> link_out2_axis_tvalid,
		link_out_axis_tdata	=> link_out2_axis_tdata,
		--	link_out_axis_tstrb	=> link_out2_axis_tstrb,
		link_out_axis_tkeep	=> link_out2_axis_tkeep,
		link_out_axis_tlast	=> link_out2_axis_tlast,
		link_out_axis_tready	=> link_out2_axis_tready,
		
		
		node_in_axis_tvalid	=> node_in1_axis_tvalid,
		node_in_axis_tdata	=> node_in1_axis_tdata,
		--	node_in_axis_tstrb	=> node_in1_axis_tstrb,
		node_in_axis_tkeep	=> node_in1_axis_tkeep,
		node_in_axis_tlast	=> node_in1_axis_tlast,
		node_in_axis_tready	=> node_in1_axis_tready,
		
		
		node_out_axis_tready	=> node_out2_axis_tready,
		node_out_axis_tdata	=> node_out2_axis_tdata,
		--	node_out_axis_tstrb	=> node_out2_axis_tstrb,
		node_out_axis_tkeep	=> node_out2_axis_tkeep,
		node_out_axis_tlast	=> node_out2_axis_tlast,
		node_out_axis_tvalid	=> node_out2_axis_tvalid,
		
		axis_aclk	=> axis_aclk,
		axis_aresetn	=> axis_aresetn
	
		);

------------------------------------------------------------------------------

axi_s_frame_simplex_switch_from2_to1 :  entity axi_s_frame_simplex_switch 
	generic map (

			LINK_FIFO_SIZE => LINK_FIFO_SIZE,
			LINK_FIFO_FILLED_FLAG_LEVEL_A => LINK_FIFO_FILLED_FLAG_LEVEL_A,
			LINK_FIFO_FILLED_FLAG_LEVEL_B => LINK_FIFO_FILLED_FLAG_LEVEL_B,
	
			AXIS_DATA_WIDTH => C_AXIS_DATA_WIDTH 			
			)
	port map (

		
		active_node_out_frame 			=> active_node_out_frame1,
		active_transfer_frame 			=> active_transfer_frame1,
	
		node_fifo_filled_flag_a 		=> node_fifo_filled_flag_a2,	
        node_fifo_filled_flag_b         => node_fifo_filled_flag_b2,
        node_fifo_full_flag             => node_fifo_full_flag2,

        transfer_fifo_filled_flag_a     => transfer_fifo_filled_flag_a2,    
        transfer_fifo_filled_flag_b     => transfer_fifo_filled_flag_b2,
        transfer_fifo_full_flag         => transfer_fifo_full_flag2,
		
		transfer_fifo_fill_level        => transfer_fifo_fill_level_2_1,          	
        node_fifo_fill_level            => node_fifo_fill_level_2, 
        switch_state                    => switch_state_1,
	
		link_in_out_transfer_disable 	=> link2_1_in_out_transfer_disable, 
		node_in_fifo_disable 			=> node_in_fifo_disable2,
		node_out_disable  				=> node_out_disable1,
		fifo_full_handshake 			=> fifo2_full_handshake,
		set_changeover_switch_to_none 	=> set_changeover_switch_to_none1,
		link_out_wait					=>	link_out_wait1,
		 
	

		
		link_in_axis_tready	=> link_in2_axis_tready_m,
		link_in_axis_tdata	=> link_in2_axis_tdata,
		--	link_in_axis_tstrb	=> link_in2_axis_tstrb,
		link_in_axis_tkeep	=> link_in2_axis_tkeep,
		link_in_axis_tlast	=> link_in2_axis_tlast,
		link_in_axis_tvalid	=> link_in2_axis_tvalid,
		
		
		link_out_axis_tvalid	=> link_out1_axis_tvalid,
		link_out_axis_tdata	=> link_out1_axis_tdata,
		--	link_out_axis_tstrb	=> link_out1_axis_tstrb,
		link_out_axis_tkeep	=> link_out1_axis_tkeep,
		link_out_axis_tlast	=> link_out1_axis_tlast,
		link_out_axis_tready	=> link_out1_axis_tready,
		
		
		node_in_axis_tvalid	=> node_in2_axis_tvalid,
		node_in_axis_tdata	=> node_in2_axis_tdata,
		--	node_in_axis_tstrb	=> node_in2_axis_tstrb,
		node_in_axis_tkeep	=> node_in2_axis_tkeep,
		node_in_axis_tlast	=> node_in2_axis_tlast,
		node_in_axis_tready	=> node_in2_axis_tready,
		
		
		node_out_axis_tready	=> node_out1_axis_tready,
		node_out_axis_tdata	=> node_out1_axis_tdata,
		--	node_out_axis_tstrb	=> node_out1_axis_tstrb,
		node_out_axis_tkeep	=> node_out1_axis_tkeep,
		node_out_axis_tlast	=> node_out1_axis_tlast,
		node_out_axis_tvalid	=> node_out1_axis_tvalid,
		
		axis_aclk		=> axis_aclk,
		axis_aresetn	=> axis_aresetn
	
		);
-------------------------------------------------------------------------------------
        
        
        axi_s_synch_frame_detector1 :  entity axi_s_synch_frame_detector 
            generic map (
            
        
                    AXIS_DATA_WIDTH     => C_AXIS_DATA_WIDTH             
                    )
            port map (
        
                frame_start_pulse                 => frame1_start_pulse_axis,        
                frame_start_toggle                 => frame_start_toggle_axis1,
        
                synch_axis_tready    => link_in1_axis_tready_m,
                synch_axis_tdata    => link_in1_axis_tdata,
                --    synch_axis_tstrb    => link_in1_axis_tstrb,
                -- synch_axis_tkeep    => link_in1_axis_tkeep,
                synch_axis_tlast    => link_in1_axis_tlast,
                synch_axis_tvalid    => link_in1_axis_tvalid,
                
                axis_aclk    => axis_aclk,
                axis_aresetn    => axis_aresetn
        );
        -------------------------------------------------------------------------------------
        
        axi_s_synch_frame_detector2 :  entity axi_s_synch_frame_detector
            generic map (
            
        
                    AXIS_DATA_WIDTH     => C_AXIS_DATA_WIDTH             
                    )
            port map (
        
                frame_start_pulse                 => frame2_start_pulse_axis,        
                frame_start_toggle                 => frame_start_toggle_axis2,
        
                synch_axis_tready    => link_in2_axis_tready_m,
                synch_axis_tdata    => link_in2_axis_tdata,
                --    synch_axis_tstrb    => link_in2_axis_tstrb,
                -- synch_axis_tkeep    => link_in2_axis_tkeep,
                synch_axis_tlast    => link_in2_axis_tlast,
                synch_axis_tvalid    => link_in2_axis_tvalid,
                
                axis_aclk    => axis_aclk,
                axis_aresetn    => axis_aresetn
        );


----------------------------------------------------------------------------------------
-- Handling of signals crossing the clock domain boundaries
 
 

 
 
synch_to_sys_clock_process : process(s_axi_aclk) 
begin
	if	(rising_edge	(s_axi_aclk))	then
		if s_axi_aresetn = '0' then


			
			statusreg_synch1 <= (others => '0'); 
			statusreg_synch2 <= (others => '0');			
			statusreg_axi <= (others => '0');								

			frame_start_toggle_synch1 <= (others => '0'); 
			frame_start_toggle_synch2 <= (others => '0'); 	
			frame1_start_pulse <= '0';
			frame2_start_pulse <= '0';  
													
		else
			
			statusreg_synch1 <= statusreg; 
			statusreg_synch2 <= statusreg_synch1;		
			statusreg_axi <= statusreg_synch2;
			
			
			node_fifo_fill_level_2_sync2 <= node_fifo_fill_level_2_sync1;
            node_fifo_fill_level_1_sync2 <= node_fifo_fill_level_1_sync1;
            transfer_fifo_fill_level_1_2_sync2 <= transfer_fifo_fill_level_1_2_sync1;
            transfer_fifo_fill_level_2_1_sync2 <= transfer_fifo_fill_level_2_1_sync1;
            
            node_fifo_fill_level_2_sync1 <= node_fifo_fill_level_2;
            node_fifo_fill_level_1_sync1 <= node_fifo_fill_level_1;
            transfer_fifo_fill_level_1_2_sync1 <= transfer_fifo_fill_level_1_2;
            transfer_fifo_fill_level_2_1_sync1 <= transfer_fifo_fill_level_2_1;  
			
			
			-- Transfers toggling signals across clcck bpundary
			frame_start_toggle_synch1 <= frame_start_toggle_synch1 (SYNCH_TOGGLE_ARRAY_SIZE-2 downto 0) &  frame_start_toggle_axis1; 		-- Synchronising shift registers.
			frame_start_toggle_synch2 <= frame_start_toggle_synch2 (SYNCH_TOGGLE_ARRAY_SIZE-2 downto 0) &  frame_start_toggle_axis2;
					 
			-- Recreates pulse from togging signals. 		 
			if not frame_start_toggle_synch1(SYNCH_TOGGLE_ARRAY_SIZE-1) = frame_start_toggle_synch1(SYNCH_TOGGLE_ARRAY_SIZE-2) then -- Toggle 
			 
					frame1_start_pulse <= '1'; 
			else 
					frame1_start_pulse <= '0';  
			end if;
	 		
			if not frame_start_toggle_synch2(SYNCH_TOGGLE_ARRAY_SIZE-1) = frame_start_toggle_synch2(SYNCH_TOGGLE_ARRAY_SIZE-2) then
			 
					frame2_start_pulse <= '1'; 
			else 
					frame2_start_pulse <= '0';  
			end if;
			
		end if;
	end if;

end process;

------------------


synch_to_stream_clock_process : process(axis_aclk)
begin
	if	(rising_edge	(axis_aclk))	then
		if axis_aresetn = '0' then
			configreg_synch1 <= (others => '0'); 
			configreg_synch2 <= (others => '0');			
			configreg <= (others => '0');								
													
		else
			configreg_synch1 <= configreg_axi; 
			configreg_synch2 <= configreg_synch1;		
			configreg <= configreg_synch2;
	 	end if;
	end if;

end process;

----*********************************************************************
 
---- -- xpm_cdc_pulse: Clock Domain Crossing Pulse Transfer
---- -- Xilinx Parameterized Macro, Version 2016.2
--frame1_start_pulse_xpm_cdc_pulse_inst: xpm_cdc_pulse
--  generic map (

--    -- Common module generics
--    DEST_SYNC_FF   => 4, -- integer; range: 2-10
--    RST_USED       => 1, -- integer; 0=no reset, 1=implement reset
--    SIM_ASSERT_CHK => 1  -- integer; 0=disable simulation messages, 1=enable simulation messages

--  )
--  port map (

--    src_clk    => axis_aclk,
--    src_rst    => axis_areset,   -- optional; required when RST_USED = 1
--    src_pulse  => frame1_start_pulse_axis,
--    dest_clk   => s_axi_aclk,
--    dest_rst   => s_axi_areset,  -- optional; required when RST_USED = 1
--    dest_pulse => frame1_start_pulse
--  );


--frame2_start_pulse_xpm_cdc_pulse_inst: xpm_cdc_pulse
--  generic map (

--    -- Common module generics
--    DEST_SYNC_FF   => 4, -- integer; range: 2-10
--    RST_USED       => 1, -- integer; 0=no reset, 1=implement reset
--    SIM_ASSERT_CHK => 1  -- integer; 0=disable simulation messages, 1=enable simulation messages

--  )
--  port map (

--    src_clk    => axis_aclk,
--    src_rst    => axis_areset,   -- optional; required when RST_USED = 1
--    src_pulse  => frame2_start_pulse_axis,
--    dest_clk   => s_axi_aclk,
--    dest_rst   => s_axi_areset,  -- optional; required when RST_USED = 1
--    dest_pulse => frame2_start_pulse
--  );


--statusreg_xpm_cdc_array_single_inst: xpm_cdc_array_single
--  generic map (

--    -- Common module generics
--    DEST_SYNC_FF   => 4, -- integer; range: 2-10
--    SIM_ASSERT_CHK => 1, -- integer; 0=disable simulation messages, 1=enable simulation messages
--    SRC_INPUT_REG  => 0, -- integer; 0=do not register input, 1=register input
--    WIDTH          => C_S_AXI_DATA_WIDTH  -- integer; range: 2-1024

--  )
--  port map (

--    src_clk  => axis_aclk,  -- optional; required when SRC_INPUT_REG = 1
--    src_in   => statusreg,
--    dest_clk => s_axi_aclk,
--    dest_out => statusreg_axi
--  );




--xpm_cdc_handshake_inst:  xpm_cdc_handshake
--  generic map (

--    -- Common module generics
--    DEST_EXT_HSK   => 1, -- integer; 0=user handshake, 1=internal handshake
--    DEST_SYNC_FF   => 4, -- integer; range: 2-10
--    SIM_ASSERT_CHK => 0, -- integer; 0=disable simulation messages, 1=enable simulation messages
--    SRC_SYNC_FF    => 4, -- integer; range: 2-10
--    WIDTH          => C_S_AXI_DATA_WIDTH  -- integer; range: 1-1024
--  )
--  port map (

--    src_clk  => src_clk,
--    src_in   => node_fifo_fill_level_2,
--    src_send => src_send,
--    src_rcv  => src_rcv,
--    dest_clk => dest_clk,
--    dest_req => dest_req,
--    dest_ack => dest_ack, -- optional; required when DEST_EXT_HSK = 1
--    dest_out => dest_out
-- );



	
			
--------------------------------------------------------------------


end arch_imp;
