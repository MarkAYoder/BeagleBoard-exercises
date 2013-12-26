#!/usr/bin/python
# Playing with inporting audo in
# Taken from http://stackoverflow.com/questions/6867675/audio-recording-in-python
import alsaaudio, wave, numpy

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

while True:
    l, data = inp.read()
    a = numpy.fromstring(data, dtype='int16')
    print numpy.abs(a).mean()
#    w.writeframes(data)