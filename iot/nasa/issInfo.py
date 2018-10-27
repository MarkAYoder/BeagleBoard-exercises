#!/usr/bin/env python3
# From: https://codeclubprojects.org/en-GB/python/iss/
import json
import urllib.request
url = 'http://api.open-notify.org/astros.json'
response = urllib.request.urlopen(url)
result = json.loads(response.read())
# print(result)

print('People in Space: ', result['number'])
for p in result['people']:
    print(p['name'])

url = 'http://api.open-notify.org/iss-now.json'
response = urllib.request.urlopen(url)
result = json.loads(response.read())
print(result)

location = result['iss_position']
lat = location['latitude']
lon = location['longitude']
print('Latitude: ', lat, ' Longitude: ', lon)


lat = 39.5
long = -87.2
