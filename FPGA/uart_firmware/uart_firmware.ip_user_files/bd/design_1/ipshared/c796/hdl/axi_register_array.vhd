library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_register_array is
	generic (
		-- Users to add parameters here
		
		REGISTER_WIDTH                   : integer              := 32;
	    NUMBER_OF_REGISTERS              : integer              := 4;	
		 REG_SIGNED								 : integer              := 0;	  -- 0: unsigned 1 signed				 

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here

	 load									: in	std_logic_vector( NUMBER_OF_REGISTERS-1 downto 0) := (others => '0');	-- Load flags. One load bit per register. '1': Loads selected register with values from register_array_load.
	
	 register_array_write_vec		: out  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Register values. 
	 register_array_read_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0');  -- Values that the processor reads.
	 register_array_init_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Initial values loaded at reset
	 register_array_load_vec 		: in  std_logic_vector(NUMBER_OF_REGISTERS * REGISTER_WIDTH  -1 downto 0) :=  (others => '0'); -- Values loaded when load flags are set.
	 register_write_a	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register A. 
	 register_write_b	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register B. 
	 register_write_c	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register C.  
	 register_write_d	 				: out  std_logic_vector(REGISTER_WIDTH  -1 downto 0) := (others => '0');  -- Direct output register D. 


		-- User ports ends
		-- Do not modify the ports beyond this line

		
		s_axi_aclk	: in std_logic;-- Global Clock Signal
		s_axi_aresetn	: in std_logic;-- Global Reset Signal. This Signal is Active LOW
		
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);	-- Write address (issued by master, acceped by Slave)
		s_axi_awprot	: in std_logic_vector(2 downto 0);						-- Write channel Protection type. This signal indicates the -- privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
		s_axi_awvalid	: in std_logic;										-- Write address valid. This signal indicates that the master signaling valid write address and control information.
		s_axi_awready	: out std_logic;									-- Write address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
		s_axi_wdata		: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);		-- Write data (issued by master, acceped by Slave) 
		s_axi_wstrb		: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);		-- Write strobes. This signal indicates which byte lanes hold  valid data. There is one write strobe bit for each eight  bits of the write data bus.    
		s_axi_wvalid	: in std_logic;										-- Write valid. This signal indicates that valid write  data and strobes are available.
		s_axi_wready	: out std_logic;									-- Write ready. This signal indicates that the slave  can accept the write data.
		s_axi_bresp		: out std_logic_vector(1 downto 0);					-- Write response. This signal indicates the status  of the write transaction.
		s_axi_bvalid	: out std_logic;									-- Write response valid. This signal indicates that the channel is signaling a valid write response.
		s_axi_bready	: in std_logic;										-- Response ready. This signal indicates that the master  can accept a write response.
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);		-- Read address (issued by master, acceped by Slave)
		s_axi_arprot	: in std_logic_vector(2 downto 0);					-- Protection type. This signal indicates the privilege and security level of the transaction, and whether the  transaction is a data access or an instruction access.
		s_axi_arvalid	: in std_logic;										-- Read address valid. This signal indicates that the channel is signaling valid read address and control information.
		s_axi_arready	: out std_logic;									-- Read address ready. This signal indicates that the slave is  ready to accept an address and associated control signals.
		s_axi_rdata		: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);		-- Read data (issued by slave)
		s_axi_rresp		: out std_logic_vector(1 downto 0); 				-- Read response. This signal indicates the status of the read transfer.
		s_axi_rvalid	: out std_logic;									-- Read valid. This signal indicates that the channel is signaling the required read data.
		s_axi_rready	: in std_logic										-- Read ready. This signal indicates that the master can accept the read data and response information.

	);
end axi_register_array;

