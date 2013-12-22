#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <math.h>

int string_len = 160;

#define MAX 10
#define DELAY 1000000

static FILE *rgb_fp;
// static FILE *ain_fp;
int running=1;

void clear() {
  int i;
  for (i=0; i<string_len; i++) {
    fprintf(rgb_fp, "0 0 0 %d", i);
  }
}

void display() {
  fprintf(rgb_fp, "0 0 0 -1\n");
}

void rgb(int red, int green, int blue, int index, int us) {
  fprintf(rgb_fp, "%d %d %d %d", red, green, blue, index);
  if(us) {
    display();
//    printf("sending %d %d %d %d for %d\n", red, green, blue, index, us);
  }
  usleep(us);
}

// Pattern 0 outputs all the same color
void pattern0(int r, int g, int b) {
  int i;
  for (i=0; i<string_len; i++) {
    rgb(r, g, b, i, 0);
  }
  display();
  running = 0;
}

// Pattern 1 outputs a string of increasing brightness
void pattern1() {
  int i;
  for (i=0; i<string_len; i++) {
    rgb(0, i%127, 0, i, 20000);
  }
  for (i=0; i<string_len; i++) {
    rgb(0, 0, i%127, i, 20000);
  }
  for (i=0; i<string_len; i++) {
    rgb(i%127, 0, 0, i, 20000);
  }
}

// Pattern 2 outputs all the same random color
void pattern2() {
  int i;
  unsigned char g, r, b;
  srand(time(NULL));
  
  g = rand() % 0x7F;
  r = rand() % 0x7F;
  b = rand() % 0x7F;
 
  for (i=0; i<string_len; i++) {
    rgb(r, b, g, i, 0);
  }
  display();
  usleep(200000);
}

// Pattern 3 is a single LED running backward and forward.
void pattern3(int timeUp, int timeBack) {
  int i;

  // Climbing up
  for(i=0; i<string_len-1; i++) {
    rgb(   0, 0, 0, i,   0);
    rgb((i*20/string_len)+1, 0, 0, i+1, timeUp);
    if(!running) return;
  }
  // Sledding down
  for(i=string_len-1; i>=0; i--) {
    rgb(0,  0,  0, i+1, 0);
    rgb(0,  0, (string_len-i+4)*20/string_len, i  , timeBack);
    if(!running) return;
  }
}

// pattern4 matches the static LEDs on the tree.
void pattern4(int skip) {
  int i;
  int period=5;
  int phase;
  for(phase=0; phase<skip*period; phase++) {
    clear();
    for(i=phase-skip*period; i<string_len; i+=skip*period) {
      rgb(MAX,   0,   0, i+0*skip, 0);
      rgb(  0, MAX,   0, i+1*skip, 0);  
      rgb(  0,   0, MAX, i+2*skip, 0);  
      rgb(MAX, MAX/4, 0, i+3*skip, 0);  
      rgb(MAX, MAX,   0, i+4*skip, 0); 
    }
  display();
  usleep(DELAY);
  if(!running) return;
  }
}

// Pattern 5 is a single LED running smoothly along.
void pattern5(int timeUp, int timeBack) {
  int i, j;
  int smooth=10;

  for(i=0; i<string_len-1; i++) {
    for(j=1; j<=smooth; j++) {
      rgb(0, (smooth-j), 0, i,   0);
      rgb(0,        (j), 0, i+1, timeUp/(smooth*1.5));
    }
  }
  for(i=string_len-1; i>=0; i--) {
    for(j=1; j<=smooth; j++) {
      rgb(0,  0, (smooth-j), i+1, 0);
      rgb(0,  0,        (j), i  , timeBack/(smooth*1.5));
    }
  }
}

// Pattern 6 is a sine wave
void pattern6(int timeUp, int timeBack) {
  int r, g, b;
  float i, 
        f = 10.0;  // Frequency
  static int phase = 0;

  for(i=0; i<string_len; i++) {
      r = (int) (25 * (sin(2*M_PI*f*(i+phase   )/string_len) + 1)) + 1;
      g = (int) (25 * (sin(2*M_PI*f*(i+phase+5 )/string_len) + 1)) + 1;
      b = (int) (25 * (sin(2*M_PI*f*(i+phase+10)/string_len) + 1)) + 1;
      // printf("%f: %d\n", i, value);
      rgb(r, g, b, i, 0);
  }
  phase++;
  // printf("phase = %d\n", phase);
  display();
  usleep(10000);
}

// Pattern 7 reads the analog in and positions the LED.
void pattern7(int timeUp, int timeBack) {
#ifdef HACK
  int value, oldIndex;
  static int index = 0;
  oldIndex = index;
  fseek(ain_fp, 0L,  SEEK_SET);
  fscanf(ain_fp, "%d", &value);
  index = (value-4072)*159/(1416-4072);
  if(index != oldIndex) {
//    printf("ain: %d, %d, %d (old)\n", value, index, oldIndex);
    rgb(0, 0, 0, oldIndex, 0);
    rgb(10, 10, 10, index, 10000);
  }
#endif
}

//signal handler that breaks program loop and cleans up
void signal_handler(int signo){
  if (signo == SIGINT) {
    printf("\n^C pressed, cleaning up and exiting..\n");
    running=0;
    // fflush(stdout);
    // fclose(rgb_fp);
    // exit(0);
  }
}

int main(int argc, char *argv[], char *envp[]) { 
  rgb_fp = fopen("/sys/firmware/lpd8806/device/rgb", "w");
//  ain_fp = fopen("/sys/devices/platform/omap/tsc/ain6", "r");
  setbuf(rgb_fp, NULL);
//  if (rgb_fp == NULL || ain_fp == NULL) {
  if (rgb_fp == NULL) {
    printf("Failed to open device\n");
    return 1;
  }
 
  if (signal(SIGINT, signal_handler) == SIG_ERR) {
    printf("Error with SIGINT handler\n");
    return 1;
  }
  
    if(getenv("STRING_LEN")) {
        string_len = atoi(getenv("STRING_LEN"));
    } else {
      	string_len = 160;
    }
    printf("string_len = %d\n", string_len);
  
  int pattern=3;
  int arg=4;
  int arg2 = 10000;
  int arg3 = 127;
  if(argc > 1) {
    pattern=atoi(argv[1]);
  }
  if(argc > 2) {
    arg=atoi(argv[2]);
    arg2 = arg;
  }
  if(argc > 3) {
    arg2=atoi(argv[3]);
  }
  if(argc > 4) {
    arg3=atoi(argv[4]);
  }
  printf("Running pattern%d(%d)\n", pattern, arg);

  clear();
  while (running) {
    switch(pattern) {
      case 0:
	pattern0(arg, arg2, arg3);
	break;
      case 1:
	pattern1();
	break;
      case 2:
	pattern2();
	break;
      case 3:
        pattern3(arg, arg2);
	break;
      case 4:
	pattern4(arg);
	break;
      case 5:
	pattern5(arg, arg2);
	break;
      case 6:
	pattern6(arg, arg2);
	break;
      case 7:
	pattern7(arg, arg2);
	break;
    }
  }

//  fflush(stdout);
  fclose(rgb_fp);
//  fclose(ain_fp);
}
