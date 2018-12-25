#!/usr/bin/env python3
# From https://github.com/Hundemeier/sacn
import sacn
import time

sender = sacn.sACNsender()  # provide an IP-Address to bind to if you are using Windows and want to use multicast
sender.start()  # start the sending thread
# sender[univ].multicast = False  # set multicast to True
# Keep in mind that if multicast is on, unicast is not used

for univ in range(1, 74):
	sender.activate_output(univ)  # start sending out data in the 1st universe
	sender[univ].destination = "fpp"  # or provide unicast information.

for univ in range(1, 74):
	# sender[univ].dmx_data = (0, 255, 0, 255, 0, 0, 255, 255, 255)  # some test DMX data
	row = []
	for i in range(0, 510, 3):
		row.append( 10)
		row.append( 10)
		row.append( 30)
	sender[univ].dmx_data = row

time.sleep(0.1)  # send the data for 10 seconds
sender.stop()  # do not forget to stop the sender
