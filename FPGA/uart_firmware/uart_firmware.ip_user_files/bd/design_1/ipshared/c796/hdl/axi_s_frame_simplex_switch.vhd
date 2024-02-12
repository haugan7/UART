-- axi_s_frame_simplex switch IP module.

-- It contains:

-- Two fifos with a common input signal, one for node input, one for transferring data fom one link to the changeover switch for the next link.
-- An output register with a flow control switch at its input.    
-- A line changeover switch. It operates only when there are idle interval between frames. It is locked at the present input when multiple frames are transferred without any idle intervals between them.    
-- Line  switch control. Changing is only performed when the presently engaged link is inactive. 
-- Start of frame detector at the line input. It generates  frame start pulse that can be used for synchronisation of link nodes.  
-- Frame active detectors at line and node inputs to the changeover switch. 
-- The interval between the axis_tlast and the next axis_tready pulses are declared as idle.
 
-- Two fifo fill level thresholds are flagged. These signals can beused for flow control with hysteresis.  

-- link_out wait signal can e used for flow control, It does not cause any data loss, unless the fifos overflows. 
-- The disable signal amputates ongoing messages, both when turned on and off. 
-- A message in the middle of transfer when the disabel signal is set will be amputates losing its tlast signal. The next incoming message will then be spiced onto the amputated frame  so the next one is benig lost too.

-- The Aurora core does not read the tvalid -signal. As the FIFO sets this continuously high unless the FIFO is full the FIFO is ready to receive data words any time, so that does not give any problems.  
 
   
-- Author: Kjell Ljøkelsøy Sintef Energy.  2016. 


-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity axi_s_frame_simplex_switch is
	generic (
	
		LINK_FIFO_SIZE 					: integer := 2048;  -- Size of transfer fifo and node input fifo
		LINK_FIFO_FILLED_FLAG_LEVEL_A	: integer := 256;   -- threshold for fifo fill level signal A 
		LINK_FIFO_FILLED_FLAG_LEVEL_B	: integer := 128; 	-- threshold for fifo fill level signal B 
		
		-- Parameters of Axis interface
		AXIS_DATA_WIDTH					: integer := 32
		
	);
	port (

		axis_aclk		: in std_logic;
		axis_aresetn	: in std_logic;
		  
		-- Status signals. 	

		node_fifo_filled_flag_a 		: out std_logic := '0';		-- node input fifo has reached treahold level. 
		node_fifo_filled_flag_b 		: out std_logic := '0';
		node_fifo_full_flag	 			: out std_logic := '0';		--  node input fifo is full. 
	    transfer_fifo_filled_flag_a 	: out std_logic := '0';		-- transfer fifo has reached treahold level. 
        transfer_fifo_filled_flag_b     : out std_logic := '0';
        transfer_fifo_full_flag          : out std_logic := '0';     -- Either transfer fifo is full. 

		active_node_out_frame			: out std_logic := '0';		--  '1' frame is being transferred or is waiting. 
		active_transfer_frame	  		: out std_logic := '0';		--  '1' frame from the link input is being transferred to link out or is waiting.
		
		-- Diagnostics signals.
		transfer_fifo_fill_level        : out std_logic_vector (AXIS_DATA_WIDTH-1 downto 0); 
		node_fifo_fill_level            : out std_logic_vector (AXIS_DATA_WIDTH-1 downto 0); 
        switch_state                    : out std_logic_vector (2-1 downto 0);   -- 0: idle 1: node out 2: transfer fifo
		 
   		 
		-- Control signals. 
		link_in_out_transfer_disable 	: in std_logic := '0';  	--  '1' Hard disable, Amputates active frames.
		node_in_fifo_disable 			: in std_logic := '0';
		fifo_full_handshake 			    : in std_logic := '0'; 		-- '0' Keeps tready on, overwrites fifo. - Looses data, but does not stall the  other fifo. '1' Sets tready to '0' stops writing to FIFOs wen either local or transfer FIFO is full. does not wirh when Aurora is used as input.
		node_out_disable 				: in std_logic := '0';		-- '1' Disables and flushes node out input. 				
		set_changeover_switch_to_none	: in std_logic := '0';		-- '1' Sets changeover switch to None. when ongoing frame has passed through. Soft disable, does not amputate frames. 
		link_out_wait 					: in std_logic := '0';		-- '1' Inhibit outoput trasfers, Output flow control.
		
		
		
		
		 		
		-- link axi stream interfaces. 

		link_in_axis_tdata	: in std_logic_vector(AXIS_DATA_WIDTH-1 downto 0); --:= (others => '1');
	--	link_in_axis_tstrb	: in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in_axis_tkeep	: in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_in_axis_tlast	: in std_logic :='0';
		link_in_axis_tvalid	: in std_logic :='0';
		link_in_axis_tready	: out std_logic := '0';

		link_out_axis_tdata	: out std_logic_vector(AXIS_DATA_WIDTH-1 downto 0):= (others => '1');
	--	link_out_axis_tstrb	: out std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		link_out_axis_tkeep	: out std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');	
		link_out_axis_tlast	: out std_logic := '0';
		link_out_axis_tvalid : out std_logic := '0';	
		link_out_axis_tready	: in std_logic := '1';
	
	--  Local node axi stream interfaces.
	 
		node_in_axis_tdata	: out std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
	--	node_in_axis_tstrb	: out std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in_axis_tkeep	: out std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0):= (others => '1');
		node_in_axis_tlast	: out std_logic := '0';
		node_in_axis_tvalid	: out std_logic := '0';
		node_in_axis_tready	: in std_logic := '1';

		node_out_axis_tdata	: in std_logic_vector(AXIS_DATA_WIDTH-1 downto 0);
