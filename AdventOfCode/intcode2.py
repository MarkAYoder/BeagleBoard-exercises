#!/usr/bin/env python3

import sys

# Read in the program, convert to an array of strings
# data = sys.stdin.readlines()[0].split(',')
initdata = '1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,10,19,23,2,9,23,27,1,6,27,31,2,31,9,35,1,5,35,39,1,10,39,43,1,10,43,47,2,13,47,51,1,10,51,55,2,55,10,59,1,9,59,63,2,6,63,67,1,5,67,71,1,71,5,75,1,5,75,79,2,79,13,83,1,83,5,87,2,6,87,91,1,5,91,95,1,95,9,99,1,99,6,103,1,103,13,107,1,107,5,111,2,111,13,115,1,115,6,119,1,6,119,123,2,123,13,127,1,10,127,131,1,131,2,135,1,135,5,0,99,2,14,0,0'.split(',')

# print(data)

# Convert each string to an intger
for i in range(len(initdata)):
    initdata[i] = int(initdata[i])
    
print(initdata)

#  Initialize the machine
for noun in range(100):
    for verb in range(100):
        pc = 0
        data = initdata.copy()
        data[0] = 1
        data[1] = noun
        data[2] = verb
        # print('noun: %d, verb: %d' %(noun, verb))
        # print(data)
        while(data[pc] != 99):
            # print('pc: %d' %(pc))
            # print (data)
            if(data[pc] == 1):
                data[data[pc+3]] = data[data[pc+1]] + data[data[pc+2]]
            elif(data[pc] == 2):
                data[data[pc+3]] = data[data[pc+1]] * data[data[pc+2]]
            pc = pc +4
        # print(data)
        if data[0] == 19690720:
            print('noun: %d, verb: %d' %(noun, verb))
            break