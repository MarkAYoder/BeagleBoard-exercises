
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
static FILE *rgb_fp, *data_fp;
int keepgoing = 1;	// Set to 0 when ctrl-c is pressed

/* Global thread environment */
int twinkle_env = 0;

// Current state of LED string

    typedef struct rgb {
        int r;
        int g;
        int b;
    } rgb;
    rgb currentState[MAX_STRING_LEN];

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
	        // display();
//    		printf("sending %d %d %d %d for %d\n", red, green, blue, index, us);
        }
        usleep(us);
}

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
		set_rgb( i*r, i*g,  i*b, led, delay);
	}
    for(i=step; i>0; i--) {
		set_rgb( i*r, i*g,  i*g, led, delay);
	}
//    set_rgb(currentState[led].r, currentState[led].g,  currentState[led].b, led, 0);
    set_rgb(0, 0, 0, led, 0);
    
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

#ifdef HACK //This is unstable
    data_fp = fopen(LPD8806 "/data", "r");
	if(data_fp == NULL) {
		printf("Opening data failed\n");
		exit(0);
	}
    printf("Starting to read data\n");
    for(i=0; fscanf(data_fp, "%d \[%d %d %d]\n", &index, &currentState[i].r, &currentState[i].g, &currentState[i].b) != EOF; i++) {
    }

    for(i=0; i<10; i++) {
        printf("%d: %d, %d, %d\n", i, currentState[i].r, currentState[i].g, currentState[i].b);
    }
#endif

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

#ifdef HACK
    for(i=0; i<string_len; i++) {
        set_rgb(0, 0, 0, i, 0);    
    }
#endif

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