--		node_out_axis_tstrb	: in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out_axis_tkeep	: in std_logic_vector((AXIS_DATA_WIDTH/8)-1 downto 0) := (others => '1');
		node_out_axis_tlast	: in std_logic := '0';
		node_out_axis_tvalid : in std_logic := '0'; 
		node_out_axis_tready : out std_logic := '1'

	);
	
end axi_s_frame_simplex_switch;

architecture arch_imp of axi_s_frame_simplex_switch is	


 
--***************************************************************************************************************

	constant FIFO_ELEMENT_SIZE : integer := AXIS_DATA_WIDTH + 1*AXIS_DATA_WIDTH/8 + 1;  --  



	type	fifo_tdata_array_type	is	array	(LINK_FIFO_SIZE	-	1	downto	0)	of		std_logic_vector(FIFO_ELEMENT_SIZE	-1	downto	0);
	signal	transfer_fifo_element_array	:	fifo_tdata_array_type	:=	(others	=>	(others	=>	'1'));
	signal	node_fifo_element_array	:	fifo_tdata_array_type	:=	(others	=>	(others	=>	'1'));
		
	signal fifo_in_element : std_logic_vector(FIFO_ELEMENT_SIZE-1 downto 0) := (others => '0'); 
	signal transfer_fifo_out_element : std_logic_vector(FIFO_ELEMENT_SIZE-1 downto 0) := (others => '0'); 		
	signal node_fifo_out_element : std_logic_vector(FIFO_ELEMENT_SIZE-1 downto 0) := (others => '0');
	
			
		
	signal	fifo_write_pointer	:	integer	range	LINK_FIFO_SIZE-1	downto	0	:=	0;		
	signal	transfer_fifo_read_pointer	:	integer	range	LINK_FIFO_SIZE-1	downto	0	:=	0;	
	signal	node_fifo_read_pointer	:	integer	range	LINK_FIFO_SIZE-1	downto	0	:=	0;	
	
	signal	link_transfer_fifo_fill_level    :	integer	range	LINK_FIFO_SIZE-1	downto	0	:=	0;
	signal	link_node_fifo_fill_level	    :	integer	range	LINK_FIFO_SIZE-1	downto	0	:=	0;


	signal link_transfer_fifo_filled_flag_a : std_logic := '0';
	signal link_transfer_fifo_filled_flag_b : std_logic := '0';
	signal link_node_fifo_filled_flag_a : std_logic := '0';
	signal link_node_fifo_filled_flag_b : std_logic := '0';

	signal link_fifo_full_flag : std_logic := '0';
	signal link_transfer_fifo_full_flag : std_logic := '0';
	signal link_node_fifo_full_flag : std_logic := '0';
	
	
	signal	transfer_fifo_tdata_out	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	transfer_fifo_tkeep_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--  signal 	transfer_fifo_tstrb_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	transfer_fifo_tlast_out	:	std_logic	:=	'0';
	signal	transfer_fifo_tvalid_out :	std_logic	:=	'0';
	signal	transfer_fifo_tready_out :	std_logic	:=	'0';


	signal	node_fifo_tdata_out	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	node_fifo_tkeep_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--  signal 	node_fifo_tstrb_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	node_fifo_tlast_out	:	std_logic	:=	'0';
	signal	node_fifo_tvalid_out :	std_logic	:=	'0';
	signal	node_fifo_tready_out :	std_logic	:=	'0';

	signal	fifo_tdata_in	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	fifo_tkeep_in: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--  signal 	fifo_tstrb_in	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	fifo_tlast_in	:	std_logic	:=	'0';
	signal	fifo_tvalid_in	:	std_logic	:=	'0';
	signal	fifo_tready_in	:	std_logic	:=	'0';


	-- link out register

	signal	link_out_tdata_reg_buffer	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	link_out_tkeep_reg_buffer	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--	signal 	link_out_tstrb_reg_buffer	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	link_out_tlast_reg_buffer	:	std_logic	:=	'0';
	signal	link_out_tvalid_reg_buffer	:	std_logic	:=	'0';
	
	signal	link_out_reg_buffer_full		:	std_logic	:=	'0';
	signal	link_out_transfer_in			:	std_logic	:=	'0';		
	signal	link_out_transfer_out			:	std_logic	:=	'0';
	signal	link_out_wait_out				:	std_logic	:=	'0';		
	
	signal	link_out_tdata_reg_in	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	link_out_tkeep_reg_in	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--	signal 	link_out_tstrb_reg_in	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	link_out_tlast_reg_in	:	std_logic	:=	'0';
	signal	link_out_tvalid_reg_in	:	std_logic	:=	'0';
	signal	link_out_tready_reg_in	:	std_logic	:=	'0';
	signal	link_out_tvalid_reg_in_m	:	std_logic	:=	'0';
	signal	link_out_tready_reg_in_m	:	std_logic	:=	'0';


	signal	link_out_tdata_reg_out	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	link_out_tkeep_reg_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--	signal 	link_out_tstrb_reg_out	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	link_out_tlast_reg_out	:	std_logic	:=	'0';
	signal	link_out_tvalid_reg_out	:	std_logic	:=	'0';
	signal	link_out_tready_reg_out	:	std_logic	:=	'0';

	
	signal	node_out_tdata	:	std_logic_vector(AXIS_DATA_WIDTH	-1	downto	0)	:=	(others=>	'0');
	signal 	node_out_tkeep	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
