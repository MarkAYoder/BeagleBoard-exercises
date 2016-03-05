#!/usr/bin/env node
// From: https://developers.google.com/maps/documentation/elevation/intro#What
var key = 'AIzaSyD6Ub1PeZ7w2ODxmvHPfMvmdUS5KiWYjI0';
var request = require('request');
var api     = "https://maps.googleapis.com/maps/api/elevation/json";
var path    = "31.7744923,76.9856026|31.772946,76.993499";
var samples = "5";

var url = api + "?path=" + path + "&samples=" + samples + "&key=" + key;

console.log(url);
request(url, function(err, response, body) {
    if (err || response.statusCode != 200) {
      return console.log('error', err, body.error);
    }
    
    body = JSON.parse(body);
    console.log(body.results);
});
