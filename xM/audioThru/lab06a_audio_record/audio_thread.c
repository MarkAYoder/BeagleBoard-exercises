/*
 *   audio_thread.c
 */

//* Standard Linux headers **
#include     <stdio.h>                          // Always include stdio.h
#include     <stdlib.h>                         // Always include stdlib.h
#include     <fcntl.h>                          // Defines open, read, write methods
#include     <unistd.h>                         // Defines close and sleep methods
//#include     <string.h>                         // Defines memcpy
#include     <alsa/asoundlib.h>			// ALSA includes

//* Application headers **
#include     "debug.h"                          // DBG and ERR macros
#include     "audio_thread.h"                   // Audio thread definitions
#include     "audio_input_output.h"             // Audio driver input and output functions

//* ALSA and Mixer devices **
//#define     SOUND_DEVICE     "plughw:0,0"	// This uses line in
#define     SOUND_DEVICE     "plughw:1,0"	// This uses the PS EYE mikes

//* Output file name **
#define     OUTFILE          "/tmp/audio.raw"

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
    #define     OUTPUT_FILE_OPENED          0x4

    unsigned  int   initMask =  0x0;		// Used to only cleanup items that were init'd

    // Input and output driver variables
    snd_pcm_uframes_t exact_bufsize;
    snd_pcm_t	*pcm_capture_handle;

    FILE          * outfile = NULL;	// Output file pointer (i.e. handle)
    int   blksize = BLOCKSIZE;		// Raw input or output frame size
    char *inputBuffer = NULL;		// Input buffer for driver to read into

// Thread Create Phase -- secure and initialize resources
// ******************************************************

    // Setup audio input device
    // ************************

    // Open an ALSA device channel for audio input
    exact_bufsize = blksize/BYTESPERFRAME;

    if( audio_io_setup( &pcm_capture_handle, SOUND_DEVICE, SAMPLE_RATE, 
			SND_PCM_STREAM_CAPTURE, &exact_bufsize ) == AUDIO_FAILURE )
    {
        ERR( "Audio_input_setup failed in audio_thread_fxn\n\n" );
        status = AUDIO_THREAD_FAILURE;
        goto cleanup;
    }
    DBG( "exact_bufsize = %d\n", (int) exact_bufsize);

    // Record that input OSS device was opened in initialization bitmask
    initMask |= INPUT_ALSA_INITIALIZED;

    blksize = exact_bufsize*BYTESPERFRAME;
    // Create input buffer to read into from OSS input device
    if( ( inputBuffer = malloc( blksize ) ) == NULL )
    {
        ERR( "Failed to allocate memory for input block (%d)\n", blksize );
        status = AUDIO_THREAD_FAILURE;
        goto  cleanup ;
    }

    DBG( "Allocated input audio buffer of size %d to address %p\n", blksize, inputBuffer );

    // Record that the input buffer was allocated in initialization bitmask
    initMask |= INPUT_BUFFER_ALLOCATED;

    // Open audio output file
    // **********************

    // Open a file for record
    outfile = fopen(OUTFILE, "w");

    if( outfile == NULL )
    {
        ERR( "Failed to open file %s\n", OUTFILE );
        status = AUDIO_THREAD_FAILURE;
        goto  cleanup ;
    }

    DBG( "Opened file %s with FILE pointer = %p\n", OUTFILE, outfile );

    // Record that input OSS device was opened in initialization bitmask
    initMask |= OUTPUT_FILE_OPENED;


// Thread Execute Phase -- perform I/O and processing
// **************************************************

    // Processing loop
    DBG( "Entering audio_thread_fxn processing loop\n" );

    while( !envPtr->quit )
    {
        // Read capture buffer from ALSA input device

        if( snd_pcm_readi(pcm_capture_handle, inputBuffer, blksize/BYTESPERFRAME) < 0 )
        {
	    snd_pcm_prepare(pcm_capture_handle);
	    ERR( "<<<<<<<<<<<<<<< Buffer Overrun >>>>>>>>>>>>>>>\n");
            ERR( "Error reading the data from file descriptor %d\n", (int) pcm_capture_handle );
            status = AUDIO_THREAD_FAILURE;
            goto  cleanup ;
        }

        if( fwrite( inputBuffer, sizeof( char ), blksize, outfile ) < blksize )
        {
            ERR( "Error writing the data to FILE pointer %p\n", outfile );
            status = AUDIO_THREAD_FAILURE;
            goto cleanup;
        }
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

    // Close input OSS device
    if( initMask & INPUT_ALSA_INITIALIZED )
        if( audio_io_cleanup( pcm_capture_handle ) != AUDIO_SUCCESS )
        {
            ERR( "audio_input_cleanup() failed for file descriptor %d\n", (int) pcm_capture_handle );
            status = AUDIO_THREAD_FAILURE;
        }

    // Close output file
    if( initMask & OUTPUT_FILE_OPENED )
    {
        DBG( "Closing output file at FILE ptr %p\n", outfile );
        fclose( outfile );
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

    // Return from audio_thread_fxn function
    // *************************************

    // Return the status at exit of the thread's execution
    DBG( "Audio thread cleanup complete. Exiting audio_thread_fxn\n" );
    return status;
}