--	signal 	node_out_tstrb	: 	std_logic_vector((AXIS_DATA_WIDTH/8)-1	downto	0) := (others	=>	'1');
	signal	node_out_tlast	:	std_logic	:=	'0';
	signal	node_out_tvalid	:	std_logic	:=	'0';	
	signal	node_out_tready	:	std_logic	:=	'0';	
		


	-- fifo out active detection. 
	
	signal fifo_out_captured_tlast_pulse : std_logic := '0';
	signal fifo_out_frame_start_pulse : std_logic := '0';
	signal fifo_out_frame_active : std_logic := '0'; 
	signal fifo_out_frame_active_reg : std_logic := '0'; 
	
	-- node out active detection.
	
	signal node_out_captured_tlast_pulse : std_logic := '0';
	signal node_out_frame_start_pulse : std_logic := '0';
	signal node_out_frame_active : std_logic := '0'; 
	signal node_out_frame_active_reg : std_logic := '0'; 
	
	-- Link selector control signals. 
	
	constant SELECTOR_CHANNELS : integer := 2;
	constant SELECT_LINK_FIFO  : integer := 2;
	constant SELECT_NODE_OUT   : integer := 1;
	constant SELECT_NONE	   : integer := 0;	
	
	
	signal link_out_selector : integer range SELECTOR_CHANNELS downto 0 := 0;



