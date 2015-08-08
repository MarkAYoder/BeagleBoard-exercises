#!/usr/bin/env node

    var http = require('http');
    var through = require('through2');

    console.log("Starting...");

    var server = http.createServer(function(req, res) {
        console.log("Got request " + req.method);
        if (req.method === 'POST') {
            console.log("It's a POST");
            req.pipe(through(function(buffer, _, next) {
                this.push(buffer.toString().toUpperCase());
                console.log(buffer.toString());
                next();
            })).pipe(res);
        }
        else {
            res.end('beep boop\n');
        }
    });
    server.listen(parseInt(process.argv[2]));
    