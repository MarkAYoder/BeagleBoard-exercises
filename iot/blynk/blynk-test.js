#!/usr/bin/env node
// From: http://www.instructables.com/id/Blynk-JavaScript-in-20-minutes-Raspberry-Pi-Edison/step2/Writing-a-simple-script/

var Blynk = require('blynk-library');

var AUTH = '66e9f649bfb7441c8c2bb554becabcf3';

var blynk = new Blynk.Blynk(AUTH, options = {
  connector : new Blynk.TcpClient()
});

var v1 = new blynk.VirtualPin(1);
var v9 = new blynk.VirtualPin(9);

v1.on('write', function(param) {
  console.log('V1:', param[0]);
});

v9.on('read', function() {
  v9.write(new Date().getSeconds());
});

var term = new blynk.WidgetTerminal(3);
term.on('write', function(data) {
  term.write('You wrote:' + data + '\n');
  blynk.notify("HAHA! " + data);
});