--**************************************************************************************************************
begin

	-- Connection of external signals. 



	 
	link_out_axis_tdata <= link_out_tdata_reg_out;
	link_out_axis_tkeep <= link_out_tkeep_reg_out;  
	--link_out_axis_tstrb <= link_out_tsterb_reg_out;
	link_out_axis_tlast <= link_out_tlast_reg_out;
	link_out_axis_tvalid <= link_out_tvalid_reg_out;
	link_out_tready_reg_out <= link_out_axis_tready;
		
	node_out_tdata	 <= node_out_axis_tdata;
	node_out_tkeep <= node_out_axis_tkeep;  
	--node_out_tstrb <= node_out_axis_tstrb;
	node_out_tlast <= node_out_axis_tlast;
	


	--  Warning the disable signal will amputate messages when it is turned on or off. 
	node_out_tvalid <= node_out_axis_tvalid when node_out_disable = '0' else '0'; --Sets tvalid to 0 when disabled.
	node_out_axis_tready <= node_out_tready when node_out_disable = '0' else '1'; -- Sets tready to 1, so the input is flushed when disabled. 
	
	fifo_tdata_in <= link_in_axis_tdata;
	fifo_tkeep_in <= link_in_axis_tkeep;
	--fifo_tstrb_in <= link_in_axis_tstrb;
	fifo_tlast_in <= link_in_axis_tlast;
	fifo_tvalid_in <= 	link_in_axis_tvalid; 
	link_in_axis_tready <=  fifo_tready_in; 
	
	node_in_axis_tdata <= node_fifo_tdata_out;
	node_in_axis_tkeep <= node_fifo_tkeep_out;  
	--node_in_axis_tstrb <= node_fifo_tstrb_out;
	node_in_axis_tlast <= node_fifo_tlast_out;
	node_in_axis_tvalid <= node_fifo_tvalid_out;
	node_fifo_tready_out <= node_in_axis_tready;   
			

----------------------------------------------------------------------------------------
-- Input fifo.
-- Fifo has two output channels that reads from a common memory block.
-- The fifo has multiple data arrays, stores tdata, tkeep, tlast signals. 
-- Control singals tvalid and tready are hanldled locally at each side of the fifo.   


-- Merges fifo elements into a single element, to avoid that the two tlast fifos are merged into signle register with two read ports, which is then is not able to infer as a block ram    

fifo_in_element(AXIS_DATA_WIDTH -1 downto 0) <=  fifo_tdata_in; 
fifo_in_element(FIFO_ELEMENT_SIZE-1) <= fifo_tlast_in;
fifo_in_element(AXIS_DATA_WIDTH + AXIS_DATA_WIDTH/8-1 downto AXIS_DATA_WIDTH) <= fifo_tkeep_in;

transfer_fifo_tdata_out <= transfer_fifo_out_element(AXIS_DATA_WIDTH -1 downto 0); 
transfer_fifo_tlast_out <= transfer_fifo_out_element(FIFO_ELEMENT_SIZE-1);
transfer_fifo_tkeep_out <= transfer_fifo_out_element(AXIS_DATA_WIDTH + AXIS_DATA_WIDTH/8-1 downto AXIS_DATA_WIDTH); 


node_fifo_tdata_out <= node_fifo_out_element(AXIS_DATA_WIDTH -1 downto 0); 
node_fifo_tlast_out <= node_fifo_out_element(FIFO_ELEMENT_SIZE-1);
node_fifo_tkeep_out <= node_fifo_out_element(AXIS_DATA_WIDTH + AXIS_DATA_WIDTH/8-1 downto AXIS_DATA_WIDTH); 


	link_fifo_write_process	:	process(axis_aclk)	
		begin																																																																												
			if	(rising_edge	(axis_aclk))	then																																												
				if(axis_aresetn	=	'0')	then					
					fifo_write_pointer	<=	0;
					fifo_tready_in <= '0';
			else	
				-- Writes to buffer. 				
				if	fifo_tvalid_in	=	'1'	and		fifo_tready_in	=	'1'	then	


					transfer_fifo_element_array(fifo_write_pointer) <=	fifo_in_element;
					node_fifo_element_array(fifo_write_pointer) <=	fifo_in_element;
					-- Updates write pointer.	
					if	fifo_write_pointer	<	LINK_FIFO_SIZE-1 	then
						fifo_write_pointer	<=	fifo_write_pointer + 1;
					else	
						fifo_write_pointer	<=	0;			
					end	if;			
				end	if;
				 if fifo_full_handshake = '1' then  
				 	fifo_tready_in <=  not link_fifo_full_flag;   -- Ready unless fifo is full.
				 	--fifo_tready_in <= not fifo_full_flag and fifo_tvalid_in;  -- cannot use this one, as Aurora IP does not use tready. 
				 else
					 fifo_tready_in <= '1';  	 -- Always reday.					  
				end if;			
		
			end	if;
		end	if;																																																																		
	end	process;	

