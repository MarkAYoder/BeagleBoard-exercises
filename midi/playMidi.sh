#!/usr/bin/env bash
# Do this to play one midi file
# playMidi.py filename light#
echo $0 $1 $2
./register.py p    # Set registration
aplaymidi -p 20 $1
./lightsOnOne.py $2     # Turn on one light to show it's done