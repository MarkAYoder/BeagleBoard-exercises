#!/bin/bash
# script to create lots of busy work by creating lots of busy processes

# remove the file that stops us from running
rm ~/.stoprunning

# self-limit the script - create the file that will stop the scripts
# after 100 seconds.  This removes the long term I/O-bound processes
# that can cause the kernel the complain about a process being blocked
# for more than 120 seconds
(sleep 100; touch ~/.stoprunning)&

while true
do
   echo "Running script $0"
   ./busy.sh &
   if [ -e ~/.stoprunning ]
   then
      echo "$0 is stopping"
      exit
   fi
done
