#!/usr/bin/env python3
# From: https://codeclubprojects.org/en-GB/python/iss/
# pip install haversine
import json
import urllib.request
from haversine import haversine, Unit

# Get the current location of the ISS
# The API returns the current location of the ISS in JSON format
url = 'http://api.open-notify.org/iss-now.json'
response = urllib.request.urlopen(url)
result = json.loads(response.read())
# print(result)

location = result['iss_position']
iss = (float(location['latitude']), float(location['longitude']))
print('Current Location : ', iss)

# Get the distance from the ISS to Brazil Indiana
brazil = (39.525000, -87.127500)
distance = haversine(iss, brazil, unit=Unit.MILES)
print('Distance from ISS to Brazil : ', int(distance), 'miles')
