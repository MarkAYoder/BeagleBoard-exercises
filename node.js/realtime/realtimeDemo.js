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
// This seems to send the correct header if I leave this out.
//            res.writeHead(200, {'Content-Type': path === 'json.js' ? 'text/javascript' : 'text/html'});
            res.write(data, 'utf8');
            res.end();
        });
        break;

//    default:
//        send404(res);
    }
});

var send404 = function (res) {
    res.writeHead(404);
    res.write('404');
    res.end();
};

server.listen(8080);
console.log("Listening on 8080");

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
    socket.on('message', function (message) {
//        console.log("Received message: " + message + 
//            " - from client " + socket.id);
        socket.emit('message', sendData() );
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        if(connectCount === 0) {
            child.kill('SIGHUP');
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

 // initiate read from arecord
    if(connectCount === 0) {
    try {
        console.log("process.platform: " + process.platform);
        if(process.platform !== "darwin") {
        child = child_process.spawn(
           "/usr/bin/arecord",
           [
            "-Dplughw:1,0",
            "-c2", "-r8000", "-fU8", "-traw", 
            "--buffer-size=800", "--period-size=800", "-N"
           ]
        );
        } else {
        child = child_process.spawn(
           "/Users/yoder/bin/sox-14.4.0/rec",
           [
            "-c2", "-r44100", "-tu8",  
            "--buffer", "1600", "-q", "-"
           ]
        );

        }
//        console.log("arecord started");
        child.stdout.setEncoding('base64');
        child.stdout.on('data', function(data) {
            // Save data read from arecord in globalData
            globalData = data;
            frameCount++;
        });
        child.stderr.on('data', function(data) {
            console.log("arecord: " + data);
        });
        child.on('exit', function(code) {
            console.log("arecord exited with: " + code);
        });
    } catch(err) {
        console.log("arecord error: " + err);
    }
    }
    connectCount++;
    console.log("connectCount = " + connectCount);
});

