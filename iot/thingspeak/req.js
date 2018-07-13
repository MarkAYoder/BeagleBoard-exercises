#!/usr/bin/env node
// Get bulk data from thingspeak using request

var request       = require('request');
var util          = require('util');
var fs            = require('fs');

const filename = "/home/debian/exercises/iot/thingspeak/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));

const results = 2;
const url = util.format("https://api.thingspeak.com/channels/%s/feeds.json/?api_key=%s&results=%s",
    keys.channel_id, keys.write_key, results);

// From: https://www.mathworks.com/help/thingspeak/readdata.html
// Get all fields
request(url, {timeout: 10000}, function (error, response, body) {
    if (!error && response.statusCode == 200) {
        console.log(body); 
    } else {
        console.log("error=" + error + " response=" + JSON.stringify(response));
    }
});

// From: https://www.mathworks.com/help/thingspeak/readfield.html
// Just get one field
const field = 1;
const url2 = util.format("https://api.thingspeak.com/channels/%s/fields/%s.json/?api_key=%s&results=%s",
    keys.channel_id, field, keys.write_key, results);

request(url2, {timeout: 10000}, function (error, response, body) {
    if (!error && response.statusCode == 200) {
        console.log(body); 
    } else {
        console.log("error=" + error + " response=" + JSON.stringify(response));
    }
});
