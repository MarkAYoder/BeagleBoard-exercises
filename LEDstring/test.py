#!/usr/bin/python
from time import sleep

len = 320

# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)
r = 10
g = 20
b = 30
for i in range(0, 10):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))
        # print("0 0 127 %d" % (i))

    r = r + 1
    g = g + 1
    b = b + 1

    fo.write("\n");
    sleep(0.100)

# Close opened file
fo.close()