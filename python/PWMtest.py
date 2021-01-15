#!/usr/bin/env python3

import PWMmay as PWM

channel = "P8_13"
# channel = "P8_19"
channel = "P8_34"   # doesn't work
channel = "P8_36"   # doesn't work
channel = "P8_45"
channel = "P8_46"
# channel = "P9_14"   # doesn't work
# channel = "P9_16"   # doesn't work
# channel = "P9_21"   # doesn't work
# channel = "P9_22"
# channel = "P9_28"   # doesn't work
# channel = "P9_29"   # doesn't work
# channel = "P9_42"

print(PWM.get_pwm_key(channel))

print(PWM.get_pwm_path(channel))

err = PWM.start(channel, 50, freq=100)
# err = PWM.start(channel, 50)
if err == None:
    exit()

# print(PWM.set_frequency(channel, 10000))

# print(PWM.set_duty_cycle(channel, 10))

# print(PWM.stop(channel))

for channel in ["P8_13", "P8_19", "P8_45", "P8_46", ]:
    print(channel)