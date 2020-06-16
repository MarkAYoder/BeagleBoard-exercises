#!/usr/bin/env python3
# From: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/pwm
import Adafruit_BBIO.PWM as PWM
import Adafruit_BBIO.GPIO as GPIO
import time

#PWM.start(channel, duty, freq=2000, polarity=0)
pwmR = "P1_36"      # J4
pwmL = "P2_1"       # J4 
ERB  = "P2_3"
ELB  = "P2_4"
DIRR = "P1_35"
DIRL = "P1_33"

GPIO.setup(ELB,  GPIO.IN)
GPIO.setup(ERB,  GPIO.IN)
GPIO.setup(DIRR, GPIO.OUT)
GPIO.setup(DIRL, GPIO.OUT)

PWM.start(pwmR, 10)
PWM.start(pwmL, 10)

# GPIO.add_event_detect("P1_35", GPIO.FALLING)
# #your amazing code here
# #detect wherever:
# if GPIO.event_detected("P9_12"):
#     print "event detected!"

# PWM.set_duty_cycle("P9_14", 25.5)
# PWM.set_frequency("P9_14", 10)

# PWM.stop(pwmR)
# PWM.stop(pwmL)
# PWM.cleanup()

def my_callback(channel):
    print('Edge detected on channel %s'%channel)

# GPIO.add_event_detect(ERB, GPIO.BOTH, callback=my_callback) 
# GPIO.add_event_detect(ELB, GPIO.BOTH, callback=my_callback) 

try:
    GPIO.output(DIRR, 1)
    GPIO.output(DIRL, 1)
    time.sleep(2)
    
    GPIO.output(DIRR, 0)
    GPIO.output(DIRL, 1)
    time.sleep(2)
    
    GPIO.output(DIRR, 1)
    GPIO.output(DIRL, 0)
    time.sleep(2)
    
    GPIO.output(DIRR, 2)
    GPIO.output(DIRL, 0)
    time.sleep(2)
    
except KeyboardInterrupt:
    PWM.stop(pwmR)
    PWM.stop(pwmL)
    PWM.cleanup()