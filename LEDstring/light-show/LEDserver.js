#!/usr/bin/node
// From Getting Started With node.js and socket.io 
// http://codehenge.net/blog/2011/12/getting-started-with-node-js-and-socket-io-v0-7-part-2/
// This is a general server for the various web frontends
// buttonBox, ioPlot, realtimeDemo
"use strict";

var port = 8081, // Port to listen on
	http = require('http'),
	url = require('url'),
	fs = require('fs'),
	b = require('bonescript'),
	//child_process = require('child_process'),
	server,
	connectCount = 0,	// Number of connections to server
	NUMLIGHTS = 320,    // Number of LEDs in the LED string
	MAX_TOTAL_DELAY_SECONDS = 600,    // maximum ammount of total delay time allowed in lightDeltasQueue
	MAX_TOTAL_DELTAS = 10000,    // maximum size of the light deltas queue
	lightsDisplaying = false,  // if it is working it's way through the light deltas queue currently
	lightDeltasQueue = [];   // the list of lights changes / delays to do, in order.

lightDeltasQueue.totalDelay = 0; // miliseconds of delay in the frams in the 
	
	
// Initialize various IO things.
function initIO() {
	// Make sure gpios 7 and 20 are available.
	//b.pinMode('P9_42', b.INPUT);
	//b.pinMode('P9_41', b.INPUT);
	//b.pinMode(pwm,	 b.INPUT);	// PWM
	
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
		path = '/lightShow.html';
	}

	fs.readFile(__dirname + path, function (err, data) {
		if (err) {return send404(res); }
//			console.log("path2: " + path);
		res.write(data, 'utf8');
		res.end();
	});
});

server.listen(port);
console.log("Listening on " + port);

var setLights = function(lightsToChange){
	var ledChain = "";
	var file ='/sys/firmware/lpd8806/device/rgb';
	for (var i = 0; i < lightsToChange.length; i++){
		ledChain = "";
		if (0 <= Math.round(lightsToChange[i][3]) <= NUMLIGHTS-1){
			ledChain += 
				(Math.min(Math.max(Math.round(lightsToChange[i][0]),0),127) | 0) + " " + 
				(Math.min(Math.max(Math.round(lightsToChange[i][1]),0),127) | 0) + " " + 
				(Math.min(Math.max(Math.round(lightsToChange[i][2]),0),127) | 0) + " " + 
				(Math.min(Math.max(Math.round(lightsToChange[i][3]),0),NUMLIGHTS-1) | 0); 
			b.writeTextFile(file, ledChain);
				
		}
	}
	b.writeTextFile(file, "\n");
};

var processLights = function(){
	var currentDelta;
	while (lightDeltasQueue.length > 0){
		currentDelta= lightDeltasQueue.shift();
		setLights(currentDelta.data);
		lightDeltasQueue.totalDelay -= (currentDelta.delay | 0);
		if (10000 > (currentDelta.delay | 0) > 0 ) {
			setTimeout(processLights, currentDelta.delay);
			return;
		}
	}
	lightsDisplaying = false;
};

var restartProcessing = function(){
	if (lightsDisplaying == false){
		lightsDisplaying = true;
		processLights();
	}
};


// socket.io, I choose you
var io = require('socket.io').listen(server);
io.set('log level', 2);

// See https://github.com/LearnBoost/socket.io/wiki/Exposed-events
// for Exposed events

	
// on a 'connection' event
io.sockets.on('connection', function (socket) {

	console.log("Connection " + socket.id + " accepted.");

	socket.on('LEDChain2', function (params) {
		if (lightDeltasQueue.totalDelay < 1000 * MAX_TOTAL_DELAY_SECONDS && lightDeltasQueue.length < MAX_TOTAL_DELTAS){
			lightDeltasQueue.push(params);
			lightDeltasQueue.totalDelay +=  (params.delay | 0);
			restartProcessing();
		} else {
			console.log("dropping frame. current total delay: " + lightDeltasQueue.totalDelay + ", current frame count: " + lightDeltasQueue.length);
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