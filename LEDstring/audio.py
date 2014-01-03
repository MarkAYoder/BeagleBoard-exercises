#!/usr/bin/python
# Playing with inporting audo in
# Taken from http://stackoverflow.com/questions/6867675/audio-recording-in-python
# http://pyalsaaudio.sourceforge.net/
# opkg install python-pyalsaaudio

import alsaaudio, wave, numpy

import threading

fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)
len = 320
max = 30
updated = False

print alsaaudio.cards()
inp = alsaaudio.PCM(alsaaudio.PCM_CAPTURE, card="CameraB404271")
inp.setchannels(1)
inp.setrate(8000)
inp.setformat(alsaaudio.PCM_FORMAT_S16_LE)
inp.setperiodsize(800)

# w = wave.open('test.wav', 'w')
# w.setnchannels(1)
# w.setsampwidth(2)
# w.setframerate(44100)

# Turn whole string off
def clear(r,g,b):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))
    updated = True
        
def onTo(here):
    for i in range(0, here):
        fo.write("%d %d %d %d" % (max, max, max, i))
    
    for i in range(here, len-1):
        fo.write("%d %d %d %d" % (0, 0, 0, i))
    updated = True

            
# This is the master update thread.  None of the other threads update the string.
# Instead this updates the whole thread at a regular interval.
def keepDisplaying():
    delay = 0.01
    print "keepDisplaying called with delay = %d" % (delay);
    while True:
        if updated:
            fo.write("\n")
            updated = False
        sleep(0.01);
    
clear(0, 2, 0)

# Start update thread
threading.Thread(target=keepDisplaying).start()

while True:
    l, data = inp.read()
    a = numpy.fromstring(data, dtype='int16')
    mean = numpy.abs(a).mean()
    print mean
    onTo(mean)
#    w.writeframes(data)