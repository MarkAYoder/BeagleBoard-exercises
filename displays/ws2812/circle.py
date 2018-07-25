#!/usr/bin/env python

"""A demo client for Open Pixel Control
http://github.com/zestyping/openpixelcontrol

Runs an LED around in a circle

To run:
First start the gl simulator using, for example, the included "wall" layout

    make
    bin/gl_server layouts/wall.json

Then run this script in another shell to send colors to the simulator

    python_clients/example.py

"""

import time
import random
import opc
from collections import deque

ADDRESS = 'localhost:7890'

# Create a client object
client = opc.Client(ADDRESS)

# Test if it can connect
if client.can_connect():
    print 'connected to %s' % ADDRESS
else:
    # We could exit here, but instead let's just print a warning
    # and then keep trying to send pixels in case the server
    # appears later
    print 'WARNING: could not connect to %s' % ADDRESS

# Send pixels forever
STR_LEN=16
for i in range(STR_LEN):
    leds = [(0, 0, 0)] * STR_LEN
leds[0] = (0, 127, 0)

while True:
    tmp = leds[0]
    for i in range(STR_LEN-1):
        leds[i] = leds[i+1]
    leds[-1] = tmp
    if client.put_pixels(leds, channel=0):
        print 'sent'
    else:
        print 'not connected'
    time.sleep(0.1)

