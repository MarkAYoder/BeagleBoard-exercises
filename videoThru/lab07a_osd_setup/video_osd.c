/*
 *   video_osd.c
 */

// Standard Linux headers
#include     <stdio.h>		// Always include stdio.h
#include     <stdlib.h>		// Always include stdlib.h
#include     <string.h>		// Defines memset and memcpy methods

#include     <fcntl.h>		// Defines open, read, write methods
#include     <unistd.h>		// Defines close and sleep methods
#include     <sys/mman.h>	// Defines mmap method
#include     <sys/ioctl.h>	// Defines ioctl method

#include     <linux/fb.h>	// Defines framebuffer driver methods

// Application header files
#include     "video_osd.h"	// Video driver definitions
#include     "debug.h"		// DBG and ERR macros

#define     SCREEN_BPP     4	// Bytes per pixel for gfx window

// Global variables to hold osd window attributes
struct  fb_var_screeninfo  osdInfo;


/******************************************************************************
 *  video_osd_setup                                                           *
 ******************************************************************************
 *  input parameters:                                                         *
 *  int *osdFdByRef     -- used to return the file desc of OSD device         *
 *      char *osdDevice     -- string containing name of OSD device           *
 *      unsigned char trans -- Initial alpha value			      *
 *      unsigned int   **osdDisplayByRef -- used to return a pointer to the   *
 *                             mmap'ed osd buffer                             *
 *                                                                            *
 ******************************************************************************/
int video_osd_setup( int * osdFdByRef, char * osdDevice, 
                     unsigned char  trans, unsigned int ** osdDisplayByRef )
{
    int size;
    int i, j;

    *osdFdByRef = open( osdDevice, O_RDWR );

    if( *osdFdByRef == -1 ) {
        ERR( "Failed to open OSD device %s\n", osdDevice );
        return VOSD_FAILURE;
    }
    DBG( "OSD device %s opened with file descriptor %d\n", osdDevice, *osdFdByRef );

    if( ioctl( *osdFdByRef, FBIOGET_VSCREENINFO, &osdInfo ) == -1 ) {
        ERR( "Error reading variable info for file descriptor %d\n", *osdFdByRef );
        close( *osdFdByRef );
        return VOSD_FAILURE;
    }
    DBG( "--- Osd Buffer Info ---------------\n" );
    DBG( "osdInfo xres         %d (%#x)\n", osdInfo.xres, osdInfo.xres );
    DBG( "osdInfo yres         %d (%#x)\n", osdInfo.yres, osdInfo.yres );
    DBG( "osdInfo xresVirtual  %d (%#x)\n", osdInfo.xres_virtual, 
						osdInfo.xres_virtual );
    DBG( "osdInfo yresVirtual  %d (%#x)\n", osdInfo.yres_virtual, 
						osdInfo.yres_virtual );
    DBG( "==================================\n" );

    // 32 bits per pixel (4 bytes)
    size = osdInfo.xres_virtual * osdInfo.yres * SCREEN_BPP;

    *osdDisplayByRef = (unsigned int *) mmap(NULL, size,
                                          PROT_READ | PROT_WRITE,
                                          MAP_SHARED, *osdFdByRef, 0);
    if( *osdDisplayByRef == MAP_FAILED ) {
        ERR( "Failed mmap on file descripor %d\n", *osdFdByRef );
        close( *osdFdByRef );
        return VOSD_FAILURE;
    }
    DBG( "Mapped osd window to location %p, size %d (%#x)\n", 
			*osdDisplayByRef, size, size );

    // Fill the window with the new attribute value
//    for(i=0; i<size/4; i++) {
//	(*osdDisplayByRef)[i] = (trans<<24) | 0x00ff0000;	// AARRGGBB
//    }
    // Fill in the upper left half of the screen
    for(j=0; j<osdInfo.yres/2; j++)
	for(i=0; i<osdInfo.xres/2; i++) {
	    (*osdDisplayByRef)[i + j*osdInfo.xres] = 
		(trans<<24) | 0x00ff0000;	// AARRGGBB
	}

    DBG( "\tFilled OSD window with pattern: 0x%08x\n" , (trans<<24) | 0x00ff0000);

    return VOSD_SUCCESS;
}

/******************************************************************************
 *  video_osd_place                                                           *
 *	Assume input is a bmp file with stores values bottom row first	      *
 ******************************************************************************
 *  input parameters:                                                         *
 *      unsigned int *osdDisplay     -- mmap'ed location of osd window        *
 *      unsigned int *picture      -- bitmapped picture array		      *
 *      int x_offset                 -- x offset to place picture in osd      *
 *      int y_offset                 -- y offset to place picture in osd      *
 *      int x_picsize                -- x dimension of picture                *
 *      int y_picsize                -- y dimension of picture                *
 *                                                                            *
 *  NOTE: this function does not check offsets and picture size against       *
 *      dimensions of osd and attr window. If your math is wrong, you will    *
 *      get a segmentation fault (or worse)                                   *
 *                                                                            *
 ******************************************************************************/
