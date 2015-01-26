/*
 * video_input.c
 */

/* Standard Linux headers */
#include     <stdio.h>                       //always include stdio.h
#include     <stdlib.h>                      //always include stdlib.h
#include     <string.h>                      //defines memset and memcpy methods
#include     <errno.h>

#include     <fcntl.h>                       //defines open, read, write methods
#include     <unistd.h>                      //defines close and sleep methods
#include     <sys/mman.h>                    //defines mmap method
#include     <sys/ioctl.h>                   //defines ioctl method

#include     <asm/types.h>           //standard typedefs required by v4l2 header
#include     <linux/videodev2.h>     //v4l2 driver definitions

/* Application header files */
#include     "video_input.h"
#include     "debug.h"                        //DBG and ERR macros

/* Macro for clearing structures */
#define     CLEAR(x) memset (&(x), 0, sizeof (x))

/******************************************************************************
 * video_input_setup
 ******************************************************************************/
/*  input parameters:                                                         */
/*      int *fdByRef  --   file descriptor passed by reference. Used to       */
/*                         return the file descriptor of newly opened device  */
/*      char *device  --   device node for V4L2 capture driver                */
/*      VideoBuffer **vidBufsPtrByRef  --  pointer to VideoBuffer structure   */
/*                         that is passed by reference.                       */
/*                         (VideoBuffer struct def in video_capture.h )       */
/*                         used to return the location of an array of type    */
/*                         VideoBuffer describing buffers allocated by the    */
/*                         capture device.                                    */
/*      int *numVidBufsByRef  -- used as both an input and output value:      */
/*                         on input, *numVidBufsByRef is the requested # bufs */
/*                         on output it is filled with the actual # alloc'd   */
/*      int *captureWidthByRef -- used as both an input and output value:     */
/*                         on input: requested capture frame width            */
/*                         on output: granted capture frame width             */
/*      int *captureHeightByRef -- identical to captureWidthByRef,            */
/*                         but for height                                     */
/*                                                                            */
/*                                                                            */
/*  return value:                                                             */
/*      int  -- VIN_SUCCESS or VIN_FAILURE as defined in video_input.h        */
/*                                                                            */
/******************************************************************************/
int video_input_setup( int * fdByRef, char * device, VideoBuffer ** vidBufsPtrByRef,
			unsigned int * numVidBufsByRef, int * captureWidthByRef, 
			int * captureHeightByRef )
{
    struct  v4l2_requestbuffers	req;		//  < buffer request structure >
    enum  v4l2_buf_type		type;		//  < buffer type >
    struct  v4l2_buffer		buf;		//  < V4L2 buffer descriptor >
    VideoBuffer			*buffersPtr;    //  < ptr to array of buffers >
    int				numBufs;        //  < number buffers pointed to by buffersPtr >

    struct  v4l2_format		fmt;		//  < buffer format >
    int				captureFd;	//  < video capture file descriptor >

    /* Define a macro to handle the (repetitive) cleanup for a failure */
#define     failure_procedure( )                                                                                      \
                close  (  captureFd );                                                                                \
                *fdByRef            = -1;	\
                *vidBufsPtrByRef    = NULL;	\
                *numVidBufsByRef    = 0;	\
                *captureWidthByRef  = 0;	\
                *captureHeightByRef = 0;	\
                return VIN_FAILURE

    DBG( "Initializing video capture device: %s\n", device );

    /* Open video capture device */

    if( ( captureFd = open( device, O_RDWR, 0 ) ) == -1 ) {
        ERR( "Cannot open %s\n", device );
        failure_procedure( ) ;	//    macro defined at top of this function
    }

    DBG( "\tVideo capture device opened with file descriptor: %d\n", captureFd );

//+++++++++++++++++++++++++++++++
// The following lists the difference contols understood by the video device
// From: http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#standard

struct v4l2_input input;

	memset (&input, 0, sizeof (input));

	if (-1 == ioctl (captureFd, VIDIOC_G_INPUT, &input.index)) {
		perror ("VIDIOC_G_INPUT");
		exit (EXIT_FAILURE);
	}

	if (-1 == ioctl (captureFd, VIDIOC_ENUMINPUT, &input)) {
		perror ("VIDIOC_ENUM_INPUT");
		exit (EXIT_FAILURE);
	}

	printf ("Current input: %s\n", input.name);

//+++++++++++++++++++++++++++++++
	// Turn on autogain
	struct v4l2_control control;
	control.id = V4L2_CID_AUTOGAIN;
	control.value = 1;

	if(ioctl (captureFd, VIDIOC_S_CTRL, &control) == -1) {
	    ERR("Setting AutoGain failed\n");
	    }
	    
    /* Set the captured buffer format to UYUV interlaced w/ given resolution */
    CLEAR( fmt );

    fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
    fmt.fmt.pix.field       = V4L2_FIELD_NONE;

    fmt.fmt.pix.width       = *captureWidthByRef;
    fmt.fmt.pix.height      = *captureHeightByRef;

#define	f fmt.fmt.pix.pixelformat
    DBG( "\tFormat    %d (%#x) %c%c%c%c\n", f, f, 
		f&0xff, (f>>8)&0xff, (f>>16)&0xff, (f>>24)&0xff );

    /* Set the video capture format */
    if( ioctl( captureFd, VIDIOC_S_FMT, &fmt ) == -1 ) {
        ERR( "VIDIOC_S_FMT failed on file descriptor %d\n", captureFd );
        failure_procedure( ) ;	//    macro defined at top of this function
    }

    DBG( "\tCapturing %dx%d video \n", fmt.fmt.pix.width, fmt.fmt.pix.height );
#define	f fmt.fmt.pix.pixelformat
    DBG( "\tFormat    %d (%#x) %c%c%c%c\n", f, f, 
		f&0xff, (f>>8)&0xff, (f>>16)&0xff, (f>>24)&0xff );

    /* Request the capture device allocate N memory mapped video capture */
    /*     buffers -- where N is specified by dereferencing numVidBufPtr */
    CLEAR( req );

    req.count  = *numVidBufsByRef;
    req.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    req.memory = V4L2_MEMORY_MMAP;

    /* Allocate buffers in the capture device driver */
    if( ioctl( captureFd, VIDIOC_REQBUFS, &req ) == -1 ) {
        ERR( "VIDIOC_REQBUFS failed on file descriptor %d\n", captureFd );
        return VIN_FAILURE;
    }

    DBG( "%d capture buffers were successfully allocated.\n", req.count );

    /* if the driver can't allocate all buffers, it will allocate as many */
    /*     as it can and set req.count to this value                      */
    if( req.count < *numVidBufsByRef ) {
        ERR( "Insufficient buffer memory on file descriptor %d\n", captureFd );
        failure_procedure( ) ;	// macro defined at top of this function
    }

    /* Allocate memory for the array of buffer descriptors                */
    buffersPtr = calloc( req.count, sizeof( *buffersPtr ) );

    if( !buffersPtr ) {
        ERR( "Failed to allocate memory for capture buffer structs.\n" );
        close( captureFd );
        failure_procedure( ) ;	// macro defined at top of this function
    }

    /* Map the allocated buffers to user space and store their locations   */
    /*     in the array pointed to by buffersPtr.                          */
    for( numBufs = 0; numBufs < req.count; numBufs++ ) {
        CLEAR( buf );

        /* type, memory and index are inputs in the buf structure for      */
        /*      VIDIOC_QUERYBUF ioctl, which will return the corresponding */
        /*      buffer length (based on format and cropping settings       */
        /*      already specified) as well as an offset value from a       */
        /*      driver-memory-space pointer. These values are then used to */
        /*      mmap the buffers into user space.                          */
        buf.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory = V4L2_MEMORY_MMAP;
        buf.index  = numBufs;

        if( ioctl( captureFd, VIDIOC_QUERYBUF, &buf ) == -1 ) {
            ERR( "Failed VIDIOC_QUERYBUF on file descriptor %d\n", captureFd );
            failure_procedure( ) ;	// macro defined at top of this function
        }

        /* use buf.length and buf.m.offset returned by VIDIOC_QUERYBUF to   */
        /*      fill in buffer descriptor array with location and size of   */
        /*      each buffer allocated by V4L2 capture device.               */
        buffersPtr[ numBufs ].length = buf.length;
        buffersPtr[numBufs].start = mmap (  NULL,
                                            buf.length,
                                            PROT_READ | PROT_WRITE,
                                            MAP_SHARED,
                                            captureFd,
                                            buf.m.offset);

        if( buffersPtr[ numBufs ].start == MAP_FAILED ) {
            ERR( "Failed to mmap buffer on file descriptor %d\n", captureFd );
            failure_procedure( ) ;	// macro defined at top of this function
        }

        DBG( "\tCapture buffer %d, size %d mapped to address %p\n",
		numBufs, buf.length, buffersPtr[ numBufs ].start );

        /*  Enqueue all of the allocated buffers to be available for capture */
        if( ioctl( captureFd, VIDIOC_QBUF, &buf ) == -1 ) {
            ERR( "VIODIOC_QBUF failed on file descriptor %d\n", captureFd );
            failure_procedure( ) ;	// macro defined at top of this function
        }
    }

    /* Start the video streaming */
    type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

    if( ioctl( captureFd, VIDIOC_STREAMON, &type ) == -1 ) {
        ERR( "VIDIOC_STREAMON failed on file descriptor %d\n", captureFd );
        failure_procedure( ) ;	// macro defined at top of this function
    }

    /* Return VIN_SUCCESS and the various returns by reference */
    /* return the file descriptor of the newly opened device */
    *fdByRef            = captureFd;

    /* Return buffers and numBufs values through provided pointers */
    *vidBufsPtrByRef    = buffersPtr;
    *numVidBufsByRef    = numBufs;

    /* Capture width and height may be different from requested values */
    *captureWidthByRef  = fmt.fmt.pix.width;
    *captureHeightByRef = fmt.fmt.pix.height;

    return VIN_SUCCESS;
}

