#!/usr/bin/env python3
# From: https://github.com/mido/mido
# Copies to a new midi file, but doesn't work.
# Time needs to be fixed.

from mido import Message, MidiFile, MidiTrack

mid = MidiFile()
track = MidiTrack()
mid.tracks.append(track)

filename = 'midifiles/little_f.mid'

print("Reading file")
i=0
for msg in MidiFile(filename):
    i=i+1
    track.append(msg)
    if i>5000:
        break

mid.save('new_song.mid')
