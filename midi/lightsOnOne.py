#!/usr/bin/env python3
# From: https://github.com/mido/mido
# Turn on one light

import mido, sys

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
outport.send(msg)

light = 1
if len(sys.argv) == 2:
    light = int(sys.argv[1])

msg = mido.Message('program_change', channel=11, program=light)
# print(msg)
outport.send(msg)
