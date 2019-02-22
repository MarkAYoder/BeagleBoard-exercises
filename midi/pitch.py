#!/usr/bin/env python3
# From: https://github.com/mido/mido
# This is supposed to change the pitch on the fly, but it doesn't work.

import mido
import time

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

for pitch in range(33, 95):
    for chan in range(3):
        msg = mido.Message('control_change', channel=chan, control=100, value=1)
        outport.send(msg)
        msg = mido.Message('control_change', channel=chan, control=101, value=0)
        outport.send(msg)
        msg = mido.Message('control_change', channel=chan, control=6, value=pitch)
        print(msg)
        outport.send(msg)
    time.sleep(0.5)
