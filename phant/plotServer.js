#!/usr/bin/env node

var http = require('http');
var url  = require('url');
var fs   = require('fs');

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    if (path === '/') {
        path = '/plotPing.html';
    }

    // console.log("path: " + __dirname + path);
    fs.readFile(__dirname + path, function (err, data) {
        if (err) {
            console.log(err);
            return send404(res);
        }
        // console.log("path2: " + path);
        res.write(data, 'utf8');
        res.end();
    });
}).listen(8082);

console.log("Listening on 8082");

function send404(res) {
    res.writeHead(404);
    res.write('404');
    res.end();
}
