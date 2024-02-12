//-*****************************************************************************
//	AXI_S chain_link switch 
//	Author: Kjell Ljøkelsøy Sintef Energy.	2016. 
//-*****************************************************************************

#define AXI_S_CHAIN_LINK_SWITCH_STATUSREG(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (0))

	#define	 LINK_OUT_WAITING_1_BITNR		 	0 // 1: Transfer of data at link out is blocked.  Flow control. No data loss. 

	#define	 ACTIVE_TRANSFER_FRAME_1_BITNR	  	2	// 1: Frame from the link input is being transferred to link out or is waiting. 
	#define	 ACTIVE_NODE_OUT_FRAME_1_BITNR	  	3	// 1: Frame from node is being transferred or is waiting.

	#define	 SWITCH_STATE_1_START_BITNR			4	 // State of the changeover switch.  2 bit signal: 0: idle 1: node out 2: transfer fifo
	
	#define	 TRANSFER_FIFO_FILLED_A1_BITNR		8  // 1:Transfer fifo from link to changeover switch is filled to flag threshold level A. 
	#define	 TRANSFER_FIFO_FILLED_B1_BITNR		9	//	1: Transfer fifo from link to changeover switch is filled to flag threshold level B. 
	#define	 NODE_FIFO_FILLED_A1_BITNR			10 // 1: Node input fifo is filled to flag threshold level A. 
	#define	 NODE_FIFO_FILLED_B1_BITNR			11 // 1: Node input fifo is filled to flag threshold level A.	

	#define	 TRANSFER_FIFO_FULL_1_BITNR			12 // 1: Transfer fifo from link to changeover switch is full. 
	#define	 NODE_FIFO_FULL_1_BITNR				13 // 1: Node input fifo is full.	
	
	#define	 LINK_FLUSH_1_BITNR					15  // 1: Hardware input signal is set. Flushes both node and transfer fifo.
	
	#define	 LINK_OUT_WAITING_2_BITNR			16  
	
	#define	 ACTIVE_TRANSFER_FRAME_2_BITNR		18
	#define	 ACTIVE_NODE_OUT_FRAME_2_BITNR		19

	#define	 SWITCH_STATE_2_START_BITNR			20
	
	#define	 TRANSFER_FIFO_FILLED_A2_BITNR		24	
	#define	 TRANSFER_FIFO_FILLED_B2_BITNR		25
	
	#define	 NODE_FIFO_FILLED__A2BITNR			26
	#define	 NODE_FIFO_FILLED_B2_BITNR			27		

	#define	 TRANSFER_FIFO_FULL_2_BITNR			28
	#define	 NODE_FIFO_FULL_2_BITNR				29		
	
	#define	 LINK_FLUSH_2_BITNR					31 // hardware input
	
#define AXI_S_CHAIN_LINK_SWITCH_CONFIGREG(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (1))
	
	#define LINK_OUT_WAIT1_BITNR					0		// 1: Blocks transfer of data at link out.	Flow control. No data loss. 
	#define LINK_OUT_WAIT2_BITNR					16
		
	#define SET_TRANSFER_SWITCH1_TO_NONE_BITNR	1 	// 1:	 When ongoing frame transfer is finished the changeover switch is locked. 
	#define SET_TRANSFER_SWITCH2_TO_NONE_BITNR	17 	// 		None of the inputs are active. Soft disable, No data loss. 
		
	#define NODE_OUT1_DISABLE_BITNR : integer		8	// 1: Node out input is disabled, and flushed. Aborts ongoing transfers immediately.
	#define NODE_OUT2_DISABLE_BITNR : integer		24	// No tlast flag is sent. Next message is appended to amputated message, so both are lost.
	
	#define NODE_IN1_FIFO_DISABLE_BITNR			9	// 1: node input FIFO is flushed.  Hard disable, Ongoing transfer is abored.  
	#define NODE_IN2_FIFO_DISABLE_BITNR			25 // No tlast flag is sent. Next message is appended to amputated message, so both are lost.			
	#define LINK1_2_IN_OUT_TRANSFER_DISABLE_BITNR	10	// 1: link transfer FIFO is flushed.  Ongoing transfer is aborted. No tlast flag is sent.
	#define LINK2_1_IN_OUT_TRANSFER_DISABLE_BITNR	26	//	Next message is appended to amputated message, so both are lost.

	#define FIFO1_INPUT_HANDSHAKE_BITNR			12	//’0’ No handshake. overwrites, flushes fifo. '1' pauses writing (tready handshake) 
	#define FIFO2_INPUT_HANDSHAKE_BITNR			28	// (The Aurora IP does not use tready handshake at its RX AXI stream interface.) 

	
 #define NODE_FIFO_FILL_LEVEL1_REGNR(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (2))  // Fill level of input fifo 
 #define NODE_FIFO_FILL_LEVEL2_REGNR(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (3))	 
 
 #define TRANSFER_FIFO_FILL_LEVEL_1_2_REGNR(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (4))  // Fill level of transfer fifo
 #define TRANSFER_FIFO_FILL_LEVEL_2_1_REGNR(BASEADDR)	*(volatile unsigned int*)(BASEADDR + 4* (5))   
 
