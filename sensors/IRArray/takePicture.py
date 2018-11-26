#!/usr/bin/env python3
# Takes a pictures from the IRarray and copied it to Google Drive
# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO
import os
import datetime
import threading

button="P2_17"  # PAUSE=P8_9, MODE=P8_10
LED = "USR3"

def takePic():
    print("Pressed")
    # Turn LED on to show it's working
    GPIO.output(LED, 1)

    file = "/tmp/" + datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S") + ".jpg"
    # print(file)
  
    os.system("./fb2jpg.sh /dev/fb0 " + file)
    os.system("rclone copy " + file + " drive:Pictures")
    
    # Turn LED off
    GPIO.output(LED, 0)
    
# Set the GPIO pin:
GPIO.setup(button, GPIO.IN)
GPIO.setup(LED,    GPIO.OUT)
GPIO.output(LED, 0)

print("Running...")

while True:
    GPIO.wait_for_edge(button, GPIO.RISING)  # FALLING, RISING, BOTH
    takePic()