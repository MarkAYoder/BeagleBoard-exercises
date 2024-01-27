#!/usr/bin/env python3
# From: https://codeclubprojects.org/en-GB/python/iss/
import json
import urllib.request
import time

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
# print(result)

location = result['iss_position']
lat = location['latitude']
lon = location['longitude']
print('Current Location : ', lat, ', ', lon)


# url = 'http://api.open-notify.org/iss-pass.json?lat=39.5&lon=-87.2&n=10'
# response = urllib.request.urlopen(url)
# result = json.loads(response.read())
# # print(result)

# print('Next time overhead: ')
# for over in result['response']:
#     print(time.ctime(over['risetime']))
