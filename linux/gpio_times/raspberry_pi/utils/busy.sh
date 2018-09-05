#!/bin/bash
# script to do some processor and I/O work to keep things busy

while true
do
   echo "this is a test"
   date
   true
   # do some processor work
   echo $((13**99)) 1>/dev/null 2>&1
   # do some I/O work
   sync

   # check to see if user has created the "stop" file
   if [ -e ~/.stoprunning ]
   then
#      echo "$0 stop"
      exit
   fi
done
