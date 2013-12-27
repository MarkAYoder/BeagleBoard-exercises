var socket;
var firstconnect = true;
disp = [];


var canvas;
var NUMLIGHTS=320;

var limer = function(n, l, h) {
	return Math.min(Math.max(n,l),h);
}

for (var i = 0; i < NUMLIGHTS; i++) {
	disp[i] = [limer(i,0,127),limer(NUMLIGHTS-i,0,127),127,0];
}

var drawCanvas = function() {
	canvas = document.getElementById("canvas");
	var ctx = canvas.getContext("2d");
	var width = canvas.getBoundingClientRect().width;
	var height = canvas.getBoundingClientRect().height;
	
	ctx.fillStyle = "rgb(0,0,0)";
	ctx.fillRect(0, 0, width, height);

	for (var i = 0; i < NUMLIGHTS ; i++) {
		ctx.fillStyle = "rgb(" +(2*disp[i][0]) + "," + (2*disp[i][1]) + "," + (2*disp[i][2]) + ")";
		ctx.fillRect((9*i)+1, 1, 7, 7);
	 }
};
//drawCanvas();
window.setTimeout("drawCanvas()",0);

var setLight = function(r, g, b, p){
	if (p >=0 && p <NUMLIGHTS){
		disp[p] = [limer(r,0,127),limer(g,0,127),limer(b,0,127),1];
	} 
};

var sendLights = function(delay) {
	var lightsToSend  =[];
	for (var i = 0; i < NUMLIGHTS; i++){
		if (disp[i][3] == 1){
			lightsToSend[lightsToSend.length] = [disp[i][0],disp[i][1],disp[i][2],i];
			disp[i][3] = 0;
		}
	}
	drawCanvas();
	socket.emit('LEDChain2', {data:lightsToSend, delay:(delay | 0)});
};

function runCode(code) {
    socket.emit('runCode', {code:code});
}

//socket.emit('i2cset', {i2cNum: i2cNum, i: 2*i, 
//			 disp: '0x'+disp[i].toString(16)});

function connect() {
  if(firstconnect) {
	socket = io.connect(null);

	// See https://github.com/LearnBoost/socket.io/wiki/Exposed-events
	// for Exposed events
	socket.on('message', function(data)
		{ status_update("Received: message " + data);});
	socket.on('connect', function()
		{ status_update("Connected to Server"); });
	socket.on('disconnect', function()
		{ status_update("Disconnected from Server"); });
	socket.on('reconnect', function()
		{ status_update("Reconnected to Server"); });
	socket.on('reconnecting', function( nextRetry )
		{ status_update("Reconnecting in " + nextRetry/1000 + " s"); });
	socket.on('reconnect_failed', function()
		{ message("Reconnect Failed"); });
	firstconnect = false;
  }
  else {
	socket.socket.reconnect();
  }
}

function disconnect() {
  socket.disconnect();
}

function status_update(txt){
	document.getElementById("statusUpdate").innerText = txt;
}

connect();
