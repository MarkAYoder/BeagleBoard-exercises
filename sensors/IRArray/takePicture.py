#!/usr/bin/env python3
# Takes a pictures from the IRarray and copied it to Google Drive
# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO

button="P2_17"  # PAUSE=P8_9, MODE=P8_10
LED   ="USR3"

# Set the GPIO pins:
GPIO.setup(LED,    GPIO.OUT)
GPIO.setup(button, GPIO.IN)

print("Running...")

while True:
  state = GPIO.input(button)
  GPIO.output(LED, state)
  
  GPIO.wait_for_edge(button, GPIO.BOTH)
  print("Pressed")