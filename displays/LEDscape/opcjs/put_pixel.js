#!/usr/bin/env node

var opc_client = require('open-pixel-control');
var util = require('util');

var client = new opc_client({
  address: 'localhost',
  port: 7890
});

client.on('connected', function() {
  var strip = 
      client.add_strip({
        length: 300
      });
    
    // console.log("strip: " + util.inspect(strip));

  var i = 0, color = [127, 0, 127];

  setInterval(function(){

    // console.log("i: " + i);
    client.put_pixel(strip.id, i, color);
    // client.put_pixel(strip.id, i+100, color);

    if(i == strip.length) {
      i = 0;
      color = color[0] == 0 ? [127, 0, 127] : [0, 0, 0];
    } else {
      i++;
    }
  }, 10);
});

client.connect();
