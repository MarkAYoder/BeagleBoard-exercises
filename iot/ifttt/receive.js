#!/usr/bin/env node
// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/

"use strict";

var port = 9090, // Port to listen on
    http = require('http'),
    url = require('url'),
    fs = require('fs'),
    util = require('util'),
    qs = require('querystring'),
    server;
    
function send404(res) {
    res.writeHead(404);
    res.write('404');
    res.end();
}

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    // console.log("req: " + util.inspect(req));
    // console.log("res: " + util.inspect(req));
    
    console.log(util.inspect(qs.parse(url.parse(req.url).query)));

    fs.readFile(__dirname + path, function (err, data) {
        if (err) {return send404(res); }
            console.log("path2: " + path);
        res.write(data, 'utf8');
        res.end();
    });
});

server.listen(port);
console.log("Listening on " + port);
