/*
 * autogain.c - Sets the AUTOGAIN on a PlayStation Eye
 */

/* Standard Linux headers */
#include     <stdio.h>               //always include stdio.h
#include     <stdlib.h>              //always include stdlib.h
#include     <fcntl.h>               //defines open, read, write methods
#include     "debug.h"               //DBG and ERR macros

#include     <linux/videodev2.h>     //v4l2 driver definitions

#define     V4L2_DEVICE    "/dev/video0"

//*****************************************************************************
//*  main
//*****************************************************************************
int main( int argc, char *argv[] )
{
    int	captureFd;      //  < video capture file descriptor >


    if( ( captureFd = open( V4L2_DEVICE, O_RDWR, 0 ) ) == -1 )
    {
        ERR( "Cannot open %s\n", V4L2_DEVICE );
    }

    struct v4l2_control control;
    control.id = V4L2_CID_AUTOGAIN;
    control.value = 1;

    if(ioctl (captureFd, VIDIOC_S_CTRL, &control) == -1) {
	ERR("Setting AUTOGAIN failed\n");
	} else {
	printf("AUTOGAIN set\n");
	}

    close( captureFd );
}


