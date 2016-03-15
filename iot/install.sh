# Installing crontab entery for turning off LED triggers at night
echo "# Turn off LED triggers at night
NODE_PATH=/usr/local/lib/node_modules
1 6   * * *   root    /root/exercises/iot/ledTrigger.js
1 21  * * *   root    /root/exercises/iot/ledTrigger.js off
" >> /etc/crontab
