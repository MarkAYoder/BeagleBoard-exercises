This is a program for controlling a balancing robot via the web.
robotWebControl.py uses Flask and Socket.io to create a web server that 
serves a page with buttons for controlling the robot.  It sends its commands to
../python/balance.py via a named pipe called 'pipe'.

Run in two windows.
sudo ../python/balance.py < pipe  # Reads from the named pipe
./robotWebControl.py