int video_osd_place( unsigned int * osdDisplay, 
                     unsigned int * picture, int  x_offset,
                     int  y_offset, int  x_picsize, int  y_picsize )
{
    int i;
    unsigned  int      * displayOrigin;

    displayOrigin = osdDisplay + ( y_offset * osdInfo.xres ) + x_offset;

    for( i = 0; i < y_picsize; i++ ) {
        memcpy( displayOrigin + ( i * osdInfo.xres ), 
		picture       + ((y_picsize-i-1) * x_picsize ), 
		( x_picsize<<2 ) );
    }

    return VOSD_SUCCESS;
}

/******************************************************************************
 *  video_osd_scroll                                                          *
 ******************************************************************************
 *  input parameters:                                                         *
 *      unsigned short *osdDisplay   -- mmap'ed location of osd window        *
 *      unsigned short *picture      -- bitmapped picture array               *
 *      int x_offset                 -- x offset to place picture in osd      *
 *      int y_offset                 -- y offset to place picture in osd      *
 *      int x_picsize                -- x dimension of picture                *
 *      int y_picsize                -- y dimension of picture                *
 *      int x_scroll                 -- x scrolling offset                    *
 *      int y_scroll                 -- y scrolling offset                    *
 *                                                                            *
 *  NOTE: this function does not check offsets and picture size against       *
 *      dimensions of osd and attr window. If your math is wrong, you will    *
 *      get a segmentation fault (or worse)                                   *
 *                                                                            *
 ******************************************************************************/
int video_osd_scroll( unsigned int * osdDisplay, 
                      unsigned int * picture,
                      int  x_offset,  int  y_offset, int  x_picsize,
                      int  y_picsize, int  x_scroll, int  y_scroll )
{
    int i;
    unsigned int *displayOrigin;

    displayOrigin = osdDisplay + ( y_offset * osdInfo.xres_virtual ) + x_offset;

    for( i = 0; i < ( y_picsize - y_scroll ); i++ )
    {
        memcpy( displayOrigin + ( i * osdInfo.xres_virtual ),
                picture + (( i + y_scroll ) * x_picsize ) + x_scroll,
                (( x_picsize - x_scroll )<<2 ));
        memcpy( displayOrigin + ( i * osdInfo.xres_virtual ) + ( x_picsize - x_scroll ),
                picture + (( i + y_scroll ) * x_picsize ), (( x_scroll )<<1 ));

    }
    for( i = ( y_picsize - y_scroll ); i < y_picsize; i++ )
    {
        memcpy( displayOrigin + ( i * osdInfo.xres_virtual ),
                picture + (( i - y_picsize + y_scroll ) * x_picsize ) + x_scroll,
                (( x_picsize - x_scroll )<<2 ));
        memcpy( displayOrigin + ( i * osdInfo.xres_virtual ) + ( x_picsize - x_scroll ),
                picture + (( i - y_picsize + y_scroll ) * x_picsize ), ( x_scroll<<1 ));
    }


    return VOSD_SUCCESS;
}

/******************************************************************************
 *  video_osd_circframe
 ******************************************************************************
 *  input parameters:                                                         *
 *      unsigned short *osdDisplay   -- mmap'ed location of osd window        *
 *      unsigned short fillval       -- color fill for the frame in ARGB      *
 *                                                                            *
 ******************************************************************************/
int video_osd_circframe( unsigned int * osdDisplay, unsigned int  fillval )
{
    int i, j;
    float x, y, x_scale, y_scale;

    DBG( "Entering video_osd_circframe\n" );

    // Center circle in upper left quarter
    x_scale = (float) (osdInfo.xres >> 2);
    y_scale = (float) (osdInfo.yres >> 2);

    DBG( "Entering video_osd_circframe for-loop\n" );

    for( j = 0; j < osdInfo.yres/2; j++ ) {
        y = ( float )j - y_scale;
        for( i = 0; i < osdInfo.xres/2; i++ ) {
            x = ( float )i - x_scale;
	    if (((x*x /(x_scale*x_scale)) + (y*y/(y_scale*y_scale))) > 0.9) {
                osdDisplay[i + j*osdInfo.xres] = fillval;
            }
        }
    }
    DBG( "Exiting video_osd_circframe\n" );

    return VOSD_SUCCESS;
}

/******************************************************************************
 *  video_osd_cleanup
 ******************************************************************************
 *  input parameters:                                                         *
 *      int osdFd                   -- file descriptor of open attr window    *
 *      unsigned short *osdDisplay  -- mmap'ed location of osd window         *
 *                                                                            *
 ******************************************************************************/
int video_osd_cleanup( int  osdFd, unsigned int * osdDisplay )
{
    struct  fb_var_screeninfo  vInfo;
    int                        size;

    DBG( "Entering osd window cleanup\n" );

    if( ioctl( osdFd, FBIOGET_VSCREENINFO, &vInfo ) == -1 )
    {
        ERR( "Error reading variable information for file descriptor %d\n", osdFd );
        close( osdFd );
        return VOSD_FAILURE;
    }

    // 32 bits per pixel
    size = vInfo.xres_virtual * vInfo.yres * SCREEN_BPP;

    munmap( osdDisplay, size );
    close( osdFd );

    DBG( "\tClosed osd window (file descriptor: %d)\n", osdFd );
    DBG( "\tUnmapped osd window memory (%p)\n", osdDisplay );

    return VOSD_SUCCESS;
}