architecture arch_imp of axi_register_array is

	------------------------------
	
		function i_log2 (x : positive) return integer is   -- Needed to extract size of array index  
			variable i : integer;
				begin
					i := 0;  
					while (2 ** i < x) and i < 512 loop
						i := i + 1;
					end loop;
				return i;
		end function;

	-------------------------
	
	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	
	--constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	--constant OPT_MEM_ADDR_BITS : integer := 1;
	
	
	constant  NUM_REG              : integer              := NUMBER_OF_REGISTERS;	
	
	constant REG_ADDR_WIDTH 		: integer := i_log2(NUM_REG);
	
	constant REG_ADDR_SHIFT			: integer := i_log2(C_S_AXI_DATA_WIDTH/8);
	
	constant P_NUM_REG				: integer  := 2 ** REG_ADDR_WIDTH; 
	
	constant NUMBER_OF_DIRECT_OUTPUTS		: integer  := 4; 
	
	
	signal reg_read_enable   		: std_logic                               	:= '0';
	signal reg_write_enable  		: std_logic                               	:= '0';
	signal reg_read_enable_dly1  	: std_logic                               	:= '1';
	signal reg_read_ack      		: std_logic                               	:= '0';
	signal reg_write_ack     		: std_logic                               	:= '0';
	
	signal reg_wr_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
	signal reg_rd_addr 					: std_logic_vector(REG_ADDR_WIDTH - 1 downto 0)    := (others => '0');
	
	signal reg_wr_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
	signal reg_rd_index 					: integer range P_NUM_REG-1 downto 0 := 0; 
	
	type register_array_type is array (P_NUM_REG - 1 downto 0) of std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);

	signal register_array_read   	: register_array_type := (others => (others => '0')); -- Values the processor reads from the register. 
	signal register_array_write 	: register_array_type := (others => (others => '0')); -- Values the processor writes from the register. This is the actual register.
	signal register_array_init 	: register_array_type := (others => (others => '0'));	-- Inital values set in register during reset. 
	signal register_array_load 	: register_array_type := (others => (others => '0'));	-- Values that is loaded into register when load bit is set.

--	signal load 					: std_logic_vector(P_NUM_REG - 1 downto 0)    := (others => '0');
--

	
	type direct_register_write_array_type is array (NUMBER_OF_DIRECT_OUTPUTS - 1 downto 0) of std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);	
	
	signal direct_register_write_array : direct_register_write_array_type := (others => (others => '0'));
	
	
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
--	---- Number of Slave Registers 4
--	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--signal byte_index	: integer;

begin



	assert (C_S_AXI_ADDR_WIDTH >= REG_ADDR_WIDTH + REG_ADDR_SHIFT)
		report "#### Address width not wide enough to reach for all registers in this file."
		severity failure;
		
	---===========================================================	
	reg_read_enable <= '1';
	reg_write_enable <= slv_reg_wren;

	 
	reg_wr_addr <= axi_awaddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);
	
	reg_rd_addr <= axi_araddr (REG_ADDR_WIDTH +REG_ADDR_SHIFT-1 downto REG_ADDR_SHIFT);

	reg_wr_index <= to_integer(unsigned(reg_wr_addr));
	
	reg_rd_index <= to_integer(unsigned(reg_rd_addr));
	
	----------------------------------------------------------------------------
	-- Register write process. Bytewise write.
	
	Register_array_process : process(s_axi_aclk) is
		begin
			if s_axi_aclk'event and s_axi_aclk = '1' then
				if s_axi_aresetn = '0' then
					register_array_write   <= register_array_init;
				else			
					if  reg_write_enable = '1' then
						for byte_index in 0 to (C_S_AXI_DATA_WIDTH / 8) - 1 loop					 
							if (s_axi_wstrb(byte_index) = '1')  then						
								register_array_write(reg_wr_index)(byte_index * 8 + 7 downto byte_index * 8) <= s_axi_wdata(byte_index * 8 +7 downto byte_index * 8);
							end if;
						end loop;
					end if;
					 for reg in 0 to NUM_REG-1 loop
						if load(reg) = '1' then	
							register_array_write(reg) <= register_array_load(reg);
						end if;
					end loop;				
				end if;	
			end if;		
		end process;
	
 	-------------
	-- Read.
	
	reg_data_out <= register_array_read(reg_rd_index) when  reg_read_enable = '1' else (others => '0');


 	
