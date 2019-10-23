#!/usr/bin/env node
// Measure the weather with TMP101 sensors
// Uses kernel driver
//
// bone$ cd /sys/class/i2c-adapter/i2c-2
// bone$ sudo chgrp debian *
// bone$ sudo chmod g+w delete_device new_device
// bone$ echo tmp101 0x48 > new_device
// bone$ cd 2-0048/hwmon/hwmon0
// bone$ cat temp1_input
// 24250

// const i2c     = require('i2c-bus');
const util    = require('util');
const fs      = require('fs');
const ms = 15*1000;               // Repeat time
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://mqtt.thingspeak.com');

// Read the i2c temp sensors
const tmp101 = ['/sys/class/i2c-adapter/i2c-2/2-0048/hwmon/hwmon0/temp1_input'];

// console.log(util.inspect(request));
// request.debug = true;

// Initiate MQTT API
const filename = "/home/debian/exercises/iot/thingspeak/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));
const url = "channels/" + keys.channel_id + "/publish/" + keys.write_key;
// console.log("url: " + url);

client.on('connect', function() {
  var tempOld = [];
  var temp = [];

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather(data) {

        // Read the temp sensors
        for(var i=0; i<tmp101.length; i++) {
            // Convert from C to F
            temp[i] = fs.readFileSync(tmp101[i])/1000;
            temp[i] = temp[i]*9/5+32;     //Convert to F
            console.log("temp: %dF (0x%s)", temp[i], tmp101[i].toString(16));
        }
        // dashboard widget automatically detects datatype & unit
        if((temp[0] !== tempOld[0]) || (temp[1] !== tempOld[1])) {
          console.log("Updating from: " + tempOld[0] + " " + tempOld[1]);
          client.publish(url, util.format("field1=%s&field2=%s", temp[0], temp[1]));
          tempOld[0] = temp[0];
          tempOld[1] = temp[1];
        }
    }
});