#!/usr/bin/env python
import os
import time
ms = 250    # Read time in ms

PATH = '/sys/bus/i2c/devices/i2c-2/2-0029/iio:device1'
PWMPATH = '/dev/bone/pwm'

if (not os.path.exists(PATH)):
    print (PATH+': Not found')
    os.exit()

print("Hi")

data = [0,0,0]

pwmr = open(PWMPATH+"/1/a/duty_cycle", "w")
pwmg = open(PWMPATH+"/0/b/duty_cycle", "w")
pwmb = open(PWMPATH+"/0/a/duty_cycle", "w")

fr = open(PATH+"/in_intensity_red_raw",   "r")
fg = open(PATH+"/in_intensity_green_raw", "r")
fb = open(PATH+"/in_intensity_blue_raw",  "r")
while True:
    fr.seek(0)
    fg.seek(0)
    fb.seek(0)
    data[0] = fr.read()[:-1]
    data[1] = fg.read()[:-1]
    data[2] = fb.read()[:-1]
    print(" ".join(data))

    pwmr.seek(0)
    pwmr.write(data[0])
    pwmg.seek(0)
    pwmg.write(data[1])
    pwmb.seek(0)
    pwmb.write(data[2])

    time.sleep(ms/1000)