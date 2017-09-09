#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');
const util = require('util');
const exec = require('child_process').exec;

const screen_name = 'MarkAYoder';
// const screen_name = 'realDonaldTrump';

var client = new Twitter({
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET,
    });

// Get timeline for a given user
var opts = {screen_name: screen_name, count: 5};
client.get('statuses/user_timeline', opts,  function(error, params, response) {
    if(error) {
        console.log(error);
        throw error;
    }

    // console.log(params);  // Tweet body
    // console.log(util.inspect(params[1].entities));
    // console.log(util.inspect(params[1].entities.media[0].media_url_https));
    const cmd = 'wget ' + params[1].entities.media[0].media_url_https + ' -O /tmp/twitter.jpg';
    console.log("Running: " + cmd);
    exec(cmd, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
    //   console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
    });
    // var i;
    // for(i=0; i<params.length; i++) {
    //     console.log(i + ": " + params[i].created_at + " " + params[i].text);   // Text only
    //     // console.log();   // Text only
    // }
});