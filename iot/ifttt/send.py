#!/usr/bin/env python3
import requests
import json
import os

# event = 'my_mail'
# event = 'log'
event = 'logone'

# Get the key (See setup.sh)
key = str(os.getenv('IFTTT_KEY'))

payload = dict(value1= 'Hello', value2= 'Test 2', value3= 'BeagleBone')

url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key

print(url)

r = requests.get(url, stream=True, data=payload)

print(r)
print(r.text)
