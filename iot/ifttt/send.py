#!/usr/bin/env python3
import requests
import json
# // event = 'my_test'
# // event = 'my_Web'
# // event = 'tweet'
event = 'my_mail'
# event = 'sms'
# // event = 'notification'
# // event = 'phone'
key = 'EG33hBxy7L7W3DvKnNoCh'
payload = dict(value1= 'My', value2= 'Test 2', value3= 'BeagleBone')

url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key

print(url)

r = requests.get(url, stream=True, data=payload)

print(r)
r.raw.decode_content = True
print(r.text)