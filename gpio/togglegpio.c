// Blink pin 60 at 1 Hz
//
//Created by Dingo_aus, 7 January 2009
//email: dingo_aus [at] internode <dot> on /dot/ net
// From http://www.avrfreaks.net/wiki/index.php/Documentation:Linux/GPIO#gpio_framework
//
//Created in AVR32 Studio (version 2.0.2) running on Ubuntu 8.04
// Modified by Mark A. Yoder, 21-July-2011
// Modified by Mark A. Yoder 30-May-2013

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include "gpio-utils.h"

int main(int argc, char** argv)
{
	//create a variable to store whether we are sending a '1' or a '0'
	char set_value[5]; 
	//Integer to keep track of whether we want on or off
	int toggle = 0;
	int onOffTime;	// Time in micro sec to keep the signal on/off
	int gpio = 60;
	int gpio_fd;

	if (argc < 2) {
		printf("Usage: %s <on/off time in us>\n\n", argv[0]);
		printf("Toggle gpio 60 at the period given\n");
		exit(-1);
	}
	onOffTime = atoi(argv[1]);

	printf("**********************************\n"
		"*  Welcome to PIN Blink program  *\n"
		"*  ....blinking gpio 60          *\n"
		"*  ....period of %d us.........*\n"
		"**********************************\n", 2*onOffTime);

	//Using sysfs we need to write the gpio number to /sys/class/gpio/export
	//This will create the folder /sys/class/gpio/gpio60
	gpio_export(gpio);

	printf("...export file accessed, new pin now accessible\n");
	
	//SET DIRECTION
	gpio_set_dir(gpio, "out");
	printf("...direction set to output\n");
			
	gpio_fd = gpio_fd_open(gpio, O_RDONLY);

	//Run an infinite loop - will require Ctrl-C to exit this program
	while(1)
	{
		toggle = !toggle;
		gpio_set_value(gpio, toggle);
//		printf("...value set to %d...\n", toggle);

		//Pause for a while
		usleep(onOffTime);
	}
	gpio_fd_close(gpio_fd);
	return 0;
}
