#!/usr/bin/env python3
import Adafruit_BBIO.GPIO as GPIO
import time

LED="P9_11"

GPIO.setup(LED, GPIO.OUT)

while True:
    GPIO.output(LED, GPIO.HIGH)
    time.sleep(0.5)
    GPIO.output(LED, GPIO.LOW)
    time.sleep(0.5)
