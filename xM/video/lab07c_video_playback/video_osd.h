/*
 * video_osd.h
 */

// Set if attributes window is to be used (Don't define for Beagle)
#undef		ATTR		// Define if attributes widow is to be used --may	

/* SUCCESS and FAILURE definitions for video display functions */
#define     VOSD_SUCCESS     0
#define     VOSD_FAILURE     -1

/* Global Variables Definitions */
extern  struct  fb_var_screeninfo  osdInfo;

/* Function prototypes */
int video_osd_setup( int * osdFdByRef, char * osdDevice, 
                     unsigned char  trans, unsigned int ** osdDisplayByRef );

int video_osd_place( unsigned int * osdDisplay, unsigned int * picture,
                     int  x_offset, int  y_offset, int  x_picsize, int  y_picsize );

int video_osd_cleanup( int  osdFd, unsigned int * osdDisplay );

int video_osd_scroll( unsigned int * osdDisplay, unsigned int * picture,
                      int  x_offset, int  y_offset, int  x_picsize, int  y_picsize, int  x_scroll, int  y_scroll );

int video_osd_circframe( unsigned int * osdDisplay, unsigned int  fillval );

