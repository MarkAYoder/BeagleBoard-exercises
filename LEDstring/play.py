#!/usr/bin/python
from time import sleep
import math

len = 320
max = 30

# Open a file
fo = open("/sys/firmware/lpd8806/device/rgb", "w", 0)

# Turn whole string off
def clear(r,g,b):
    for i in range(0, len):
        fo.write("%d %d %d %d" % (r, g, b, i))
        
def skiUpDown():
    for i in range(0, len-1):
        fo.write("%d %d %d %d" % (0, 0, 0, i))
        fo.write("%d %d %d %d" % (max, 0, 0, i+1))
        fo.write("\n");
        sleep(0.05)
    
    for i in range(len, 1, -1):
        fo.write("%d %d %d %d" % (0, 0, 0, i))
        fo.write("%d %d %d %d" % (0, 0, max, i-1))
        fo.write("\n");
        sleep(0.02)
    
clear(0, 20, 0)

while True:
    skiUpDown()
        
# Close opened file
fo.close()
