#!/usr/bin/python
from time import sleep
import math
import threading
import signal
import sys

len = 320
max = 30
keepgoing = True

def signal_handler(signal, frame):
    global keepgoing
    print 'You pressed Ctrl+C!'
    keepgoing = False
#    fo.close()
    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

# Update the thread at a regular interval
def keepDisplaying(delay):
    global keepgoing
    print "keepDisplaying called with delay = %f" % delay
    
    while keepgoing:
        fo.write("\n")
        sleep(delay)

# Turn whole string off
def clear(r,g,b):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))
        
def skiUpDown():
    global keepgoing
    while keepgoing:
        for i in range(0, len):
            fo.write("%d %d %d %d" % (0, 0, 0, i))
            fo.write("%d %d %d %d" % (max, 0, 0, i+1))
            sleep(0.05)
        
        for i in range(len, 1, -1):
            fo.write("%d %d %d %d" % (0, 0, 0, i))
            fo.write("%d %d %d %d" % (0, 0, max, i-1))
            sleep(0.02)
    
# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

clear(0, 2, 0)

threading.Thread(target=keepDisplaying, args=(0.01,)).start()

for i in range(10):
    threading.Thread(target=skiUpDown).start()
    sleep(2)
    
# Close opened file
# fo.close()
