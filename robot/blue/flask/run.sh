# Here's how to run the web controlled robot
# sudo ../python/balance.py < pipe & 
# ./robotWebControl.py

tmux new-session -d -s robot
tmux new-window -t robot:1 -n 'Robot Web Control' ./robotWebControl.py 
tmux split-window -v -t robot:1 "sudo ../python/balance.py < pipe"
tmux a -t robot
