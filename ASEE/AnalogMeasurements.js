//*****************************************************************
var b = require('bonescript');

//Old bonescript defines ’bone’ globally
var pins = b.bone.pins;

var ledPin = pins.P9_14;                                     //PWM pin for LED interface
var ainPin = pins.P9_39;                                     //analog input pin for IR sensor

var IR_sensor_value;

b.pinMode(ledPin, b.OUTPUT);                        //set pin to digital output
while(1)
{
//read analog output from IR sensor
//normalized value ranges from 0..1
IR_sensor_value = b.analogRead(ainPin);
b.analogWrite(ledPin, IR_sensor_value);
}
