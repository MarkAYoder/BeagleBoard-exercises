#!/usr/bin/env node
// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/

"use strict";

var port = 9090, // Port to listen on
    http  = require('http'),
    url   = require('url'),
    util  = require('util'),
    qs    = require('querystring'),
    b     = require('bonescript'),
    server,
    LED = 'P9_14';
    
b.pinMode(LED, b.OUTPUT);

server = http.createServer(function (req, res) {
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
    }
    
    var params = util.inspect(qs.parse(url.parse(req.url).query));
    console.log(params);
    res.write(params);
    res.write("</html>");
    res.end();
});

server.listen(port);
console.log("Listening on " + port);
