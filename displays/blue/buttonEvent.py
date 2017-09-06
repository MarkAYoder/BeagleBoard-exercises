#!/usr/bin/env python3
# Reads the PAUSE button using interupts and sets the LED
# Pin table at https://github.com/beagleboard/beaglebone-blue/blob/master/BeagleBone_Blue_Pin_Table.csv

# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO
import time

buttonP="PAUSE"  # PAUSE or MODE
buttonM="MODE"

LEDp   ="RED"
LEDm   ="GREEN"

# Set the GPIO pins:
GPIO.setup(LEDp,    GPIO.OUT)
GPIO.setup(LEDm,    GPIO.OUT)
GPIO.setup(buttonP, GPIO.IN)
GPIO.setup(buttonM, GPIO.IN)

GPIO.output(LEDp, 1)
GPIO.output(LEDm, 1)

print("Running...")

GPIO.add_event_detect(buttonP, GPIO.BOTH)
GPIO.add_event_detect(buttonM, GPIO.BOTH)

while True:   # This is ugly since we have to poll for the event
  if GPIO.event_detected(buttonP):
    state = GPIO.input(buttonP)
    GPIO.output(LEDp, state)
    print(LEDp + " Toggled")
    
  if GPIO.event_detected(buttonM):
    state = GPIO.input(buttonM)
    GPIO.output(LEDm, state)
    print(LEDm + " Toggled")