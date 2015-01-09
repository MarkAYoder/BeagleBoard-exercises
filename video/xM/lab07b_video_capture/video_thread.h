/*
 *   video_thread.h
 */

// Success and failure definitions for the thread
#define     VIDEO_THREAD_SUCCESS     ( void * ) 0
#define     VIDEO_THREAD_FAILURE     ( void * ) - 1

// Thread environment definition (i.e. what it needs to operate)
typedef  struct  video_thread_env
{
    int quit;                         // Thread will run as long as quit = 0
} video_thread_env;

// Function prototypes
void *video_thread_fxn( void *arg );

