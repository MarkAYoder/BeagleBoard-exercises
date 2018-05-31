/*
 * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
 *
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *	* Redistributions of source code must retain the above copyright
 *	  notice, this list of conditions and the following disclaimer.
 *
 *	* Redistributions in binary form must reproduce the above copyright
 *	  notice, this list of conditions and the following disclaimer in the
 *	  documentation and/or other materials provided with the
 *	  distribution.
 *
 *	* Neither the name of Texas Instruments Incorporated nor the names of
 *	  its contributors may be used to endorse or promote products derived
 *	  from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdint.h>
#include <pru_uart.h>
#include "resource_table_empty.h"

/* The FIFO size on the PRU UART is 16 bytes; however, we are (arbitrarily)
 * only going to send 8 at a time */
#define FIFO_SIZE	16
#define MAX_CHARS	8

/* This hostBuffer structure is temporary but stores a data buffer */
struct {
	uint8_t msg; // Not used today
	uint8_t data[FIFO_SIZE];
} hostBuffer;

/* Making this buffer global will force the received data into memory */
uint8_t buffer[MAX_CHARS];

void main(void)
{
	uint8_t tx;
	uint8_t cnt;

	/* TODO: If modifying this to send data through the pins then PinMuxing
	 * needs to be taken care of prior to running this code.
	 * This is usually done via a GEL file in CCS or by the Linux driver */


	/*** INITIALIZATION ***/

	/* Set up UART to function at 115200 baud - DLL divisor is 104 at 16x oversample
	 * 192MHz / 104 / 16 = ~115200 */
	CT_UART.DLL = 104;
	CT_UART.DLH = 0;
	CT_UART.MDR = 0x0;

	/* Enable Interrupts in UART module. This allows the main thread to poll for
	 * Receive Data Available and Transmit Holding Register Empty */
	CT_UART.IER = 0x7;

	/* If FIFOs are to be used, select desired trigger level and enable
	 * FIFOs by writing to FCR. FIFOEN bit in FCR must be set first before
	 * other bits are configured */
	/* Enable FIFOs for now at 1-byte, and flush them */
	CT_UART.FCR = (0x8) | (0x4) | (0x2) | (0x1);
	//CT_UART.FCR = (0x80) | (0x4) | (0x2) | (0x01); // 8-byte RX FIFO trigger

	/* Choose desired protocol settings by writing to LCR */
	/* 8-bit word, 1 stop bit, no parity, no break control and no divisor latch */
	CT_UART.LCR = 3;

	/* Enable loopback for test */
	CT_UART.MCR = 0x10;
	CT_UART.MCR = 0x00;

	/* Choose desired response to emulation suspend events by configuring
	 * FREE bit and enable UART by setting UTRST and URRST in PWREMU_MGMT */
	/* Allow UART to run free, enable UART TX/RX */
	CT_UART.PWREMU_MGMT = 0x6001;

	/*** END INITIALIZATION ***/

	/* Priming the 'hostbuffer' with a message */
	hostBuffer.data[0] = 'H';
	hostBuffer.data[1] = 'e';
	hostBuffer.data[2] = 'l';
	hostBuffer.data[3] = 'l';
	hostBuffer.data[4] = 'o';
	hostBuffer.data[5] = '!';
	hostBuffer.data[6] = '\0';

	/*** SEND SOME DATA ***/

	/* Let's send/receive some dummy data */
	while(1) {
		for (cnt = 0; cnt < MAX_CHARS; cnt++) {
			/* Load character, ensure it is not string termination */
			if ((tx = hostBuffer.data[cnt]) == '\0')
				break;
			CT_UART.THR = tx;
	
			/* Because we are doing loopback, wait until LSR.DR == 1
			 * indicating there is data in the RX FIFO */
			// while ((CT_UART.LSR & 0x1) == 0x0);
	
			// /* Read the value from RBR */
			// buffer[cnt] = CT_UART.RBR;
	
			/* Wait for TX FIFO to be empty */
			while (!((CT_UART.FCR & 0x2) == 0x2));
		}
	}

	/*** DONE SENDING DATA ***/

	/* Disable UART before halting */
	CT_UART.PWREMU_MGMT = 0x0;

	/* Halt PRU core */
	__halt();
}
