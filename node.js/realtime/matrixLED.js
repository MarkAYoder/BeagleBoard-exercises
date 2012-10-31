// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
"use strict";

var http = require('http'),
    url = require('url'),
    fs = require('fs'),
    exec = require('child_process').exec,
    server,
    connectCount = 0;	// Number of connections to server

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    switch (path) {
    case '/':
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write('<h1>Hello!</h1>Try<ul><li><a href="/matrixLED.html">Matrix LED Demo</a></li></ul>');

        res.end();
        break;

    default:		// This is so all the files will be sent.
        fs.readFile(__dirname + path, function (err, data) {
            if (err) {return send404(res); }
//            console.log("path2: " + path);
            res.write(data, 'utf8');
            res.end();
        });
        break;

    }
});

var send404 = function (res) {
    res.writeHead(404);
    res.write('404');
    res.end();
};

server.listen(8081);

// socket.io, I choose you
var io = require('socket.io').listen(server);
io.set('log level', 2);

// on a 'connection' event
io.sockets.on('connection', function (socket) {
    console.log("Connection " + socket.id + " accepted.");
//    console.log("socket: " + socket);

    // Now that we have our connected 'socket' object, we can 
    // define its event handlers

    // Send whole display every time a 'i2c' is received.
    socket.on('i2c', function (i2cNum) {
//        console.log('Got i2c request:' + i2cNum);
        exec('i2cdump -y -r 0x00-0x0f 3 ' + i2cNum + ' b',
            function (error, stdout, stderr) {
//		The LED has 8 16-bit values
//                console.log('i2cget: "' + stdout + '"');
		var lines = stdout.split("00: ");
		// Get the last line of the output and send the string
		lines = lines[1].substr(0,47);
		console.log("lines = %s", lines);
                socket.emit('i2c', lines);
                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
            });
    });

    // Sets one column every time i2cset is received.
    socket.on('i2cset', function(params) {
//	console.log(params);
	// Double i since display has 2 bytes per LED
	exec('i2cset -y 3 ' + params.i2cNum + ' ' + 2*params.i + ' ' +
		params.disp); 
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        if(connectCount === 0) {
        }
        console.log("connectCount = " + connectCount);
    });

    connectCount++;
    console.log("connectCount = " + connectCount);
});

