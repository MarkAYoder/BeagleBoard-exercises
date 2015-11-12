/*
 *   audio_input_output.h
 */

/* Success and Failure definitions for audio functions */
#define     AUDIO_SUCCESS     0
#define     AUDIO_FAILURE     -1

//* The number of channels of the audio codec **
#define     NUM_CHANNELS     2
#define     BYTESPERFRAME    4

/* Function prototypes */
int audio_io_setup(snd_pcm_t **pcm_handle, char *soundDevice, int sampleRate,
			snd_pcm_stream_t stream, snd_pcm_uframes_t *exact_bufsize );
int audio_io_cleanup( snd_pcm_t *pcm_handle );

