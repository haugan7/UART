/*
 * Empty C++ Application
 */

#include "xil_printf.h"
#include "stdlib.h"


#define SUCCESS 0

int sw_counter = 0;

int main(void){


	xil_printf("Hello from AVNET picozed!\r\n");
	xil_printf("-------------------------!\r\n");
	while(true){
		sw_counter = sw_counter + 1;
		xil_printf("counter :: %i\r\n", sw_counter);
	}

	xil_printf("This will never print!\r\n");
	return SUCCESS;
}
