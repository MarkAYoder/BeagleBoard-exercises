#!/usr/bin/env node
// From: https://azure.microsoft.com/en-us/develop/iot/get-started/

// Add reference to the Azure IoT Hub device library
var device = require('azure-iot-device');
// Define the connection string to connect to IoT Hub
var connectionString = 'HostName=BeagleWest.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=ZhZ/RcGJbu3FHfG7SWk1KAGr2JhTigdwe9P1D4OCbdU=';
// Create the client instance specifying the preferred protocol
var client = new device.Client(connectionString, new device.Https());
// Create a message and send it to IoT Hub.
var data = JSON.stringify({ 'deviceId': 'myFirstDevice', 'data': 'mydata' });
var message = new device.Message(data);
message.properties.add('myproperty', 'myvalue');
client.sendEvent(message, function(err, res){
    if (err) console.log('SendEvent error: ' + err.toString());
    if (res) console.log('SendEvent status: ' + res.statusCode + ' ' + res.statusMessage);
});
// Receive messages from IoT Hub
client.receive(function (err, res, msg) {
  console.log('receive data: ' + msg.getData());
  client.complete(msg, function(err, res){
    if (err) console.log('Complete error: ' + err.toString());
    if (res) console.log('Complete status: ' + res.statusCode + ' ' + res.statusMessage);
  });
});

// static const char* deviceId = "Bone";
// static const char* deviceKey = "ENnz8UA0bjAfeFWkeU9FZw==";
// static const char* hubName = "BeagleWest";
// static const char* hubSuffix = "azure-devices.net";