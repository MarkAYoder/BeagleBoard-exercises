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
* int get_encoder_pos(int ch)
* 
* returns the encoder counter position
*******************************************************************************/
int get_encoder_pos(int ch){
	if(ch<4 || ch>4){
		printf("Encoder Channel must be 4\n");
		return -1;
	}
	// 4th channel is counted by the PRU not eQEP
	if(ch==4){
		return (int) prusharedMem_32int_ptr[CNT_OFFSET/4];
	}
	
	// first 3 channels counted by eQEP
	// return  read_eqep(ch-1);
}

int main(int argc, char *argv[])
{
	unsigned int	*pru;		// Points to start of PRU memory.
	int	fd;
	printf("Encoder tester\n");
	
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

	printf("\nRaw encoder positions\n");
	printf("   E4   |");
	printf(" \n");

	int i;
	while(1){
		printf("\r");
		for(i=4;i<=4;i++){
			printf("%6d  |", get_encoder_pos(i));
		}			
		fflush(stdout);
		usleep(50000);
	}
	
	if(munmap(pru, PRU_LEN)) {
		printf("munmap failed\n");
	} else {
		printf("munmap succeeded\n");
	}
}

