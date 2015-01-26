/*
 *   video_output.c
 */

// Standard Linux headers
#include     <stdio.h>                          // Always include stdio.h
#include     <stdlib.h>                         // Always include stdlib.h
#include     <string.h>                         // Defines memset and memcpy methods

#include     <fcntl.h>                          // Defines open, read, write methods
#include     <unistd.h>                         // Defines close and sleep methods
#include     <sys/mman.h>                       // Defines mmap method
#include     <sys/ioctl.h>                      // Defines ioctl method

#include     <linux/fb.h>                       // Defines framebuffer driver methods

// Application header files
#include     "video_output.h"                   // Video driver definitions
#include     "debug.h"                          // DBG and ERR macros

// Bits per pixel for video window
// Note:	The gfx buffer used by the OSD is 32 bits/pixel
//		The frame buffer used by the video is 16 bits/pixel
#define     SCREEN_BPP     16


/******************************************************************************
 * video_output_setup
 ******************************************************************************
 *  Input Parameters:                                                         *
 *      int *fdByRef      --  File descriptor passed by reference. It is used *
 *                            to return the file descriptor of the device     *
 *                            opened by this function.                        *
 *      char *device      --  Device node for FBDEV driver                    *
 *      char **displayBuffersArray -- an array of output buffer pointers.     *
 *                            The array must be allocated (i.e not just a     *
 *                            pointer with no memory assocaited with it)      *
 *                            The array is filled in as a return value with   *
 *                            pointers to the buffers mmap'ed by the driver   *
 *      int numDisplayBufs -- number of buffers for the driver to mmap        *
 *      int *displayWidthByRef -- used as both an input and output value:     *
 *                            on input: requested display frame width         *
 *                            on output: granted display frame width          *
 *      int *displayHeightByRef -- identical to displayWidthByRef,            *
 *                            but for height                                  *
 *      uint32_t zoomFactor -- zoom factor for display. Accepts:              *
 *                            ZOOM_1X, ZOOM_2X, ZOOM4X as defined in          *
 *                            video_display.h                                 *
 *                                                                            *
 *                                                                            *
 *  Return Value:                                                             *
 *      int  -- file descriptor of the newly opened display device, or        *
 *              VCAP_FAILURE if failure (VCAP_FAILURE must be negative)       *
 *                                                                            *
 ******************************************************************************/
