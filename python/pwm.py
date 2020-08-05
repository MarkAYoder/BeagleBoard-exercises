#!/usr/bin/env python3
# From: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/pwm
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/PWM.html

import Adafruit_BBIO.PWM as PWM
LED="P9_14"

# PWM.start(channel, duty, freq=2000, polarity=0)
PWM.start(LED, 50)
 
# Optionally, you can set the frequency as well as the polarity from their defaults:
PWM.start(LED, 50, 1, 1)

# The valid values for duty are 0.0 to 100.0. The start method activate 
# pwm on that channel. There is no need to setup the channels with Adafruit_BBIO.PWM.

# Once you've started, you can then set the duty cycle, or the frequency:
PWM.set_duty_cycle(LED, 25.5)
PWM.set_frequency(LED, 10)

# You'll also want to either disable that specific channel, or cleanup all of them when you're done:
    # PWM.stop(LED)
    # PWM.cleanup()