#!/usr/bin/env python3
import requests
import json
# event = 'my_test'
# event = 'my_Web'
# event = 'tweet'
event = 'my_mail'
# event = 'sms'
# event = 'notification'
# event = 'phone'
# event ='start_call'
key = 'EG33hBxy7L7W3DvKnNoCh'
payload = dict(value1= '1-812-233-3219', value2= 'Test 2', value3= 'BeagleBone')

url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key

print(url)

r = requests.get(url, stream=True, data=payload)

print(r)
print(r.text)
