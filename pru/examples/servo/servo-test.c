/* 
 *
 *  servo tester
 *  (c) Copyright 2016
 *  Mark A. Yoder, 20-July-2016
 *
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
	unsigned int	*pru;
	int	fd;
	unsigned long	pruss_addr = 0x4A300000;		// Page 184 am335x TRM
	int pruss_len = 0x80000;

	printf("Servo tester\n");
	
	fd = open ("/dev/mem", O_RDWR | O_SYNC);
	if (fd == -1) {
		printf ("ERROR: could not open /dev/mem.\n\n");
		return 1;
	}
	pru = mmap (0, pruss_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, pruss_addr);
	if (pru == MAP_FAILED) {
		printf ("ERROR: could not map memory.\n\n");
		return 1;
	}
	close(fd);
	printf ("Using /dev/mem.\n");
	
	int addr = 0x10000;
	
	printf("Addr %x contains 0x%lx\n", addr, pru[addr/4]);

	// while(1) {
	// 	printf("value to store: ");
	// 	scanf("%d", &value);
	// 	printf("Storing: %d in %lx\n", value, addr);
	// 	pru[addr/4] = value;
	// }
	
	while(1) {
		// printf("Updating...");
		// fflush(stdout);
		pru[addr/4] = 0x100;
		usleep(25);
	}
	
	if(munmap(pru, pruss_len)) {
		printf("munmap failed\n");
	} else {
		printf("munmap succeeded\n");
	}
}

