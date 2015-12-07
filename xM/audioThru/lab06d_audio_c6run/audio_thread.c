/*
 *   audio_thread.c
 */

//* Standard Linux headers **
#include     <stdio.h>			// Always include stdio.h
#include     <stdlib.h>			// Always include stdlib.h
#include     <alsa/asoundlib.h>		// ALSA includes
#include     <string.h>			// For memcpy

//* Application headers **
#include     "debug.h"			// DBG and ERR macros
#include     "audio_thread.h"		// Audio thread definitions
#include     "audio_input_output.h"	// Audio driver input and output functions
#include     "audio_process.h"

// Timing routines
#include <time.h>
#if defined(_TMS320C6X)			// Here's how to test for the DSP
#elif defined(__GNUC__)			// Test for the ARM
  #include <sys/time.h>
#endif

typedef unsigned long long timestamp_t;

static timestamp_t get_timestamp ()
{
#if defined(_TMS320C6X)
  // There is no gettimeofday in DSP RTS or DSP/BIOS
  return (timestamp_t) clock();
#elif defined(__GNUC__)
  struct timeval now;
  gettimeofday (&now, NULL);
  return  now.tv_usec + (timestamp_t)now.tv_sec * 1000000;
#endif
}

//* ALSA devices **
//#define     IN_SOUND_DEVICE      "plughw:0,0"	// Use for line in
#define     IN_SOUND_DEVICE      "plughw:1,0"	// Use for PS EYE input
#define     OUT_SOUND_DEVICE     "plughw:0,0"

//* The sample rate of the audio codec **
#define     SAMPLE_RATE      48000

//* The gain (0-100) of the left channel **
#define     LEFT_GAIN        100

//* The gain (0-100) of the right channel **
#define     RIGHT_GAIN       100

//*  Parameters for audio thread execution **
#define     BLOCKSIZE        48000


