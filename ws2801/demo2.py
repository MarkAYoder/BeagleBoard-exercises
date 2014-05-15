#!/usr/bin/env python
# Simple Example for accessing WS2801 LED stripes
# Copyright (C) 2013  Philipp Tiefenbacher <wizards23@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# For more information about this project please visit:
# http://www.hackerspaceshop.com/ledstrips/raspberrypi-ws2801.html

# Added global update

import math
import sys
import time

from LedStrip_WS2801 import LedStrip_WS2801


def mySin(a, min, max):
    return min + ((max - min) / 2.) * (math.sin(a) + 1)


def rainbow(a):
    intense = 15
    return [int(mySin(a, 0, intense)), int(mySin(a + math.pi / 2, 0, intense)), int(mySin(a + math.pi, 0, intense))]


def fillAll(ledStrip, color, sleep):
    for i in range(0, ledStrip.nLeds):
        ledStrip.setPixel(i, color)
        ledStrip.update()
        time.sleep(sleep)


def rainbowAll(ledStrip, times, sleep):
    for t in range(0, times):
        for i in range(0, ledStrip.nLeds):
            ledStrip.setPixel(i, rainbow((1.1 * math.pi * (i + t)) / ledStrip.nLeds))
        ledStrip.update()
        if (sleep != 0):
            time.sleep(sleep)


def antialisedPoint(ledStrip, color, step, dscale, sleep=0):
    rr = color[0]
    gg = color[1]
    bb = color[2]
    screenOffset = int(1.0 / (step * dscale)) + 1
    for j in range(-screenOffset, int(ledStrip.nLeds / step + screenOffset)):
        for i in range(0, ledStrip.nLeds):
            delta = 1 - abs(i - j * step) * dscale
            if delta < 0:
                delta = 0
            ledStrip.setPixel(i, [int(delta * rr), int(delta * gg), int(delta * bb)])
        ledStrip.update()
        #   time.sleep(sleep)


def knight_rider(ledStrip, trail_nb_leds=3, color=[255, 0, 0], times=5, sleep=0.08):
    if trail_nb_leds > ledStrip.nLeds or trail_nb_leds <= 0:
        raise ValueError("Wrong trail_nb_leds value")
    black_color = [0, 0, 0]

    for i in range(times):
        # left to right
        for i in range(ledStrip.nLeds + trail_nb_leds):
            ledStrip.setAll(black_color)
            for j in range(min(i + 1, trail_nb_leds)):
                if i - j <= ledStrip.nLeds:
                    ledStrip.setPixel(index=i - j, color=[x / max((j * 8), 1) for x in color]) #  division is to fake lower brightness
            ledStrip.update()
            time.sleep(sleep)

        # right to left
        for i in reversed(range(-trail_nb_leds, ledStrip.nLeds)):
            ledStrip.setAll(black_color)
            for j in range(min(ledStrip.nLeds - i + 1, trail_nb_leds)):
                if i + j >= 0:
                    ledStrip.setPixel(index=i + j, color=[x / max((j * 8), 1) for x in color]) #  division is to fake lower brightness
            ledStrip.update()
            time.sleep(sleep)

        time.sleep(0.7)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        nrOfleds = 240
    else:
        nrOfleds = int(sys.argv[1])
    delayTime = 0.01

    # oldStrip = LedStrip_WS2801_FileBased(nrOfleds, "/dev/spidev0.0")
    # fillAll(oldStrip, [255, 0, 0], delayTime)
    # oldStrip.close()

    ledStrip = LedStrip_WS2801(nrOfleds)

    max = 15
    sleep = 0.2

    while True:
        fd = open("demo.txt", "r")
        demo = int(fd.read())
        fd.close()
        print(demo)
        if demo == 0:
            print "fillAll(ledStrip, [max, 0, 0], 0.01)"
            fillAll(ledStrip, [max, 0, 0], 0.01)
        elif demo == 1:
            print "fillAll(ledStrip, [0, max, 0], delayTime)"
            fillAll(ledStrip, [0, max, 0], delayTime)
        elif demo == 2:
            print "fillAll(ledStrip, [0, 0, max], 0.01)"
            fillAll(ledStrip, [0, 0, max], 0.01)
        elif demo == 3:
            print "rainbowAll(ledStrip, 20, 0.01)"
            rainbowAll(ledStrip, 20, 0.01)
            fillAll(ledStrip, [max, 0, 0], 0.01)
        elif demo == 4:
            print "antialisedPoint(ledStrip, [255, 0, 0], 0.5, sleep)"
            antialisedPoint(ledStrip, [255, 0, 0], 0.5, sleep)
        elif demo == 5:
            print "antialisedPoint(ledStrip, [0, 255, 0], 0.5, sleep)"
            antialisedPoint(ledStrip, [0, 255, 0], 0.5, sleep)
        elif demo == 6:
            print "antialisedPoint(ledStrip, [0, 0, 255], 0.5, sleep)"
            antialisedPoint(ledStrip, [0, 0, 255], 0.5, sleep)
