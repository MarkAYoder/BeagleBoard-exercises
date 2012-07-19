// dm3730-pwm-demo --- Demonstrate usage of the dm3730-pwm library
// Based on the omap3530-pwm-demo by Thomas Most.
// Modified by Mark A. Yoder 25-July-2011
// Copyright (c) 2010 Thomas W. Most <twm@freecog.net>
//
// The contents of this file may be used subject to the terms of either of the
// following licenses:
//
// GNU LGPL 2.1 license:
//
//   This library is free software; you can redistribute it and/or modify it
//   under the terms of the GNU Lesser General Public License as published by the
//   Free Software Foundation; either version 2.1 of the License, or (at your
//   option) any later version.
//
//   This library is distributed in the hope that it will be useful, but WITHOUT
//   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//   FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
//   for more details.
//
//   You should have received a copy of the GNU Lesser General Public License
//   along with this library; if not, write to the Free Software Foundation,
//   Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
// MIT license:
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//   of this software and associated documentation files (the "Software"), to deal
//   in the Software without restriction, including without limitation the rights
//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//   copies of the Software, and to permit persons to whom the Software is
//   furnished to do so, subject to the following conditions:
//   
//   The above copyright notice and this permission notice shall be included in
//   all copies or substantial portions of the Software.
//   
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//   THE SOFTWARE.

#include <glib.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>

//#include <string.h>
//#include <fcntl.h>
//#include <poll.h>
//#include <signal.h>

#include "dm3730-pwm.h"

int
main(int argc, char **argv)
{
    int frequency;
	if (argc < 2) {
		printf("Usage: %s <frequency>\n", argv[0]);
		printf("Sets up a PWM signal on gpio 145 and 146 at the given frequency\n");
        printf("and sweeps the duty-cycle up and down once\n");
		exit(-1);
	}

    frequency = atoi(argv[1]);
    int mem_fd = pwm_open_devmem();
    if (mem_fd == -1) {
        g_error("Unable to open /dev/mem, are you root?: %s", g_strerror(errno));
    }

    // Set instances 10 and 11 to use the 13 Mhz clock
    pwm_config_clock(mem_fd, TRUE, TRUE);
    guint8 *gpt10 = pwm_mmap_instance(mem_fd, 10);
    guint8 *gpt11 = pwm_mmap_instance(mem_fd, 11);

    // Get the resolution for 20 kHz PWM
    guint32 resolution = pwm_calc_resolution(frequency, PWM_FREQUENCY_13MHZ);
    printf("Resolution = %d\n", resolution);

    // Ramp up and down a bit
    int i;
    for (i = 0; i <= 100; i++) {
        g_print("%3d\n", i);
        pwm_config_timer(gpt10, resolution, i / 100.0);
        pwm_config_timer(gpt11, resolution, i / 100.0);
        usleep(100000);
    }
    sleep(1);
    for (i = 100; i >= 0; i--) {
        g_print("%3d\n", i);
        pwm_config_timer(gpt10, resolution, i / 100.0);
        pwm_config_timer(gpt11, resolution, i / 100.0);
        usleep(100000);
    }

    pwm_munmap_instance(gpt10);
    pwm_close_devmem(mem_fd);
}

// vim: set ts=4 et :
