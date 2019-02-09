#!/usr/bin/env python3
# From: https://github.com/mido/mido
# Maps channels to 0-2

import mido
import time

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"
filename = 'midifiles/little_f.mid'
# filename = 'midifiles/brand3.mid'
# filename = 'midifiles/brandenb.mid'

outport = mido.open_output(organ)

i=0
for msg in mido.MidiFile(filename):
    i=i+1
    if i>0:
        time.sleep(msg.time)
        if not msg.is_meta:
            outport.send(msg)
            print(msg)
        else:
            print('***')
            print(msg)
    if i>5000:
        break

# port.panic()
# Stop all notes
outport.reset()
