#!/usr/bin/env python3
# if you install it from pip, else use `from Blynk import *`
from blynkapi import Blynk
import time

# vars
auth_token = "dc1c083949324ca28fbf393231f8cf09"

# create objects
v0 =  Blynk(auth_token, pin = "V0" )
v10 = Blynk(auth_token, pin = "V10")

# get current status
res = v0.get_val()
print(res)

# set pin value to 1
print("V10 on")
v10.set_val(255)
# set pin value to 0
time.sleep(10)

print("V10 off")
v10.off()