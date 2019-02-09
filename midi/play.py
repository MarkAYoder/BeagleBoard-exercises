#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
msg = mido.Message('note_on', note=60)
msg.type
msg.note
msg.bytes()

msg.copy(channel=2)

port = mido.open_output('Port Name')
port.send(msg)

with mido.open_input() as inport:
    for msg in inport:
        print(msg)

mid = mido.MidiFile('song.mid')
for msg in mid.play():
    port.send(msg)