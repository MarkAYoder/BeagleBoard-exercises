//***********************************************
//export gpio pin on the BeagleBone to prepare for usage
//
//USAGE: specify gpio # as an int
//
//written by: 	Andrew Miller
//Date:		9 September 2012
//***********************************************
int export_gpio(int gpio);

//***********************************************
//unexport gpio pin on the BeagleBone
//
//USAGE: specify gpio # as an int
//
//written by: 	Andrew Miller
//Date:		9 September 2012
//***********************************************
int unexport_gpio(int gpio);

//***********************************************
//set direction of gpio to either in or out specified by string
//GPIO MUST BE EXPORTED
//
//USAGE: specify gpio # as an int
//USAGE: specify direction as a string of either "in" or "out"
//
//written by:	Andrew Miller
//Date:		9 September 2012
//***********************************************
int set_gpio_direction(int gpio, char* direction);

//set value of gpio
//GPIO MUST BE EXPORTED
//
//USAGE: specify gpio # as an int
//USAGE: specify value as an int of either 1 or 0
//
//written by:	Andrew Miller
//Date:		9 September 2012
int set_gpio_value(int gpio, int value);

//***********************************************
//set trigger edge for given gpio pin
//GPIO MUST BE EXPORTED
//
//USAGE: specify gpio # as an int
//USAGE: specify edge as a string of "rising", "falling", or "both"
//
//written by: 	Andrew Miller
//Date:		10 September 2012
//***********************************************
int set_gpio_edge(int gpio, char* edge);

//***********************************************
//set file descriptor
//GPIO MUST BE EXPORTED
//
//USAGE: specify gpio # as an int
//
//written:	by RidgeRun
//Date:		2011
//***********************************************
int gpio_fd_open(int gpio);

//***********************************************
//close file descriptor
//GPIO MUST BE EXPORTED
//
//USAGE: give fd of open gpio
//
//written by:	RidgeRun
//Date:		2011
//***********************************************
int gpio_fd_close(int fd);

//***********************************************
//set new value for omap_mux
//
//to see all muxes and possible values, look at
// /sys/kernel/debug/omap_mux
//
//all muxes are listed here. grep if looking for
//any particular component or cat into any mux to
//see what is attached.
//
//USAGE: provide mux name as a string EX) "gpmc_a11"
//USAGE: provide the mux enable as an int from 0-7
//
//written by: 	Andrew Miller
//Date:		10 September 2012
//***********************************************
int set_mux_value(char* mux, int value);

//***********************************************
//read specified anilog pin
//
//USAGE: specify ain1-7 for reading Ex) "ain6"
//	 will read ain5
//
//written by:	Andrew Miller
//Date:		10 September 2012
//***********************************************
int read_ain(char* ain);

//***********************************************
//set pwm on a given pwm output
//
//USAGE: specify pwm as string, EX) ehrpwm.2:0
//USAGE: specify period_freq in hertz
//USAGE: specify duty cycle as percent
//
//written by: 	Andrew Miller
//Date:		10 September 2012
//***********************************************
int set_pwm(char* pwm, int period_freq, int duty_percent);

//***********************************************
//unset pwm on a given pwm output
//
//USAGE: specify pwm as a string EX) "ehrpwm.2:0"
//
//written by:	Andrew Miller
//Date:		10 September 2012
//***********************************************
int unset_pwm(char* pwm);


#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#define MAX_BUF 127


/****************************************************************
 * export_gpio
 ****************************************************************/

int export_gpio(int gpio){
	FILE *fp;
	
	//open the export file
	if((fp = fopen("/sys/class/gpio/export", "ab")) == NULL){
		printf("Cannot open export file. \n");
		return 1;
	}
	
	//write specified gpio to export file
	fprintf(fp, "%d\n", gpio);
	fflush(fp);
	fclose(fp);
	
	//return 0 if everything runs correctly
	return 0;
}

/****************************************************************
 * unexport_gpio
 ****************************************************************/

int unexport_gpio(int gpio){
	FILE *fp;
	
	//open the unexport file
	if((fp = fopen("/sys/class/gpio/unexport", "ab")) == NULL){
		printf("Cannot open unexport file. \n");
		return 1;
	}

	//write specified gpio to unexport file
	fprintf(fp, "%d\n", gpio);
	fflush(fp);
	fclose(fp);

	return 0;
}

/****************************************************************
 * set_gpio_direction
 ****************************************************************/

int set_gpio_direction(int gpio, char* direction){
	FILE *fp;
	char path[MAX_BUF];

	//create path using specified gpio
	snprintf(path, sizeof path,"/sys/class/gpio/gpio%d/direction", gpio);
	//open direction file
	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open specified direction file. Is gpio%d exported?\n", gpio);
		return 1;
	}

	//write "in" or "out" to direction file
	rewind(fp);
	fprintf(fp, "%s\n", direction);
	fflush(fp);
	fclose(fp);
}