int video_output_setup( int *fdByRef, char *device, char **displayBuffersArray,
                        int  numDisplayBuffers, int *displayWidthByRef,
                        int *displayHeightByRef, u_int32_t zoomFactor )
{
    int                        displayFd;             // File descriptor for opened device
    struct  fb_var_screeninfo  varInfo;               // Variable display screen information
    int                        frameSize, lineWidth;  // Line and frame sizes in bytes
    int                        i;                     // For loop index

    // Define a macro to handle the repetitive cleanup required upon failure
#define     failure_procedure( )                           \
                close  (  displayFd );                     \
                *fdByRef = -1;                             \
                for( i = 0; i < numDisplayBuffers; i++ )   \
                {                                          \
                    displayBuffersArray[ i ] = NULL;       \
                }                                          \
                *displayWidthByRef  = 0;                   \
                *displayHeightByRef = 0;                   \
                return VOUT_FAILURE

    DBG( "Initializing display device: %s\n", device );

    // Open the display device
    displayFd = open( device, O_RDWR );

    if( displayFd == -1 ) {
        ERR( "Failed to open fb device %s\n", device );
        failure_procedure( ) ;
    }
    DBG( "\tDisplay device opened with file descriptor: %d\n", displayFd );

    // Query driver for current state of variable screen info
    if( ioctl( displayFd, FBIOGET_VSCREENINFO, &varInfo ) == -1 ) {
        ERR( "Failed FBIOGET_VSCREENINFO on %s\n", device );
        failure_procedure( ) ;
    }

    // Configure display resolution

    // Setting xres_virtual = xres assures that a 1-d buffer will
    //       properly display.  (Otherwise would require zero filling
    //       of unused xres_virtual for each line.)
    // Multiple frames are mapped along y-axis as yres_virtual
    varInfo.xres           = *displayWidthByRef;
    varInfo.xres_virtual   = *displayWidthByRef;
    varInfo.yres           = *displayHeightByRef;
    varInfo.yres_virtual   = ( *displayHeightByRef ) * numDisplayBuffers;

    // Screen bits per pixel *must* be 16
    varInfo.bits_per_pixel = SCREEN_BPP;

/*
RGB565 (fbset -depth 16) 
RGB24 packed (fbset -depth 24) 
RGB24 unpacked (fbset -depth 32) 
YUV422 (fbset -nonstd 1) (only for video overlays) 
YUY422 (fbset -nonstd 8) (only for video overlays) 
From: http://groups.google.com/group/beagleboard/browse_thread/thread/9bc347f5f0853aa1/907f1ac3554b1a19?lnk=gst&q=fbset#907f1ac3554b1a19
*/
    varInfo.nonstd = 8; // use YUY422 format, the camera seems to require this

    // Request video display format
    if( ioctl( displayFd, FBIOPUT_VSCREENINFO, &varInfo ) == -1 ) {
        ERR( "Failed FBIOPUT_VSCREENINFO on file descriptor %d\n", displayFd );
        failure_procedure( ) ;
    }

    // Get allocated video display format
    if( ioctl( displayFd, FBIOGET_VSCREENINFO, &varInfo ) == -1 ) {
        ERR( "Failed FBIOFET_VSCREENINFO on file descriptor %d\n", displayFd );
        failure_procedure( ) ;
    }

    DBG( "=== Video Buffer Info ============\n" );
    DBG( "video xres        %d (%#x)\n", varInfo.xres, varInfo.xres );
    DBG( "video yres        %d (%#x)\n", varInfo.yres, varInfo.yres );
    DBG( "video xresVirtual %d (%#x)\n", varInfo.xres_virtual, varInfo.xres_virtual );
    DBG( "video yresVirtual %d (%#x)\n", varInfo.yres_virtual, varInfo.yres_virtual );
    DBG( "video format:     %d (%#x)\n", varInfo.nonstd, varInfo.nonstd );
    DBG( "video bits_per_pixel: %d\n", varInfo.bits_per_pixel );
    DBG( "==================================\n" );

    // Calculate frame size and line width based on granted resolution
    frameSize = varInfo.xres * varInfo.yres * SCREEN_BPP / 8;
    lineWidth = varInfo.xres * SCREEN_BPP / 8;

    // Map the video buffers to user space
    // xres_virtual = xres guarantees they can all be mapped as one
    //     continuous buffer
    displayBuffersArray[0] = (char *) mmap (NULL,
                                            frameSize * numDisplayBuffers,
                                            PROT_READ | PROT_WRITE,
                                            MAP_SHARED,
                                            displayFd,
                                            0);

    if( displayBuffersArray[ 0 ] == MAP_FAILED ) {
        ERR( "Failed mmap on file descriptor %d\n\tframeSize=%d, numDisplayBuffer=%d\n", 
		displayFd, frameSize, numDisplayBuffers );
        return VOUT_FAILURE;
    }

    // Set the displayBuffersArray array with offsets from the one
    //    continuous memory segment
    DBG( "\tMapped display buffer 0, size %d to location %p\n", frameSize,
         displayBuffersArray[ 0 ] );
    for( i = 1; i < numDisplayBuffers; i++ ) {
        displayBuffersArray[ i ] = displayBuffersArray[ i - 1 ] + frameSize;
        DBG( "\tMapped display buffer %d, size %d to location %p\n", i, frameSize,
             displayBuffersArray[ i ] );
    }

    // Set return-by-reference values and return VOUT_SUCCESS
    // (note: displayBuffersArray has already been filled)

    // Allocated is not guaranteed to be the same as requested value.
    //    return actual allocated value via provided pointers
    *displayWidthByRef  = varInfo.xres;
    *displayHeightByRef = varInfo.yres;

    // Return file descriptor for newly opened device via supplied pointer
    *fdByRef            = displayFd;

    // Return the file descriptor of the newly opened device.
    return VOUT_SUCCESS;
}

