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

#define SYSFS_GPIO_DIR "/sys/class/gpio"

FILE *fp; 

int main(int argc, char** argv)
{
	//create a variable to store whether we are sending a '1' or a '0'
	char set_value[5]; 
	//Integer to keep track of whether we want on or off
	int toggle = 0;
	int onOffTime;	// Time in micro sec to keep the signal on/off

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
	if ((fp = fopen(SYSFS_GPIO_DIR "/export", "ab")) == NULL)
		{
			printf("Cannot open export file.\n");
			exit(1);
		}
	//Set pointer to begining of the file
		rewind(fp);
		//Write our value of "60" to the file
		strcpy(set_value,"60");
		fwrite(&set_value, sizeof(char), 3, fp);
		fclose(fp);
	
	printf("...export file accessed, new pin now accessible\n");
	
	//SET DIRECTION
	//Open the LED's sysfs file in binary for reading and writing, store file pointer in fp
	if ((fp = fopen(SYSFS_GPIO_DIR "/gpio60/direction", "rb+")) == NULL)
	{
		printf("Cannot open direction file.\n");
		exit(1);
	}
	//Set pointer to begining of the file
	rewind(fp);
	//Write our value of "out" to the file
	strcpy(set_value,"out");
	fwrite(&set_value, sizeof(char), 3, fp);
	fclose(fp);
	printf("...direction set to output\n");
			
	if ((fp = fopen(SYSFS_GPIO_DIR "/gpio60/value", "rb+")) == NULL)
	{
		printf("Cannot open value file.\n");
		exit(1);
	}
	//Run an infinite loop - will require Ctrl-C to exit this program
	while(1)
	{
		toggle = !toggle;
		if(toggle)
		{
			//Set pointer to begining of the file
			rewind(fp);
			//Write our value of "1" to the file 
			strcpy(set_value,"1");
			fwrite(&set_value, sizeof(char), 1, fp);
			fflush(fp);
//			printf("...value set to 1...\n");
		}
		else
		{
			//Set pointer to begining of the file
			rewind(fp);
			//Write our value of "0" to the file 
			strcpy(set_value,"0");
			fwrite(&set_value, sizeof(char), 1, fp);
			fflush(fp);
//			printf("...value set to 0...\n");
		}
		//Pause for a while
		usleep(onOffTime);
	}
	fclose(fp);
	return 0;
}
