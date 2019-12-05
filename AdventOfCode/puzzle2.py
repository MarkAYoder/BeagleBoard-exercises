#!/usr/bin/env python3

import sys

# Read in the program, convert to an array of strings
data = sys.stdin.readlines()[0].split(',')

# print(data)

# Convert each string to an intger
for i in range(len(data)):
    data[i] = int(data[i])
    
print(data)

pc = 0
while(data[pc] != 99):
    print('pc: %d' %(pc))
    # print (data[pc])
    if(data[pc] == 1):
        data[data[pc+3]] = data[data[pc+1]] + data[data[pc+2]]
    elif(data[pc] == 2):
        data[data[pc+3]] = data[data[pc+1]] * data[data[pc+2]]
    pc = pc +4
    print(data)