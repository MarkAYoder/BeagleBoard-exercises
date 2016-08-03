# Go to https://data.sparkfun.com/streams/make and create a data stream
# Save the keys in phantKeys.json
npm install -g request

wget https://raw.githubusercontent.com/ControlEverythingCommunity/SI7021/master/C/SI7021.c si7021.c

echo "# Record BIC temp
NODE_PATH=/usr/local/lib/node_modules
* * * * * root /root/exercises/sensors/bic/logTemp.js 2>&1 | logger" > /etc/crontab
