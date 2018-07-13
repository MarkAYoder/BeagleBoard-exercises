#!/usr/bin/env node
// Measure the weather
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282
// Record with mqtt on ThingSpeak

const BMP085        = require('bmp085');
const util          = require('util');
const fs            = require('fs');
const ms = 15*1000;               // Repeat time
const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://mqtt.thingspeak.com');


// Initiate MQTT API
const filename = "/home/debian/exercises/iot/thingspeak/keys_home.json";
const keys = JSON.parse(fs.readFileSync(filename));
const url = "channels/" + keys.channel_id + "/publish/" + keys.write_key;
console.log("url: " + url);

const barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

client.on('connect', function() {
    var tempOld  = 0;
    var pressOld = 0;

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather() {
        barometer.read(postTemp);
    }
    
    function postTemp(data) {
        // logger.debug("data: " + util.inspect(data));
        console.log("data: " + util.inspect(data));
        const temp = data.temperature;
        const pressure = data.pressure.toFixed(1);
    
        // logger.debug("temp: " + temp);
        // logger.debug("pressure: " + pressure);
        console.log("temp: " + temp);
        console.log("pressure: " + pressure);

        if((temp !== tempOld) || (pressure !== pressOld)) {
          console.log("Updating from: " + tempOld + " " + pressOld);
          client.publish(url, util.format("field1=%s&field2=%s", temp, pressure));
          tempOld  = temp;
          pressOld = pressure;
        }
    }
});