#!/usr/bin/env python
import os
import time
ms = 200    # Read time in ms

IIOPATH = '/sys/bus/i2c/devices/i2c-2/2-0029/iio:device1'
PWMPATH = '/dev/bone/pwm'

if (not os.path.exists(IIOPATH)):
    print (IIOPATH+': Not found. Run setup.sh')
    os.exit()

print("red  green  blue")
data = [0,0,0]

pwmr = open(PWMPATH+"/1/a/duty_cycle", "w")
pwmg = open(PWMPATH+"/0/b/duty_cycle", "w")
pwmb = open(PWMPATH+"/0/a/duty_cycle", "w")

fr = open(IIOPATH+"/in_intensity_red_raw",   "r")
fg = open(IIOPATH+"/in_intensity_green_raw", "r")
fb = open(IIOPATH+"/in_intensity_blue_raw",  "r")
while True:
    fr.seek(0)
    fg.seek(0)
    fb.seek(0)
    data[0] = fr.read()[:-1]
    data[1] = fg.read()[:-1]
    data[2] = fb.read()[:-1]
    print("  ".join(data)+"       ", end='\r')

    pwmr.seek(0)
    pwmr.write(data[0])
    pwmg.seek(0)
    pwmg.write(data[1])
    pwmb.seek(0)
    pwmb.write(data[2])

    time.sleep(ms/1000)