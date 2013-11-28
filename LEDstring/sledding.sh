#!/bin/bash
# Usage:
# sledding.sh  starts the sledders
# sledding.sh kill  stops them
if [ "x${1}" != "xkill" ]
then
  # Launch 5 sledders
  for i in {1..10}
  do
    ./tree 3 60000 20000 &
    sleep 2
  done

  # ./fire 48 0 &
  ./fire  7 1 &
else
  # Kill the processes
  for app in 'tree 3' 'fire 7'
  do
    kill $(ps aux | grep "\./$app" | awk '{print $2}')
  done
fi
