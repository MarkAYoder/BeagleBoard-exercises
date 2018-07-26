#!/usr/bin/env node
// From: https://ubidots.com/docs/api/mqtt.html#what-is-mqtt
const mqtt = require("mqtt");

const client = mqtt.connect('mqtt://things.ubidots.com', {
    username: 'A1E-CwTZx0K0SBYokmm2qBop9YIr8dpkRu',
    password: ""
});
var variablesPublish = {
        "temperature": 25,
        "luminosity": { "value": 20 },
        "wind_speed": [
            { "value": 13, "timestamp": 10001 }, 
            { "value": 14, "timestamp": 13001 }]
};
var json = JSON.stringify(variablesPublish);

client.on('connect', function() {
    client.publish("/v1.6/devices/my-data-source-1", 
        json, {'qos': 1},
        function (err, response) {
            if(err) {
                console.log(err);
            }
            console.log(response);
        });
    client.end();
});
    