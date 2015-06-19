#!/usr/bin/env node
var request = require('request');
var qs = require('querystring');
var event = 'my_test';
var key = 'yycMlao6V0SbGCk2iAhl9';
var string = {value1: 'My', value2: 'Test', value3: 'BeagleBone'};

var url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key + 
            '?' + qs.stringify(string);

console.log(url);

request(url, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body); 
  } else {
    console.log("error=" + error + " response=" + JSON.stringify(response));
  }
});
