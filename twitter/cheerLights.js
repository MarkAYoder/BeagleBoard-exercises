#!/usr/bin/env node
// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request

var Twitter = require('twitter');
var fs = require('fs');
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

function getTweet() {
    // Get timeline for a given user
    var opts = {screen_name: 'MarkAYoder', count: 1};
    client.get('statuses/user_timeline', opts,  function(error, params, response) {
        var text;
        var i;
        // console.log(error);
        if(error) throw error;
        // console.log(params);  // Tweet body
        console.log(params[0].created_at);   // Text only
        console.log(params[0].text);   // Text only
        text = params[0].text;
        
        text = text.toLowerCase();
    
        for(i=0; i<colors.length ; i++) {
            // console.log(i);
            if(text.indexOf(colors[i]) != -1) {
                console.log("Found: " + colors[i]);
                break;
            }
        }
        
        console.log(color[colors[i]]);
        
        function clear(red, green, blue) {
          var i;
          for (i=0; i<string_len; i++) {
              fs.appendFile(LEDpath, Math.floor(red  /2) + ' ' + 
                                     Math.floor(green/2) + ' ' + 
                                     Math.floor(blue /2) + ' ' + 
                                     i + ' ');
          }
        }
        
        function display() {
            fs.appendFile(LEDpath, "0 0 0 -1\n");
        }
        
        clear(color[colors[i]][0], color[colors[i]][1], color[colors[i]][2]);
        display();
    });
}
getTweet();
setInterval(getTweet, 10*1000);