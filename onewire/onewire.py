#!/usr/bin/env python
import time

w1="/sys/bus/w1/devices/28-00000114ef1b/w1_slave"

while True:
    raw = open(w1, "r").read()
    print "Temperature is "+str(float(raw.split("t=")[-1])/1000)+" degrees"
    time.sleep(1)
