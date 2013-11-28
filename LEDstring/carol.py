#!/usr/bin/python
from time import sleep
import math

len = 320
amp = 25
f = 25
shift = 3
time = 0
max = 128

# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

while True:
    for i in range(0, len):
        r = (amp * (math.sin(2*math.pi*f*(i+time-0*shift)/len) + 1)) + 1;
        g = 4#(amp * (math.sin(2*math.pi*f*(i-time-1*shift)/len) + 1)) + 1;
        b = 1;#(amp * (math.sin(2*math.pi*f*(i-time-2*shift)/len) + 1)) + 1;
        fo.write("%d %d %d %d" % (r%max, g%max, b%max, i))
        # print("0 0 127 %d" % (i))

    fo.write("0 0 0 -1\n");
    time = time + 1
    sleep(0.100)

# Close opened file
fo.close()