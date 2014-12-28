# This is for fast numerical computations
export LD_LIBRARY_PATH=/usr/local/lib/
# From: http://www.eliteraspberries.com/blog/2013/09/cflags-for-numerical-computing-on-the-beaglebone-black.html
CC=gcc
export CC

CFLAGS="-march=armv7-a -mtune=cortex-a8"
CFLAGS="$CFLAGS -mfloat-abi=hard -mfpu=neon -ffast-math -O3"
export CFLAGS

CXXFLAGS="$CFLAGS"
export CXXFLAGS