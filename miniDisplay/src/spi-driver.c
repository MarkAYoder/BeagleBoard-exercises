#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>
#include <stdbool.h>
#include <math.h>
#include "spi-driver.h"

#define pabort(s) {perror(s); abort();}

static char *device;
static uint8_t mode = -1;
static uint8_t bits = -1;
static uint32_t speed = -1;
static int fd;

int SPIInit(int devNo, int bpw, int speedl) {
    if (devNo < 0 || bpw < 1 || speedl < 0)
        return SPI_INVALID_PARAMETER;

    static char k[128];
    int ret = 0;
    speed = speedl;
    bits = bpw;
    mode = 0;
    memset(k, 0, 128);

    sprintf(k, "/dev/spidev1.%i", devNo);
    if (access(k, F_OK) != -1)
        device = k;
    else
        return SPI_INVALID_DEVICE;

    fd = open(device, O_RDWR);
    if (fd < 0)
        return SPI_DEVICE_ACCESS_ERROR;

    // Configure SPI Mode
    ret = ioctl(fd, SPI_IOC_WR_MODE, &mode);
    if (ret == -1)
        return SPI_MODE_SET_ERROR;

    /*
     * bits per word
     */
    ret = ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits);
    if (ret == -1)
        return SPI_BITS_SET_ERROR;

    /*
     * max speed hz
     */
    ret = ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);
    if (ret == -1)
        return SPI_SPEED_SET_ERROR;

    return 0;
}

int SPIWriteWord(void *data)
{
    int i = write(fd, data, (int)ceil(bits / 8.0));
    if (i == -1)
        return SPI_WRITE_ERROR;

    return 0;
}

int SPIWriteChunk(void *data, int count)
{

   int i = write(fd, data, count);
   if(i == -1)
	  return SPI_WRITE_ERROR;

   return 0;
}
