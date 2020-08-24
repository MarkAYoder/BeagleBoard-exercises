#!/usr/bin/env python3
# From: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/adc
# From: https://adafruit-beaglebone-io-python.readthedocs.io/en/latest/ADC.html

# To setup ADC, simply import the module, and call setup:
import Adafruit_BBIO.ADC as ADC
import time
ADC.setup()

# Then, to read the analog values on P9_38, simply read them:
value = ADC.read("P9_38")
print(value)

# In addition to the key (above), you can also read using the pin name:
value = ADC.read("AIN3")
print(value)

# There is currently a bug in the ADC driver. You'll need to read the values twice 
# in order to get the latest value.
# The values returned from read are in the range of 0 - 1.0. You can get the voltage by doing the following:

value = ADC.read("P9_38")
print(value)

# voltage = value * 1.8 #1.8V

# You can also use read_raw to get the actual values:
value = ADC.read_raw("P9_38")
print(value)

while True:
    value = ADC.read("P9_38")
    print('{0:.2f}'.format(value), end='\r')
    time.sleep(0.1)