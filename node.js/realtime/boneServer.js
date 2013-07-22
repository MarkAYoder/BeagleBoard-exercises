// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
// This is a general server for the various web frontends
// buttonBox, ioPlot, realtimeDemo
"use strict";

var port = 8083, // Port to listen on
    http = require('http'),
    url = require('url'),
    fs = require('fs'),
    b = require('bonescript'),
    exec = require('child_process').exec,
    server,
//    pwmPath    = "/sys/class/pwm/ehrpwm.1:0",

    connectCount = 0,	// Number of connections to server
    errCount = 0;	// Counts the AIN errors.

// Initialize various IO things.
function initIO() {
    // Make sure gpios 7 and 20 are available.
    b.pinMode('P9_42', b.INPUT);
    b.pinMode('P9_41', b.INPUT);
    
    // Initialize pwm
    // Clear up any unmanaged usage
/*
    fs.writeFileSync(pwmPath+'/request', '0');
    // Allocate and configure the PWM
    fs.writeFileSync(pwmPath+'/request', '1');
    fs.writeFileSync(pwmPath+'/period_freq', 1000);
    fs.writeFileSync(pwmPath+'/duty_percent', '0');
    fs.writeFileSync(pwmPath+'/polarity', '0');
    fs.writeFileSync(pwmPath+'/run', '1');
    // Set pin Mux
//    Don't know why the wiretFileSync doesn't work
//    fs.writeFileSync(pinMuxPath+'/gpmc_a2', '0x0e'); // pwm, no pull up
    exec("echo 0x0e > " + pinMuxPath + "/gpmc_a2");
*/
}

initIO();

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    switch (path) {
    case '/':
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write('<h1>Hello!</h1>Try: <ul>\n' +
        '<li><a href="/ioPlot.html">IO Plotting Demo</a></li>\n' +
        '<li><a href="/buttonBox.html">Button Box Demo</a></li>\n' +
        '<li><a href="/audioDemo.html">Audio Demo</a></li>\n' +
        '</ul>');

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

server.listen(port);
console.log("Listening on " + port);

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
        if(typeof x.value !== 'number') console.log('x.value = ' + x.value);

            socket.emit('ain', {pin:ainNum, value:x.value});
//            console.log('emitted ain: ' + x.value + ', ' + ainNum);
        });
    });

    socket.on('gpio', function (gpioNum) {
//    console.log('gpio' + gpioNum);
        b.digitalRead(gpioNum, function(x) {
            if (x.err) throw x.err;
            socket.emit('gpio', {pin:gpioNum, value:x.value});
//            console.log('emitted gpio: ' + x.value + ', ' + gpioNum);
        });
    });

    socket.on('i2c', function (i2cNum) {
//        console.log('Got i2c request:' + i2cNum);
        exec('i2cget -y 1 ' + i2cNum + ' 0 w',
            function (error, stdout, stderr) {
//     The TMP102 returns a 12 bit value with the digits swapped
                stdout = '0x' + stdout.substring(4,6) + stdout.substring(2,4);
//                console.log('i2cget: "' + stdout + '"');
                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                socket.emit('i2c', stdout);
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
    
//    socket.on('slider', function(slideNum, value) {
//    console.log('slider' + slideNum + " = " + value);
//        fs.writeFile(pwmPath + "/duty_percent", value);
//    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        console.log("connectCount = " + connectCount);
    });

    connectCount++;
    console.log("connectCount = " + connectCount);
});

