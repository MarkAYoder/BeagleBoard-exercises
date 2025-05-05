#!/usr/bin/env python3
# From: https://codeclubprojects.org/en-GB/python/iss/
# pip install haversine
import gpiod
import json
import urllib.request
import time
from haversine import haversine, Unit

# Get the current location of the ISS
# The API returns the current location of the ISS in JSON format
url = 'http://api.open-notify.org/iss-now.json'
# response = urllib.request.urlopen(url)
# result = json.loads(response.read())
# # print(result)

# location = result['iss_position']
# iss = (float(location['latitude']), float(location['longitude']))
# print('Current Location : ', iss)

# # Get the distance from the ISS to Brazil Indiana
# brazil = (39.525000, -87.127500)
# distance = haversine(iss, brazil, unit=Unit.MILES)
# print('Distance from ISS to Brazil : ', int(distance), 'miles')

LED_CHIP = 'gpiochip1'
blue   = 18 # 'P9_19'

LED_LINE_OFFSET = [blue]

chip = gpiod.Chip(LED_CHIP)
lines = chip.get_lines(LED_LINE_OFFSET)
lines.request(consumer='blue.py', type=gpiod.LINE_REQ_DIR_OUT)

# Turn all LEDs off
def allOff():
    print("allOff")
    lines.set_values([0])  # All off

# Turn on blue LED
print("blue on")
lines.set_values([1])     # blue
time.sleep(5)

