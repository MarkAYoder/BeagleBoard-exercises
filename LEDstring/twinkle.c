
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
#define LPD8806 "/sys/firmware/lpd8806/device"
#define MAX_STRING_LEN 320
#define UPDATE_RATE  10000  // micro seconds between string updates

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
	  fprintf(rgb_fp, "\n");
}

// This is the master update thread.  None of the other threads update the string.
// Instead this updates the whole thread at a regular interval.
void *keepDisplaying(void *env) {
    int *tmp = env;
    int delay = *tmp;
    
    printf("keepDisplaying called with delay = %d\n", delay);
    
    while(keepgoing) {
        display();
        usleep(delay);
    }
}

void set_rgb(int red, int green, int blue, int index, int us) {
	fprintf(rgb_fp, "%d %d %d %d", red, green, blue, index);
	if(us) {
        // No need to display since keepDisplaying thread does it
	    // display();
        // printf("sending %d %d %d %d for %d\n", red, green, blue, index, us);
        }
    usleep(us);
}

// Animate each twinkle.  Pass the time in us between updates
void *twinkle(void *env) {
	int *tmp = env;
	int led = *tmp;	// Initial direction
    int i;
    int delay;
    int r, g, b, step = 10;
#define MASK 0x3f
    
    r = (rand() % MASK)/step;
    g = (rand() % MASK)/step;
    b = (rand() % MASK)/step;
    
    delay = 10000 + rand() % 50000;
    for(i=1; i<=step; i++) {
		set_rgb(i*r, i*g,  i*b, led, delay);
	}
    // Make 1 in 10 roll down the string
    if(rand()%100) {
        for(i=step; i>0; i--) {
    		set_rgb(i*r, i*g,  i*g, led, delay);
    	}
        set_rgb(0, 0, 0, led, 0);
    } else if(rand()%25) {
        for(i=led-1; i>=0; i--) {
            set_rgb(   0,    0,    0, i+1, 0);
            set_rgb((i%step)*r, (i%step)*g, (i%step)*b, i  , 2*delay);
        }
    } else {
        for(i=led; i<MAX_STRING_LEN; i++) {
            set_rgb(   0,    0,    0, i, 0);
            set_rgb((i%step)*r, (i%step)*g, (i%step)*b, i+1  , 20*delay);
        }
    }
    pthread_detach(pthread_self());
}

/****************************************************************
 * Main
 ****************************************************************/
int main(int argc, char **argv, char **envp)
{
    int err, i, delay = 100000;
    int r, g, b, index;    // Value of current LED

// Set the signal callback for Ctrl-C
	signal(SIGINT, signal_handler);

    rgb_fp = fopen(LPD8806 "/rgb", "w");
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
    printf("delay between twinkles = %d\n", delay);

    int update_rate = UPDATE_RATE;
    err = pthread_create(&twinkleThread, NULL, &keepDisplaying, &update_rate);
    if(err) {
        printf("keepDisplaying pthread_create err = %d, i=%d\n", err, i);
        printf("EAGAIN = %d\n", EAGAIN);
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

