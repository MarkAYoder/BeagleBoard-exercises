#!/usr/bin/env python3
import Adafruit_BBIO.GPIO as GPIO
import time

LED = "USR0"; 

GPIO.setup(LED, GPIO.OUT)

while True:
    GPIO.output(LED, GPIO.HIGH)
    time.sleep(0.25)
    GPIO.output(LED, GPIO.LOW)
    time.sleep(0.25)