-- Fifo read, transfer to link output
	transfer_fifo_read_process	:	process(axis_aclk)	
	begin																																																																												
		if	(rising_edge	(axis_aclk))	then																																												
			if(axis_aresetn	=	'0')	then																																																

				transfer_fifo_out_element <=	(others	=>	'0');
				transfer_fifo_tvalid_out <= '0';
				transfer_fifo_read_pointer	<=	0;
																																																									
			else	
				if link_in_out_transfer_disable = '1' then
					-- Blocks output, flushes fifo . This will amputate ongoing messages. 
					transfer_fifo_tvalid_out <= '0';
					transfer_fifo_read_pointer <= fifo_write_pointer;
				else
					-- Read output 1 from buffer
					if not (transfer_fifo_tvalid_out = '1' and transfer_fifo_tready_out = '0') then  --Reads only when not waiting for transfoer to finish.

						transfer_fifo_out_element <= transfer_fifo_element_array(transfer_fifo_read_pointer); 
						if 	(fifo_write_pointer	=	transfer_fifo_read_pointer) then
							transfer_fifo_tvalid_out	<=	'0';    -- Fifo is empty. 				
						else
							transfer_fifo_tvalid_out	<=	'1'; --  New data word out, updates pointer to nect one to be read. 
							-- Updates read pointer to next word.
							if	transfer_fifo_read_pointer	<	LINK_FIFO_SIZE-1 	then 
								transfer_fifo_read_pointer	<=	transfer_fifo_read_pointer + 1;
							else	
								transfer_fifo_read_pointer	<=	0;			
							end	if;	
						end if; 				
					end if;	
				end if;
			end	if;
		end	if;																																																																		
	end	process;
	
	-- fifo read, to local node 						
	node_fifo_read_process	:	process(axis_aclk)	
		begin																																																																												
			if	(rising_edge	(axis_aclk))	then																																												
				if(axis_aresetn	=	'0')	then					

				node_fifo_tvalid_out <= '0';
				
				node_fifo_out_element <=	(others	=>	'0');	
				node_fifo_read_pointer	<=	0;
			else 
				if node_in_fifo_disable = '1' then
					-- Blocks output, flushes fifo. This will amputate ongoing messages. 
					node_fifo_tvalid_out <= '0';
					node_fifo_read_pointer <= fifo_write_pointer;
				else
												
					if not (node_fifo_tvalid_out = '1' and node_fifo_tready_out = '0') then  --Reads only when not waiting for transfoer to finish.
		
						node_fifo_out_element <= node_fifo_element_array(node_fifo_read_pointer); 

						-- Updates read pointer. Sets valid flag to 0 if fifo is empty.
						if 	(fifo_write_pointer	=	node_fifo_read_pointer) then 
							node_fifo_tvalid_out	<=	'0';   -- Fifo is empty.  					
						else
							node_fifo_tvalid_out	<=	'1';  --  New data word out, updates pointer to next one to be read. 
							-- Updates read pointer to next word.
							if	node_fifo_read_pointer	<	LINK_FIFO_SIZE-1 	then 
								node_fifo_read_pointer	<=	node_fifo_read_pointer + 1;
							else	
								node_fifo_read_pointer	<=	0;			
							end	if;	
						end if; 				
					end if;
	
				end if;	
			end	if;
		end	if;																																																																		
	end	process;							
	
	-- Fill level. Combinatoric operations in order to avoid delay.
	 
	link_transfer_fifo_fill_level <=  fifo_write_pointer	-	transfer_fifo_read_pointer  + LINK_FIFO_SIZE when fifo_write_pointer	-	transfer_fifo_read_pointer < 0
					else fifo_write_pointer	-	transfer_fifo_read_pointer;
	
	link_node_fifo_fill_level <=  fifo_write_pointer	-	node_fifo_read_pointer  + LINK_FIFO_SIZE when fifo_write_pointer	-	node_fifo_read_pointer < 0
					else fifo_write_pointer	-	node_fifo_read_pointer;

	-- Flags full fifo when there is still room for one word. Must do that in order to handle the register delay. 
	
	link_transfer_fifo_full_flag <= '0' when link_transfer_fifo_fill_level <= LINK_FIFO_SIZE -3 else '1'; 
	link_node_fifo_full_flag <= '0' when link_node_fifo_fill_level <= LINK_FIFO_SIZE -3 else '1';
	 
	link_fifo_full_flag <= link_transfer_fifo_full_flag or link_node_fifo_full_flag;
		

    link_transfer_fifo_filled_flag_a <= '0' when link_transfer_fifo_fill_level < LINK_FIFO_FILLED_FLAG_LEVEL_A else '1';
    link_transfer_fifo_filled_flag_b <= '0' when link_transfer_fifo_fill_level < LINK_FIFO_FILLED_FLAG_LEVEL_B else '1';
    
    link_node_fifo_filled_flag_a <= '0' when link_node_fifo_fill_level < LINK_FIFO_FILLED_FLAG_LEVEL_A else '1';	
    link_node_fifo_filled_flag_b <= '0' when link_transfer_fifo_fill_level < LINK_FIFO_FILLED_FLAG_LEVEL_B else '1'; 


    fill_state_reg_process	:	process(axis_aclk)	
    begin
    	if	(rising_edge	(axis_aclk))	then
         
            switch_state <= std_logic_vector(to_unsigned(link_out_selector,2));
            
            transfer_fifo_fill_level <= std_logic_vector(to_unsigned(link_transfer_fifo_fill_level,AXIS_DATA_WIDTH));
            node_fifo_fill_level <= std_logic_vector(to_unsigned(link_node_fifo_fill_level,AXIS_DATA_WIDTH));

            transfer_fifo_filled_flag_a <= link_transfer_fifo_filled_flag_a;
            transfer_fifo_filled_flag_b <= link_transfer_fifo_filled_flag_b;
            node_fifo_filled_flag_a <= link_node_fifo_filled_flag_a;
            node_fifo_filled_flag_b <= link_node_fifo_filled_flag_b;
                                              
            transfer_fifo_full_flag <= link_transfer_fifo_full_flag;
            node_fifo_full_flag <= link_node_fifo_full_flag;
     
            active_transfer_frame <= fifo_out_frame_active;
            active_node_out_frame <= node_out_frame_active;
            
        end if;
    end process; 



