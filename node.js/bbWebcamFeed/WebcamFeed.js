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
        res.write('<h1>Hello!</h1>Try<ul><li><a href="/WebcamFeed.html">Webcam Feed</a></li></ul>');

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
console.log("Listening on 8081");

// Listen on a socket
var io = require('socket.io').listen(server);
io.set('log level', 2);

// Start streaming the video
var camNum = 0;
var camPath = "/dev/video" + camNum;
var exec_string = 'gst-launch v4l2src device=\"' + camPath + '\" ! video/x-raw-yuv,width=320,height=240,framerate=15/1 ! theoraenc ! oggmux ! tcpserversink port=8080';
//console.log('killall gst-launch-0.10');
console.log(exec_string);
//exec('killall gst-launch-0.10');
exec(exec_string, function(error, stdout, stderr) {
	console.log('stdout: ' + stdout);
	console.log('stderr: ' + stderr);
	if (error !== null) {
		console.log('exec error: ' + error);
	}
});

// on a 'connection' event
io.sockets.on('connection', function (socket) {
    var frameCount = 0;	// Counts the frames from arecord
    var lastFrame = 0;	// Last frame sent to browser
    console.log("Connection " + socket.id + " accepted.");

    socket.on('setcam', function(newCamNum) {
        camNum = newCamNum;

camPath = "/dev/video" + camNum;
exec_string = 'gst-launch v4l2src device=\"' + camPath + '\" ! video/x-raw-yuv,width=320,height=240,framerate=15/1 ! theoraenc ! oggmux ! tcpserversink port=8080';
exec('killall gst-launch-0.10');
exec(exec_string);
console.log(exec_string);

        socket.emit('updatePage');
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        if(connectCount === 0) {
        }
//        exec('killall gst-launch-0.10');
        console.log("connectCount = " + connectCount);
    });

    connectCount++;
    console.log("connectCount = " + connectCount);
});



