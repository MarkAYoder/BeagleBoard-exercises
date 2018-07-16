#!/usr/bin/env node
// You'll need a single TembooSession object in your code, eg:
const util = require('util');

const tsession = require("temboo/core/temboosession");
var session = new tsession.TembooSession("yoder", "myFirstApp", "8Zq5lFq6TmyCbgKDAycYoMOyVNMrZpMB");

const Google = require("temboo/Library/Google/Geocoding");

var geocodeByAddressChoreo = new Google.GeocodeByAddress(session);

// Instantiate and populate the input set for the choreo
var geocodeByAddressInputs = geocodeByAddressChoreo.newInputSet();

// Set inputs
geocodeByAddressInputs.set_Address("4902 W Co Rd 740 N, Brazil, IN 47834");

// Run the choreo, specifying success and error callback handlers
geocodeByAddressChoreo.execute(
    geocodeByAddressInputs,
    function(results) {
        console.log(results.get_Latitude());
        console.log(util.inspect(results));
        console.log(results.getResultString())
    },
    function(error){console.log(error.type); console.log(error.message);}
);
