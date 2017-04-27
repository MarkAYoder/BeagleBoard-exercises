#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');

const screen_name = 'MarkAYoder';
// const screen_name = 'realDonaldTrump';

var client = new Twitter({
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET,
    });

// console.log(client);

// client.get('favorites/list', function(error, params, response) {
//     // console.log(error);
//     if(error) throw error;
//     console.log(params);  // The favorites.
//     console.log(response);  // Raw response object.
// });

// Get my timeline
// client.get('statuses/home_timeline', function(error, params, response) {
//     // console.log(error);
//     if(error) throw error;
//     console.log(params);  // The favorites.
//     // console.log(response);  // Raw response object.
// });

// Get timeline for a given user
var opts = {screen_name: screen_name, count: 4};
client.get('statuses/user_timeline', opts,  function(error, params, response) {
    console.log(error);
    if(error) throw error;
    // console.log(params);  // Tweet body
    var i;
    for(i=0; i<params.length; i++) {
        console.log(i + ": " + params[i].created_at + " " + params[i].text);   // Text only
        // console.log();   // Text only
    }
});