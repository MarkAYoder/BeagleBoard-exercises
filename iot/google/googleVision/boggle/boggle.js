#!/usr/bin/env node
// From: https://groups.google.com/d/msg/cloud-vision-trusted-testers/cmpDD08YdEo/yA66qCS0CgAJ

var key = 'AIzaSyD8RAfCr0CD2QPzmfEJUtuwy7vfm0lraKE';
var fs = require('fs');
var request = require('request');

var queryVision = function(path, callback){
  
  var buffer = fs.readFileSync(path, 'base64'); 
  var json   = {
    "requests": [{
      "image":{ "content": buffer },
      // https://cloud.google.com/vision/reference/rest/v1/images/annotate
      "features": [
        // { "type": "LABEL_DETECTION",  "maxResults": 10 },
        // { "type": "LANDMARK_DETECTION","maxResults": 12 },
        // { "type": "LOGO_DETECTION",   "maxResults": 4 },
        { "type": "TEXT_DETECTION",   "maxResults": 100 },
        // { "type": "FACE_DETECTION",   "maxResults": 4 },
        // { "type": "IMAGE_PROPERTIES", "maxResults": 12 }
      ]
    }]
  };
  
  request({
    'uri'     : 'https://vision.googleapis.com/v1/images:annotate?key='+key,
    'headers' : [{ name: 'content-type', value: 'application/json' }],
    'method'  : 'POST',
    'json'    : json
  }, 
  function (err, response, body){
    if (err || response.statusCode != 200) {
      return console.error('error', err, body.error);
      process.exit(1);
    }
    
    console.log(JSON.stringify(body.responses[0], undefined, 2));
    
    var response = body.responses[0];
    // callback();

  });
};

// console.log(process.argv[2]);
queryVision(process.argv[2]);
