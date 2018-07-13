#!/usr/bin/env node
'use strict';

const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://mqtt.thingspeak.com');

const CHANNEL='518308';
const WRITEKEY='WOGHQ8UL1EC7RZIA';

client.on('connect', function() {
    client.publish("channels/" + CHANNEL + "/publish/" + WRITEKEY, 
        'field1=10&field2=100');
    client.end();
});

