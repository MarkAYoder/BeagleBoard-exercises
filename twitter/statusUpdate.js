#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');

var client = new Twitter({
    consumer_key: process.env.API_KEY,
    consumer_secret: process.env.API_SECRET,
    access_token_key: process.env.TOKEN,
    access_token_secret: process.env.TOKEN_SECRET,
    });

// console.log(client);

// Get timeline for a given user
var opts = {status: "Testing API 2", trim_user: true};
client.post('statuses/update', opts,  function(error, params, response) {
    if(error) {
        console.log(error);
    } else {
        console.log(params);  // Tweet body
    }
});