--------------------------------------------------------------------
-- Output register with one sample elasticity. Allows tready signals to pass through a register. 
-- Stores one sample in a buffer register in order to handle a once clock delay of the tready- signal. 
 -- Without the buffer mechanism the treaddy signal must be combinatoric through the whole axis chain.

	 -- Flow control signal. Paused data transfers.
	  
	 link_out_tvalid_reg_in_m <=  link_out_tvalid_reg_in when  link_out_wait = '0'  else '0';
	 link_out_tready_reg_in  <= link_out_tready_reg_in_m when  link_out_wait = '0'  else '0';	
	   
	-- Gathers ready and valid signals to determine that transfer is occuring. 
		
	link_out_transfer_in 	<= '1' when link_out_tvalid_reg_in_m  = '1' and link_out_tready_reg_in = '1' else '0';
	link_out_transfer_out	<= '1' when link_out_tvalid_reg_out = '1' and link_out_tready_reg_out = '1' else '0';
	link_out_wait_out 		<= '1' when link_out_tvalid_reg_out = '1' and link_out_tready_reg_out = '0' else '0';
	link_out_tready_reg_in_m 	<= 	not link_out_reg_buffer_full;	

	link_out_register_process	:	process(axis_aclk)	
	variable		fill_level	:	integer := 0;
		begin																																																																												
			if	(rising_edge	(axis_aclk))	then																																												
				if(axis_aresetn	=	'0')	then
				
					link_out_tdata_reg_out	<= (others =>'0');
					link_out_tlast_reg_out <= '0';
					link_out_tkeep_reg_out <= (others =>'0');
				--	link_out_tstrb_reg_out <= '0';
					link_out_tvalid_reg_out <= '0';
				--	link_out_tready_reg_in <= '0';
					
					link_out_tdata_reg_buffer	<= (others =>'0');
					link_out_tlast_reg_buffer <= '0';
					link_out_tkeep_reg_buffer <= (others =>'0');
				--  link_out_tstrb_reg_buffer <= '1';
					link_out_tvalid_reg_buffer <= '0';
				--	link_out_ready_reg_buffer <= '1';
					link_out_reg_buffer_full <= '0';
				
													
				else 
	 			-- Buffer captures value that otherwise would be lost due to register delay when register is stalled because tready_out is low. 
	 			if	link_out_transfer_in = '1' then
					link_out_tdata_reg_buffer <= link_out_tdata_reg_in;  
					link_out_tlast_reg_buffer <= link_out_tlast_reg_in;
					link_out_tkeep_reg_buffer <= link_out_tkeep_reg_in;	
				--	link_out_tstrb_reg_buffer <= link_out_tstrb_reg_in;
					link_out_tvalid_reg_buffer <= link_out_tvalid_reg_in_m;		
			end if;
					-- Determines buffer state, wheter value captured in buffer is also written  in register or not.    
					if link_out_transfer_in = '1' and link_out_wait_out = '1' then 	-- --new value in and old value stalled in register . 
						link_out_reg_buffer_full <= '1';
					end if;	
								
					if link_out_transfer_in = '0' and link_out_transfer_out = '1' then 	-- --new value in and old value stalled in register . 
		
						link_out_reg_buffer_full <= '0';
					end if;
			
					-- Register. Reads from eiher input or buffer register. 
					if link_out_wait_out= '0' then
						if link_out_reg_buffer_full = '0' then  -- buffer fill controls tready_in signal
							-- Normal buffer update from input.
									link_out_tdata_reg_out <= link_out_tdata_reg_in;  
									link_out_tkeep_reg_out <= link_out_tkeep_reg_in;	
								--	link_out_tstrb_reg <= link_out_tstrb_reg_in;						
									link_out_tlast_reg_out <= link_out_tlast_reg_in;
									link_out_tvalid_reg_out <= link_out_tvalid_reg_in_m;	
						else 
							-- buffer is full, must read from bufffer. 
							link_out_tdata_reg_out <= link_out_tdata_reg_buffer;  	
							link_out_tkeep_reg_out <= link_out_tkeep_reg_buffer;
						--	link_out_tstrb_reg_out <= link_out_tstrb_reg_buffer;			
							link_out_tlast_reg_out <= link_out_tlast_reg_buffer;
							link_out_tvalid_reg_out <= '1'; 
						end if;
					end if;
						
				end if;				
			end if;
		end process;





