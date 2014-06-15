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

lastDemo = 0    # number of the last demo run
cntFile = "demo.txt"
tempFile = "temp.txt"

# Read the control file and return True if the demo number has changed
def demoChange():
    global lastDemo
    fd = open(cntFile, "r")
    demo = fd.read()
    if len(demo) == 0:
        print "0 len"
        return False
    demo = int(demo)
    fd.close()
    # print(demo)
    if demo == lastDemo:
        return False
    else:
        print "Demo changed"
        lastDemo = demo
        return True     # The demo number has changed
        
def rainbow(ledStrip, max):
    phase = 0
    skip = 60
    f = 10
    shift = 3
    nrOfleds = ledStrip.nLeds
    
    for i in range(nrOfleds-skip, nrOfleds):
        ledStrip.setPixel(i, [0, 0, 0])

    while True:
        for i in range(0, nrOfleds-skip):
            r = int((max * (math.sin(2*math.pi*f*(i-phase-0*shift)/nrOfleds) + 1)) + 1)
            g = int((max * (math.sin(2*math.pi*f*(i-phase-1*shift)/nrOfleds) + 1)) + 1)
            b = int((max * (math.sin(2*math.pi*f*(i-phase-2*shift)/nrOfleds) + 1)) + 1)
            ledStrip.setPixel(i, [r, g, b])
    
        ledStrip.update()
        if demoChange():
            return
        phase = phase + 0.5
        time.sleep(0.050)

# Draws a bar graph with 0 in the middle and running from -max to max
rows = 30
def barGraph(ledStrip, bar, value, color, maxVal):
    global rows
    for i in range(0, rows):
        ledStrip.setPixel(bar*rows+i, [0, 0, 0])
    for i in range(rows/2, rows/2+value*rows/(2*maxVal), int(math.copysign(1,value))):
        ledStrip.setPixel(bar*rows+i, color)

def sensorTag(ledStrip, sleep):
    fillAll(ledStrip, [0, 0, 0], 0)
    while True:
        fd = open(tempFile, "r")
        temp = fd.readline()
        fd.close()
        if len(temp) == 0:
            temp = 0;
        temp = int(float(temp))

        barGraph(ledStrip, 0, temp-30, [20,0,0], 10);
        ledStrip.update()
        if demoChange():
            return
        time.sleep(sleep)

def mySin(a, min, max):
    return min + ((max - min) / 2.) * (math.sin(a) + 1)

def rainbowOld(a):
    intense = 15
    return [int(mySin(a, 0, intense)), int(mySin(a + math.pi / 2, 0, intense)), int(mySin(a + math.pi, 0, intense))]

def fillAll(ledStrip, color, sleep):
    for i in range(0, ledStrip.nLeds):
        ledStrip.setPixel(i, color)
        ledStrip.update()
        if demoChange():
            return
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
        if demoChange():
            return
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

    ledStrip = LedStrip_WS2801(nrOfleds)

    max = 15
    sleep = 0.2
    
    # barGraph(ledStrip, 0,   5, [2, 0, 0], 10);
    # barGraph(ledStrip, 1,  -5, [0, 4, 0], 10);
    # barGraph(ledStrip, 2,  10, [0, 0, 6], 10);
    # barGraph(ledStrip, 3, -10, [2, 2, 0], 10);
    
    # ledStrip.update()
    # quit()

    while True:
        fd = open(cntFile, "r")
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
            print "antialisedPoint(ledStrip, [255, 0, 0], 0.5, sleep)"
            antialisedPoint(ledStrip, [255, 0, 0], 0.5, sleep)
        elif demo == 4:
            print "antialisedPoint(ledStrip, [0, 255, 0], 0.5, sleep)"
            antialisedPoint(ledStrip, [0, 255, 0], 0.5, sleep)
        elif demo == 5:
            print "antialisedPoint(ledStrip, [0, 0, 255], 0.5, sleep)"
            antialisedPoint(ledStrip, [0, 0, 255], 0.5, sleep)
        elif demo == 6:
            print "rainbox"
            rainbow(ledStrip, max)
        elif demo == 7:
            print "sensorTag"
            sensorTag(ledStrip, 1)
