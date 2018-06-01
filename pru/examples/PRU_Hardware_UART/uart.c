// From: http://git.ti.com/pru-software-support-package/pru-software-support-package/trees/master/pru_cape/pru_fw/PRU_Hardware_UART

#include <stdint.h>
#include <pru_uart.h>
#include "resource_table_empty.h"

/* The FIFO size on the PRU UART is 16 bytes; however, we are (arbitrarily)
 * only going to send 8 at a time */
#define FIFO_SIZE	16
#define MAX_CHARS	8
#define BUFFER		40

//******************************************************************************
//    Print Message Out
//      This function take in a string literal of any size and then fill the
//      TX FIFO when it's empty and waits until there is info in the RX FIFO
//      before returning.
//******************************************************************************
void PrintMessageOut(volatile char* Message)
{
	uint8_t cnt, index = 0;

	while (1) {
		cnt = 0;

		/* Wait until the TX FIFO and the TX SR are completely empty */
		while (!CT_UART.LSR_bit.TEMT);

		while (Message[index] != NULL && cnt < MAX_CHARS) {
			CT_UART.THR = Message[index];
			index++;
			cnt++;
		}
		if (Message[index] == NULL)
			break;
	}

	/* Wait until the TX FIFO and the TX SR are completely empty */
	while (!CT_UART.LSR_bit.TEMT);

}

//******************************************************************************
//    IEP Timer Config
//      This function waits until there is info in the RX FIFO and then returns
//      the first character entered.
//******************************************************************************
char ReadMessageIn(void)
{
	while (!CT_UART.LSR_bit.DR);

	return CT_UART.RBR_bit.DATA;
}

void main(void)
{
	uint32_t i;
	volatile uint32_t not_done = 1;

	char rxBuffer[BUFFER];
	rxBuffer[BUFFER-1] = NULL; // null terminate the string

	/*** INITIALIZATION ***/

	/* Set up UART to function at 115200 baud - DLL divisor is 104 at 16x oversample
	 * 192MHz / 104 / 16 = ~115200 */
	CT_UART.DLL = 104;
	CT_UART.DLH = 0;
	CT_UART.MDR_bit.OSM_SEL = 0x0;

	/* Enable Interrupts in UART module. This allows the main thread to poll for
	 * Receive Data Available and Transmit Holding Register Empty */
	CT_UART.IER = 0x7;

	/* If FIFOs are to be used, select desired trigger level and enable
	 * FIFOs by writing to FCR. FIFOEN bit in FCR must be set first before
	 * other bits are configured */
	/* Enable FIFOs for now at 1-byte, and flush them */
	CT_UART.FCR = (0x80) | (0x8) | (0x4) | (0x2) | (0x01); // 8-byte RX FIFO trigger

	/* Choose desired protocol settings by writing to LCR */
	/* 8-bit word, 1 stop bit, no parity, no break control and no divisor latch */
	CT_UART.LCR = 3;

	/* If flow control is desired write appropriate values to MCR. */
	/* No flow control for now, but enable loopback for test */
	CT_UART.MCR = 0x00;

	/* Choose desired response to emulation suspend events by configuring
	 * FREE bit and enable UART by setting UTRST and URRST in PWREMU_MGMT */
	/* Allow UART to run free, enable UART TX/RX */
	CT_UART.PWREMU_MGMT_bit.FREE = 0x1;
	CT_UART.PWREMU_MGMT_bit.URRST = 0x1;
	CT_UART.PWREMU_MGMT_bit.UTRST = 0x1;

	/* Turn off RTS and CTS functionality */
	CT_UART.MCR_bit.AFE = 0x0;
	CT_UART.MCR_bit.RTS = 0x0;

	/*** END INITIALIZATION ***/

	while(1) {
		/* Print out greeting message */
		PrintMessageOut("Hello you are in the PRU UART demo test please enter some characters\r\n");
	
		/* Read in 5 characters from user, then echo them back out */
		for (i = 0; i < BUFFER-1 ; i++) {
			rxBuffer[i] = ReadMessageIn();
			if(rxBuffer[i] == '\r') {	// Quit early if ENTER is hit.
				rxBuffer[i+1] = NULL;
				break;
			}
		}
	
		PrintMessageOut("you typed:\r\n");
		PrintMessageOut(rxBuffer);
		PrintMessageOut("\r\n");
	}

	/*** DONE SENDING DATA ***/
	/* Disable UART before halting */
	CT_UART.PWREMU_MGMT = 0x0;

	/* Halt PRU core */
	__halt();
}
