/* 
 *
 *  pwm tester
 *  (c) Copyright 2016
 *  Mark A. Yoder, 21-Oct-2016
 *	The period and duty cycle values are stored in each PRU's Data memory
 *
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>

#define PRU_ADDR		0x4A300000		// Start of PRU memory Page 184 am335x TRM
#define PRU_LEN			0x80000			// Length of PRU memory
#define PRU0_DRAM		0x00000			// Offset to DRAM
#define PRU1_DRAM		0x02000
#define PRU_SHAREDMEM	0x10000			// Offset to shared memory

unsigned int	*pru0DRAM_32int_ptr;		// Points to the start of local DRAM
unsigned int	*pru1DRAM_32int_ptr;		// Points to the start of local DRAM
unsigned int	*prusharedMem_32int_ptr;	// Points to the start of the shared memory

int main(int argc, char *argv[])
{
	unsigned int	*pru;		// Points to start of PRU memory.
	int	fd;
	int onCount  = 10000000;		// Default 'on' count
	int offCount = 10000000;
	if(argc==3) {
		onCount  = strtol(argv[1], NULL, 10);
		offCount = strtol(argv[2], NULL, 10);
	}
	printf("pwm tester: %d, %d\n", onCount, offCount);
	
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
	
	pru0DRAM_32int_ptr =     pru + PRU0_DRAM/4 + 0x200/4;	// Points to 0x200 of PRU0 memory
	pru1DRAM_32int_ptr =     pru + PRU1_DRAM/4 + 0x200/4;	// Points to 0x200 of PRU1 memory
	prusharedMem_32int_ptr = pru + PRU_SHAREDMEM/4;	// Points to start of shared memory

	int ch =0;		// We only have channel 0
	pru0DRAM_32int_ptr[2*(ch)+0] = onCount;		// On time
	pru0DRAM_32int_ptr[2*(ch)+1] = offCount;	// Off time

	if(munmap(pru, PRU_LEN)) {
		printf("munmap failed\n");
	} else {
		printf("munmap succeeded\n");
	}
}

