#!/usr/bin/env python3
# From https://github.com/Hundemeier/sacn
import sacn
import time
import sys
import math
from PIL import Image

bright = 255	# Max brightness
channels = 510	# number of channels per universe
maxUniv = 74	# Total numbers of universes
cols = 192
rows = 64

file = "sarahSmall.jpg"
if len(sys.argv) >= 2:
    file = sys.argv[1]

if len(sys.argv) >= 3:
    bright = int(sys.argv[2])

im = Image.open(file)
print(file, im.bits, im.size, im.format, im.mode)
if im.size > (cols, rows):
    print("Image too big. Max size is: ", cols, "x", rows)
    sys.exit(1)

# Right justify the image
offset = math.floor((cols-im.size[0]))
print("offset: ", offset)

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
row = channels*[0]	# Start with a blank row

for j in range(im.size[1]):
    for i in range(im.size[0]):
        univ = math.floor(3*(j*cols+i+offset) / channels) + 1	# Univ starts with 1
        # print("univ: ", univ)
        if(univ != lastUniv):	# You've switched universes
            # print("New univ: ", univ, i, j)
            # print("lastUniv: ", lastUniv)
            sender[lastUniv].dmx_data = row
            row = channels*[0]
            lastUniv = univ
        rgb = im.getpixel((i, j))
        idx = (3*(j*cols+i+offset)) % channels
        # print("i, j ", i, j, "idx: ", idx, "univ: ", univ)
        for k in range(3):
            row[idx+k] = math.floor(rgb[k]*bright/255)

sender[univ].dmx_data = row

time.sleep(0.05)

sender.stop()  # do not forget to stop the sender
