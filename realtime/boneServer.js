#!/usr/bin/node
// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
// This is a general server for the various web frontends
// buttonBox, ioPlot, realtimeDemo
"use strict";

var port = 9090, // Port to listen on
    bus = '/dev/i2c-2',
    busNum = 2,     // i2c bus number
    i2cNum = 0,             // Remembers the address of the last request
    http = require('http'),
    url = require('url'),
    fs = require('fs'),
    b = require('bonescript'),
    child_process = require('child_process'),
    server,
    connectCount = 0,	// Number of connections to server
    errCount = 0;	// Counts the AIN errors.
    
//  Audio
    var frameCount = 0,     // Counts the frames from arecord
        lastFrame = 0,      // Last frame sent to browser
        audioData,          // all data from arecord is saved here and sent
			                // to the client when requested.
        audioChild = 0,     // Process for arecord
        audioRate = 8000;
        
        // PWM
        var pwm = 'P9_21';

// Initialize various IO things.
function initIO() {
    // Make sure gpios 7 and 20 are available.
    b.pinMode('P9_42', b.INPUT);
    b.pinMode('P9_41', b.INPUT);
    b.pinMode(pwm,     b.ANALOG_OUTPUT);    // PWM
    
    // Initialize pwm
}

function send404(res) {
    res.writeHead(404);
    res.write('404');
    res.end();
}

initIO();

server = http.createServer(function (req, res) {
// server code
    var path = url.parse(req.url).pathname;
    console.log("path: " + path);
    if (path === '/') {
        path = '/boneServer.html';
    }

    fs.readFile(__dirname + path, function (err, data) {
        if (err) {return send404(res); }
//            console.log("path2: " + path);
        res.write(data, 'utf8');
        res.end();
    });
});

server.listen(port);
console.log("Listening on " + port);

// socket.io, I choose you
var io = require('socket.io').listen(server);
io.set('log level', 2);

// See https://github.com/LearnBoost/socket.io/wiki/Exposed-events
// for Exposed events

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
            if(typeof x.value !== 'number' || x.value === "NaN") {
                console.log('x.value = ' + x.value);
            } else {
                socket.emit('ain', {pin:ainNum, value:x.value});
            }
//            if(ainNum === "P9_38") {
//                console.log('emitted ain: ' + x.value + ', ' + ainNum);
//            }
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
        console.log('Got i2c request:' + i2cNum);
        child_process.exec('i2cget -y ' + busNum + ' ' + i2cNum + ' 0 w',
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
    
    // Send a packet of data every time a 'audio' is received.
    socket.on('audio', function () {
//        console.log("Received message: " + message + 
//            " - from client " + socket.id);
        if(audioChild === 0) {
            startAudio();
        }
        socket.emit('audio', sendAudio() );
    });
    
    socket.on('matrix.bs', function (i2cNum) {
        var i;
        var line = new Array(16);
        // console.log('Got i2c request:' + i2cNum);
        b.i2cOpen(bus, 0x70);
        for(i=0; i<16; i++) {
            // Can only read one byte at a time.  Something's wrong
            line[i] = b.i2cReadBytes(bus, i, 1)[0].toString(16);
            // console.log("line: " + JSON.stringify(line[i]));
        }
        console.log(line.join(' '));
        socket.emit('matrix', line.join(' '));
    });
    
    socket.on('matrix.wire', function (i2cNum) {
        var i;
        var line = new Array(16);
        // console.log('Got i2c request:' + i2cNum);
        b.i2cOpen(bus, 0x70);
        for(i=0; i<16; i++) {
            // Can only read one byte at a time.  Something's wrong
            line[i] = b.i2cReadBytes(bus, i, 1)[0].toString(16);
            // console.log("line: " + JSON.stringify(line[i]));
        }
        console.log(line.join(' '));
        socket.emit('matrix', line.join(' '));
    });
    
    socket.on('matrix', function (i2cNum) {
//        console.log('Got i2c request:' + i2cNum);
        child_process.exec('i2cdump -y -r 0x00-0x0f ' + busNum + ' ' + i2cNum + ' b',
            function (error, stdout, stderr) {
//      The LED has 8 16-bit values
//                console.log('i2cget: "' + stdout + '"');
		var lines = stdout.split("00: ");
		// Get the last line of the output and send the string
		lines = lines[1].substr(0,47);
		console.log("lines = %s", lines);
                socket.emit('matrix', lines);
                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
            });
    });
    
    // Sets one column every time i2cset is received.
    socket.on('i2cset.bs', function(params) {
        // console.log(params);
        if(params.i2cNum !== i2cNum) {
            i2cNum = params.i2cNum;
            console.log("i2cset: Opening " + i2cNum);
    	    b.i2cOpen(bus, i2cNum);
        }
    	b.i2cWriteBytes(bus, params.i, [params.disp]);
    });
    
    socket.on('i2cset', function(params) {
    // console.log(params);
	// Double i since display has 2 bytes per LED
	child_process.exec('i2cset -y ' + busNum + ' ' + params.i2cNum + ' ' + params.i + ' ' +
		params.disp); 
    });
    
    socket.on('slider', function(slideNum, value) {
        console.log('slider' + slideNum + " = " + value);
        b.analogWrite(pwm, value/5, 80);
    });

    socket.on('disconnect', function () {
        console.log("Connection " + socket.id + " terminated.");
        connectCount--;
        console.log("connectCount = " + connectCount);
    });

    connectCount++;
    console.log("connectCount = " + connectCount);
});

function sendAudio() {
//        console.log("Sending data");
    if(frameCount === lastFrame) {
//            console.log("Already sent frame " + lastFrame);
    } else {
        lastFrame = frameCount;
    }
    return(audioData);
}

function startAudio(){
    try {
        console.log("process.platform: " + process.platform);
        if(process.platform !== "darwin") {
        audioChild = child_process.spawn(
           "/usr/bin/arecord",
           [
            "-Dplughw:1,0",
            "-c2", "-r"+audioRate, "-fU8", "-traw", 
            "--buffer-size=800", "--period-size=800", "-N"
           ]
        );
        } else {
        audioChild = child_process.spawn(
           "/Users/yoder/bin/sox-14.4.0/rec",
           [
            "-c2", "-r44100", "-tu8",  
            "--buffer", "1600", "-q", "-"
           ]
        );

        }
//        console.log("arecord started");
        audioChild.stdout.setEncoding('base64');
        audioChild.stdout.on('data', function(data) {
            // Save data read from arecord in globalData
            audioData = data;
            frameCount++;
        });
        audioChild.stderr.on('data', function(data) {
            console.log("arecord: " + data);
        });
        audioChild.on('exit', function(code) {
            console.log("arecord exited with: " + code);
        });
    } catch(err) {
        console.log("arecord error: " + err);
    }
}
