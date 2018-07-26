#!/usr/bin/env node
// Measure the weather with TMP101 sensors
const i2c     = require('i2c-bus');
const util          = require('util');
const fs            = require('fs');
const ms = 15*1000;               // Repeat time
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://things.ubidots.com', {
    username: 'A1E-CwTZx0K0SBYokmm2qBop9YIr8dpkRu',
    password: ""
});
const device = "office";

// Read the i2c temp sensors
const bus = 2;
const tmp101 = [0x48, 0x4a];
const sensor = i2c.openSync(bus);

// console.log(util.inspect(request));
// request.debug = true;

client.on('connect', function() {
  var tempOld = [];
  var temp = [];

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather() {

        // Read the temp sensors
        console.log(Date().toString());
        for(var i=0; i<tmp101.length; i++) {
            // Convert from C to F
            temp[i] = sensor.readByteSync(tmp101[i], 0x0)*9/5+32;
            console.log("temp: %dF (0x%s)", temp[i], tmp101[i].toString(16));
        }
        // dashboard widget automatically detects datatype & unit
        if((temp[0] !== tempOld[0]) || (temp[1] !== tempOld[1])) {
          console.log("Updating from: " + tempOld[0] + " " + tempOld[1]);
          var variablesPublish = {
              "Temperature0": temp[0],
              "Temperature1": temp[1], 
              };  
          var json = JSON.stringify(variablesPublish);

          client.publish("/v1.6/devices/" + device, json, {'qos': 1},
              function (err, response) {
                  if(err) {
                      console.log(err);
                  }
                  console.log(response);
              });
          tempOld[0] = temp[0];
          tempOld[1] = temp[1];
        }
    }
});