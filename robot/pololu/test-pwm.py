#!/usr/bin/env python3
# From: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/pwm
import Adafruit_BBIO.PWM as PWM
#PWM.start(channel, duty, freq=2000, polarity=0)
pwmR = "P1_36"
pwmL = "P2_1"
PWM.start(pwmR, 10)
PWM.start(pwmL, 10)

# PWM.set_duty_cycle("P9_14", 25.5)
# PWM.set_frequency("P9_14", 10)

PWM.stop(pwmR)
PWM.stop(pwmL)
PWM.cleanup()