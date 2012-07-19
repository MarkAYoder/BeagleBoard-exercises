/* Code originally taken from the following URL:
     http://svn.arhuaco.org/svn/src/emqbit/tools/emqbit-bench/
*/

/*
 * Authors:
 *    Nelson Castillo   nelson@emqbit.com
 *    Andres Calderon   andres.calderon@emqbit.com
 *    Copyright (c) EmQbit ltda <www.emqbit.com>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *-----------------------------------------------------------------------------
 *
 * History:
 *
 * 2007.04.16 - Fixes for the FLOPSs calculation method
 *              (thanks to Søren Andersen <san@rosetechnology.dk>).
 * 2007.03.14 - Initial release.
 */

#include <stdio.h>

#include <time.h>
#if defined(_TMS320C6X)
#elif defined(__GNUC__)
  #include <sys/time.h>
  //#include <unistd.h>
#endif

#include <stdlib.h>
#include <math.h>

#include "common.h"
#include "distance.h"

typedef struct
{
  char *desc;
  float (*f) (float*, float*, int);
} test_case;

typedef unsigned long long timestamp_t;

static timestamp_t get_timestamp ()
{
#if defined(_TMS320C6X)
  // There is no gettimeofday in DSP RTS or DSP/BIOS
  return (timestamp_t) clock();
#elif defined(__GNUC__)
  struct timeval now;
  gettimeofday (&now, NULL);
  return  now.tv_usec + (timestamp_t)now.tv_sec * 1000000;
#endif
}

static float *new_vector(int N);

int
main(int argc, char *argv[])
{
  test_case tests[] =
    {
      {"Dot with C code        ",  dot_c},
      {"Distance with C code   ",  distance_c},
      {NULL,                       NULL}
    };

  float  secs;
  int i;
  int n;

  float *vector1;
  float *vector2;
  int N = 32;
  int inc = 4;
  int nTimes;

  for(N=(1<<MINPOW2),n=0;  N<(1<<MAXPOW2);N=N<<1,n++ )
  {
    inc++;
    
    vector1 = new_vector(N);
    vector2 = new_vector(N);

    for(i=0; tests[i].desc; ++i)
    {
      volatile float dot;
      int j;
      timestamp_t t0, t1;

      nTimes = ITERATIONS;

      t0 = get_timestamp();

      for(j=0; j<nTimes; ++j)
      {
        dot = tests[i].f(vector1, vector2, N);
      }
      
      t1 = get_timestamp();

      secs = (t1 - t0) / 1000000.0L;

      fprintf(stderr,"N=%d, nTimes=%d: %s => time:%g s\n", N, nTimes, tests[i].desc, secs);
    }
    
    free(vector1);
    free(vector2);
  }

  return 0;
}

static float *new_vector(int N)
{
  int i;
 
  float *new;
  
  new = malloc(sizeof(float) * N);

  for(i = 0; i < N; ++i)
    new[i] = (float)rand()/(float)RAND_MAX - 0.5;

  return new;
}
