#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');
var fs = require('fs');
var lastColor = '';
var newColor;
var color = require('color-name');
var colors = ['red', 'blue', 'red', 'green', 'blue', 'cyan', 'white', 
            'purple', 'magenta', 'yellow', 'orange', 'pink'];
var LEDpath = '/sys/firmware/lpd8806/device/rgb';
// var LEDpath = 'test.rgb';
var string_len = process.env.STRING_LEN;

var client = new Twitter({
    consumer_key: process.env.API_KEY,
    consumer_secret: process.env.API_SECRET,
    access_token_key: process.env.TOKEN,
    access_token_secret: process.env.TOKEN_SECRET,
    });
    
function clear(color) {
    var i;
    for (i=0; i<string_len; i++) {
        fs.appendFile(LEDpath, 
            Math.floor(color[0]/2) + ' ' +  // Red
            Math.floor(color[1]/2) + ' ' +  // Green
            Math.floor(color[2]/2) + ' ' +  // Blue
            i + ' ');                       // Index
    }
}

function display() {
    fs.appendFile(LEDpath, "0 0 0 -1\n");
}

function getTweet() {
    // Get timeline for a given user
    var opts = {screen_name: 'MarkAYoder', q: '#CheerLights', count: 1};
    client.get('search/tweets', opts,  function(error, params, response) {
        var text;
        var i;
        // console.log(error);
        if(error) throw error;
        // console.log(params.statuses[0]);  // Tweet body
        // console.log(params.statuses[0].created_at);   // Text only
        // console.log(params.statuses[0].text);   // Text only
        text = params.statuses[0].text;
        
        text = text.toLowerCase();
    
        for(i=0; i<colors.length ; i++) {
            // console.log(i);
            if(text.indexOf(colors[i]) != -1) {
                console.log("Found: " + colors[i]);
                break;
            }
        }
        newColor = color[colors[i]];
        console.log(newColor);
        
        if(newColor !== lastColor) {
            clear(newColor);
            display();
            lastColor = newColor;
            console.log('Updating');
        }
    });
}

getTweet();
setInterval(getTweet, 10*1000);