#include "mmapgpio.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

GPIO_MMAP::GPIO_MMAP(uint8_t gpioBank) {
  int fd = open("/dev/mem", O_RDWR | O_SYNC);

  if (fd < 0) {
    printf("Could not open GPIO memory fd\n");
    exit(1);
  }

  switch(gpioBank) {
    case 0:
       value = (unsigned long *)mmap(NULL, 0xFFF, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_BANK_0);
       break;
    case 1:
       value = (unsigned long *) mmap(NULL, 0xFFF, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_BANK_1);
       break;
    case 2:
       value = (unsigned long *) mmap(NULL, 0xFFF, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_BANK_2);
       break;
    case 3:
       value = (unsigned long *) mmap(NULL, 0xFFF, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_BANK_3);
       break;
  }
  
  if (value == MAP_FAILED) {
    printf("GPIO mapping failed\n");
    close(fd);
    exit(1);
  }
  
  close(fd);
}

GPIO_MMAP::~GPIO_MMAP() {
  delete value;
}

uint8_t GPIO_MMAP::read(uint8_t gpioNum) {
  return value[GPIO_DATAIN/4] & (1 << gpioNum);
}

void GPIO_MMAP::write(uint8_t gpioNum, uint8_t out) {
  if (out == 1) {
    value[GPIO_DATAOUT/4] |= (1 << gpioNum);
  } else {
    value[GPIO_DATAOUT/4] &= ~(1 << gpioNum);
  }
}  
