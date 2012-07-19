/*
 *   audio_thread.h
 */

// Success and failure definitions for the thread
#define     AUDIO_THREAD_SUCCESS     ( ( void * ) 0 )
#define     AUDIO_THREAD_FAILURE     ( ( void * ) - 1 )

// Thread environment definition (i.e. what it needs to operate)
typedef  struct  audio_thread_env
{
    int quit;                // Thread will run as long as quit = 0
} audio_thread_env;

// Function prototypes
void * audio_thread_fxn( void * envByRef );

