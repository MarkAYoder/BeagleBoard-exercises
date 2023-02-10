#!/usr/bin/env python
import time

mpu="/sys/class/i2c-adapter/i2c-2/2-0068/iio:device1/"

rawX = open(mpu+"in_accel_x_raw", "r")

while True:
    rawX.seek(0)
    print("accs_x_raw "+str(float(rawX.read())/1000)+"      ", end='\r')
    time.sleep(1)

