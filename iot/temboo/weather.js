#!/usr/bin/env node
// You'll need a single TembooSession object in your code, eg:
var tsession = require("temboo/core/temboosession");
var session = new tsession.TembooSession("yoder", "myFirstApp", "8Zq5lFq6TmyCbgKDAycYoMOyVNMrZpMB");

var NOAA = require("temboo/Library/NOAA");

var weatherByZipcodeChoreo = new NOAA.WeatherByZipcode(session);

// Instantiate and populate the input set for the choreo
var weatherByZipcodeInputs = weatherByZipcodeChoreo.newInputSet();

// Set inputs
weatherByZipcodeInputs.set_Product("glance");
weatherByZipcodeInputs.set_ZipCodeList("47834");

// Run the choreo, specifying success and error callback handlers
weatherByZipcodeChoreo.execute(
    weatherByZipcodeInputs,
    function(results){console.log(results.get_Response());},
    function(error){console.log(error.type); console.log(error.message);}
);