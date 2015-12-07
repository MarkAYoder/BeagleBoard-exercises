#!/usr/bin/python
#
# Based on crytry.py
#

from time import sleep
import math
import random
import threading
import signal
import sys

len = 320
max = 30
keepgoing = True

# Returns a new array of tuples representing colors
# this will be an array of tuples
def create_global_colors(len, max):
    new_list = list();
    for i in range(0, len):
        new_list.append((0,0,0))
    return new_list

def signal_handler(signal, frame):
    global keepgoing
    print 'You pressed Ctrl+C!'
    keepgoing = False
#    fo.close()
#    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

# Update the thread at a regular interval
def keepDisplaying(delay):
    global keepgoing
    print "keepDisplaying called with delay = %f" % delay
    
    while keepgoing:
        fo.write("0 0 0 -1\n")
        sleep(delay)

# Turn whole string off
def clear(r,g,b):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))
        
def skiUpDown():
    global keepgoing
    global color_list
    while keepgoing:
        i = 0
        while i < len and color_list[i][2] == 0:
            fo.write("%d %d %d %d" % (0, 0, 0, i))
            fo.write("%d %d %d %d" % (max, 0, 0, i+1))
            color_list[i] = (max, 0, 0)
            if not keepgoing:
                break
            sleep(0.05)
            i+=1
        
        if i >= len:
            i = len-1
            
        while i >= 0:
            fo.write("%d %d %d %d" % (0, 0, max/4, i))
            fo.write("%d %d %d %d" % (0, 0, max, i-1))
            color_list[i] = (0, max, max)
            if not keepgoing:
                break
            sleep(0.02)
            i-=1
        
        if i < 0:
            i = 0
    
# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

clear(0, 1, 0)

color_list = create_global_colors(len,max);

threading.Thread(target=keepDisplaying, args=(0.01,)).start()

for i in range(10):
    last = threading.Thread(target=skiUpDown)
    last.start()
    sleep(random.uniform(.5,3))

print "All threads launched"

last.join()

print "All Done"

