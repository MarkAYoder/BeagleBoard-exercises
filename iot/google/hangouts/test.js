#!/usr/bin/env node
// From: https://www.npmjs.com/package/hangupsjs

var Client = require('hangupsjs');
var Q = require('q');
 
// callback to get promise for creds using stdin. this in turn 
// means the user must fire up their browser and get the 
// requested token. 
var creds = function() {
  return {
    auth: Client.authStdin
  };
};
 
var client = new Client();
 
// set more verbose logging 
client.loglevel('debug');
 
// receive chat message events 
client.on('chat_message', function(ev) {
  return console.log(ev);
});
 
// connect and post a message. 
// the id is a conversation id. 
client.connect(creds).then(function() {
    return client.sendchatmessage('UgzJilj2Tg_oqkAaABAQ',
    [[0, 'Hello World']]);
}).done();