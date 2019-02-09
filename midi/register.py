#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import sys

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

vol = 'pp'
stops = [4, 17, 18, 33]

if len(sys.argv) == 2:
    vol = sys.argv[1]

print(vol)

if vol == 'pp':
    stops = [4, 17, 18, 33]
elif vol == 'p':
    stops = [4, 6, 16, 20, 33, 36, 45]
elif vol == 'mf':
    stops = [4, 5, 6, 12, 15, 16, 19, 20, 32, 33, 35, 36, 45]
elif vol == 'f':
    stops = [3, 4, 5, 6, 7, 11, 12, 15, 16, 19, 20, 27, 
                32, 33, 34, 35, 36, 38, 45]
elif vol == 'ff':
    stops = [3, 4, 5, 6, 7, 8, 10, 11, 12, 15, 16, 17, 19, 20, 21,
                22, 25, 27, 31, 32, 33, 34, 35, 36, 37, 38, 40, 
                42, 45]
elif vol == 't':
    stops = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 19, 20, 21,
                22, 24, 25, 26, 27, 31, 32, 33, 34, 35, 36, 37, 38, 40, 
                41, 42, 43, 45]


organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

print("Sending cancel")
msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
outport.send(msg)

for i in stops:
    msg = mido.Message('program_change', channel=11, program=i)
    # print(msg)
    outport.send(msg)

# Stop all notes
outport.reset()
