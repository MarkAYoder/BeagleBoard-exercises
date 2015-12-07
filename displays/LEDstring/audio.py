#!/usr/bin/python
# Playing with inporting audo in
# Taken from http://stackoverflow.com/questions/6867675/audio-recording-in-python
# http://pyalsaaudio.sourceforge.net/
# opkg install python-pyalsaaudio

from time import sleep
import alsaaudio, numpy
# import wave

import threading

fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)
len = 320
maxLED = 30
updated = False
fftSize = 512

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
    global updated
    for i in range(0, here):
        fo.write("%d %d %d %d" % (maxLED, maxLED, maxLED, i))
    
    for i in range(here, len-1):
        fo.write("%d %d %d %d" % (0, 0, 0, i))
    updated = True

def spectrum(data):
    data = maxLED*data/max(data);
    for i in range(0, fftSize/2):
        fo.write("%d %d %d %d" % (data[i], data[i], data[i], i))
    updated = True
            
# This is the master update thread.  None of the other threads update the string.
# Instead this updates the whole thread at a regular interval.
def keepDisplaying():
    global updated
    delay = 0.01
    print "keepDisplaying called with delay = %f" % (delay);
    while True:
        if updated:
            fo.write("\n")
            updated = False
        sleep(0.01)
    
clear(0, 2, 0)

# Start update thread
threading.Thread(target=keepDisplaying).start()
recentData = numpy.zeros(10)
dataIndex = 0

while True:
    l, data = inp.read()
    a = numpy.fromstring(data[0:fftSize], dtype='int16')
    mean = numpy.int16(numpy.abs(a).mean())
    recentData[dataIndex] = mean
    dataIndex = dataIndex + 1
    if dataIndex == recentData.size:
        dataIndex = 0
#    fft = numpy.int16(numpy.absolute(numpy.fft.fft(a)[0:fftSize/2]))
#    print fft
#    spectrum(fft)
#    print mean, recentData.mean()
    onTo(numpy.int16(recentData.mean())-50)
#    w.writeframes(data)