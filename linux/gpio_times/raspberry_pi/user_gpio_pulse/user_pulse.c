// To isolate the core, edit the file /boot/cmdline.txt to have
// isolcpus=3 (keep any task from normally being scheduled on the 4th
// core)
//
// To assign this program to that isolated core, run it with:
// taskset 0x8 ./user_pulse 10000
//
// Where 0x8 is the mask for the 4th core (1000b), and the 10000
// is the number of microseconds for the asserted pulse in the
// pulse train (the deasserted portion of the pulse is much smaller,
// since we don't care about its measurement).


#include <bcm2835.h>
#include <stdio.h>
#include <time.h>
#include <sched.h>
#include <sys/mman.h>

int main(int argc, char **argv)
{
    volatile int delay;
    int i;
    long int start_time;
    long int time_difference, shortest, longest;
    struct timespec gettime_now;
    int sleeptime, loopsize;

    const struct sched_param priority = {99};

    sched_setscheduler(0, SCHED_FIFO, &priority);
    printf("YES locked in memory\n");
    mlockall(MCL_CURRENT); // lock in memory to keep us from paging out

    if (argc < 2)
    {
        printf("You didn't supply a time, so we assume 10 msec (10000)\n");
        sleeptime = 10000;
    }
    else
    {
        sscanf(argv[1], "%d", &sleeptime);
        printf("User-requested sleeptime of %dusec\n", sleeptime);
    }

    loopsize = 10000;
    if (sleeptime < 10000)
        loopsize = 10000/sleeptime * loopsize;
    printf("loopsize of %d\n", loopsize);


    if (!bcm2835_init())
    {
        printf("oops\n");
        return 1;
    }

    shortest = 0x7FFFFFFF;  // initialize the shortest/longest variables
    longest = 0;
    bcm2835_gpio_fsel(RPI_BPLUS_GPIO_J8_07, BCM2835_GPIO_FSEL_OUTP);
#if 0
    // this code is only used when first hooking up the logic
    // analyzer/oscope to verify you're looking at the right lines
    printf("holding the line LOW for 20 seconds\n");
    bcm2835_gpio_write(RPI_BPLUS_GPIO_J8_07, LOW);
    usleep(20 * 1000 * 1000);
    printf("holding the line high for 20 seconds\n");
    bcm2835_gpio_write(RPI_BPLUS_GPIO_J8_07, HIGH);
    usleep(20 * 1000 * 1000);
    bcm2835_gpio_write(RPI_BPLUS_GPIO_J8_07, LOW);
#endif
    for(i=0;i<loopsize;i++)
    {
        clock_gettime(CLOCK_REALTIME, &gettime_now);
        start_time = gettime_now.tv_nsec;

        // assert the GPIO
        bcm2835_gpio_write(RPI_BPLUS_GPIO_J8_07, HIGH);

        usleep(sleeptime); // user-requested sleep time

        // deassert the GPIO
        bcm2835_gpio_write(RPI_BPLUS_GPIO_J8_07, LOW);

        clock_gettime(CLOCK_REALTIME, &gettime_now);
        time_difference = gettime_now.tv_nsec - start_time;
        if (time_difference < 0)
        {
            time_difference += 1000000000; //(Rolls over every 1 second)
            printf("Rolled over, i=%d, shortest=%ld, longest=%ld\n",i,
                   shortest, longest);
        }

        if (time_difference < shortest)
            shortest = time_difference; // save away shortest time
        if (time_difference > longest)
            longest = time_difference; // save away longest time
    }
    printf("longest pulse time was %d, shortest %d\n", longest, shortest);
}
