#!/usr/bin/env python
from time import sleep
import math
import random
import threading
import signal
import sys

len = 320
max = 30
keepgoing = True

def signal_handler(signal, frame):
    global keepgoing
    print ('You pressed Ctrl+C!')
    keepgoing = False
#    fo.close()
#    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

# Update the thread at a regular interval
def keepDisplaying(delay):
    global keepgoing
    print ("keepDisplaying called with delay = %f" % delay)
    
    while keepgoing:
        fo.write("0 0 0 -1\n")
        sleep(delay)

# Turn whole string off
def clear(r,g,b):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))

f = 25
shift = 3
phase = 0
len = 320
amp = 25

def rainbow(i):
    r = (amp * (math.sin(2*math.pi*f*(i-phase-0*shift)/len) + 1)) + 1;
    g = (amp * (math.sin(2*math.pi*f*(i-phase-1*shift)/len) + 1)) + 1;
    b = (amp * (math.sin(2*math.pi*f*(i-phase-2*shift)/len) + 1)) + 1;
    fo.write("%d %d %d %d" % (r, g, b, i))

def skiUpDown():
    global keepgoing
    while keepgoing:
        for i in range(0, len):
#            fo.write("%d %d %d %d" % (0, 0, 0, i))
            rainbow(i)
            fo.write("%d %d %d %d" % (max, 0, 0, i+1))
            if not keepgoing:
                break
            sleep(0.05)
        
        for i in range(len, 1, -1):
            fo.write("%d %d %d %d" % (0, 0, max/4, i))
            fo.write("%d %d %d %d" % (0, 0, max, i-1))
            if not keepgoing:
                break
            sleep(0.02)
            
    print ("One more skiier has stopped")
    
# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

clear(0, 1, 0)

threading.Thread(target=keepDisplaying, args=(0.01,)).start()

for i in range(10):
    last = threading.Thread(target=skiUpDown)
    last.start()
    if not keepgoing:
        break
    sleep(random.uniform(.5,3))

print ("All threads launched")

# This didn't work... couldn't end the program
#last.join()  

while keepgoing:
    sleep(.5)

print ("All Done")

