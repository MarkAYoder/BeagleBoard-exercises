#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <signal.h> // Defines signal-handling functions (i.e. trap Ctrl-C)
#include "gpio.h"

#define PIN_MUX_PATH "/sys/kernel/debug/omap_mux/"
#define MAX_BUF 64

/****************************************************************
* Global variables
****************************************************************/
int keepgoing = 1;	// Set to 0 when ctrl-c is pressed
unsigned int controller[4] = {30, 31, 48, 5};	//number of gpios to be used for driving the motor

/****************************************************************
* signal_handler
****************************************************************/
// Callback executed when SIGINT is sent to the process (Ctrl-C)
void signal_handler(int sig)
{
	int i;
	printf( "Ctrl-C pressed, cleaning up and exiting..\n" );
	keepgoing = 0;
	//Unxport gpios
	for (i = 0; i < 4; i++){
		gpio_unexport(controller[i]);
	}
}

/****************************************************************
* Set the mode to gpio output
****************************************************************/
int mode_gpio_out(char *pinMux)
{
	int fd, len;
	char buf[MAX_BUF];
 
	len = snprintf(buf, sizeof(buf), PIN_MUX_PATH "%s", pinMux);
 
	fd = open(buf, O_WRONLY);
	if (fd < 0) 
	{
		perror("mode/gpio");
		return fd;
	}
 
	write(fd, "7", 2);	//'7' means %000111, e.g. mode 7(gpio), pull enabcontroller, pull down, output
 
	close(fd);
	return 0;
}

/****************************************************************
* analog input
****************************************************************/
int analogIn(char *ain)
{
	FILE *fp;
	char ainPath[MAX_BUF];
	char ainVal[MAX_BUF];
	
	snprintf(ainPath, sizeof ainPath, "/sys/devices/platform/omap/tsc/%s", ain);

	if((fp = fopen(ainPath, "r")) == NULL){
	printf("Can't open this pin, %s\n", ain);
	return 1;
	}

	fgets(ainVal, MAX_BUF, fp);

	fclose(fp);
	return atoi(ainVal);		
}

/****************************************************************
* Initialize IO
****************************************************************/
void initIO(){
	char gpio30[] = "gpmc_wait0";
	char gpio31[] = "gpmc_wpn";
	char gpio48[] = "gpmc_a0";
	char gpio5[] = "spi0_cs0";

	int i;

	//Set pin mux in gpio output mode for controllers
	mode_gpio_out(gpio30);
	mode_gpio_out(gpio31);
	mode_gpio_out(gpio48);
	mode_gpio_out(gpio5);

	//Export gpios and set up output direction for controllers
	for (i = 0; i < 4; i++){
		gpio_export(controller[i]);
		gpio_set_direction(controller[i], 1);
	}
	
}

/****************************************************************
* Delay Function
****************************************************************/
void delay (unsigned int loops)
{
	int i, j;
	for (i = 0; i < loops; i++)
		for (j = 0; j < 50000; j++);
}

/****************************************************************
* Clockwise Rotate
****************************************************************/
void cRotate (int *pos){
	//Use a 4 state position to decide how to rotate
	switch (*pos){
		case 0:
			gpio_set_value(controller[0], 0);
			gpio_set_value(controller[1], 1);
			gpio_set_value(controller[2], 1);
			gpio_set_value(controller[3], 0);
			break;
		case 1:
			gpio_set_value(controller[0], 1);
			gpio_set_value(controller[1], 1);	
			gpio_set_value(controller[2], 0);
			gpio_set_value(controller[3], 0);
			break;
		case 2:
			gpio_set_value(controller[0], 1);
			gpio_set_value(controller[1], 0);
			gpio_set_value(controller[2], 0);
			gpio_set_value(controller[3], 1);
			break;
		case 3:
			gpio_set_value(controller[0], 0);
			gpio_set_value(controller[1], 0);
			gpio_set_value(controller[2], 1);
			gpio_set_value(controller[3], 1);
	}
	delay(50);
	*pos = (*pos+1)%4; 	
}

/****************************************************************
* Counter Clockwise Rotate
****************************************************************/
void ccRotate (int *pos){
	//Use a 4 state position to decide how to rotate
	switch (*pos){
		case 0:
			gpio_set_value(controller[0], 1);
			gpio_set_value(controller[1], 0);
			gpio_set_value(controller[2], 0);
			gpio_set_value(controller[3], 1);
			break;
		case 1:
			gpio_set_value(controller[0], 0);
			gpio_set_value(controller[1], 0);	
			gpio_set_value(controller[2], 1);
			gpio_set_value(controller[3], 1);
			break;
		case 2:
			gpio_set_value(controller[0], 0);
			gpio_set_value(controller[1], 1);
			gpio_set_value(controller[2], 1);
			gpio_set_value(controller[3], 0);
			break;
		case 3:
			gpio_set_value(controller[0], 1);
			gpio_set_value(controller[1], 1);
			gpio_set_value(controller[2], 0);
			gpio_set_value(controller[3], 0);
	}
	delay(50);
	*pos = (*pos-1+4)%4; 	
}

/****************************************************************
* Main
****************************************************************/
int main(int argc, char *argv[]){
	
	char PT1[] = "ain4", PT2[] = "ain6";
	int PT1_val[20], PT2_val[20], PT_sum[20];
	int min, minPos, pos, PT1_now, PT2_now, i;

	// Set the signal callback for Ctrl-C
	signal(SIGINT, signal_handler);

	initIO();

	pos = 0;

	//Since we don't know the initial position of motor, we'd better let it rotate 2 steps first
	cRotate(&pos);
	cRotate(&pos);

	//Clockwise rotate for a cycle and record the value in different directions
	for(i = 0; i < 20; i++) {
		PT1_val[i] = analogIn(PT1);
		PT2_val[i] = analogIn(PT2);
		printf("PT1:%d PT2:%d\n", PT1_val[i], PT2_val[i]);
		cRotate(&pos);
		delay(100);
	}

	for(i = 0; i < 20; i++) {
		PT_sum[i] = PT1_val[i] + PT2_val[i];
	}

	min = 50000;	//Initialize a large number as min to garantee to be replaced later
	//Find the direction with minimum value, which has the strongest light	
	for(i = 0; i < 20; i++)		
		if(PT_sum[i] < min) {
			min = PT_sum[i];
			minPos = i;
		}
	printf("min:%d minPos:%d\n", min, minPos);

	//Counter clockwise rotate to the direction with strongest light
	for(i = 19; i >= 0; i--) {
		ccRotate(&pos);
		delay(100);
		if((i-minPos) == 0) break;
	}

	//Tracking mode. Find the strongest light and rotate to its direction
	while(keepgoing){
		//Read analog inputs
		PT1_now = analogIn(PT1);
		PT2_now = analogIn(PT2);
		//Set a threshold. If the difference between the phototransistors is too small, we will not rotate	
		if (PT1_now - PT2_now < 150 && PT1_now - PT2_now > -150){
			delay(300);
		}
		//Decide which direction to rotate
		else if (PT1_now > PT2_now){
			cRotate(&pos);
		}		
		else if (PT1_now < PT2_now){
			ccRotate(&pos);
		}
		printf("PT1:%d PT2:%d\n", PT1_now, PT2_now);
	}
	return 0;
}


