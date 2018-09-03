#!/usr/bin/env python3
# From: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/adc

import Adafruit_BBIO.ADC as ADC

ADC.setup()
value = ADC.read("P9_40")
voltage = value * 1.8 #1.8V