#!/usr/bin/env python3
# Reads a TMP101 sensor and posts its temp on ThinkSpeak
# https://thingspeak.com/channels/538706
# source setup.sh to set THING_KEY

import requests
import os, sys
import time

TMP101a='/sys/class/i2c-adapter/i2c-2/2-0048/hwmon/hwmon0/'
TMP101b='/sys/class/i2c-adapter/i2c-2/2-0049/hwmon/hwmon1/'

# Get the key (See setup.sh)
key = os.getenv('THING_KEY', default="")
if(key == ""):
    print("THING_KEY is not set")
    sys.exit()

url = 'https://api.thingspeak.com/update'
print(url)

while(1):
    f = open(TMP101a+'temp1_input', "r")
    temp1=f.read()[:-1]     # Remove trailing new line
    # Convert from mC to C
    temp1 = int(temp1)/1000
    f.close()
    print("temp1: " + str(temp1))

    f = open(TMP101b+'temp1_input', "r")
    temp2=f.read()[:-1]
    temp2 = int(temp2)/1000
    f.close()
    print("temp2: " + str(temp2))

    payload = dict(api_key=key, field1=temp1, field2=temp2)
    r = requests.get(url, stream=True, data=payload)
    print(r)
    print(r.text)

    time.sleep(15*60)
