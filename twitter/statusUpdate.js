#!/usr/bin/env node
// Posts a tweet
// Run setup.sh first

// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');

// The message
var message="This is a test message.";

// Use the command line as the message if given.
if(process.argv.length > 2) {
    message = process.argv.slice(2).join(" ");
    console.log(message);
}

var client = new Twitter({
    consumer_key: process.env.API_KEY,
    consumer_secret: process.env.API_SECRET,
    access_token_key: process.env.TOKEN,
    access_token_secret: process.env.TOKEN_SECRET,
    });

// console.log(client);

// Post message
var opts = {status: message, trim_user: true };
client.post('statuses/update', opts,  function(error, params, response) {
    if(error) {
        console.log(error);
    } else {
        //console.log(params);  // Tweet body
        console.log("Posted");
    }
});
