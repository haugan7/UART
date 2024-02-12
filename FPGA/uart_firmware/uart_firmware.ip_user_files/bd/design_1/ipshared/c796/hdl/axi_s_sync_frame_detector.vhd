-- axi_s_synch_frame_detector IP module.
-- It contains:
-- A start of frame detector, 
-- A frame header pattern match detector.
-- A time capture register.

-- Author: Kjell Ljøkelsøy Sintef Energy.  2016. 

 
  
 
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity axi_s_synch_frame_detector is
	generic (
	
	
		-- Parameters of Axis interface
		AXIS_DATA_WIDTH					: integer := 32
		
	);
	port (

		axis_aclk		: in std_logic;
		axis_aresetn	: in std_logic;
		  
		-- Status signals. 	
		frame_start_pulse 				: out std_logic := '0';	-- Start of incoming frame on link.
		frame_start_toggle 				: out std_logic:= '0';		-- toggling flag.		
		
			
		 		
		-- axi stream input signals. 

		synch_axis_tdata	: in std_logic_vector(AXIS_DATA_WIDTH-1 downto 0); --:= (others => '1');

		synch_axis_tlast	: in std_logic := '0';
		synch_axis_tvalid	: in std_logic := '0';
		synch_axis_tready	: in std_logic := '0'
	);
	
	end axi_s_synch_frame_detector;
	
----------------------------------------------------------------------------

architecture arch_imp of axi_s_synch_frame_detector is


	
	
	--   link in frame start detectioon.
	signal synch_captured_tlast_pulse : std_logic := '0';
	signal synch_frame_start_pulse : std_logic := '0';
	signal synch_frame_start_toggle : std_logic := '0';
		
	signal synch_frame_active : std_logic := '0'; 	
	
begin

	
	frame_start_pulse <= synch_frame_start_pulse; 

-----------------------------------------------------------------------------------------------------------
-- Input frame start detector. 
-- Detects start of frame transmision.  Uses start of frame for synhronisation of system. 
-- A toggling flag allows signalling across clock domains. 
-- First tvalid after tlast indicates start of new frame.  

synch_active_frame_detection_process : process(axis_aclk)
	begin
		if rising_edge (axis_aclk) then
			if axis_aresetn = '0'then
				synch_frame_active <= '0';
				synch_captured_tlast_pulse <= '0';
				synch_frame_start_toggle <= '0';
			else
			
				synch_captured_tlast_pulse <= '0';
				synch_frame_start_pulse <= '0';
				
				if 	synch_captured_tlast_pulse = '1' then
					synch_frame_active <= '0';   -- frame was completed the last time
				end if;
				
				if synch_axis_tvalid = '1' then
					synch_frame_active <= '1';
				
					if synch_frame_active = '0' or  synch_captured_tlast_pulse = '1' then 
						synch_frame_start_pulse <= '1';
						synch_frame_start_toggle <= not synch_frame_start_toggle;
					end if;
	
				end if;
				
				if synch_axis_tready = '1' and synch_axis_tvalid = '1' then  -- completed transfer of the last word.
					synch_captured_tlast_pulse <=  synch_axis_tlast;
				end if;			
			
			end if;
		end if;
	end process;

frame_start_toggle <= synch_frame_start_toggle;


end;
