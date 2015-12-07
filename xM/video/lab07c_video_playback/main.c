/*
 *   main.c
 *
 * ============================================================================
 * Copyright (c) Texas Instruments Inc 2005
 *
 * Use of this software is controlled by the terms and conditions found in the
 * license agreement under which this software has been supplied or provided.
 * ============================================================================
 */

// Standard Linux headers
#include     <stdio.h>	// Always include this header
#include     <stdlib.h>	// Always include this header
#include     <signal.h>	// Defines signal-handling functions (i.e. trap Ctrl-C)

// Application headers
#include     "debug.h"
#include     "video_thread.h"

/* Global thread environments */
video_thread_env video_env = {0};

/* Store previous signal handler and call it */
void (*pSigPrev)(int sig);

/* Callback called when SIGINT is sent to the process (Ctrl-C) */
void signal_handler(int sig) {
    DBG( "Ctrl-C pressed, cleaning up and exiting..\n" );

    video_env.quit = 1;

    if( pSigPrev != NULL )
        (*pSigPrev)( sig );
}

//*****************************************************************************
//*  main
//*****************************************************************************
int main(int argc, char *argv[])
{
/* The levels of initialization for initMask */
#define VIDEOTHREADATTRSCREATED 0x1
#define VIDEOTHREADCREATED      0x2
    unsigned int    initMask  = 0;
    int             status    = EXIT_SUCCESS;

    void *videoThreadReturn;

    /* Set the signal callback for Ctrl-C */
    pSigPrev = signal( SIGINT, signal_handler );

    /* Make video frame buffer visible */
    system("cd ..; ./vid1Show");

    /* Create a thread for video */
    DBG( "Creating video thread\n" );
    printf( "\tPress Ctrl-C to exit\n" );

    videoThreadReturn = video_thread_fxn( (void *) &video_env );

    initMask |= VIDEOTHREADCREATED;

//cleanup:
    /* Make video frame buffer invisible */
    system("cd ..; ./resetVideo");

    exit( status );
}
