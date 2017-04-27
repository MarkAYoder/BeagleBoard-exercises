#!/usr/bin/env node
// Posts a tweet with image.
// First run setup.sh to authorize

// From https://www.npmjs.com/package/twitter
// See hhttps://dev.twitter.com/rest/public
// to see what you can request


var Twitter = require('twitter');
var exec = require('child_process').exec,
    child,
    media_id;
// The message
var message="Testing API 7";
var image = 'autoRun.jpg';
    
// Use the command line as the message if given.
if(process.argv.length !== 4) {
    console.log("Usage: statusUpdateImage.js path_to_image.jpg message");
    process.exit();
} else {
    image   = process.argv[2];
    message = process.argv[3];
}

var client = new Twitter({
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET,
    });

// Upload image
console.log("Uploading " + image);
child = exec('twurl -H upload.twitter.com "/1.1/media/upload.json" -f ' + image + ' -F media -X POST',
  function (err, stdout, stderr) {
    if (err) {
      console.log('exec error: ' + err);
      console.log('Did you authorize?');
    }
    if(stderr) {
        console.log('stderr: ' + stderr);
    }
    console.log('stdout: ' + stdout);
    
    // Get media string of uploaded image
    media_id = JSON.parse(stdout).media_id_string;
    console.log(image + 'posted with media_id = ' + media_id);

    // Post message
    var opts = {status: message, trim_user: true,
                media_ids: media_id};
    client.post('statuses/update', opts,  function(error, params, response) {
        if(error) {
            console.log(error);
        } else {
            //console.log(params);  // Tweet body
            console.log("Posted: " + message);
        }
    });
});
