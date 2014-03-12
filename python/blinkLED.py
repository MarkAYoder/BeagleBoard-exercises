import Adafruit_BBIO.GPIO as GPIO
import time

GPIO.setup("P9_14", GPIO.OUT)

while True:
    GPIO.output("P9_14", GPIO.HIGH)
    time.sleep(0.5)
    GPIO.output("P9_14", GPIO.LOW)
    time.sleep(0.5)
