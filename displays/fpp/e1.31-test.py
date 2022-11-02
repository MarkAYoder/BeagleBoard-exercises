#!/usr/bin/env python3
# Controls a NeoPixel (WS2812) string via E1.31 and FPP
# https://pypi.org/project/sacn/
# https://github.com/FalconChristmas/fpp/releases
import sacn
import time

# provide an IP-Address to bind to if you are using Windows and want to use multicast
univ = 32
sender = sacn.sACNsender()
sender.start()							# start the sending thread
sender.activate_output(univ)		# start sending out data in the 1st universe
sender[univ].multicast = False # set multicast to True
sender[univ].destination = "192.168.7.2"  # or provide unicast information.
sender.manual_flush = True # turning off the automatic sending of packets
# Keep in mind that if multicast is on, unicast is not used
LEDcount = 170
# Have green fade is as it goes
data = []
for i in range(LEDcount):
	data.append(0)		# Red
	data.append(255)	# Green
	data.append(0)		# Blue
sender[univ].dmx_data = data
sender.flush()
time.sleep(2)

# Turn off all LEDs
data=[]
for i in range(3*LEDcount):
	data.append(0)
sender[univ].dmx_data = data
sender.flush()
time.sleep(0.25)

# Have red fade in
data = []
for i in range(LEDcount):
	data.append(i)
	data.append(0)
	data.append(0)
sender[univ].dmx_data = data
sender.flush()
time.sleep(5)

# Make LED circle 5 times
for j in range(5):
	for i in range(LEDcount-1):
		data[3*i+0] = 0
		data[3*i+1] = 0
		data[3*i+2] = 0
		data[3*i+3] = 0
		data[3*i+4] = 64
		data[3*i+5] = 0
		sender[univ].dmx_data = data
		sender.flush()
		time.sleep(0.02)
# Wrap around
	i = LEDcount-1
	data[0] = 0
	data[1] = 64
	data[2] = 0
	data[3*i+0] = 0
	data[3*i+1] = 0
	data[3*i+2] = 0
	sender[univ].dmx_data = data
	sender.flush()
	time.sleep(0.02)
    
time.sleep(2)  # send the data for 10 seconds
sender.stop()  # do not forget to stop the sender