/******************************************************************************
 * flip_display_buffers
 ******************************************************************************
 *  Input Parameters:                                                         *
 *      int displayFd   -- file descriptor for the driver as returned by      *
 *                         video_output_setup                                 *
 *      int displayIdx  -- index of the output buffer to be displayed         *
 *                                                                            *
 *                                                                            *
 *  Return Value:                                                             *
 *      int  --  VOUT_SUCCESS or VOUT_FAILURE as defined in                   *
 *               video_display.h                                              *
 *                                                                            *
 ******************************************************************************/
int flip_display_buffers( int  displayFd, int  displayIdx )
{
    struct  fb_var_screeninfo  vInfo;	// Variable info for display screen

    // Get current state of the display screen variable information
    if( ioctl( displayFd, FBIOGET_VSCREENINFO, &vInfo ) == -1 ) {
        ERR( "Failed FBIOGET_VSCREENINFO\n" );
        return VOUT_FAILURE;
    }

    // Modify y offset to select a display screen
    vInfo.yoffset = vInfo.yres * displayIdx;

    // Swap the working buffer for the displayed buffer
    if( ioctl( displayFd, FBIOPAN_DISPLAY, &vInfo ) == -1 ) {
        ERR( "Failed FBIOPAN_DISPLAY\n" );
        return VOUT_FAILURE;
    }

    // Halt thread until FBIOPAN_DISPLAY is latched at VSYNC

	// This is a real hack.  This is defined in .../include/linux/omapfb.h,  
	// but doesn't work from there.
#define OMAP_IO(num)		_IO('O', num)
#define OMAPFB_WAITFORVSYNC	OMAP_IO(57)
    if( ioctl( displayFd, OMAPFB_WAITFORVSYNC, &vInfo ) == -1 ) {
        ERR( "Failed OMAPFB_WAITFORVSYNC\n" );
        return VOUT_FAILURE;
    }

    return VOUT_SUCCESS;
}


/******************************************************************************
 * video_output_cleanup
 ******************************************************************************
 *  Input Parameters:                                                         *
 *      int displayFd   -- file descriptor for the driver as returned by      *
 *                         video_output_setup                                 *
 *      char *displayBuffersArray -- pointer to the array of driver buffer    *
 *                         pointers that was filled by video_output_setup     *
 *      int numDisplayBuffers     -- number of buffers in displayBuffersArray *
 *                                                                            *
 *                                                                            *
 *  Return Value:                                                             *
 *      int  --  VOUT_SUCCESS or VOUT_FAILURE as defined in                   *
 *               video_display.h                                              *
 *                                                                            *
 ******************************************************************************/
void video_output_cleanup( int  displayFd, char ** displayBuffersArray, int  numDisplayBuffers )
{
    struct  fb_var_screeninfo  varInfo;                         // Variable display screen info
    int                        frameSize;                       // Display frame size in bytes

    // Get display frame resolution from the variable info
    if( ioctl( displayFd, FBIOGET_VSCREENINFO, &varInfo ) == -1 ) {
        ERR( "Failed FBIOFET_VSCREENINFO for file descriptor %d\n", displayFd );
    }

    // Calculate frame size so we know how much to un-map
    frameSize = varInfo.xres * varInfo.yres * SCREEN_BPP / 8;

    // Un-memory-map display buffers from this process
    munmap( displayBuffersArray[ 0 ], frameSize * numDisplayBuffers );

    DBG( "Unmapped contiguous display buffer block of\n" );
    DBG( "\tsize %d at location %p\n", ( frameSize * numDisplayBuffers ), 
		displayBuffersArray[ 0 ] );

    // Close display device
    close( displayFd );

    DBG( "Closed video display device (file descriptor %d)\n", displayFd );

}

