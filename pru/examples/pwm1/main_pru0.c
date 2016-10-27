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
#include "pwmParams.h"
#include "resource_table_pru1.h"

#define	INS_PER_US 200           // 5ns per instruction
#define INS_PER_DELAY_LOOP 2	 // two instructions per delay loop
// set up a 50ms delay
#define TIME 50 * 1000 * (INS_PER_US / INS_PER_DELAY_LOOP)

// The function is defined in pru1_asm_blinky.asm in same dir
// We just need to add a declaration here, the defination can be
// seperately linked
extern void start(int *RAM0);
volatile register unsigned int __R30;
volatile register unsigned int __R31;
int *RAM0  = (int *) pwmParams;
int i;
int time;

void main(void) {
    /* Clear SYSCFG[STANDBY_INIT] to enable OCP master port */
	CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

	__delay_cycles(TIME);
 	// start(TIME);
 	__delay_cycles(TIME);
 	
 	while(!(__R31&(1<<3))) {
		time = RAM0[0];		// on time
		for(i=0; i<time; i++) {
			__R30 |= 1<<5;
			// __delay_cycles must be passed a const, so we have to do our own loop
			// Must have something in loop, otherwise it optimized out.
		}
		time = RAM0[1];		// off time
		for(i=0; i<time; i++) {
			__R30 &= ~(1<<5);
		}
	}
	__delay_cycles(TIME);	// Give some time for press to release
	// Call assembly language
 	start(RAM0);
	__halt();
}

