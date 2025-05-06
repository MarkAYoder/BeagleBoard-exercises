#!/usr/bin/env python3
# From: https://codeclubprojects.org/en-GB/python/iss/
# pip install haversine
# pip install geopy
import gpiod
import json
import urllib.request
import time
from haversine import haversine, Unit
from geopy.geocoders import Nominatim

# calling the Nominatim tool and create Nominatim class
loc = Nominatim(user_agent="Geopy Library")
# entering the location name
getLoc = loc.geocode("Brazil Indiana USA")
# printing address
print(getLoc.address)
brazil = (getLoc.latitude, getLoc.longitude)

url = 'http://api.open-notify.org/iss-now.json'

LED_CHIP = 'gpiochip1'
blue   = 18 # 'P9_19'

LED_LINE_OFFSET = [blue]

chip = gpiod.Chip(LED_CHIP)
lines = chip.get_lines(LED_LINE_OFFSET)
lines.request(consumer='blue.py', type=gpiod.LINE_REQ_DIR_OUT)

# Turn on blue LED
print("blue on")
lines.set_values([1])     # blue LED on

def control_led_based_on_distance():
    try:
        # Get the current location of the ISS
        response = urllib.request.urlopen(url)
        result = json.loads(response.read())
        # print(result)

        location = result['iss_position']
        iss = (float(location['latitude']), float(location['longitude']))
        print('Current Location : ', iss)

        # Get the distance from the ISS to Brazil Indiana
        # haversine returns distance in miles between two points
        distance = haversine(iss, brazil, unit=Unit.MILES)
        print('Distance from ISS to Brazil : ', int(distance), 'miles, ', int(distance*1.60934), 'km')

        if distance < 1000:
            print("Distance < 1000 miles")
            lines.set_values([1])
        else:
            print("Distance > 1000 miles")
            lines.set_values([0])

    except Exception as err:
        print('ERROR:', err)

# Main loop
while True:
    control_led_based_on_distance()
    time.sleep(60)  # Wait for 60 seconds before checking again
