/*
 *   audio_input_output.c
 */
// Modfied for ALSA input/output 6-May-2011, Mark A. Yoder

// Based on Basic PCM audio (http://www.suse.de/~mana/alsa090_howto.html#sect02)http://www.suse.de/~mana/alsa090_howto.html#sect03

//* Standard Linux headers **
#include    <stdio.h>                           // Always include stdio.h
#include    <stdlib.h>                          // Always include stdlib.h
#include    <alsa/asoundlib.h>			// ALSA includes

//* Application headers **
#include     "audio_input_output.h"             // Audio i/o methods and types
#include     "debug.h"                          // Defines debug routines

//*******************************************************************************
//*  audio_io_setup
//*******************************************************************************
//*  Input parameters:                                                         **
//*   snd_pcm_t **pcm_handle--  A pointer to a point to the ALSA device.       **
//*   char *soundDevice     --  string value for ALSA driver device node,      **
//*                             such as "plughw:0,0"                           **
//*   int samplerate        --  sample rate in Hertz, i.e. 44100               **
//*   snd_pcm_stream_t stream-- Either SND_PCM_STREAM_CAPTURE to record or     **
//*				SND_PCM_STREAM_PLAYBACK to playback            **
//*   snd_pcm_uframes_t *exact_bufsize_handle				       **
//*			    --  Pointer to the desired buffersize.  The value  **
//*				is updated to the size that was granted.       **
//*                                                                            **
//*  Return value:                                                             **
//*      int  --  AUDIO_SUCCESS or AUDIO_FAILURE as per audio_input_output.h   **
//*                                                                            **
//*******************************************************************************
int audio_io_setup(snd_pcm_t **pcm_handle, char *soundDevice, int sampleRate,
			snd_pcm_stream_t stream, snd_pcm_uframes_t *exact_bufsize_handle )
{
    /* This structure contains information about    */
    /* the hardware and can be used to specify the  */      
    /* configuration to be used for the PCM stream. */ 
    snd_pcm_hw_params_t *hwparams;

/*  
The most important ALSA interfaces to the PCM devices are the "plughw" and the "hw" interface. If you use the "plughw" interface, you need not care much about the sound hardware. If your soundcard does not support the sample rate or sample format you specify, your data will be automatically converted. This also applies to the access type and the number of channels. With the "hw" interface, you have to check whether your hardware supports the configuration you would like to use.
*/
    /* Name of the PCM device, like plughw:0,0          */
    /* The first number is the number of the soundcard, */
    /* the second number is the number of the device.   */
    char *pcm_name;
  
// Then we initialize the variables and allocate a hwparams structure:
    /* Init pcm_name. Of course, later you */
    /* will make this configurable ;-)     */
    pcm_name = strdup(soundDevice);
  
    /* Allocate the snd_pcm_hw_params_t structure on the stack. */
    snd_pcm_hw_params_alloca(&hwparams);
  
// Now we can open the PCM device:
    /* Open PCM. The last parameter of this function is the mode. */
    /* If this is set to 0, the standard mode is used. Possible   */
    /* other values are SND_PCM_NONBLOCK and SND_PCM_ASYNC.       */ 
    /* If SND_PCM_NONBLOCK is used, read / write access to the    */
    /* PCM device will return immediately. If SND_PCM_ASYNC is    */
    /* specified, SIGIO will be emitted whenever a period has     */
    /* been completely processed by the soundcard.                */
	DBG( "pcm_handle before snd_pcm_open = %d\n", (int) pcm_handle);
    if (snd_pcm_open(pcm_handle, pcm_name, stream, 0) < 0) {
      ERR( "Error opening PCM device %s\n", pcm_name);
      return AUDIO_FAILURE;
    }
	DBG( "pcm_handle after snd_pcm_open = %d\n", (int) pcm_handle);

/* 
Before we can write PCM data to the soundcard, we have to specify access type, sample format, sample rate, number of channels, number of periods and period size. First, we initialize the hwparams structure with the full configuration space of the soundcard.
*/
    /* Init hwparams with full configuration space */
    if (snd_pcm_hw_params_any(*pcm_handle, hwparams) < 0) {
      ERR( "Cannot configure this PCM device.\n");
      return AUDIO_FAILURE;
    }

/*  
Information about possible configurations can be obtained with a set of functions named
    snd_pcm_hw_params_can_<capability>
    snd_pcm_hw_params_is_<property>
    snd_pcm_hw_params_get_<parameter>
  
The availability of the most important parameters, namely access type, buffer size, number of channels, sample format, sample rate and number of periods, can be tested with a set of functions named
    snd_pcm_hw_params_test_<parameter> 
  
These query functions are especially important if the "hw" interface is used. The configuration space can be restricted to a certain configuration with a set of functions named
    snd_pcm_hw_params_set_<parameter>
  
For this example, we assume that the soundcard can be configured for stereo playback of 16 Bit Little Endian data, sampled at 44100 Hz. Accordingly, we restrict the configuration space to match this configuration:
*/
    int rate = sampleRate;	/* Sample rate */
    unsigned int exact_rate;   		/* Sample rate returned by */
                      		/* snd_pcm_hw_params_set_rate_near */ 
//    int dir;          /* exact_rate == rate --> dir = 0 */
                      /* exact_rate < rate  --> dir = -1 */
                      /* exact_rate > rate  --> dir = 1 */
    int periods = 4;  /* Number of periods, See http://www.alsa-project.org/main/index.php/FramesPeriods */
//    snd_pcm_uframes_t periodsize = 44100; /* Periodsize (bytes) */

/*
A frame is equivalent of one sample being played, irrespective of the number of channels or the number of bits. e.g.
1 frame of a Stereo 48khz 16bit PCM stream is 4 bytes.
1 frame of a 5.1 48khz 16bit PCM stream is 12 bytes.
A period is the number of frames in between each hardware interrupt. The poll() will return once a period.
The buffer is a ring buffer. The buffer size always has to be greater than one period size. Commonly this is 2*period size, but some hardware can do 8 periods per buffer. It is also possible for the buffer size to not be an integer multiple of the period size.
Now, if the hardware has been set to 48000Hz , 2 periods, of 1024 frames each, making a buffer size of 2048 frames. The hardware will interrupt 2 times per buffer. ALSA will endeavor to keep the buffer as full as possible. Once the first period of samples has been played, the third period of samples is transfered into the space the first one occupied while the second period of samples is being played. (normal ring buffer behaviour).
*/

/*  
The access type specifies the way in which multichannel data is stored in the buffer. For INTERLEAVED access, each frame in the buffer contains the consecutive sample data for the channels. For 16 Bit stereo data, this means that the buffer contains alternating words of sample data for the left and right channel. For NONINTERLEAVED access, each period contains first all sample data for the first channel followed by the sample data for the second channel and so on.
*/
  
    /* Set access type. This can be either    */
    /* SND_PCM_ACCESS_RW_INTERLEAVED or       */
    /* SND_PCM_ACCESS_RW_NONINTERLEAVED.      */
    /* There are also access types for MMAPed */
    /* access, but this is beyond the scope   */
    /* of this introduction.                  */
    if (snd_pcm_hw_params_set_access(*pcm_handle, hwparams, SND_PCM_ACCESS_RW_INTERLEAVED) < 0) {
      ERR( "Error setting access.\n");
      return AUDIO_FAILURE;
    }
  
    /* Set sample format */
    if (snd_pcm_hw_params_set_format(*pcm_handle, hwparams, SND_PCM_FORMAT_S16_LE) < 0) {
      ERR( "Error setting format.\n");
      return AUDIO_FAILURE;
    }

    /* Set sample rate. If the exact rate is not supported */
    /* by the hardware, use nearest possible rate.         */ 
    exact_rate = rate;
    if (snd_pcm_hw_params_set_rate_near(*pcm_handle, hwparams, &exact_rate, 0u) < 0) {
      ERR( "Error setting rate.\n");
      return AUDIO_FAILURE;
    }
    if (rate != exact_rate) {
      DBG( "The rate %d Hz is not supported by your hardware.\nUsing %d Hz instead.\n",
	 rate, exact_rate);
    } else {
      DBG( "Using %d Hz sampling rate.\n", rate);
    }

    /* Set number of channels */
    if (snd_pcm_hw_params_set_channels(*pcm_handle, hwparams, NUM_CHANNELS) < 0) {
      ERR( "Error setting channels.\n");
      return AUDIO_FAILURE;
    }

    /* Set number of periods. Periods used to be called fragments. */ 
    if (snd_pcm_hw_params_set_periods(*pcm_handle, hwparams, periods, 0) < 0) {
      ERR( "Error setting periods.\n");
      return AUDIO_FAILURE;
    }

/*  
The unit of the buffersize depends on the function. Sometimes it is given in bytes, sometimes the number of frames has to be specified. One frame is the sample data vector for all channels. For 16 Bit stereo data, one frame has a length of four bytes.
*/
    /* Set buffer size (in frames). The resulting latency is given by */
    /* latency = periodsize * periods / (rate * bytes_per_frame)     */
//    *exact_bufsize_handle = (periodsize * periods) >> 2;
    if (snd_pcm_hw_params_set_buffer_size_near(*pcm_handle, hwparams, exact_bufsize_handle) < 0) {
      ERR( "Error setting buffersize.\n");
      return AUDIO_FAILURE;
    }
    DBG( "exact_bufsize = %d\n", (int) *exact_bufsize_handle);
 
/* 
If your hardware does not support a buffersize of 2^n, you can use the function snd_pcm_hw_params_set_buffer_size_near. This works similar to snd_pcm_hw_params_set_rate_near. Now we apply the configuration to the PCM device pointed to by pcm_handle. This will also prepare the PCM device.
*/
  
    /* Apply HW parameter settings to */
    /* PCM device and prepare device  */
    if (snd_pcm_hw_params(*pcm_handle, hwparams) < 0) {
      ERR( "Error setting HW params.\n");
      return AUDIO_FAILURE;
    }
 
    //* Return status **
    DBG( "Opened %s\n", soundDevice);
    return AUDIO_SUCCESS;
}

//*******************************************************************************
//*  audio_io_cleanup
//*******************************************************************************
//*  Input parameters:                                                         **
//*    snd_pcm_t *pcm_handle --  Handle of ALSA device to be closed.	       **
//*                                                                            **
//*  Return value:                                                             **
//*      int -- AUDIO_SUCCESS or AUDIO_FAILURE as per audio_input_output.h     **
//*                                                                            **
//*******************************************************************************
int audio_io_cleanup(snd_pcm_t *pcm_handle)
{
/*  
If we want to stop playback, we can either use snd_pcm_drop or snd_pcm_drain. The first function will immediately stop the playback and drop pending frames. The latter function will stop after pending frames have been played.
*/
    /* Stop PCM device and drop pending frames */
//    snd_pcm_drop(pcm_handle);

    /* Stop PCM device after pending frames have been played */ 
    if(snd_pcm_drain(pcm_handle) != 0)
    {
        ERR( "Failed close on ALSA audio output device (file descriptor %d) \n", (int) pcm_handle );
        return AUDIO_FAILURE;
    }

    DBG( "Closed audio output device (file descriptor %d)\n", (int) pcm_handle );

    return AUDIO_SUCCESS;
}

