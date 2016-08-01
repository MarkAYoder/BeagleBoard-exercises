/*
 * Source Modified by Zubeen Tolani < ZeekHuge - zeekhuge@gmail.com >
 * Based on the examples distributed by TI
 *
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
#include <pru_cfg.h>
#include <pru_ctrl.h>
#include "resource_table_pru1.h"
#include <pru_intc.h>

// The function is defined in pru-pwm.asm in same dir
// We just need to add a declaration here, the defination can be
// seperately linked
extern void start(void);

volatile register uint32_t __R30;
volatile register uint32_t __R31;

// Initialize intrupts so the PRUs can be syncronized.
// PRU1 is started first and then waits for PRU0
// PRU0 is then started and tells PRU1 when to start going
void configIntc(void) {	
	__R31 = 0x00000000;					// Clear any pending PRU-generated events
	CT_INTC.CMR4_bit.CH_MAP_16 = 1;		// Map event 16 to channel 1
	CT_INTC.HMR0_bit.HINT_MAP_1 = 1;	// Map channel 1 to host 1
	CT_INTC.SICR = 16;					// Ensure event 16 is cleared
	CT_INTC.EISR = 16;					// Enable event 16
	CT_INTC.HIEISR |= (1 << 0);			// Enable Host interrupt 1
	CT_INTC.GER = 1; 					// Globally enable host interrupts
}

void main(void) {
	CT_CFG.GPCFG0 = 0x0000;				// Configure GPI and GPO as Mode 0 (Direct Connect)
	__R30 &= 0xFFFF0000;				// Clear GPO pins
	configIntc();						// Configure INTC

	CT_CFG.SYSCFG_bit.STANDBY_INIT = 0; // Clear SYSCFG[STANDBY_INIT] to enable OCP master port

	// Access PRU Shared RAM using Constant Table                    */
	// C28 defaults to 0x00000000, we need to set bits 23:8 to 0x0100 in order to have it point to 0x00010000	 */
	PRU0_CTRL.CTPPR0_bit.C28_BLK_POINTER = 0x0100;

	start();
}