/******************************************************************************
 * video_input_cleanup
 ******************************************************************************/
/*  input parameters:                                                         */
/*      int fd          -- file descriptor for the driver as returned by      */
/*                         video_input_setup                                  */
/*      VideoBuffer *vidBufsPtr  -- pointer to an array of video buffers      */
/*                         allocated by the capture device, i.e.              */
/*                         *vidBufsPtrByRef as returned by reference from     */
/*                         video_input_setup                                  */
/*                         (VideoBuffer struct defined in video_capture.h )   */
/*      int numVidBufs  -- number of video buffers pointed to by vidBufsPtr   */
/*                                                                            */
/*                                                                            */
/*  return value:                                                             */
/*      int  --  VIN_SUCCESS or VIN_FAILURE as defined in video_capture.h     */
/*                                                                            */
/******************************************************************************/
int video_input_cleanup( int  fd, VideoBuffer *vidBufsPtr, int  numVidBufs )
{
    enum  v4l2_buf_type  type;			//  < video buffer type >
    unsigned  int        i;			//  < for loop index >
              int        status = VIN_SUCCESS;	//  < return value for function >

    /* Shut off the video capture */
    type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    if( ioctl( fd, VIDIOC_STREAMOFF, &type ) == -1 ) {
        ERR( "VIDIOC_STREAMOFF failed\n" );
        status = VIN_FAILURE;
    }
    DBG( "Halted video capture stream on file descriptor %d\n", fd );

    /* Unmap the capture frame buffers from user space */
    for( i = 0; i < numVidBufs; ++i ) {
        if( munmap( vidBufsPtr[ i ].start, vidBufsPtr[ i ].length ) == -1 ) {
            ERR( "Failed to unmap capture buffer %d\n", i );
            status = VIN_FAILURE;
        } else {
            DBG( "\tunmapped video capture frame, size %d located at %p\n",
                 vidBufsPtr[ i ].length, vidBufsPtr[ i ].start );
        }
    }

    /* Free the array itself after each buffer described by it has been freed */
    free  (  vidBufsPtr );

    if( close( fd ) == -1 ) {
        ERR( "Failed to close capture device\n" );
        status = VIN_FAILURE;
    }
    DBG( "\tClosed video capture device (file descriptor %d)\n", fd );

    return status;
}

