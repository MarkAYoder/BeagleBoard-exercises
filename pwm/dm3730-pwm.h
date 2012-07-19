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

// 13 MHz clock
#define PWM_FREQUENCY_13MHZ 13000000
// 32 kHz clock
#define PWM_FREQUENCY_32KHZ 32000

guint8 *pwm_mmap_instance(int mem_fd, int instance_number);
int pwm_munmap_instance(guint8 *instance);
int pwm_config_clock(int mem_fd, gboolean gptimer10_13mhz, gboolean gptimer11_13mhz);
guint32 pwm_calc_resolution(int pwm_frequency, int clock_frequency);
void pwm_config_timer(guint8 *instance, guint32 resolution, float duty_cycle);
int pwm_open_devmem(void);
void pwm_close_devmem(int dev_fd);

// vim: set ts=4 expandtab :
