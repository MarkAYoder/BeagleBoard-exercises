#!/usr/bin/env nodejs
var e131 = require('e131');
console.log("Starting...");
 
var client = new e131.Client('fpp');  // or use a universe
// console.log("client: ");
// console.log(client);
var packet = client.createPacket(512);  // we want 8 RGB (x3) slots
var slotsData = packet.getSlotsData();
packet.setSourceName('test E1.31 client');
// packet.setUniverse(0x01);  // make universe number consistent with the client
packet.setOption(packet.Options.PREVIEW, true);  // don't really change any fixture
// packet.setPriority(packet.DEFAULT_PRIORITY);  // not strictly needed, done automatically
// console.log("packet: ");
// console.log(packet);
console.log("slotsData: " + slotsData.length);
// console.log(slotsData); 
// console.log("looping...");
// slotsData is a Buffer view, you can use it directly

function cycleColor() {
  // console.log("cycleColor");
    for(var univ=1; univ<9; univ++) {
	packet.setUniverse(univ);
	for (var idx=0; idx<slotsData.length; idx+=3) {
	    slotsData[idx+0] = 0xff;
	    slotsData[idx+1] = 0x00;
	    slotsData[idx+2] = 0x00;
	}
	client.send(packet);
    }
}
// setInterval(cycleColor, 250);
cycleColor();
