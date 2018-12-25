#!/usr/bin/env python3
# From https://github.com/Hundemeier/sacn
import sacn
import time
import sys
import math
from PIL import Image

im = Image.open("sarahSmall.jpg")
print(im.bits, im.size, im.format, im.mode)

for i in range(48, 58):
	r, g, b = im.getpixel((i, i))
	print(r, g, b)

channels = 510	# number of channels per universe
maxUniv = 74	# Total numbers of universes
cols = 192
rows = 64
sender = sacn.sACNsender()  # provide an IP-Address to bind to if you are using Windows and want to use multicast
sender.start()  # start the sending thread
# sender[univ].multicast = False  # set multicast to True
# Keep in mind that if multicast is on, unicast is not used

for univ in range(1, maxUniv):
	sender.activate_output(univ)  # start sending out data in the 1st universe
	sender[univ].destination = "fpp"  # or provide unicast information.

# Cycle through each pixel one row at a time
# Fill in each universe and then send it
lastUniv = 1	# If different than last univ, send
row = channels*[0]

for j in range(im.size[1]):
    for i in range(im.size[0]):
        univ = math.floor(3*(j*cols+i) / channels) + 1	# Univ starts with 1
        # print("univ: ", univ)
        if(univ != lastUniv):	# You've switched universes
            print("New univ: ", univ, i, j)
            print("lastUniv: ", lastUniv)
            sender[lastUniv].dmx_data = row
            row = channels*[0]
            lastUniv = univ
        rgb = im.getpixel((i, j))
        idx = (3*(j*cols+i)) % channels
        print("i, j ", i, j, "idx: ", idx, "univ: ", univ)
        row[idx+0] = rgb[0]
        row[idx+1] = rgb[1]
        row[idx+2] = rgb[2]

sender[univ].dmx_data = row

time.sleep(0.05)

sender.stop()  # do not forget to stop the sender
