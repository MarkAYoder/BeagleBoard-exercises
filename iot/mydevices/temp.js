#!/usr/bin/env node
// Measure the weather
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// const BMP085        = require('bmp085');
const i2c     = require('i2c-bus');
const util          = require('util');
const fs            = require('fs');
const ms = 15*1000;               // Repeat time
const Cayenne = require('cayennejs');

// Read the i2c temp sensors
const bus = 2;
const tmp101 = [0x48, 0x4a];
const sensor = i2c.openSync(bus);

// console.log(util.inspect(request));
// request.debug = true;

// Initiate MQTT API
const filename = "/home/debian/exercises/iot/mydevices/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));
const cayenneClient = new Cayenne.MQTT(keys);
const channel = 0;  // Record temp on channel 0

cayenneClient.connect((err, mqttClient) => {
  var tempOld = 25;
  var temp = [];

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather(data) {

        // Read the temp sensors
        for(var i=0; i<tmp101.length; i++) {
            temp[i] = sensor.readByteSync(tmp101[i], 0x0);
            // temp[i] = Math.random();
            console.log("temp: %dC, %dF (0x%s)", temp[i], temp[i]*9/5+32, tmp101[i].toString(16));
        }
        // dashboard widget automatically detects datatype & unit
        if(temp[0] !== tempOld) {
          console.log("Updating from: " + tempOld);
          cayenneClient.celsiusWrite(channel, temp[0]);
          tempOld = temp[0];
        }
    }
});