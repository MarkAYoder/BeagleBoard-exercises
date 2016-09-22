# To run .js scripts on bone be sure to update request
npm install -g request bmp085 winston

# the bmp085 install if failing.  Try:
npm install -g underscore
wget https://raw.githubusercontent.com/fiskeben/bmp085/master/bmp085.js
# Change require('bmp085') to require('./bmp085')

# From: http://phant.io/beaglebone/install/2014/07/03/beaglebone-black-install/

# npm install -g phant
# phant &
# Browse to https://data.sparkfun.com/ and click "Create" and fill in the fields
# Save the keys as json.

# Load jquery and jsapi
wget https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js
wget https://www.google.com/jsapi

# Log some data
# wget http://14.139.34.32:8080/input/$phant_PUBLIC?private_key=$ylDNWDNO7yFGDwORErVjCN84lmz\&amplitude=23.29\&timestamp=25.94

# Make html visible to default web server
dir=$PWD
cd $webRoot
ln -s $dir .

echo "# Record ping times
NODE_PATH=/usr/local/lib/node_modules
* * * * * root /root/exercises/iot/phant/recordPing.js 2>&1 | logger
" >> /etc/crontab 
# Look in /var/log/message for logger messages
