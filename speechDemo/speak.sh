#!/bin/bash
WAV=/tmp/flite.wav
flite -o $WAV -t "$*"
# mplayer $WAV > /dev/null
aplay -Dplughw:1,0 $WAV
