#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');
var fs = require('fs');
var lastColor = '';
var newColor;
var color = require('color-name');
var colors = Object.keys(color);        // Look for all colors
var LEDpath = '/sys/firmware/lpd8806/device/rgb';
// var LEDpath = 'test.rgb';
var string_len = process.env.STRING_LEN;

console.log("STRING_LEN = " + string_len);

colors.sort(function(a,b) {     // Soft colors so longer names will be found.
    return b.length - a.length;
});

var client = new Twitter({
    consumer_key: process.env.API_KEY,
    consumer_secret: process.env.API_SECRET,
    access_token_key: process.env.TOKEN,
    access_token_secret: process.env.TOKEN_SECRET,
    });
    
function clear(color, skip) {
    var i;
    if(typeof skip === 'undefined') {
        skip = 1;
    }
    for (i=0; i<string_len; i+=skip) {
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
        var skip;       // Number of LEDs to skip
        // console.log(error);
        if(error) {
            console.log("Error: " + error);
            } else {
            // console.log(params.statuses[0]);  // Tweet body
            // console.log(params.statuses[0].created_at);   // Text only
            // console.log(params.statuses[0].text);   // Text only
            
            text = params.statuses[0].text.toLowerCase();
    
            for(i=0; i<colors.length ; i++) {
                // console.log(i);
                if(text.indexOf(colors[i]) != -1) {
                    console.log("Found: " + colors[i]);
                    break;
                }
            }
            if(i === colors.length) {
                newColor = [10, 10, 10];
                skip = 1;
            } else {
                newColor = color[colors[i]];
                skip = 1;
            }
            console.log(newColor);
            
            if(newColor !== lastColor) {
                clear(newColor, skip);
                display();
                lastColor = newColor;
                console.log('Updating');
                }
            }
    });
}

getTweet();
setInterval(getTweet, 5*60*1000);
