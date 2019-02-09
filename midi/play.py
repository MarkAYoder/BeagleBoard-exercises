#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

outport = mido.open_output("MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0")

msg = mido.Message('note_on', note=60, channel=2)
# msg.type
# msg.note
# msg.bytes()
# msg.copy(channel=2)
print(msg)


# print(outport)
outport.send(msg)

time.sleep(1)

# outport.send(mido.Message('note_off', note=60))

# with mido.open_input() as inport:
#     for msg in inport:
#         print(msg)

# mid = mido.MidiFile('song.mid')
# for msg in mid.play():
#     port.send(msg)

# port.panic()
# Stop all notes
outport.reset()
