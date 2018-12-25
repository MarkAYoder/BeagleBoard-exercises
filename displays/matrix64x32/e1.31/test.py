#!/usr/bin/env python3
# From https://github.com/Hundemeier/sacn
import sacn
import time
import sys

color = [0, 0, 0]	# Black by default
if len(sys.argv) == 4:
    color[0] = int(sys.argv[1])
    color[1] = int(sys.argv[2])
    color[2] = int(sys.argv[3])
    print("Color: ", color[0], " ", color[1], " ", color[2])

channels = 510	# number of channels per universe
maxUniv = 74	# Total numbers of universes
sender = sacn.sACNsender()  # provide an IP-Address to bind to if you are using Windows and want to use multicast
sender.start()  # start the sending thread
# sender[univ].multicast = False  # set multicast to True
# Keep in mind that if multicast is on, unicast is not used

for univ in range(1, maxUniv):
	sender.activate_output(univ)  # start sending out data in the 1st universe
	sender[univ].destination = "fpp"  # or provide unicast information.

for count in range(1, 10):
	for univ in range(1, maxUniv):
		# sender[univ].dmx_data = (0, 255, 0, 255, 0, 0, 255, 255, 255)  # some test DMX data
		row = []
		for i in range(0, 510, 3):
			row.append(color[0])
			row.append(color[1])
			row.append(color[2])
		sender[univ].dmx_data = row
	time.sleep(0.05)  # send the data for 10 seconds

	for univ in range(1, maxUniv):
		# sender[univ].dmx_data = (0, 255, 0, 255, 0, 0, 255, 255, 255)  # some test DMX data
		row = []
		for i in range(0, 510, 3):
			row.append(color[2])
			row.append(color[1])
			row.append(color[0])
		sender[univ].dmx_data = row
	time.sleep(0.05)  # send the data for 10 seconds

sender.stop()  # do not forget to stop the sender
