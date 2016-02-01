#!/usr/bin/env node
var mqtt = require('mqtt'),
    util = require('util'),
    host = 'io.adafruit.com', // or localhost
  // , client = mqtt.connect();
    client = mqtt.connect({ 
    port: 1883, host: host, keepalive: 10000,
    username: 'markyoder', password: 'e3c496b806b35ce4b3c97dd3cb7cf8af0ca2d196'
  });

client.subscribe('markyoder/feeds/Wunderground');
client.publish('markyoder/feeds/Wunderground', '23');
client.on('message', function (topic, message) {
  console.log(topic);
  console.log(message.values);
});
client.end();
