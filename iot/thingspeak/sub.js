#!/usr/bin/env node
// Subscribes to a topic.  Unfortunately it doesn't appear to work
'use strict';

const fs    = require('fs');
const util  = require('util');
const mqtt  = require('mqtt');
const client = mqtt.connect('mqtt://mqtt.thingspeak.com');
// console.log("client: " + util.inspect(client));

// Initiate MQTT API
const filename = "/home/debian/exercises/iot/thingspeak/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));
const url = "channels/" + keys.channel_id + "/subscribe/json/" + keys.read_key;
console.log("url: " + url);

client.subscribe(url, function (err, granted) {
    if(err) {
        console.log("err: " + err);
    }
    console.log(granted);
});

client.on('message', function (topic, message) {
  console.log("topic: " + topic);
  console.log("message: " + message);
});
