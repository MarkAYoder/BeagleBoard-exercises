#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"

outport = mido.open_output(organ)

msg = mido.Message('note_on', note=60, channel=2)
# msg.type
# msg.note
# msg.bytes()
# msg.copy(channel=2)
print(msg)


# print(outport)
# outport.send(msg)

# time.sleep(1)

# outport.send(mido.Message('note_off', note=60))

# with mido.open_input(organ) as inport:
#     for msg in inport:
#         print(msg)
#         if msg.note == 36:
#             break

mid = mido.MidiFile('midifiles/little_f.mid')
i=0
for msg in mid.play():
    if i>200:
        outport.send(msg)
        print(msg)
    i=i+1
    if i>500:
        break

# port.panic()
# Stop all notes
outport.reset()
