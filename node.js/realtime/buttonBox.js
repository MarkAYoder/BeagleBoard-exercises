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
        res.write('<h1>Hello!</h1>Try<ul><li><a href="/realtimeDemo.html">Real-time Audio Demo</a></li><li><a href="/buttonBox.html">Button Box Demo</a></li></ul>');

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

var totalPoints = 800;

// on a 'connection' event
io.sockets.on('connection', function (socket) {
    var frameCount = 0;	// Counts the frames from arecord
    var lastFrame = 0;	// Last frame sent to browser
    console.log("Connection " + socket.id + " accepted.");
//    console.log("socket: " + socket);

    // now that we have our connected 'socket' object, we can 
    // define its event handlers

    // Send a packet of data every time a 'message' is received.
    socket.on('ain', function (ainNum) {
//        console.log("Received message: " + ainNum + 
//            " - from client " + socket.id);
        socket.emit('ain', readAin(ainNum));
//        console.log('emitted ain ' + readAin(ainNum));
    });

    socket.on('gpio', function (gpioNum) {
        socket.emit('gpio', readGpio(gpioNum));
//        console.log('emitted gpio: ' + readGpio(gpioNum));
    });

    socket.on('i2c', function (i2cNum) {
//        console.log('Got i2c request:' + i2cNum);
        exec('i2cget -y 3 ' + i2cNum,
            function (error, stdout, stderr) {
//                console.log('i2cget: "' + stdout + '"');
                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                socket.emit('i2c', stdout);
            });
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

// Read analog input
var ainPath = "/sys/devices/platform/omap/tsc/";
    function readAin(port) {
        return(fs.readFileSync(ainPath + "ain" + port, 'base64'));
    }

// Read analog input
var gpioPath = "/sys/class/gpio/";
    function readGpio(port) {
        return(fs.readFileSync(gpioPath + "gpio" + port + "/value", 'base64'));
    }

