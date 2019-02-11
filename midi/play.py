#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time, sys

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

filename = 'midifiles/little_f.mid'
if len(sys.argv) == 2:
    filename = sys.argv[1]

print("Playing: " + filename)

outport = mido.open_output(organ)

# msg = mido.Message('note_on', note=60, channel=2)
# msg.type
# msg.note
# msg.bytes()
# msg.copy(channel=2)
# print(msg)

# print(outport)
# outport.send(msg)

for msg in mido.MidiFile(filename):
    time.sleep(msg.time)
    if not msg.is_meta:
        if hasattr(msg, 'channel'):
            # map all channels to 0-2
            if msg.channel != 9:   # Don't do drums
                outport.send(msg.copy(channel=msg.channel%3))
                # if msg.channel != (msg.channel%3):
                #   print(msg)
    else:
        print('***')
        print(msg)

# Stop all notes
outport.reset()
