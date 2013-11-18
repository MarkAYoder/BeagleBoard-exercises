#!/usr/bin/node
var d1 = new Date();
var mpu6050 = require('mpu6050');
var mpu = new mpu6050();
mpu.initialize();

if (mpu.testConnection()) {
  console.log(mpu.getMotion6());
  console.log(mpu.getMotion6());
  console.log(mpu.getMotion6());
}
console.log(mpu.getDeviceID());
mpu.setDeviceID(10);
console.log(mpu.getDeviceID());

mpu.setSleepEnabled(1);

console.log(mpu);

var d2 = new Date();
    
    console.log(d1.getTime());
    console.log(d2.getTime());
    console.log(d2.getTime()-d1.getTime());