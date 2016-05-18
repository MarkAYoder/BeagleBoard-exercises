#!/usr/bin/env node
// Test Dweet
var dweetClient = require("node-dweetio");
var util = require('util');

var dweetio = new dweetClient();

// Send a dweet and let dweet.io make up a name for you. Subsequent calls to this will result in the same name being used.

dweetio.dweet({some:"data"}, function(err, dweet){
 
    console.log(dweet.thing); // The generated name 
    console.log(dweet.content); // The content of the dweet 
    console.log(dweet.created); // The create date of the dweet 
 
});

// Send a dweet with a name you define.

dweetio.dweet_for("my-thing", {some:"data"}, function(err, dweet){
 
    console.log(dweet.thing); // "my-thing" 
    console.log(dweet.content); // The content of the dweet 
    console.log(dweet.created); // The create date of the dweet 
 
});

dweetio.get_latest_dweet_for("my-thing", function(err, dweet){
 
    var dweet = dweet[0]; // Dweet is always an array of 1 
    
    console.log("dweet: " + util.inspect(dweet));
 
    console.log(dweet.thing); // The generated name 
    console.log(dweet.content); // The content of the dweet 
    console.log(dweet.created); // The create date of the dweet 
 
});