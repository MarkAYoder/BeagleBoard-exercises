/*
 *   video_input.h
 */

/* FAILURE and SUCCESS definitions for the video capture functions */
#define     VIN_FAILURE     -1
#define     VIN_SUCCESS     0

/* Describes a capture frame buffer */
typedef  struct  VideoBuffer
{
  void   * start;
  size_t  length;
} VideoBuffer;

/* Function prototypes */
        int video_input_setup( int * fdByRef, char * device, VideoBuffer ** vidBufsPtrByRef, unsigned int * numVidBufsByRef,
                               int * captureWidthByRef, int * captureHeightByRef );

        int video_input_cleanup( int  fd, VideoBuffer * vidBufsPtr, int  numVidBufs );

inline  int wait_for_frame( int  fd );

