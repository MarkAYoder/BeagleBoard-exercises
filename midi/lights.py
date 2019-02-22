#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

print("Sending cancel")
msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
outport.send(msg)

for j in range(10):
    for i in range(3, 53):
        msg = mido.Message('program_change', channel=11, program=i)
        # print(msg)
        outport.send(msg)
        time.sleep(0.02)
