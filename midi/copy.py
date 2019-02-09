#!/usr/bin/env python3
# From: https://github.com/mido/mido

from mido import Message, MidiFile, MidiTrack

mid = MidiFile()
track = MidiTrack()
mid.tracks.append(track)


# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

filename = 'midifiles/brandenb.mid'
filename = 'midifiles/little_f.mid'

print("Reading file")
i=0
for msg in MidiFile(filename):
    i=i+1
    track.append(msg)
    if i>5000:
        break

mid.save('new_song.mid')
