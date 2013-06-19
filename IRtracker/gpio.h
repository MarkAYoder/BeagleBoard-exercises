#ifndef GPIO_H
#define GPIO_H

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#define SYSFS_GPIO_DIR "/sys/class/gpio"
#define MAX_BUF 64

/****************************************************************
* gpio_export
****************************************************************/
int gpio_export(unsigned int gpio)
{
	int fd, len;
	char buf[MAX_BUF];
 
	fd = open(SYSFS_GPIO_DIR "/export", O_WRONLY);
	if (fd < 0) 
	{
		perror("gpio/export");
		return fd;
	}
 
	len = snprintf(buf, sizeof(buf), "%d", gpio);
	write(fd, buf, len);
	close(fd);
 
	return 0;
}

/****************************************************************
* gpio_unexport
****************************************************************/
int gpio_unexport(unsigned int gpio)
{
	int fd, len;
	char buf[MAX_BUF];
 
	fd = open(SYSFS_GPIO_DIR "/unexport", O_WRONLY);
	if (fd < 0) 
	{
		perror("gpio/unexport");
		return fd;
	}
 
	len = snprintf(buf, sizeof(buf), "%d", gpio);
	write(fd, buf, len);
	close(fd);
	return 0;
}

/****************************************************************
* gpio_set_direction
****************************************************************/
int gpio_set_direction (unsigned int gpio, unsigned int ioFlag)
{
	int fd, len;
	char buf[MAX_BUF];
 
	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/direction", gpio);
 
	fd = open(buf, O_WRONLY);
	if (fd < 0) 
	{
		perror("gpio/direction");
		return fd;
	}
 
	if (ioFlag)	//0 for input, 1 for output
		write(fd, "out", 4);
	else
		write(fd, "in", 3);
 
	close(fd);
	return 0;
}

/****************************************************************
* gpio_set_value
****************************************************************/
int gpio_set_value(unsigned int gpio, unsigned int value)
{
	int fd, len;
	char buf[MAX_BUF];
 
	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);
 
	fd = open(buf, O_WRONLY);
	if (fd < 0) 
	{
		perror("gpio/set-value");
		return fd;
	}
 
	if (value)
		write(fd, "1", 2);
	else
		write(fd, "0", 2);
 
	close(fd);
	return 0;
}

/****************************************************************
* gpio_get_value
****************************************************************/
int gpio_get_value(unsigned int gpio, unsigned int *value)
{
	int fd, len;
	char buf[MAX_BUF];
	char ch;

	len = snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);
	 
	fd = open(buf, O_RDONLY);
	if (fd < 0) 
	{
		perror("gpio/get-value");
		return fd;
	}
 
	read(fd, &ch, 1);
		
	if (ch != '0') 
		*value = 1;
	else
		*value = 0;
 
	close(fd);
	return 0;
}

#endif
