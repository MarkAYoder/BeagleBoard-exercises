#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>

#define STRAND_LEN 160 // Number of LEDs on strand
#define MAX 10
#define DELAY 1000000

static FILE *grb_fp;
int running=1;

void clear() {
  int i;
  for (i=0; i<STRAND_LEN; i++) {
    fprintf(grb_fp, "0 0 0\n");
  }
}

void display() {
	    fprintf(grb_fp, "\n");
}

void rgb(int red, int green, int blue, int us) {
    fprintf(grb_fp, "%d %d %d", green, red, blue);
//    printf("sending %d %d %d for %d", red, green, blue, us);
    if(us) {
      display();
    }
    usleep(us);
}

// pattern4 matches the static LEDs on the tree.
void pattern4() {
  int i;
  for(i=0; i<STRAND_LEN; i+=12) {
    rgb(MAX,   0,   0, 0);
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0, MAX,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0, MAX, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(MAX, MAX/4, 0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(MAX, MAX,   0, 0);  
    rgb(  0,   0,   0, 0);  
    rgb(  0,   0,   0, 0);  
  }
  display();
  while(running) {
    rgb(MAX,   0,   0, DELAY);
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0, MAX,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0, MAX, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(MAX, MAX/4, 0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(MAX, MAX,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
    rgb(  0,   0,   0, DELAY);  
  }
}

// Pattern 3 is a single LED running backward.
void pattern3() {
  int i, j;

  for(j=0; j<STRAND_LEN; j++) {
    for(i=0; i<STRAND_LEN; i++) {
      if(i==j) {
        rgb(0, 0, 127, 0);
      } else {
        rgb(0, 0, 0, 0);
      }
    }
    display();
//  usleep(100);
  }
}

// Pattern 1 outputs a string of increaing brightness
void pattern1() {
  int i;

  for (i = 0; i < STRAND_LEN; i++) {
    rgb(0, i%127, 0, 20000);
  }
}

void pattern2() {
  int i, j;
  unsigned char g, r, b;
  unsigned char data[STRAND_LEN * 3];
  srand(time(NULL));
  
  for (i = 0; i < 20; i++) {
    g = rand() % 0x7F;
    r = rand() % 0x7F;
    b = rand() % 0x7F;
    for (j = 0; j < STRAND_LEN * 3; j += 3) {
      data[j] = g;
      data[j+1] = r;
      data[j+2] = b;
    }
    for (j = 0; j < STRAND_LEN * 3; j += 3) {
      fprintf(grb_fp, "%d %d %d\n", data[j], data[j+1], data[j+2]);
    }
    usleep(200000);
  }
}

//signal handler that breaks program loop and cleans up
void signal_handler(int signo){
  if (signo == SIGINT) {
    printf("\n^C pressed, cleaning up and exiting..\n");
    running=0;
    // fflush(stdout);
    // fclose(grb_fp);
    // exit(0);
  }
}

int main() { 
  grb_fp = fopen("/sys/firmware/lpd8806/device/rgb", "w");
  setbuf(grb_fp, NULL);
  if (grb_fp == NULL) {
    return 1;
  }
  
if (signal(SIGINT, signal_handler) == SIG_ERR) {
    printf("Error with SIGINT handler\n");
    return 1;
  }
  
  pattern3();
  while (running) {
//    clear();
    pattern3();
  }

//  fflush(stdout);
  fclose(grb_fp);
}
