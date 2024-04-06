#!/usr/bin/env python3
# Pings google and turns on a RGB light according to the response time.

import gpiod
import subprocess
import time
import re
import datetime as dt

pingCmd = ["ping", "-w1", "www.google.com"]
p = re.compile('time=[0-9.]*')      # We'll search for time= followed by digits and .
ms = 15000          # Repeat time in ms.
thresh = 40.0      # If time is above this, turn on warning light
hist = 10* [thresh]  # Keep track of the last 10 values
current = 0        # Insert next value here 

LED_CHIP = 'gpiochip0'
red   = 30 # 'P9_11'
green =  5 # 'P9_17'
blue  = 31 # 'P9_13'
LED_LINE_OFFSET = [red, green, blue]

chip = gpiod.Chip(LED_CHIP)
lines = chip.get_lines(LED_LINE_OFFSET)
lines.request(consumer='flashup.py', type=gpiod.LINE_REQ_DIR_OUT)

# Turn all LEDs off
def allOff():
    print("allOff")
    lines.set_values([0, 0, 0])  # All off

lines.set_values([1, 0, 1])     # red and blue

while True:
    hour=dt.datetime.now().hour
    if hour>5 and hour<21:
        try:
            # returns output as byte string
            returned_output = subprocess.check_output(pingCmd, stderr=subprocess.STDOUT).decode("utf-8")
            # print("returned_output: {}".format(returned_output))
            
            # using decode() function to convert byte string to string
            # print('{}:\n{}'.format(pingCmd, returned_output))
            timems = float(p.search(returned_output).group()[5:])
            # print(timems)
            average = sum(hist)/len(hist)
            hist[current] = timems
            current = current + 1
            if current >= len(hist):
                current=0
            print('ping: time = %5.2f, average = %5.2f' % (timems, average))
            if timems > 1.1*average:
                lines.set_values([1, 1, 0])     # red and green
            else:
                lines.set_values([0, 1, 0])     # green

                
        except subprocess.CalledProcessError as err:
            print('ERROR:', err)
            lines.set_values([1, 0, 0])#        # red

            
    else:
        print('Good night')
        allOff()
    time.sleep(ms/1000)

# process.on('SIGINT', function() {
#     console.log('Got SIGINT');
#     clearInterval(timer);
#     setTimeout(allOff, 1000);
# });