--=============================================================================
	--  Unpacking code to be used at the outside of this module.  
	--	Reg_generate : for n in 0 to NUMBER_OF_REGISTERS -1 generate 
	--				register_array_write(n) <= register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n);
						
	--				register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_read(n);
	--				register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_init(n);
	--				register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= register_array_load(n);
	--			end generate;	


	
	Reg_generate : for n in 0 to NUM_REG -1 generate 
		Reg_signed_generate : if  REG_SIGNED = 1 generate
		
			register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= std_logic_vector(resize(signed(register_array_write(n)),REGISTER_WIDTH));
			
			register_array_read(n) <= std_logic_vector(resize(signed(register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			register_array_init(n) <= std_logic_vector(resize(signed(register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			register_array_load(n) <= std_logic_vector(resize(signed(register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			
		end generate;	
		

	
		Reg_unsigned_generate : if  not (REG_SIGNED = 1) generate
		
			register_array_write_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n) <= std_logic_vector(resize(unsigned(register_array_write(n)),REGISTER_WIDTH));
			
			register_array_read(n) <= std_logic_vector(resize(unsigned(register_array_read_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			register_array_init(n) <= std_logic_vector(resize(unsigned(register_array_init_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			register_array_load(n) <= std_logic_vector(resize(unsigned(register_array_load_vec(REGISTER_WIDTH * n + REGISTER_WIDTH-1 downto REGISTER_WIDTH * n)),C_S_AXI_DATA_WIDTH));
			
		end generate;
		
		-- Intermediate step, assigning values to direct oputput signals.
		
		Direct_output_generate : if n < NUMBER_OF_DIRECT_OUTPUTS generate
			direct_register_write_array(n) <= register_array_write(n);
		end generate;
		
	end generate;
	
	-- Wrting to direct register output signals. 
	
	register_write_a <= direct_register_write_array(0)(REGISTER_WIDTH-1 downto 0);
	register_write_b <= direct_register_write_array(1)(REGISTER_WIDTH-1 downto 0);
	register_write_c <= direct_register_write_array(2)(REGISTER_WIDTH-1 downto 0);
	register_write_d <= direct_register_write_array(3)(REGISTER_WIDTH-1 downto 0);


	--===============================================================
	-- I/O Connections assignments

	s_axi_awready	<= axi_awready;
	s_axi_wready	<= axi_wready;
	s_axi_bresp	<= axi_bresp;
	s_axi_bvalid	<= axi_bvalid;
	s_axi_arready	<= axi_arready;
	s_axi_rdata	<= axi_rdata;
	s_axi_rresp	<= axi_rresp;
	s_axi_rvalid	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one s_axi_aclk clock cycle when both
	-- s_axi_awvalid and s_axi_wvalid are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then 
	    if s_axi_aresetn = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and s_axi_awvalid = '1' and s_axi_wvalid = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- s_axi_awvalid and s_axi_wvalid are valid. 

	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then 
	    if s_axi_aresetn = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and s_axi_awvalid = '1' and s_axi_wvalid = '1') then
	        -- Write Address latching
	        axi_awaddr <= s_axi_awaddr;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one s_axi_aclk clock cycle when both
	-- s_axi_awvalid and s_axi_wvalid are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then 
	    if s_axi_aresetn = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and s_axi_wvalid = '1' and s_axi_awvalid = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and s_axi_wvalid and axi_awready and s_axi_awvalid ;


	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then 
	    if s_axi_aresetn = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and s_axi_awvalid = '1' and axi_wready = '1' and s_axi_wvalid = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (s_axi_bready = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one s_axi_aclk clock cycle when
	-- s_axi_arvalid is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when s_axi_arvalid is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then 
	    if s_axi_aresetn = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and s_axi_arvalid = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= s_axi_araddr;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one s_axi_aclk clock cycle when both 
	-- s_axi_arvalid and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (s_axi_aclk)
	begin
	  if rising_edge(s_axi_aclk) then
	    if s_axi_aresetn = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and s_axi_arvalid = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and s_axi_rready = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and s_axi_arvalid and (not axi_rvalid) ;



	-- Output register or memory read data
	process( s_axi_aclk ) is
	begin
	  if (rising_edge (s_axi_aclk)) then
	    if ( s_axi_aresetn = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (s_axi_arvalid) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

	-- User logic ends

end arch_imp;
