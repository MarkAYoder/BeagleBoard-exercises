#!/usr/bin/env node
var request = require('request');
var qs = require('querystring');
var event = 'my_test';
var key = 'yycMlao6V0SbGCk2iAhl9';
var string = {Beagle: "Bone", value1: 'My', value2: 'Test'};

var url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key + 
            '?' + qs.stringify(string);

console.log(string);
console.log(qs.stringify(string));

console.log(url);

request(url, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body); // Show the HTML for the Google homepage. 
  }
});