#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"
filename = 'midifiles/little_f.mid'
filename = 'midifiles/brand3.mid'

print("Press a key")

with mido.open_input(organ) as inport:
    for msg in inport:
        print(msg)
        if msg.type == 'note_on' and msg.note == 36:
            break
