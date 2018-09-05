/*
 * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
 *
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the
 *    distribution.
 *
 *  * Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
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
#include "resource_table_empty.h"

volatile register uint32_t __R30;
volatile register uint32_t __R31;

// 5 ns cycle
#define ONE_MILLISECOND (ONE_MICROSECOND * 1000)
#define ONE_MICROSECOND 200
#define FIVE_HUNDRED_NANOSECONDS 100

#define P8_12 0x4000
#define P8_11 0x8000
#define false 0
#define true 1
void main(void)
{
    volatile uint32_t gpio_in;
    int loopcount, req_count, done, microsecond_time;

    /* Clear SYSCFG[STANDBY_INIT] to enable OCP master port */
    CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

    loopcount = 0;
    microsecond_time = 25 - 1; // 0 based
    req_count = microsecond_time;  // convertusec to usec
    done = false;

    /* TODO: Create stop condition, else it will toggle indefinitely */
    while (!done)
    {
        //  output a pulse until signalled to stop or max time reached
        __R30 = P8_12;  // pr1_pru0_pru_r30_14 = P8_12

        while (loopcount < req_count)
        {
            // __delay_cycles(ONE_MICROSECOND);  // SANDRA, keep this here, remove lower delay for real code - just for measurement
            gpio_in = __R31;
            if (gpio_in != 0)
            {
                // signal the world that we see the int
                 __R30 = P8_11;  // pr1_pru0_pru_r30_15 - set acknowledge we are done
                __delay_cycles(ONE_MICROSECOND);
                __R30 = 0;
                done = true;
                break;
            }
            loopcount++;
            __delay_cycles(ONE_MICROSECOND);  // SANDRA remove this line
        }

        if (!done)
        {
            __R30 = 0;
            __delay_cycles(ONE_MICROSECOND * 10); // 10 usec
            loopcount = 0;
        }
    }
    __halt();
    return;
}
