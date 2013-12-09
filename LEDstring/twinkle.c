
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>	// Defines signal-handling functions (i.e. trap Ctrl-C)


/****************************************************************
 * Constants
 ****************************************************************/
 
#define MAX 127		// Brightness

/****************************************************************
 * Global variables
 ****************************************************************/
int string_len = 160;
static FILE *rgb_fp;
int keepgoing = 1;	// Set to 0 when ctrl-c is pressed

/* Global thread environment */
int twinkle_env = 0;

/* Thread handle */
pthread_t twinkleThread;

/****************************************************************
 * signal_handler
 ****************************************************************/
// Callback called when SIGINT is sent to the process (Ctrl-C)
void signal_handler(int sig)
{
	printf( "Ctrl-C pressed, cleaning up and exiting..\n" );
	keepgoing = 0;
}

void display() {
	  fprintf(rgb_fp, "0 0 0 -1\n");
}

void rgb(int red, int green, int blue, int index, int us) {
	fprintf(rgb_fp, "%d %d %d %d", red, green, blue, index);
	if(us) {
	        display();
//    		printf("sending %d %d %d %d for %d\n", red, green, blue, index, us);
        }
        usleep(us);
}

void *twinkle(void *env) {
	int *tmp = env;
	int led = *tmp;	// Initial direction
    int i;
    for(i=0; i<MAX; i+=20) {
		rgb( i, i,  i, led, 20000);
	}
    for(i=MAX; i>=0; i-=20) {
		rgb( i, i,  i, led, 20000);
	}
    rgb( 0, 0,  0, led, 0);
    
    pthread_detach(pthread_self());
}

/****************************************************************
 * Main
 ****************************************************************/
int main(int argc, char **argv, char **envp)
{
    int err, i, delay = 200000;
	// Set the signal callback for Ctrl-C
	signal(SIGINT, signal_handler);

	rgb_fp = fopen("/sys/firmware/lpd8806/device/rgb", "w");
	setbuf(rgb_fp, NULL);	// Turn buffering off
	if(rgb_fp == NULL) {
		printf("Opening rgb failed\n");
		exit(0);
	}

    if(getenv("STRING_LEN")) {
    	string_len = atoi(getenv("STRING_LEN"));
    } else {
      	string_len = 160;
    }
    printf("string_len = %d\n", string_len);
    
    if(argc == 2) {
        delay = atoi(argv[1]);
    }
    printf("delay= %d\n", delay);
    
    for(i=0; i<string_len; i++) {
        rgb(0, 0, 0, i, 0);    
    }
 
	for(i=0; keepgoing; i++) {
        twinkle_env = rand() % string_len;
	    err = pthread_create(&twinkleThread, NULL, &twinkle, &twinkle_env);
        if(err) {
            printf("pthread_create err = %d, i=%d\n", err, i);
            printf("EAGAIN = %d\n", EAGAIN);
        }
        usleep(delay);
	}
	return 0;
}

