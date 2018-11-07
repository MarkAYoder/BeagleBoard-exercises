#!/usr/bin/env python3
# Takes a pictures from the IRarray and copied it to Google Drive
# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO
import os
import datetime
import threading

button="P2_17"  # PAUSE=P8_9, MODE=P8_10

def takePic():
    print("Pressed")
    file = "/tmp/" + datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S") + ".jpg"
    # print(file)
  
    os.system("./fb2jpg.sh /dev/fb0 " + file)
    os.system("rclone copy " + file + " drive:Pictures")
    
# Set the GPIO pin:
GPIO.setup(button, GPIO.IN)

print("Running...")

while True:
    GPIO.wait_for_edge(button, GPIO.RISING)  # FALLING, RISING, BOTH
    takePic()