//*******************************************************************************
//*  audio_thread_fxn                                                          **
//*******************************************************************************
//*  Input Parameters:                                                         **
//*      void *envByRef    --  a pointer to an audio_thread_env structure      **
//*                            as defined in audio_thread.h                    **
//*                                                                            **
//*          envByRef.quit -- when quit != 0, thread will cleanup and exit     **
//*                                                                            **
//*  Return Value:                                                             **
//*      void *            --  AUDIO_THREAD_SUCCESS or AUDIO_THREAD_FAILURE as **
//*                            defined in audio_thread.h                       **
//*******************************************************************************
void *audio_thread_fxn( void *envByRef )
{

// Variables and definitions
// *************************

    // Thread parameters and return value
    audio_thread_env * envPtr = envByRef;                  // < see above >
    void             * status = AUDIO_THREAD_SUCCESS;      // < see above >

    // The levels of initialization for initMask
    #define     INPUT_ALSA_INITIALIZED      0x1
    #define     INPUT_BUFFER_ALLOCATED      0x2
    #define     OUTPUT_ALSA_INITIALIZED     0x4
    #define     OUTPUT_BUFFER_ALLOCATED     0x8

    unsigned  int   initMask =  0x0;               // Used to only cleanup items that were init'd

    // Input and output driver variables
    snd_pcm_uframes_t exact_bufsize;
    snd_pcm_t	*pcm_capture_handle, *pcm_output_handle;

    int   blksize = BLOCKSIZE;	// Raw input or output frame size
    char *inputBuffer = NULL;	// Input buffer for driver to read into
    char *outputBuffer = NULL;	// Output buffer for driver to read from

// Thread Create Phase -- secure and initialize resources
// ******************************************************

    // Setup audio input device
    // ************************

    // Open an ALSA device channel for audio input
    exact_bufsize = blksize/BYTESPERFRAME;

    if( audio_io_setup( &pcm_capture_handle, IN_SOUND_DEVICE, SAMPLE_RATE, 
			SND_PCM_STREAM_CAPTURE, &exact_bufsize ) == AUDIO_FAILURE )
    {
        ERR( "Audio_input_setup failed in audio_thread_fxn\n\n" );
        status = AUDIO_THREAD_FAILURE;
        goto cleanup;
    }
    DBG( "exact_bufsize = %d \n", (int) exact_bufsize);

    // Record that input OSS device was opened in initialization bitmask
    initMask |= INPUT_ALSA_INITIALIZED;

    blksize = exact_bufsize*BYTESPERFRAME;
    // Create input buffer to read into from ALSA input device
    if( ( inputBuffer = malloc( blksize ) ) == NULL )
    {
        ERR( "Failed to allocate memory for input block (%d)\n", blksize );
        status = AUDIO_THREAD_FAILURE;
        goto  cleanup ;
    }

    DBG( "Allocated input audio buffer of size %d to address %p\n", blksize, inputBuffer );

    // Record that the input buffer was allocated in initialization bitmask
    initMask |= INPUT_BUFFER_ALLOCATED;

    // Create output buffer to write from into ALSA output device
    if( ( outputBuffer = malloc( blksize ) ) == NULL )
    {
        ERR( "Failed to allocate memory for output block (%d)\n", blksize );
        status = AUDIO_THREAD_FAILURE;
        goto  cleanup ;
    }

    DBG( "Allocated output audio buffer of size %d to address %p\n", blksize, outputBuffer );

    // Record that the output buffer was allocated in initialization bitmask
    initMask |= OUTPUT_BUFFER_ALLOCATED;

    // Initialize audio output device
    // ******************************

    // Initialize the output ALSA device
    DBG( "pcm_output_handle before audio_output_setup = %d\n", (int) pcm_output_handle);

    DBG( "Requesting bufsize = %d\n", (int) exact_bufsize);
    if( audio_io_setup( &pcm_output_handle, OUT_SOUND_DEVICE, SAMPLE_RATE, 
			SND_PCM_STREAM_PLAYBACK, &exact_bufsize) == AUDIO_FAILURE )
    {
        ERR( "audio_output_setup failed in audio_thread_fxn\n" );
        status = AUDIO_THREAD_FAILURE;
        goto  cleanup ;
    }
	DBG( "pcm_output_handle after audio_output_setup = %d\n", (int) pcm_output_handle);
	DBG( "blksize = %d, exact_bufsize = %d\n", blksize, (int) exact_bufsize);

    // Record that input ALSA device was opened in initialization bitmask
    initMask |= OUTPUT_ALSA_INITIALIZED;

// Thread Execute Phase -- perform I/O and processing
// **************************************************
    int err;
    int errcnt =0;
    timestamp_t t_start, t_read, t_proc, t_write, t_old=0;
    
    // Processing loop
    // Do a dummy call to the DSP to get it started.  This takes a while on the first call
    // so we don't want to do it after starting the audio or a buffer will underflow.

    memset(outputBuffer, 0, blksize);		// Clear the buffer

    printf( "Starting DSP..." );
    t_start = get_timestamp();

    // Do the dummy call
    audio_process((short *)outputBuffer, (short *)outputBuffer, blksize/2);

    t_proc = get_timestamp();
    printf("%f s\n", (t_proc-t_start)/1000000.0);

    DBG( "Entering audio_thread_fxn processing loop...\n" );

    // Get things started by sending some silent buffers out.

    while( snd_pcm_readi(pcm_capture_handle, inputBuffer, exact_bufsize) < 0 )
        {
	    snd_pcm_prepare(pcm_capture_handle);
	    ERR( "<<<<<<<<<<<<<<< Buffer Prime Overrun >>>>>>>>>>>>>>>\n");
            ERR( "Error reading the data from file descriptor %d\n", 
			(int) pcm_capture_handle );
        }

    int i;
    memset(outputBuffer, 0, blksize);		// Clear the buffer
    for(i=0; i<2; i++) {
	    while ((err = snd_pcm_writei(pcm_output_handle, outputBuffer,
			 exact_bufsize)) < 0) {
		snd_pcm_prepare(pcm_output_handle);
		ERR( "<<<Pre Buffer Underrun >>> err=%d, errcnt=%d\n", err, errcnt);
	      }
	}
//
//	The main loop
//
    while( !envPtr->quit ) {
	// Read capture buffer from ALSA input device
	t_start = get_timestamp();
        while( snd_pcm_readi(pcm_capture_handle, inputBuffer, exact_bufsize) < 0 ) {
	    snd_pcm_prepare(pcm_capture_handle);
	    ERR( "<<<<<<<<<<<<<<< Buffer Overrun >>>>>>>>>>>>>>>\n");
            ERR( "Error reading the data from file descriptor %d\n", 
			(int) pcm_capture_handle );
        }
	t_read = get_timestamp();
	// Audio process
	//  I'm passing the data as short since we are processing 16-bit audio.
	//	memcpy(outputBuffer, inputBuffer, blksize);
	audio_process((short *)outputBuffer, (short *)inputBuffer, blksize/2);
	t_proc = get_timestamp();

	// Write output buffer into ALSA output device
	errcnt = 0;	
	// The Beagle gets an underrun error the first time it trys to write,
	// so I ignore the first error and it appears to work fine.
	while ((err = snd_pcm_writei(pcm_output_handle, outputBuffer, exact_bufsize)) < 0) {
	    snd_pcm_prepare(pcm_output_handle);
	    ERR( "<<<<<<<<<<<<<<< Buffer Underrun >>>>>>>>>>>>>>> err=%d, errcnt=%d\n", err, errcnt);
	    memset(outputBuffer, 0, blksize);		// Clear the buffer
	    snd_pcm_writei(pcm_output_handle, outputBuffer, exact_bufsize);
	}
	t_write= get_timestamp();
//	DBG( "%d\t%d\t%d\t%d\n", t_start-t_old, t_read-t_start, t_proc-t_read, t_write-t_proc);
	t_old = t_start;
    }

    DBG( "Exited audio_thread_fxn processing loop\n" );


// Thread Delete Phase -- free up resources allocated by this file
// ***************************************************************

cleanup:

    DBG( "Starting audio thread cleanup to return resources to system\n" );

    // Close the audio drivers
    // ***********************
    //  - Uses the initMask to only free resources that were allocated.
    //  - Nothing to be done for mixer device, as it was closed after init.

    // Close input ALSA device
    if( initMask & INPUT_ALSA_INITIALIZED )
        if( audio_io_cleanup( pcm_capture_handle ) != AUDIO_SUCCESS )
        {
            ERR( "audio_input_cleanup() failed for file descriptor %d\n", (int) pcm_capture_handle );
            status = AUDIO_THREAD_FAILURE;
        }

    // Close output ALSA device
    if( initMask & OUTPUT_ALSA_INITIALIZED )
        if( audio_io_cleanup( pcm_output_handle ) != AUDIO_SUCCESS )
        {
            ERR( "audio_output_cleanup() failed for file descriptor %d\n", (int)pcm_output_handle );
            status = AUDIO_THREAD_FAILURE;
        }

    // Free allocated buffers
    // **********************

    // Free input buffer
    if( initMask & INPUT_BUFFER_ALLOCATED )
    {
        DBG( "Freeing audio input buffer at location %p\n", inputBuffer );
        free( inputBuffer );
        DBG( "Freed audio input buffer at location %p\n", inputBuffer );
    }

     // Free output buffer
    if( initMask & OUTPUT_BUFFER_ALLOCATED )
    {
        free( outputBuffer );
        DBG( "Freed audio output buffer at location %p\n", outputBuffer );
    }

    // Return from audio_thread_fxn function
    // *************************************

    // Return the status at exit of the thread's execution
    DBG( "Audio thread cleanup complete. Exiting audio_thread_fxn\n" );
    return status;
}

