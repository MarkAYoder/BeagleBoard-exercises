#!/bin/bash
WAV=/tmp/flite.wav
flite -o $WAV -t "$*"
mplayer $WAV > /dev/null