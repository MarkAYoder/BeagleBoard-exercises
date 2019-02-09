#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

print("Sending cancel")
msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
print(msg)
outport.send(msg)
