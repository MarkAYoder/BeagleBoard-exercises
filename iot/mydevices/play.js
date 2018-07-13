#!/usr/bin/env node
const Cayenne = require('cayennejs');
const fs = require('fs');

const filename = "/home/debian/exercises/iot/mydevices/keys_office.json";
const keys = JSON.parse(fs.readFileSync(filename));
// console.log("keys: " + keys);

// Initiate MQTT API
const cayenneClient = new Cayenne.MQTT(keys);

cayenneClient.connect((err, mqttClient) => {
  var test = cayenneClient.getDataTopic(3);
  console.log("test: " + test);
  // dashboard widget automatically detects datatype & unit
  cayenneClient.fahrenheitWrite(3, 65);

  // sending raw values without datatypes
  cayenneClient.rawWrite(4, 123);

  // subscribe to data channel for actions (actuators)
  cayenneClient.on("cmd9", function(data) {
    console.log(data);
  });

});
