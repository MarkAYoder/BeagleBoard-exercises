#!/usr/bin/env node
// Measure the weather with TMP101 sensors
const i2c     = require('i2c-bus');
const util    = require('util');
const fs      = require('fs');
const ms = 15*60*1000;               // Repeat time
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://mqtt.thingspeak.com');

// Read the i2c temp sensors
const bus = 2;
const tmp101 = [0x48, 0x4a];
const sensor = i2c.openSync(bus);

// console.log(util.inspect(request));
// request.debug = true;

// Initiate MQTT API
const filename = "/home/debian/exercises/iot/thingspeak/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));
const url = "channels/" + keys.channel_id + "/publish/" + keys.write_key;
// console.log("url: " + url);

// Set to 12-bit mode
for(var i=0; i<tmp101.length; i++) {
  const CMD_ADDR = 0x1;
  sensor.writeByteSync(tmp101[i], CMD_ADDR, 0x60);  // 12-bit mode
}

client.on('connect', function() {
  var tempOld = [];
  var temp = [];

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather(data) {

        // Read the temp sensors
        for(var i=0; i<tmp101.length; i++) {
            // Convert from C to F
            temp[i] = sensor.readWordSync(tmp101[i], 0x0);    // Read temp
            // Swap the bytes and scale
            temp[i] = (((temp[i] & 0xff) << 8) | ((temp[i] & 0xff00) >> 8))/256;
            temp[i] = temp[i]*9/5+32;     //Convert to F
            // temp[i] = Math.random();
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