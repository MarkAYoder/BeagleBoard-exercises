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
#include <stdio.h>
#include <pru_cfg.h>
#include <pru_intc.h>
#include <rsc_types.h>
#include <pru_virtqueue.h>
#include <pru_rpmsg.h>
#include <pru_ctrl.h>
#include "resource_table_1.h"


volatile register uint32_t __R31;

/* Host-1 Interrupt sets bit 31 in register R31 */
#define HOST_INT				((uint32_t) 1 << 31)	

/* The PRU-ICSS system events used for RPMsg are defined in the Linux device tree
 * PRU0 uses system event 16 (To ARM) and 17 (From ARM)
 * PRU1 uses system event 18 (To ARM) and 19 (From ARM)
 */
#define TO_ARM_HOST				18	
#define FROM_ARM_HOST			19

/*
 * Using the name 'rpmsg-pru' will probe the rpmsg_pru driver found
 * at linux-x.y.z/drivers/rpmsg/rpmsg_pru.c
 */
#define CHAN_NAME					"rpmsg-pru"
#define CHAN_DESC					"Channel 31"
#define CHAN_PORT					31

/*
 * Used to make sure the Linux drivers are ready for RPMsg communication
 * Found at linux-x.y.z/include/uapi/linux/virtio_config.h
 */
#define VIRTIO_CONFIG_S_DRIVER_OK	4

 /*
 * Used to check the state of 0 bit of the r31 ie
 * the state of pr1_pru1_pru_r31_0. This gpio can be 
 * muxed to P8_45.
 */
#define CHECK_BIT	0x0001

uint8_t payload[RPMSG_BUF_SIZE];

/*
 * main.c
 */
void main(void)
{
	struct pru_rpmsg_transport transport;
	uint16_t src, dst, len;
	uint32_t prev_gpio_state;
	volatile uint8_t *status;

#define MAXPRINT	80
	char str[MAXPRINT];		// Used in snprintf

	/* allow OCP master port access by the PRU so the PRU can read external memories */
	CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;

	/* clear the status of the PRU-ICSS system event that the ARM will use to 'kick' us */
	CT_INTC.SICR_bit.STS_CLR_IDX = FROM_ARM_HOST;

	/* Make sure the Linux drivers are ready for RPMsg communication */
	status = &resourceTable.rpmsg_vdev.status;
	while (!(*status & VIRTIO_CONFIG_S_DRIVER_OK));

	/* Initialize pru_virtqueue corresponding to vring0 (PRU to ARM Host direction) */
	pru_virtqueue_init(&transport.virtqueue0, &resourceTable.rpmsg_vring0, TO_ARM_HOST, FROM_ARM_HOST);

	/* Initialize pru_virtqueue corresponding to vring1 (ARM Host to PRU direction) */
	pru_virtqueue_init(&transport.virtqueue1, &resourceTable.rpmsg_vring1, TO_ARM_HOST, FROM_ARM_HOST);

	/* Create the RPMsg channel between the PRU and ARM user space using the transport structure. */
	while (pru_rpmsg_channel(RPMSG_NS_CREATE, &transport, CHAN_NAME, CHAN_DESC, CHAN_PORT) != PRU_RPMSG_SUCCESS);
	
	while (1) {
		/* Check bit 30 of register R31 to see if the ARM has kicked us */
		if (__R31 & HOST_INT) {
			/* Clear the event status */
			CT_INTC.SICR_bit.STS_CLR_IDX = FROM_ARM_HOST;
			/* Receive all available messages, multiple messages can be sent per kick */
			while (pru_rpmsg_receive(&transport, &src, &dst, payload, &len) == PRU_RPMSG_SUCCESS) {	
				// Start counter
				PRU1_CTRL.CTRL_bit.CTR_EN = 1;
				while(1)
					if ((__R31 ^ prev_gpio_state) & CHECK_BIT) {
						prev_gpio_state = __R31 & CHECK_BIT;
						snprintf(str, MAXPRINT, "payload: %s, len: %d, cycle: %d, stall: %d, enable: %d\n", 
							payload, len, PRU1_CTRL.CYCLE, PRU1_CTRL.STALL, PRU1_CTRL.CTRL_bit.CTR_EN);
						pru_rpmsg_send(&transport, dst, src, str, sizeof(str));
						if(PRU1_CTRL.CYCLE == 0xffffffff) {  // Counter doesn't wrap.  Reset when at max.
							snprintf(str, MAXPRINT, "Max counter, enable: %d\n", PRU1_CTRL.CTRL_bit.CTR_EN );
							pru_rpmsg_send(&transport, dst, src, str, sizeof(str));
							PRU1_CTRL.CYCLE = 0;
							PRU1_CTRL.CTRL_bit.CTR_EN = 1;
						}
						// pru_rpmsg_send(&transport, dst, src, "CHANGED\n", sizeof("CHANGED\n"));
					}		
			}
		}
	}
}


