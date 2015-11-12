/*
 *    video_thread.c
 */

//* Standard Linux headers **
#include     <stdio.h>                          // Always include stdio.h
#include     <stdlib.h>                         // Always include stdlib.h
#include     <string.h>                         // Defines memset and memcpy methods
#include     <sys/ioctl.h>                      // Defines driver ioctl method
#include     <linux/fb.h>                       // Defines framebuffer driver methods
#include     <asm/types.h>                      // Standard typedefs required by v4l2 header
#include     <linux/videodev2.h>                // v4l2 driver definitions

//* Application headers files **
#include     "debug.h"                          // DBG and ERR macros
#include     "video_thread.h"                   // Video thread definitions
#include     "video_input.h"                    // Capture device functions

//* Video capture and display devices used **
#define     V4L2_DEVICE     "/dev/video0"

//* Input and Picture files **
#define     OUTFILE         "/tmp/video.raw"

//* Double-buffered display, triple-buffered capture **
#define     NUM_CAP_BUFS    3

//* Other Definitions **
#define     SCREEN_BPP      16
// #define     D1_WIDTH        720
// #define     D1_HEIGHT       480	// NTSC Format
#define     D1_WIDTH        640
#define     D1_HEIGHT       480		// Small Format
//#define   D1_HEIGHT       576		// PAL Format

//* Macro for clearing structures **
#define     CLEAR(x)       memset ( &(x), 0 , sizeof(x) )

//*******************************************************************************
//*  video_thread_fxn                                                          **
//*******************************************************************************
//*  Input Parameters:                                                         *
//*      void *envPtr  --  a pointer to a video_thread_env structure as        *
//*                     defined in video_thread.h                              *
//*                 --  originally used to pass variable used to break out of  *
//*                     real time processing loop; another element is added to *
//*                     environment structure in codec engine lab exercises    *
//*                 --  not used by lab07a, but used in remaining video labs   *
//*                                                                            *
//*   envPtr.quit   --  when quit != 0, thread will cleanup and exit           *
//*                                                                            *
//*  Return Value:                                                             *
//*      void *     --  VIDEO_THREAD_SUCCESS or VIDEO_THREAD_FAILURE as        *
//*                     defined in video_thread.h                              *
//******************************************************************************
void *video_thread_fxn( void *envByRef )
{

// Variables and definitions
// *************************

    // Thread parameters and return value
    video_thread_env *envPtr = envByRef;                  // < see above >
    void             *status = VIDEO_THREAD_SUCCESS;      // < see above >

    // The levels of initialization for initMask
    #define     OUTPUTFILEOPENED             0x1
    #define     CAPTUREDEVICEINITIALIZED     0x4

    unsigned  int initMask =  0x0;	// Used to only cleanup items that were init'd

    // Capture and display driver variables
    FILE	*outputFile = NULL;	// Output file pointer (write raw video data to file)

    int			captureFd  = 0;	// Capture driver file descriptor
    VideoBuffer		*vidBufs;	// Capture frame descriptors
    unsigned  int	numVidBufs = NUM_CAP_BUFS;       // Number of capture frames
    int	captureWidth;			// Width of a capture frame
    int	captureHeight;			// Height of a capture frame
    int	captureSize = 0;		// Bytes in a capture frame
    struct  v4l2_buffer	v4l2buf;	// Stores a dequeue'd frame
    int i;

// Thread Create Phase -- secure and initialize resources
// ******************************************************

    // Open the output file
    // ********************

    // Open output file (to write data to)
    outputFile = fopen( OUTFILE, "w" );

    if( outputFile == NULL ) {
        ERR( "Failed to open output file %s\n", OUTFILE );
        status = VIDEO_THREAD_FAILURE;
        goto cleanup;
    }
    // Record that the output file was opened
    initMask |= OUTPUTFILEOPENED;

    // Initialize the video capture device
    // ***********************************

    captureWidth   = D1_WIDTH;
    captureHeight  = D1_HEIGHT;

    if( video_input_setup( &captureFd, V4L2_DEVICE, &vidBufs, &numVidBufs, 
			&captureWidth, &captureHeight )
         == VIN_FAILURE ) {
        ERR( "Failed video_input_setup in video_thread_function\n" );
        status = VIDEO_THREAD_FAILURE;
        goto cleanup;
    }

    // Calculate size of a raw frame (in bytes)
    captureSize  = captureWidth * captureHeight * SCREEN_BPP / 8;

    // Record that capture device was opened in initialization bitmask
    initMask    |= CAPTUREDEVICEINITIALIZED;

// Thread Execute Phase -- perform I/O and processing
// **************************************************

    // Processing loop
    DBG( "Entering video_thread_fxn processing loop.\n" );

//    while( !envPtr->quit ) {
    for(i=0; i<100; i++) {

        // Initialize v4l2buf buffer for DQBUF call
        CLEAR( v4l2buf );
        v4l2buf.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        v4l2buf.memory = V4L2_MEMORY_MMAP;

        // Dequeue a frame buffer from the capture device driver
        if( ioctl( captureFd, VIDIOC_DQBUF, &v4l2buf ) == -1 ) {
            ERR( "VIDIOC_DQBUF failed in video_thread_fxn\n" );
            status = VIDEO_THREAD_FAILURE;
            break;
        }

        // Write length of data in buffer to output file
        if( fwrite( &captureSize, sizeof( captureSize ), 1, outputFile ) < 1 ) {
            ERR( "fwrite failed to FILE ptr %p\n", outputFile );
            status = VIDEO_THREAD_FAILURE;
            break;
        }

        // Write buffer to output file
        if( fwrite( vidBufs[ v4l2buf.index ].start, sizeof( char ), 
			captureSize, outputFile ) < captureSize ) {
            ERR( "fwrite failed to FILE ptr %p\n", outputFile );
            status = VIDEO_THREAD_FAILURE;
            break;
        }

        // Issue capture buffer back to capture device driver
        if( ioctl( captureFd, VIDIOC_QBUF, &v4l2buf ) == -1 ) {
            ERR( "VIDIOC_QBUF failed in video_thread_fxn\n" );
            status = VIDEO_THREAD_FAILURE;
            break;
        }
    }

    DBG( "Exited video_thread_fxn processing loop\n" );


// Thread Delete Phase -- free up resources allocated by this file
// ***************************************************************

cleanup:

    DBG( "Starting video thread cleanup to return resources to system\n" );

    // Close the video drivers
    // ***********************
    //  - Uses the initMask to only free resources that were allocated.

    // Close video capture device
    if( initMask & CAPTUREDEVICEINITIALIZED ) {
        video_input_cleanup( captureFd, vidBufs, numVidBufs );
    }

    // Close video output file
    if( initMask & OUTPUTFILEOPENED ) {
        DBG( "Closing output file at FILE * %p\n", outputFile );
        fclose( outputFile );
    }

    // Return from video_thread_fxn function
    // *************************************

    // Return the status at exit of the thread's execution
    DBG( "Video thread cleanup complete. Exiting video_thread_fxn\n" );
    return status;
}