/****************************************************************
 * set_gpio_value
 ****************************************************************/

int set_gpio_value(int gpio, int value){
	FILE *fp;
	char path[MAX_BUF];
	
	//set value only if direction is out
	snprintf(path, sizeof path, "/sys/class/gpio/gpio%d/value", gpio);
	
	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open specified value file.\n", gpio);
		return 1;
	}

	//write 1 or 0 to value file
	rewind(fp);
	fprintf(fp, "%d\n", value);
	fflush(fp);
	fclose(fp);
}

/****************************************************************
 * set_gpio_edge
 ****************************************************************/

int set_gpio_edge(int gpio, char* edge){
	FILE *fp;
	char path[MAX_BUF];
	
	//create path using specified gpio	
	snprintf(path, sizeof path, "/sys/class/gpio/gpio%d/edge", gpio);
	//open edge file
	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open specified edge file. Is gpio%d exported?\n", gpio);
		return 1;
	}

	//write "rising", "falling", or "both" to edge file
	rewind(fp);
	fprintf(fp, "%s\n", edge);
	fflush(fp);
	fclose(fp);

}

/****************************************************************
 * gpio_fd_open
 ****************************************************************/

int gpio_fd_open(int gpio)
{
	int fd, len;
	char buf[MAX_BUF];

	len = snprintf(buf, sizeof(buf), "/sys/class/gpio/gpio%d/value", gpio);
 
	fd = open(buf, O_RDONLY | O_NONBLOCK );
	if (fd < 0) {
		perror("gpio/fd_open");
	}
	return fd;
}

/****************************************************************
 * gpio_fd_close
 ****************************************************************/

int gpio_fd_close(int fd)
{
	return close(fd);
}

/****************************************************************
 * set_mux_value
 ****************************************************************/
int set_mux_value(char* mux, int value){
	FILE *fp;
	char path[MAX_BUF];

	snprintf(path, sizeof path, "/sys/kernel/debug/omap_mux/%s", mux);
	
	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open specified mux, %s\n", mux);
		return 1;
	}
	
	rewind(fp);
	fprintf(fp, "%d\n", value);
	fflush(fp);
	fclose(fp);

}
	
/****************************************************************
 * read_ain
 ****************************************************************/
int read_ain(char* ain){
	FILE *fp;
	char path[MAX_BUF];
	char buf[MAX_BUF];

	snprintf(path, sizeof path, "/sys/devices/platform/omap/tsc/%s", ain);

	if((fp = fopen(path, "r")) == NULL){
		printf("Cannot open specified ain pin, %s\n", ain);
		return 1;
	}

	if(fgets(buf, MAX_BUF, fp) == NULL){
		printf("Cannot read specified ain pin, %s\n", ain);
	}
	
	fclose(fp);
	return atoi(buf);	
}

/****************************************************************
 * set_pwm
 ****************************************************************/	
int set_pwm(char* pwm, int period_freq, int duty_percent){
	FILE *fp;
	char path[MAX_BUF];
	
	snprintf(path, sizeof path, "/sys/class/pwm/%s/run", pwm);
	
	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open pwm run file, %s\n", path);
		return 1;
	}

	rewind(fp);
	fprintf(fp, "1\n");
	fflush(fp);
	fclose(fp);

	snprintf(path, sizeof path, "/sys/class/pwm/%s/duty_ns", pwm);

	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open pwm duty_ns file, %s\n", path);
	}

	rewind(fp);
	fprintf(fp, "0\n");
	fflush(fp);
	fclose(fp);

	snprintf(path, sizeof path, "/sys/class/pwm/%s/period_freq", pwm);

	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open pwm period_freq file, %s\n", path);
	}

	rewind(fp);
	fprintf(fp, "%d\n", period_freq);
	fflush(fp);
	fclose(fp);

	snprintf(path, sizeof path, "/sys/class/pwm/%s/duty_percent", pwm);

	if((fp = fopen(path, "w")) == NULL){
		printf("Cannot open duty_percent file, %s\n", path);
	}

	rewind(fp);
	fprintf(fp, "%d\n", duty_percent);
	fflush(fp);
	fclose(fp);
}

/****************************************************************
 * unset_pwm
 ****************************************************************/
int unset_pwm(char* pwm){
	FILE *fp;
	char path[MAX_BUF];

	snprintf(path, sizeof path, "/sys/class/pwm/%s/run", pwm);

	if((fp = fopen(path, "w")) == NULL) {
		printf("Cannot open pwm run file, %s\n", path);
		return 1;
	}

	rewind(fp);
	fprintf(fp, "0\n");
	fflush(fp);
	fclose(fp);

	return 0;

}