------------------------------------------------------------------------------------------
-- Detects whether axis links are busy.
-- frame active signal is delayed one clock. Must be or-ed to tvalid.
 
fifo_out_busy_detection_process : process(axis_aclk)
	begin
		if rising_edge (axis_aclk) then
			if axis_aresetn = '0'then
			
				fifo_out_frame_active_reg <= '0';				
				fifo_out_captured_tlast_pulse <= '0';
			else 
				-- Order ooperations defines prcedence. last operation has highest priority. 
				if 	fifo_out_captured_tlast_pulse = '1' then
					fifo_out_frame_active_reg <= '0';   -- Frame was completed the last time
				end if;
				
				if transfer_fifo_tvalid_out = '1' then
					fifo_out_frame_active_reg <= '1';		-- Higher priority than setting frame passive after tlast, lower than passive due to disable.	
				end if;
				
				if link_in_out_transfer_disable = '1' then
				 	fifo_out_frame_active_reg <= '0';  -- Forces off actiive frame signal when fifo is disabled.  
				end if;
				
	
				if transfer_fifo_tready_out = '1' and transfer_fifo_tvalid_out = '1' then  -- Completed transfer of the last word.
					fifo_out_captured_tlast_pulse <=  transfer_fifo_tlast_out;  -- Emits a pulse at the next clock after tlast.
				else
					fifo_out_captured_tlast_pulse <= '0';		 
				end if;			
			
			end if;
		end if;
	end process;

	fifo_out_frame_active <= '1' when fifo_out_frame_active_reg = '1' or  transfer_fifo_tvalid_out = '1' else '0';  -- Contains also the present tvalid in order to skip the delay in the registers. 


----------------------------------------------------------------------------------------


