#!/usr/bin/env python3
import Adafruit_BBIO.GPIO as GPIO
import time

LED = "USR0"
delay = 0.25

GPIO.setup(LED, GPIO.OUT)

while True:
    GPIO.output(LED, 1)
    time.sleep(delay)
    GPIO.output(LED, 0)
    time.sleep(delay)