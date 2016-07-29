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

int pwm_enable(int mask) {
	prusharedMem_32int_ptr[PRU_ENABLE/4] = mask;
}

/*******************************************************************************
* int start_pwm_us(int ch, int period, int duty_cycle)
* 
* Starts a pwm pulse of period us (microseconds) to a single channel (ch)
* duty_cycle is the percent of on time (value between 0 and 100)
*******************************************************************************/
int start_pwm_us(int ch, int period, int duty_cycle) {
	// Sanity Checks
	if(ch<0 || ch>=SERVO_CHANNELS){
		printf("ERROR: Servo Channel must be between 1&%d\n", SERVO_CHANNELS);
		return -1;
	} if(prusharedMem_32int_ptr == NULL){
		printf("ERROR: PRU servo Controller not initialized\n");
		return -1;
	}
	// PRU runs at 200Mhz. find #loops needed
	int onTime  = (period * duty_cycle)/100;
	unsigned int countOn = ((onTime*200.0)/PRU_PWM_LOOP_INSTRUCTIONS); 
	unsigned int count   = ((period*200.0)/PRU_PWM_LOOP_INSTRUCTIONS); 
	printf("onTime: %d, period: %d, countOn: %d, countOff: %d, count: %d\n", 
		onTime, period, countOn, count-countOn, count);
	// write to PRU shared memory
	prusharedMem_32int_ptr[2*(ch)+0] = countOn;		// On time
	prusharedMem_32int_ptr[2*(ch)+1] = count-countOn;	// Off time
	return 0;
}

/*******************************************************************************
* int start_pwm_count(int ch, int countOn, int countOff)
* 
* Starts a pwm pulse on for countOn and off for countOff to a single channel (ch)
*******************************************************************************/
int start_pwm_count(int ch, int countOn, int countOff) {
	// Sanity Checks
	if(ch<0 || ch>=SERVO_CHANNELS){
		printf("ERROR: Servo Channel must be between 1&%d\n", SERVO_CHANNELS);
		return -1;
	} if(prusharedMem_32int_ptr == NULL){
		printf("ERROR: PRU servo Controller not initialized\n");
		return -1;
	}
	printf("countOn: %d, countOff: %d, count: %d\n", 
		countOn, countOff, countOn+countOff);
	// write to PRU shared memory
	prusharedMem_32int_ptr[2*(ch)+0] = countOn;	// On time
	prusharedMem_32int_ptr[2*(ch)+1] = countOff;	// Off time
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
	for(i=0; i<SERVO_CHANNELS; i++) {
		start_pwm_us(i, 1000, 5*(i+1));
	}

	// int period=1000;
	// start_pwm_us(0, 1*period, 10);
	// start_pwm_us(1, 2*period, 10);
	// start_pwm_us(2, 4*period, 10);
	// start_pwm_us(3, 8*period, 10);
	// start_pwm_us(4, 1*period, 10);
	// start_pwm_us(5, 2*period, 10);
	// start_pwm_us(6, 4*period, 10);
	// start_pwm_us(7, 8*period, 10);
	// start_pwm_us(8, 1*period, 10);
	// start_pwm_us(9, 2*period, 10);
	// start_pwm_us(10, 4*period, 10);
	// start_pwm_us(11, 8*period, 10);
	
	// int i;
	// for(i=0; i<SERVO_CHANNELS; i++) {
	// 	start_pwm_count(i, i+1, 10-(i+1));
	// }
	
	// start_pwm_count(0, 1, 1);
	// start_pwm_count(1, 2, 2);
	// start_pwm_count(2, 10, 30);
	// start_pwm_count(3, 30, 10);
	// start_pwm_count(4, 1, 1);
	// start_pwm_count(5, 10, 10);
	// start_pwm_count(6, 20, 30);
	// start_pwm_count(7, 30, 20);
	
	// for(i=0; i<24; i++) {
	// 	int mask = 1 << (i%12);
	// 	printf("Mask: %x\n", mask);
	// 	pwm_enable(mask);
	// 	usleep(500000);
	// }
	
	pwm_enable(0xfff);
	
	if(munmap(pru, PRU_LEN)) {
		printf("munmap failed\n");
	} else {
		printf("munmap succeeded\n");
	}
}

