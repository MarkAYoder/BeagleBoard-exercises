/* 
 *
 *  pwm tester
 *  (c) Copyright 2016
 *  Mark A. Yoder, 20-July-2016
 *
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "robotics_cape_defs.h"

#define PRU_ADDR		0x4A300000		// Start of PRU memory Page 184 am335x TRM
#define PRU_LEN			0x80000			// Length of PRU memory
#define PRU_SHAREDMEM	0x10000			// Offset to shared memory

unsigned int	*prusharedMem_32int_ptr;	// Points to the start of the shared memory

/*******************************************************************************
* int start_pwm_us(int ch, int period, int duty_cycle)
* 
* Starts a pwm pulse of period us (microseconds) to a single channel (ch)
* duty_cycle is the percent of on time (value between 0 and 100)
*******************************************************************************/
int start_pwm_us(int ch, int period, int duty_cycle) {
	// Sanity Checks
	if(ch<1 || ch>SERVO_CHANNELS){
		printf("ERROR: Servo Channel must be between 1&%d\n", SERVO_CHANNELS);
		return -1;
	} if(prusharedMem_32int_ptr == NULL){
		printf("ERROR: PRU servo Controller not initialized\n");
		return -1;
	}
	// PRU runs at 200Mhz. find #loops needed
	int onTime  = (period * duty_cycle)/100;
	unsigned int num_loopsOn = ((onTime*200.0)/PRU_PWM_LOOP_INSTRUCTIONS); 
	unsigned int num_loops   = ((period*200.0)/PRU_PWM_LOOP_INSTRUCTIONS); 
	printf("onTime: %d, period: %d, num_loopsOn: %d, num_LoopsOff: %d\n", 
		onTime, period, num_loopsOn, num_loops-num_loopsOn);
	// write to PRU shared memory
	prusharedMem_32int_ptr[2*(ch-1)+0] = num_loopsOn-1;			// On time
	prusharedMem_32int_ptr[2*(ch-1)+1] = num_loops-num_loopsOn;	// Off time
	return 0;
}

int main(int argc, char *argv[])
{
	unsigned int	*pru;		// Points to start of PRU memory.
	int	fd;
	printf("Servo tester\n");
	
	fd = open ("/dev/mem", O_RDWR | O_SYNC);
	if (fd == -1) {
		printf ("ERROR: could not open /dev/mem.\n\n");
		return 1;
	}
	pru = mmap (0, PRU_LEN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, PRU_ADDR);
	if (pru == MAP_FAILED) {
		printf ("ERROR: could not map memory.\n\n");
		return 1;
	}
	close(fd);
	printf ("Using /dev/mem.\n");
	
	prusharedMem_32int_ptr = pru + PRU_SHAREDMEM/4;	// Points to start of shared memory

	int i;
	for(i=1; i<=SERVO_CHANNELS; i++) {
		start_pwm_us(i, 10, 10*i);
	}
	
	if(munmap(pru, PRU_LEN)) {
		printf("munmap failed\n");
	} else {
		printf("munmap succeeded\n");
	}
}

