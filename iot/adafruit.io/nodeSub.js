#!/usr/bin/env node
// Useage nodeSub.js [message] [feed]
var mqtt = require('mqtt'),
    host = 'io.adafruit.com', // or localhost
    user = process.env.AIO_USER,
    pass = process.env.AIO_KEY,
    mess = process.argv[2] ? process.argv[2] : '100',   // Default message
    feed = process.argv[3] ? process.argv[3] : 'Wunderground',  // Default feed
  // , client = mqtt.connect();
    client = mqtt.connect({ 
    port: 1883, host: host, keepalive: 10000,
    username: user, password: pass
  });

client.subscribe(user + '/feeds/'+ feed);
client.publish  (user + '/feeds/'+ feed, mess);
client.on('message', function (topic, message) {
  console.log(topic);
  console.log(message.toString());
});
// client.end();
