#!/usr/bin/env node
// From: https://developers.google.com/maps/documentation/elevation/intro#What
var key = 'AIzaSyD6Ub1PeZ7w2ODxmvHPfMvmdUS5KiWYjI0';
var request = require('request');
var api     = "https://maps.googleapis.com/maps/api/elevation/json";
var path    = "36.578581,-118.291994|36.23998,-116.83171";
var samples = "5";

var url = api + "?path=" + path + "&samples=" + samples + "&key=" + key;

// request()

console.log(url);