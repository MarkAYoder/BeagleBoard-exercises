#!/usr/bin/env python3
# Blink read the temperature from a BMP085 and display it
import blynklib
import blynktimer
import os, sys

# Run setup.sh to create a new bmp085
BMP085='/sys/class/i2c-adapter/i2c-2/2-0077/iio:device1/'

# Get the autherization code (See setup.sh)
BLYNK_AUTH = os.getenv('BLYNK_AUTH', default="")
if(BLYNK_AUTH == ""):
    print("BLYNK_AUTH is not set")
    sys.exit()

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
oldpres = 0
# Code below: register a timer for different pins with different intervals
# run_once flag allows to run timers once or periodically
@timer.register(vpin_num=10, interval=60.0, run_once=False)
def write_to_virtual_pin(vpin_num=1):
    global oldtemp, oldpres
    # Open the file with the temperature
    f = open(BMP085+'in_temp_input', "r")
    temp=f.read()[:-1]     # Remove trailing new line
    # Convert from mC to C
    temp = int(temp)/1000
    f.close()
    
    # Open pressure
    f = open(BMP085+'in_pressure_input', "r")
    pres=float(f.read()[:-1])     # Remove trailing new line
    f.close()
    
    # Only display if changed
    if(temp != oldtemp or abs(pres-oldpres)>0.01):
        print("Pin: V{} = '{}, {}".format(vpin_num, str(temp), pres))
        # Send to blynk
        blynk.virtual_write(vpin_num, temp)
        blynk.virtual_write(11, pres)
        oldtemp = temp
        oldpres = pres

while True:
    blynk.run()
    timer.run()
