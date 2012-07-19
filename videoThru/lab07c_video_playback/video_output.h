/*
 * video_output.h
 */

/* SUCCESS and FAILURE definitions for video display functions */
#define     VOUT_SUCCESS     0
#define     VOUT_FAILURE     -1

/* Custom Davinci FBDEV defines (should be in device driver header) */
#define     VID0_INDEX       0
#define     VID1_INDEX       1
#define     ZOOM_1X          0
#define     ZOOM_2X          1
#define     ZOOM_4X          2

#define     FBIO_SETZOOM        _IOW ( 'F', 0x24, struct Zoom_Params)
#define     FBIO_WAITFORVSYNC   _IOW ( 'F', 0x20 , u_int32_t )
#define     FBIO_GETSTD         _IOR ( 'F', 0x25 , u_int32_t )

struct  Zoom_Params
{
  u_int32_t WindowID;
  u_int32_t Zoom_H;
  u_int32_t Zoom_V;
} ;

/*  Function prototypes */
int  video_attribute_setup( char * device, unsigned char  trans );

int  video_output_setup( int * fdByRef, char * device, char ** displayBuffersArray, int  numDisplayBuffers,
                         int * displayWidthByRef, int * displayHeightByRef, u_int32_t  zoomFactor );

int  flip_display_buffers( int  fd, int  displayIdx );

void video_output_cleanup( int  fd, char ** displayBuffersArray, int  numDisplayBuffers );

