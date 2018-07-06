#!/usr/bin/python
from time import sleep
import math

length = 24
max = 25

# Open a file
fo = open("/dev/rpmsg_pru30", "w", 0)

colors = [[1,0,0],[1,1,0],[0,1,0],[0,1,1],[0,0,1],[1,0,1]]

oldr=0
oldb=0
oldg=0

while True:
    for color in colors:
        newr = color[0]
        newg = color[1]
        newb = color[2]
        maxtime=20
        for time in range(0, maxtime):
            r = (max*oldr+(newr-oldr)*max*time/maxtime)
            g = (max*oldg+(newg-oldg)*max*time/maxtime)
            b = (max*oldb+(newb-oldb)*max*time/maxtime)
            for i in range(0, length):
                fo.write("%d %d %d %d" % (i, r, g, b))
                # print("0 0 127 %d" % (i))
            fo.write("-1 0 0 0\n");    
            
            # print (r,g,b)
            
            sleep(0.100)
            
        oldr=newr
        oldg=newg
        oldb=newb

# Close opened file
fo.close()