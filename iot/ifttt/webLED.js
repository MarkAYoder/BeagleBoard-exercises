#!/usr/bin/env node
// Uses ifttt to turn an LED on and off via the web

"use strict";

const port = 9090, // Port to listen on
    http  = require('http'),
    request = require('request'),
    url   = require('url'),
    util  = require('util'),
    qs    = require('querystring'),
    b     = require('bonescript');
const key = 'bHddeE_oLPxdP0ZKABzAe4';
const LED = 'GP1_4';
const button = 'GP1_3';
const event = 'LED';
    
b.pinMode(LED, b.OUTPUT);
b.pinMode(button, b.INPUT);

b.attachInterrupt(button, true, b.RISING, buttonPressed);

// This is called when the button is pressed.  It triggers a maker
// channel that sends a notification.

function buttonPressed(x) {
    if(!x.attached) {
        console.log("button pressed");
        var string = {value1: 'My', value2: 'Test 2', value3: 'BeagleBone'};
    
        var url = 'https://maker.ifttt.com/trigger/' + event + '/with/key/' + key + 
                '?' + qs.stringify(string);
    
        console.log(url);
        request(url, requestCallback);

        string = {value1: 'SMS', value2: 'Test Button', value3: 'BeagleBone'};
    
        url = 'https://maker.ifttt.com/trigger/' + 'sms' + '/with/key/' + key + 
                '?' + qs.stringify(string);
    
        console.log(url);
        request(url, requestCallback);
    }
}

function requestCallback(err, res, body) {
  if (!err && res.statusCode == 200) {
      console.log(body);
  } else {
      console.log("error=" + err + " response=" + JSON.stringify(res));
  }
}

// This creates a web server that listens for LED on and off signal.

var server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    // console.log("req: " + util.inspect(req));
    // console.log("res: " + util.inspect(req));
    
    res.write("<html>");
    if(path === '/on') {
        b.digitalWrite(LED, 1);
        res.write("LED on<br>");
    } else if (path === '/off') {
        b.digitalWrite(LED, 0);
        res.write("LED off<br>");
    } else if (path === '/toggle') {
        b.digitalWrite(LED, ~b.digitalRead(LED));
        res.write("LED toggle<br>");
    }
    
    var params = util.inspect(qs.parse(url.parse(req.url).query));
    console.log(params);
    res.write(params);
    res.write("</html>");
    res.end();
});

server.listen(port);
console.log("Listening on " + port);
