#!/usr/bin/env node
// From https://www.instructables.com/id/Blynk-JavaScript-in-20-minutes-Raspberry-Pi-Edison/
var Blynk = require('blynk-library');

var AUTH = '087e4c21298e413ab9d5f87a5279e5c9';

var blynk = new Blynk.Blynk(AUTH, options = {
    connector: new Blynk.TcpClient()
});

var v1 = new blynk.VirtualPin(1);
var v9 = new blynk.VirtualPin(9);

v1.on('write', function(param) {
    console.log('V1:', param[0]);
});

v9.on('read', function() {
    v9.write(new Date().getSeconds());
});