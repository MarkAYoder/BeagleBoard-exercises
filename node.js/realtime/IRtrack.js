// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
"use strict";

var http = require('http'),
    url = require('url'),
    fs = require('fs'),
    b = require('bonescript'),
//    exec = require('child_process').exec,
    server,
    connectCount = 0;	// Number of connections to server

    var errCount = 0;	// Counts the AIN errors.
    var ainLast;        // Remembers last AIN value (hack)

// Initialize various IO things.
function initIO() {
    // Make sure gpios 7 and 20 are available.
    b.pinMode('P9_42', b.INPUT);
    b.pinMode('P9_41', b.INPUT);
}

initIO();

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    switch (path) {
    case '/':
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write('<h1>Hello!</h1>Try<ul><li><a href="/IRtrack.html">IR Tracking Demo</a></li></ul>');

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

function send404(res) {
    res.writeHead(404);
    res.write('404');
    res.end();
}

server.listen(8082);
console.log("Listening on 8082");

// socket.io, I choose you
var io = require('socket.io').listen(server);
io.set('log level', 2);

// on a 'connection' event
io.sockets.on('connection', function (socket) {

    console.log("Connection " + socket.id + " accepted.");
//    console.log("socket: " + socket);

    // now that we have our connected 'socket' object, we can 
    // define its event handlers

    // Send value every time a 'message' is received.
    socket.on('ain', function (ainNum) {
        b.analogRead(ainNum, function(x) {
            if(x.err && errCount++<5) console.log("AIN read error");
            if(x.value > 0.94) {
                x.value = ainLast;   // Hack
                console.log("ain Hack");
            }
            socket.emit('ain', [ainNum, x.value]);
            ainLast = x.value;
//            console.log('emitted ain: ' + x.value + ', ' + ainNum);
        });
    });

    socket.on('gpio', function (gpioNum) {
//    console.log('gpio' + gpioNum);
        b.digitalRead(gpioNum, function(x) {
            if (x.err) throw x.err;
            socket.emit('gpio', [gpioNum, x.value]);
//            console.log('emitted gpio: ' + x.value + ', ' + gpioNum);
        });
    });

    socket.on('led', function (ledNum) {
        var ledPath = "/sys/class/leds/beaglebone:green:usr" + ledNum + "/brightness";
//        console.log('LED: ' + ledPath);
        fs.readFile(ledPath, 'utf8', function (err, data) {
            if(err) throw err;
            data = data.substring(0,1) === "1" ? "0" : "1";
//            console.log("LED%d: %s", ledNum, data);
            fs.writeFile(ledPath, data);
        });
    });

    function trigger(arg) {
        var ledPath = "/sys/class/leds/beaglebone:green:usr";
//    console.log("trigger: " + arg);
	    arg = arg.split(" ");
	    for(var i=0; i<4; i++) {
//	    console.log(" trigger: ", arg[i]);
	        fs.writeFile(ledPath + i + "/trigger", arg[i]);
	    }
    }
    
    socket.on('trigger', function(trig) {
//	console.log('trigger: ' + trig);
	    if(trig) {
            trigger("heartbeat mmc0 cpu0 none");
        } else {
            trigger("none none none none");
        }
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        console.log("connectCount = " + connectCount);
    });

    connectCount++;
    console.log("connectCount = " + connectCount);
});

