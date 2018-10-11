#!/usr/bin/env node
var request = require('request');
var qs = require('querystring');
// var event = 'my_test';
// var event = 'my_Web';
// var event = 'tweet';
// var event = 'my_mail';
var event = 'sms';
// var event = 'notification';
// var event = 'phone';
var key = 'EG33hBxy7L7W3DvKnNoCh';
var string = {value1: 'My', value2: 'Test 2', value3: 'BeagleBone'};

var url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key + 
            '?' + qs.stringify(string);

console.log(url);

request(url, function (err, res, body) {
  if (!err && res.statusCode == 200) {
    console.log(body); 
  } else {
    console.log("error=" + err + " response=" + JSON.stringify(res));
  }
});
