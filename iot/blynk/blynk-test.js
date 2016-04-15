#!/usr/bin/env node
// From: http://www.instructables.com/id/Blynk-JavaScript-in-20-minutes-Raspberry-Pi-Edison/step2/Writing-a-simple-script/

var Blynk = require('blynk-library');
var b = require('bonescript');

var AUTH = '66e9f649bfb7441c8c2bb554becabcf3';

var inputPin = "P9_42";
var outputPin = "P9_14";
b.pinMode(inputPin, b.INPUT);
b.pinMode(outputPin, b.OUTPUT);
b.attachInterrupt(inputPin, setLED, b.CHANGE);

var blynk = new Blynk.Blynk(AUTH, options = {
  connector : new Blynk.TcpClient()
});

var v0 = new blynk.VirtualPin(0);   // Button
var v1 = new blynk.VirtualPin(1);   // Slider
var v2 = new blynk.VirtualPin(2);   // Graph
var v4 = new blynk.VirtualPin(4);   // LED display
var v9 = new blynk.VirtualPin(9);   // Test display
var slider;

function setLED(x) {
  console.log('setLED: ' + x.value);
  v4.write(255*x.value);
  v2.write(500*x.value);
}

v0.on('write', function(param) {
  var LED = param[0];
  v2.write(LED);
  v4.write(LED);
  console.log('LED:', LED);
  b.digitalWrite(outputPin, LED);
});

v1.on('write', function(param) {
  slider = param[0];
  v2.write(slider);
  v9.write(slider);
  console.log('V1:', param[0]);
});

v2.on('read', function() {
  v2.write(slider);
});

v9.on('read', function() {
  v9.write(slider);
});

var term = new blynk.WidgetTerminal(3);
term.on('write', function(data) {
  term.write('You wrote:' + data + '\n');
  blynk.notify("HAHA! " + data);
  console.log('You wrote:' +data);
});
