#!/usr/bin/env python3

import glob
import PWMmay as PWM

channel = "P9_14"

# print(PWM.get_pwm_key(channel))

# print(PWM.get_pwm_path(channel))

print(PWM.start(channel, 50, freq=1000))

print(PWM.set_frequency(channel, 10000))

print(PWM.set_duty_cycle(channel, 10))

# print(PWM.stop(channel))