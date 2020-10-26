#!/usr/bin/env python3
# Reads a TMP101 sensor and posts its temp on ThinkSpeak
# https://thingspeak.com/channels/538706
# source setup.sh to set THING_KEY

import requests
import os, sys

TMP101='/sys/class/i2c-adapter/i2c-2/2-0049/hwmon/hwmon0/'

# Get the key (See setup.sh)
key = os.getenv('THING_KEY', default="")
if(key == ""):
    print("THING_KEY is not set")
    sys.exit()

f = open(TMP101+'temp1_input', "r")
temp=f.read()[:-1]     # Remove trailing new line
# Convert from mC to C
temp = int(temp)/1000
f.close()

print("temp: " + str(temp))
payload = dict(api_key=key, field1=temp, field2='25')

url = 'https://api.thingspeak.com/update'

print(url)

r = requests.get(url, stream=True, data=payload)

print(r)
print(r.text)