node_out_busy_detection_process : process(axis_aclk)
	begin
		if rising_edge (axis_aclk) then
			if axis_aresetn = '0'then
			
				node_out_frame_active_reg <= '0';				
				node_out_captured_tlast_pulse <= '0';
			else
				if 	node_out_captured_tlast_pulse = '1' then
					node_out_frame_active_reg <= '0';   -- frame was completed the last time
				end if;
				
				if node_out_tvalid = '1' then
					node_out_frame_active_reg <= '1';			
				end if;
				
				
				if node_out_disable = '1' then
					node_out_frame_active_reg <= '0';			-- Forces the active signal off when input disable flag is set.
				end if;
						
				node_out_captured_tlast_pulse <= '0';		
				if node_out_tready = '1' and node_out_tvalid = '1' then  -- completed transfer of the last word.
					node_out_captured_tlast_pulse <=  node_out_tlast;
				end if;			
			
			end if;
		end if;
	end process;

	node_out_frame_active <= '1' when node_out_frame_active_reg = '1' or  node_out_tvalid = '1' else '0';


----------------------------------------------------------------------------------------
-- Changeover switch control

-- Changeover is only allowed when selected input is not active. 
-- The selector is set to 0 when the selected input is not active.    
-- When the selector is set to none the first input to go active is selected. 
-- This means that a changeover always goes through a none- interval when it changes from one input to another. 
-- It also means that the switch will be stuck at the fifo if it contains multiple frames, as they will be trnaferred without pause between them. 
 
link_out_selector_control_process : process(axis_aclk)
	begin
		if rising_edge (axis_aclk) then
			if axis_aresetn = '0'then
		link_out_selector <= 0; 
		else
		case link_out_selector is
		
			when  SELECT_LINK_FIFO =>	 
				if  fifo_out_frame_active = '0' then
					link_out_selector <= 0; 	
				end if;	 
			when  SELECT_NODE_OUT =>	 
				if  node_out_frame_active = '0' then
					link_out_selector <= 0; 	
				end if;	
			when SELECT_NONE =>
				 	-- Determines next input to be selected. The last one wins is two goes active simultaneously.  				
 
					if  node_out_frame_active = '1' then				
						link_out_selector <= SELECT_NODE_OUT; 	
					end if;
					if  fifo_out_frame_active = '1' then
						link_out_selector <= SELECT_LINK_FIFO; 	-- link has higher priority than node.
					end if;
					
					if set_changeover_switch_to_none = '1' then
					 	link_out_selector <= 0; -- overrides other choices.
					end if;				
		
			when others =>
				link_out_selector <= 0;  -- Dummy. shout not occur. 
			end case;	
		
		end if;			
	end if;
end process;			





----------------------------------------------------------------------------------------
-- Changeover switch
-- Combinatoric multiplexerd. 
-- Each of the axis signals are switched. 

link_out_tdata_reg_in <= transfer_fifo_tdata_out when link_out_selector = SELECT_LINK_FIFO else
						node_out_tdata  when link_out_selector = SELECT_NODE_OUT else (others => '0');  

link_out_tkeep_reg_in <= transfer_fifo_tkeep_out when link_out_selector = SELECT_LINK_FIFO else
						node_out_tkeep  when link_out_selector = SELECT_NODE_OUT else (others => '0');  

--link_out_tstrb_reg_in <= transfer_fifo_tstrb_out when link_out_selector = SELECT_LINK_FIFO else
--						node_out_tstrb  when link_out_selector = SELECT_NODE_OUT else 
--						(others => '0');  

link_out_tlast_reg_in <= transfer_fifo_tlast_out when link_out_selector = SELECT_LINK_FIFO else
						node_out_tlast  when link_out_selector = SELECT_NODE_OUT else '0';  


link_out_tvalid_reg_in <= transfer_fifo_tvalid_out when link_out_selector = SELECT_LINK_FIFO else
						node_out_tvalid  when link_out_selector = SELECT_NODE_OUT else '0';  

-- Tready signals for the switch inputs that are not selected are set to '0'. 

transfer_fifo_tready_out <= link_out_tready_reg_in when link_out_selector = SELECT_LINK_FIFO  else '0'; 
node_out_tready <= link_out_tready_reg_in when link_out_selector = SELECT_NODE_OUT  else '0'; 

---------------------------------------------------------------------------
end arch_imp;
