/* Code originally taken from the following URL:
     http://svn.arhuaco.org/svn/src/emqbit/tools/emqbit-bench/
*/

/*
 * Authors:
 *    Jorge Victorino
 *    Andres Calderon   andres.calderon@emqbit.com
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */


#include <math.h>
#include <stdlib.h>

#include "common.h"
#include "distance.h"

float dot_c(float *v1, float *v2, int N)
{
  int i,j;
  float dot = 0.0;

  for(i=0; i<(N>>MINPOW2); ++i)
   for(j=0; j<(MINPOW2<<1); ++j)
   {
     dot+= *(v1++) * *(v2++);
   }

  return dot;
}

float distance_c(float *v1, float *v2, int N)
{
  int i,j;
  float dist2 = 0.0;

  for(i=0; i<(N>>MINPOW2); ++i)
   for(j=0; j<(MINPOW2<<1); ++j)
   {
     double diff;

    diff = *(v1++) - *(v2++);

    dist2 += diff * diff;
   }

  return sqrt(dist2);
}
