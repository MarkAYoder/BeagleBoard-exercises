#!/usr/bin/env node
// From: https://temboo.com/docs/data-visualization-quickstart
// You'll need a single TembooSession object in your code, eg:
var tsession = require("temboo/core/temboosession");
var session = new tsession.TembooSession("yoder", "myFirstApp", "8Zq5lFq6TmyCbgKDAycYoMOyVNMrZpMB");

var Google = require("temboo/Library/Google/Sheets");

var appendValuesChoreo = new Google.AppendValues(session);

// Instantiate and populate the input set for the choreo
var appendValuesInputs = appendValuesChoreo.newInputSet();

// Set inputs
appendValuesInputs.set_RefreshToken("ya29.Glv6BRk8-URcVrBNOISo0QZOIPNOPcG5z1t7CzbEknavi_60jiPldYuS3PWhhhXzp1b9JK6twty7Q9kiucvLEGTjLxsS-7iXreHHNC6svN5PUeCEa_OGJ4ef4tTe");
appendValuesInputs.set_ClientSecret("4jiALOUKuJxDgh-iDKVucyJG");
appendValuesInputs.set_Values("[  [   \"Test\",    200,    300  ] ]");
appendValuesInputs.set_ClientID("487429629858-26lq5ut6nn0mfm1md95ppd6bh8ph3nlh.apps.googleusercontent.com");
appendValuesInputs.set_SpreadsheetID("1gRmjqggKs4rFT9BwycTVCGPLupVZBFcMdkuM2fow1UU");

// Run the choreo, specifying success and error callback handlers
appendValuesChoreo.execute(
    appendValuesInputs,
    function(results){console.log(results.get_NewAccessToken());},
    function(error){console.log(error.type); console.log(error.message);}
);
