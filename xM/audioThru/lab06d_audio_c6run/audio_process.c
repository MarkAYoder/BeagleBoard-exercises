/*
 *   audio_process.c
 */

//* Standard Linux headers **
#include     <stdio.h>		// Always include stdio.h
#include     <stdlib.h>		// Always include stdlib.h
#include     <string.h>		// Defines memcpy

//* Application headers **
#if defined(_TMS320C6X)		// Here's how to test for the DSP
#elif defined(__GNUC__)		// Test for the ARM
//#include     "debug.h"		// DBG and ERR macros
#endif

#include     "audio_process.h"

// Here's where we processing the audio
// Format is left and right interleaved.

int audio_process(short *outputBuffer, short *inputBuffer, int samples) {
//int i;
    memcpy((char *)outputBuffer, (char *)inputBuffer, 2*samples);

// Samples are left and right channels interleaved.

//    DBG("samples = %d\n", samples);

#ifdef HACK
    for(i=0; i<samples; i+=2) {
	outputBuffer[i]   =   inputBuffer[i];
//	outputBuffer[i]   =   0;
	outputBuffer[i+1] =   inputBuffer[i+1];
//	outputBuffer[i+1] = 0;
    }
#endif

    return 0;
}
