# Installing crontab entery for turning off LED triggers at night
echo "
# Turn off LED triggers at night
NODE_PATH=/usr/local/lib/node_modules
1 5  58 * *   root    /root/exercises/setup/ledTrigger.js
1 21  * * *   root    /root/exercises/setup/ledTrigger.js off" >> /etc/crontab
