#!/usr/bin/env python3
# From: https://github.com/mido/mido
# This changes the volume on the fly.

import mido
import sys

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

vol=64
if len(sys.argv) == 2:
    vol = int(sys.argv[1])

for chan in range(3):
    msg = mido.Message('control_change', channel=chan, control=7, value=vol)
    print(msg)
    outport.send(msg)
