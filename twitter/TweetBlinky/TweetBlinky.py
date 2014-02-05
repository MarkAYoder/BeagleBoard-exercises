#!/usr/bin/env python
import time
# import RPi.GPIO as GPIO
import Adafruit_BBIO.GPIO as GPIO
from twython import TwythonStreamer

# Search terms
TERMS = '#lol'

# GPIO pin number of LED
LED = "P9_12"

# Twitter application authentication
APP_KEY = 'D3PuaQNFRYAtNVKXPppmw'
APP_SECRET = 'nG8zoU8MvR2bGre2UfWbW9vhBgRGRkB9kQCQ1wrXqY'
OAUTH_TOKEN = '48435578-fCNrU1hHOI1hgescqTkXm7aKAeMpGvi0yYTNtYpoV'
OAUTH_TOKEN_SECRET = 'YvGHOIkvfz81ZsMvtcKJ7G9iLidanFzM4nW3QpGOOfaFC'

# Setup callbacks from Twython Streamer
class BlinkyStreamer(TwythonStreamer):
    def on_success(self, data):
        if 'text' in data:
	    print data['text'].encode('utf-8')
	    print
	    GPIO.output(LED, GPIO.HIGH)
	    time.sleep(0.5)
	    GPIO.output(LED, GPIO.LOW)

# Setup GPIO as output
#GPIO.setmode(GPIO.BOARD)
GPIO.setup(LED, GPIO.OUT)
GPIO.output(LED, GPIO.LOW)

# Create streamer
try:
    stream = BlinkyStreamer(APP_KEY, APP_SECRET, OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
    stream.statuses.filter(track=TERMS)

except KeyboardInterrupt:
    GPIO.cleanup()
    print "KeyboardInterrupt"
