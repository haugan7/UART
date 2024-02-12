//*****************************************************************************
//  AXI_S chain_link switch 
//
//  Author: Kjell Ljøkelsøy Sintef Energy.  2016. 
//*****************************************************************************/


#include "axi_s_chain_link_switch_registers.h"
/*
#include "wait.h"

#define LOOP_COUNT_MAX 100;
*/

//-*********************************************************************************************************
// This routine disables transfer of AXI stream frames from one link to the next. 
// Transfers to and from local links are still enabled. 
/*
void Axi_s_chain_link_transfer_disable(void)
	{

	#note "Finish and test this" 
		
	int switches_idle; 
	int loop_count 
	AXI_S_CHAIN_LINK_SWITCH_CONFIGREG(BASEADDR) =  (1<< SET_TRANSFER_SWITCH1_TO_NONE_BITNR) |  (1<< SET_TRANSFER_SWITCH2_TO_NONE_BITNR)	;
	
	do --  Wait until switches are idle, in order not to amputate transfers.
		{
		uwait(1);  	
		switches_idle = (AXI_S_APPEND_SWITCH_STATUSREG(BASEADDR);
		switches_idle = switches_idle &  & ((1<< ACTIVE_TRANSFER_SWITCH1_BITNR) |  (1<< ACTIVE_TRANSFER_SWITCH2_BITNR));
		loop_count ++;
		if (loop_count => LOOP_COUNT_MAX) 
			{
			break; -- Forced out if switch is stuck. 
			}					
		}
	while (switches_idle != 0); 
	-- flushes fifo.
	
 	AXI_S_CHAIN_LINK_SWITCH_CONFIGREG(BASEADDR) =  1<< LINK1_2_IN_OUT_TRANSFER_DISABLE_BITNR) |  (1<< LINK2_1_IN_OUT_TRANSFER_DISABLE_BITNR)	
			|  (1<< SET_TRANSFER_SWITCH1_TO_NONE_BITNR) |  (1<< SET_TRANSFER_SWITCH2_TO_NONE_BITNR); 
	-- 	enables changeover again.	
		AXI_S_CHAIN_LINK_CONFIGREG(BASEADDR) =  1<< LINK1_2_IN_OUT_TRANSFER_DISABLE_BITNR) |  (1<< LINK2_1_IN_OUT_TRANSFER_DISABLE_BITNR);	
	
	}
*/
//-*********************************************************************************************************
// This routine enables transfer of AXI stream frames from one link to the next.  Transfers to and from local links are also enabled. 
/*
void Axi_s_chain_link_transfer_enable(void)
	{
	AXI_S_CHAIN_LINK_SWITCH_CONFIGREG(BASEADDR) = 0	;
	}	
*/

//-*********************************************************************************************************