#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

const Twitter = require('twitter');
const util = require('util');

// const screen_name = 'MarkAYoder';
// const screen_name = 'realDonaldTrump';
const screen_name = 'RoseHulmanPrez';

const client = new Twitter({
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET,
    });

'use strict';

// [START language_quickstart]
// Imports the Google Cloud client library
const Language = require('@google-cloud/language');

// Your Google Cloud Platform project ID
const projectId = 'trim-approach-136823';

// Instantiates a client
const language = Language({
  projectId: projectId
});

// Get timeline for a given user
var opts = {screen_name: screen_name, count: 10};
client.get('statuses/user_timeline', opts,  function(error, params, response) {
    console.log(error);
    if(error) throw error;
    // console.log(params);  // Tweet body
    var i;
    for(i=0; i<params.length; i++) {
        console.log(i + ": " + params[i].created_at + " " + params[i].text);   // Text only
        console.log();   // Text only
        
        // Detects the sentiment of the text
        language.detectSentiment(params[i].text)
          .then((results) => {
            const sentiment = results[0];
        
            console.log(`Text: ${sentiment}`);
            console.log(`Sentiment score: ${sentiment.score}`);
            console.log(`Sentiment magnitude: ${sentiment.magnitude}`);
            console.log(util.inspect(sentiment));
            console.log();
          })
          .catch((err) => {
            console.error('ERROR:', err);
          });
    }
});