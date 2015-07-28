#!/usr/bin/env node

// var http = require('http');
// var fs = require('fs');
// var server = http.createServer(function(req, res) {
//     fs.createReadStream('httpServer.js').pipe(res);
// });
// server.listen(process.argv[2]);

    // var http = require('http');
    // var fs = require('fs');
    // console.log("Starting...");
    
    // var server = http.createServer(function (req, res) {
    //     console.log("Got request");
    //     if (req.method === 'POST') {
    //         req.pipe(res);
    //     }
    //     res.end('beep boop\n');
    // });
    // server.listen(process.argv[2]);

    var http = require('http');
    var fs = require('fs');
    var server = http.createServer(function (req, res) {
        if (req.method === 'POST') {
            req.pipe(fs.createWriteStream('post.txt'));
        }
        res.end('beep boop\n');
    });
    server.listen(process.argv[2]);