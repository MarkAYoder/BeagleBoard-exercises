#!/usr/bin/env python3
# Pings google and turns on a RGB light according to the response time.

import Adafruit_BBIO.GPIO as GPIO
import subprocess
import time
import re

pingCmd = ["ping", "-w1", "www.google.com"]
p = re.compile('time=[0-9.]*')      # We'll search for time= followed by digits and .
ms = 15000          # Repeat time in ms.
thresh = 40.0      # If time is above this, turn on warning light
hist = 10* [thresh]  # Keep track of the last 10 values
current = 0        # Insert next value here 
red   = 'P9_11'
green = 'P9_15'
blue  = 'P9_13'

# for(var i = 0; i<hist.length; i++) {    # Initialize history to threshold
#     hist[i] = thresh;
# }

GPIO.setup(red,  GPIO.OUT)
GPIO.setup(green,GPIO.OUT)
GPIO.setup(blue, GPIO.OUT)

GPIO.output(red,   1)
GPIO.output(green, 0)
GPIO.output(blue,  1)

while True:
    # returns output as byte string
    returned_output = subprocess.check_output(pingCmd, stderr=subprocess.STDOUT).decode("utf-8")
    # print("returned_output: {}".format(returned_output))
    
    # using decode() function to convert byte string to string
    print('{}:\n{}'.format(pingCmd, returned_output))
    timems = float(p.search(returned_output).group()[5:])
    print(timems)
    average = sum(hist)/len(hist)
    hist[current] = timems
    current = current + 1
    if current >= len(hist):
        current=0
    print('ping: time = {}, average = {}'.format(timems, average))
    if timems > 1.1*average:
        GPIO.output(red,   1)
        GPIO.output(green, 1)
        GPIO.output(blue,  0)
    else:
        GPIO.output(red,   0)
        GPIO.output(green, 1)
        GPIO.output(blue,  0)
        
    time.sleep(0.5)


# // console.log("process.argv.length: " + process.argv.length);
# if(process.argv.length === 3) {
#     pingCmd = process.argv[2];
# }

# var timer = setInterval(ping, ms);
# ping();

# // Send off the ping command.
# function ping  () {
#     var hour = new Date().getHours();
#     if(hour>5 && hour<21) {     // Only light up during certain hours
#         child.exec(pingCmd,
#             function (error, stdout, stderr) {
#                 if(error || stderr) { 
#                     console.log('error: ' + error); 
#                     console.log('stderr: ' + stderr); 
#                     b.digitalWrite(red,   1);
#                     b.digitalWrite(green, 0);
#                     b.digitalWrite(blue,  0);
#                 } else {
#                     var time = stdout.match(/time=[0-9.]* /mg); //  Pull the time out of the return string
#                     time[0] = parseFloat(time[0].substring(5));     // Strip off the leading time=
#                     var average = 0;
#                     for(var i=0; i<hist.length; i++) {
#                         average += hist[i];
#                     }
#                     average /= hist.length;
#                     hist[current] = time[0];
#                     current++;
#                     if(current >= hist.length) {    // Keep a circular buffer of
#                         current=0;                  // most recent values
#                     }
    
#                     console.log('ping: time = %d, average = %d', time[0].toFixed(2), average.toFixed(2));
#                     if(time[0] > 1.1*average) {  // Turn on warning
#                         b.digitalWrite(red,   1);
#                         b.digitalWrite(green, 1);
#                         b.digitalWrite(blue,  0);
#                     } else {
#                         b.digitalWrite(red,   0);
#                         b.digitalWrite(green, 1);
#                         b.digitalWrite(blue,  0);
#                     }
#                 }
#             }
#         )
#     } else {
#         console.log('Good night');
#         allOff();
#     }
# }

# process.on('SIGINT', function() {
#     console.log('Got SIGINT');
#     clearInterval(timer);
#     setTimeout(allOff, 1000);
# });

# function allOff() {
#     console.log("allOff");
#     b.digitalWrite(red,   0);
#     b.digitalWrite(green, 0);
#     b.digitalWrite(blue,  0);
# }
