// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
"use strict";

var http = require('http'),
    url = require('url'),
    fs = require('fs'),
    child_process = require('child_process'),
    server,
    connectCount = 0,	// Number of connections to server
    globalData,		// all data from arecord is saved here and sent
			// to the client when requested.
    child;

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
    function getRandomData() {
        var data = [0];
        // do a random walk
        for(var i=1; i<totalPoints; i++) {
            var prev = data.length > 0 ? data[data.length - 1] : 50;
            var y = prev + Math.round(Math.random() * 10 - 5);
            if (y < -100)
                y = -100;
            if (y > 100)
                y = 100;
            data[i] = y;
        }
        return(data);
    }

// on a 'connection' event
io.sockets.on('connection', function (socket) {
    var frameCount = 0;	// Counts the frames from arecord
    var lastFrame = 0;	// Last frame sent to browser
    console.log("Connection " + socket.id + " accepted.");
//    console.log("socket: " + socket);

//    socket.emit('message', 'This is a test');

    // now that we have our connected 'socket' object, we can 
    // define its event handlers

    // Send a packet of data every time a 'message' is received.
    socket.on('ain', function (message) {
//        console.log("Received message: " + message + 
//            " - from client " + socket.id);
//        socket.emit('message', sendData() );
        socket.emit('ain', readAin(6));
//        console.log('emitted ain ' + readAin(6));
    });

    socket.on('gpio', function (message) {
        socket.emit('gpio', readGpio(7));
//        console.log('emitted gpio: ' + readGpio(7));
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        if(connectCount === 0) {
        }
        console.log("connectCount = " + connectCount);
    });

    function sendData() {
//        console.log("Sending data");
        if(frameCount === lastFrame) {
//            console.log("Already sent frame " + lastFrame);
        } else {
            lastFrame = frameCount;
        }
        return(globalData);
    }

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

