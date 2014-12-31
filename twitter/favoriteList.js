#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter

var Twitter = require('twitter');

var client = new Twitter({
    consumer_key: process.env.API_KEY,
    consumer_secret: process.env.API_SECRET,
    access_token_key: process.env.TOKEN,
    access_token_secret: process.env.TOKEN_SECRET,
    });

// console.log(client);

// client.get('favorites/list', function(error, params, response) {
//     // console.log(error);
//     if(error) throw error;
//     console.log(params);  // The favorites.
//     console.log(response);  // Raw response object.
// });

client.get('statuses/home_timeline', function(error, params, response) {
    // console.log(error);
    if(error) throw error;
    console.log(params);  // The favorites.
    // console.log(response);  // Raw response object.
});

// client.post('statuses/updates', {status: 'TYBG for twitter'},  function(error, params, response) {
//   console.log(error);
//     if(error) throw error;
//     console.log(params);  // Tweet body.
//     // console.log(response);  // Raw response object.
// });