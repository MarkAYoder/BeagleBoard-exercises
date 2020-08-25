#!/usr/bin/env python3
# Pings google and turns on a RGB light according to the response time.

import Adafruit_BBIO.GPIO as GPIO
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
red   = 'P9_11'
green = 'P9_15'
blue  = 'P9_13'

# Turn all LEDs off
def allOff():
    print("allOff")
    GPIO.output(red,   0)
    GPIO.output(green, 0)
    GPIO.output(blue,  0)

GPIO.setup(red,  GPIO.OUT)
GPIO.setup(green,GPIO.OUT)
GPIO.setup(blue, GPIO.OUT)

GPIO.output(red,   1)
GPIO.output(green, 0)
GPIO.output(blue,  1)

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
            print('ping: time = {0:0.2f}, average = {0:0.2f}'.format(timems, average))
            if timems > 1.1*average:
                GPIO.output(red,   1)
                GPIO.output(green, 1)
                GPIO.output(blue,  0)
            else:
                GPIO.output(red,   0)
                GPIO.output(green, 1)
                GPIO.output(blue,  0)
                
        except subprocess.CalledProcessError as err:
            print('ERROR:', err)
            GPIO.output(red,   1)
            GPIO.output(green, 0)
            GPIO.output(blue,  0)
            
    else:
        print('Good night')
        allOff()
    time.sleep(ms/1000)

# process.on('SIGINT', function() {
#     console.log('Got SIGINT');
#     clearInterval(timer);
#     setTimeout(allOff, 1000);
# });
