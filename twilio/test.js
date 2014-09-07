#!/usr/bin/env node
// Twilio Credentials 
var accountSid = 'AC407ab27aab63fa995dbc24c43a18d204'; 
var authToken = '99e44f31bc8c7981c4ae6d6cf9c65ed'; 
 
//require the Twilio module and create a REST client 
var client = require('twilio')(accountSid, authToken); 
 
client.messages.create({ 
	to: "8122333219", 
	from: "+18122333826", 
	body: "This is a test for my class",   
}, function(err, message) { 
	console.log(message.sid); 
});
