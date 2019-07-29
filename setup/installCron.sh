#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Installing crontab entery for turning off LED triggers at night
# and sending sms message when running
echo "
# Turn off LED triggers at night
NODE_PATH=/usr/local/lib/node_modules
58 5  * * *   root    /home/debian/exercises/setup/ledTrigger.js
2 21  * * *   root    /home/debian/exercises/setup/ledTrigger.js off
" >> /etc/crontab

# * * * * * root /home/debian/exercises/iot/phant/recordPing.js 2>&1 | logger

# echo "
# Remind me that the machine is running
# *  *    * * *   root    /home/yoder/BeagleBoard/exercises/iot/sms/sms.curl \`uname -n\` is running
# " >> /etc/crontab

