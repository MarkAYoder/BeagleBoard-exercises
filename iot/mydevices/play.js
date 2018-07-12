#!/usr/bin/env node
var Cayenne = require('cayennejs');

// Initiate MQTT API
const cayenneClient = new Cayenne.MQTT({
  username: "9d396770-6f4d-11e8-84d1-4d9372e87a68",
  password: "b977512eb348da0f00a02d000acf36d324ae6346",
  clientId: "a4153ba0-6f4d-11e8-ab28-e7cb4e37d88a"
});

cayenneClient.connect((err, mqttClient) => {
  var test = cayenneClient.getDataTopic(3);
  console.log("test: " + test);
  // dashboard widget automatically detects datatype & unit
  cayenneClient.kelvinWrite(3, 65);

  // sending raw values without datatypes
  cayenneClient.rawWrite(4, 123);

  // subscribe to data channel for actions (actuators)
  cayenneClient.on("cmd9", function(data) {
    console.log(data);
  });

});
