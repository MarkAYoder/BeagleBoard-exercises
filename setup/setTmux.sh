#!/bin/bash
cd ~/exercises/iot/phant

tmux new-session -d -s weather
 
tmux new-window -t weather:1 -n 'Weather' './weather.js'
tmux split-window -h -t weather:1 './flashUp.js'

tmux attach-session -t weather
