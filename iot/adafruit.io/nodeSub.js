#!/usr/bin/env node
// Useage nodeSub.js [message] [topic]
var mqtt = require('mqtt'),
    host = 'io.adafruit.com', // or localhost
    user = process.env.AIO_USER,
    pass = process.env.AIO_KEY,
    feed = 'Wunderground',  // Default feed
    mess = '100',   // Default message
  // , client = mqtt.connect();
    client = mqtt.connect({ 
    port: 1883, host: host, keepalive: 10000,
    username: user, password: pass
  });

if(process.argv[2]) {
  mess = process.argv[2];
}
if(process.argv[3]) {
  feed = process.argv[3];
}
client.subscribe(user + '/feeds/'+ feed);
client.publish  (user + '/feeds/'+ feed, mess);
client.on('message', function (topic, message) {
  console.log(topic);
  console.log(message.toString());
});
// client.end();
