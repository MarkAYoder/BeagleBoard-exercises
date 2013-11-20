#!/usr/bin/node
var d1 = new Date(),
    d2;
var i, j;
var base_accel_gyro = [];   // Holfd calibration values
var mpu6050 = require('mpu6050');
var mpu = new mpu6050();

// The sensor should be motionless on a horizontal surface 
//  while calibration is happening
function calibrate_sensors() {
    var num_readings = 10;
    var accel_gyro, accel_gyro_total = [];
  
    console.log("Starting Calibration");

    // Discard the first set of values read from the IMU
    accel_gyro = mpu.getMotion6();
    for(i=0; i<accel_gyro.length; i++) {
        accel_gyro_total[i] = 0;
    }
  
    // Read and average the raw values from the IMU
    for (j=0; j<num_readings; j++) {
        accel_gyro = mpu.getMotion6();
        for(i=0; i<accel_gyro.length; i++) {
            accel_gyro_total[i] += accel_gyro[i];
        }
        console.log("accel_gyro = " + accel_gyro);
//        console.log("accel_gyro_total = " + accel_gyro_total);
        // delay(100);
    }
    
    // Store the raw calibration values globally
    for(i=0; i<accel_gyro.length; i++) {
        base_accel_gyro[i] = accel_gyro_total[i] / num_readings;
    }
    console.log("base_gyro_total = " + base_accel_gyro);
        
  
  //Serial.println("Finishing Calibration");
}


mpu.initialize();

if (!mpu.testConnection()) {
    console.log("Connection Failed");
}
  calibrate_sensors();

mpu.setSleepEnabled(1);

