#!/usr/bin/env python3
# Blink read the temperature from a BMP085 and display it
import blynklib
import blynktimer
import os

# Run setup.sh to create a new bmp085
BMP085='/sys/class/i2c-adapter/i2c-2/2-0077/iio:device1/in_temp_input'

# Get the autherization code (See setup.sh)
BLYNK_AUTH = os.getenv('BLYNK_AUTH')

# Initialize Blynk
blynk = blynklib.Blynk(BLYNK_AUTH)
# create timers dispatcher instance
timer = blynktimer.Timer()

# Register Virtual Pins
# The V* says to response to all virtual pins
@blynk.handle_event('write V*')
def my_write_handler(pin, value):
    print('Current V{} value: {}'.format(pin, value))
    GPIO.output(LED, int(value[0])) 

oldtemp = 0
# Code below: register a timer for different pins with different intervals
# run_once flag allows to run timers once or periodically
@timer.register(vpin_num=10, interval=0.5, run_once=False)
def write_to_virtual_pin(vpin_num=1):
    global oldtemp
    # Open the file with the temperature
    f = open(BMP085, "r")
    temp=f.read()[:-1]     # Remove trailing new line
    # Convert from mC to C
    temp = int(temp)/1000
    f.close()
    # Only display if changed
    if(temp != oldtemp):
        print("Pin: V{} = '{}".format(vpin_num, str(temp)))
        # Send to blynk
        blynk.virtual_write(vpin_num, temp)
        oldtemp = temp

while True:
    blynk.run()
    timer.run()
