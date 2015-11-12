#!/usr/bin/python
from time import sleep
import math
import random
import threading
import signal
import sys

length = 320
max = 20
keepgoing = True

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
    for i in range(0, length):
        fo.write("%d %d %d %d" % (r, g, b, i))

# Keep track of which spots are in use
global spots
spots = [0] * length

def countspots():
    global spots
    total = 0
    for spot in spots:
        if spot>0:
            total = total + 1
    
    return total

def glo(position, reps=3, color=0, duration=2.0):
    global keepgoing
    global spots
    
    #Check that no one else is using the spot and use it
    if spots[position]==1:
        return
    else:
        spots[position]=1
    
    # this pallete of colors is designed to blend with standard lights
    colors = [[1,1,1],[1,0,0],[0,1,0],[0,0,1],[1,1,0]]
    
    if color<0 or color> len(colors):
        color=0
    
    r=colors[color][0]
    g=colors[color][1]
    b=colors[color][2]
    
    for j in range(0,reps):
        for i in range(0, max):
            intensity = i; 
            fo.write("%d %d %d %d" % (r*intensity, g*intensity, b*intensity, position))
            if not keepgoing:
                break
                return
            sleep(duration/2/max)
    
        #sleep(duration/3)
    
        for i in range(max, -1, -1):
            intensity = i; 
            fo.write("%d %d %d %d" % (r*intensity, g*intensity, b*intensity, position))
            if not keepgoing:
                break
            sleep(duration/2/max)
            
    # Record that we are done with this spot on the string
    spots[position] = 0

def gem():
    global keepgoing
    
    while keepgoing:
        glo(random.randrange(0,length),random.randrange(1,5),color=random.randrange(1,4+1),duration=random.uniform(.5,2))
    
        # roll a die to either span off a new gem or end the life of this gem.
        die = random.randrange(1,6+1)
    
        if die == 6:
            threading.Thread(target=gem).start()
        elif die <= 2:
            break
    
# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

clear(0, 0, 0)

threading.Thread(target=keepDisplaying, args=(0.01,)).start()

def fillTree():
# Keep adding threads to the tree until there are 60.
# Naturally, the threads seem to slow down around 40 or so, but occassionally make it up to 60
    while countspots() <= 60:
        last = threading.Thread(target=gem)
        last.start()
        print 'threads: ' + str(countspots())
        if not keepgoing:
            break
        sleep(random.uniform(.1,.5))
    
    print "All threads launched"
    clear(0,0,1)
    sleep(1.0)
    clear(0,0,0)
    
fillTree()

while keepgoing:
    sleep(1.0)
    if countspots() <= 0:
        fillTree()

    print 'waiting for 0, at ' + str(countspots())
