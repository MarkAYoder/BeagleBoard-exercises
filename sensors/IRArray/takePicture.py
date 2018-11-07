#!/usr/bin/env python3
# Takes a pictures from the IRarray and copied it to Google Drive
# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO
import os
import datetime

button="P2_17"  # PAUSE=P8_9, MODE=P8_10
LED   ="USR3"

# Set the GPIO pins:
GPIO.setup(LED,    GPIO.OUT)
GPIO.setup(button, GPIO.IN)

print("Running...")

while True:
  state = GPIO.input(button)
  GPIO.output(LED, state)
  
  GPIO.wait_for_edge(button, GPIO.FALLING)  # FALLING, RISING, BOTH
  print("Pressed")
  
  file = "/tmp/" + datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S") + ".jpg"
  print(file)
  
  os.system("./fb2jpg.sh /dev/fb0 " + file)
  os.system("rclone copy " + file + " drive:Pictures")