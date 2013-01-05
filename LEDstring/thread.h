#include <stdio.h>                      // Always include this header
#include <stdlib.h>                     // Always include this header

#include <pthread.h>                    // Be sure this is nptl header w/ proper -I in Makefile!

#define thread_SUCCESS  0
#define thread_FAILURE -1

// for boolean
#define REALTIME   1
#define TIMESLICE  0

int launch_pthread( pthread_t *hThread_byref, int type, int priority, void *(*thread_fxn)(void *env), void *env );

