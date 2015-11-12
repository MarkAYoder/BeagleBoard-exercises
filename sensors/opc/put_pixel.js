#!/usr/bin/env node
var opc_client = require('open-pixel-control');

var client = new opc_client({
  address: 'localhost',
  port: 7890
});

client.on('connected', function(){
  var strip = client.add_strip({
    length: 100
  });

  var i = 0, color = [255, 255, 255];
  setInterval(function(){

    client.put_pixel(strip.id, i, color);

    if(i == strip.length){
      i = 0;
      color = color[0] == 0 ? [255, 255, 255] : [0, 0, 0];
    } else {
      i++;
    }
  }, 20);
});

client.connect();
