#!/usr/bin/node
var d1 = new Date(),
    d2;
var i, j;
var base_accel_gyro = [];   // Holds calibration values
var last_read_time,
    last_accel_gyro;
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
       //  console.log("accel_gyro = " + accel_gyro);
//        console.log("accel_gyro_total = " + accel_gyro_total);
        // delay(100);
    }
    
    // Store the raw calibration values globally
    for(i=0; i<accel_gyro.length; i++) {
        base_accel_gyro[i] = accel_gyro_total[i] / num_readings;
    }
    // console.log("base_gyro_total = " + base_accel_gyro);
        
  
  //Serial.println("Finishing Calibration");
}

function set_last_read_angle_data(time, accel_gyro) {
    last_read_time = time;
    last_accel_gyro = accel_gyro;
}


function loop() {
    var error;
    var dT;
    var i;
    var FS_SEL = 131;
    var accel_gyro;

  /*
  Serial.println(F(""));
  Serial.println(F("MPU-6050"));
  */
  
  // Read the raw values.
  accel_gyro = mpu.getMotion6();
  
  // Get the time of reading for rotation computations
  var d1 = new Date();
   
/*
  Serial.print(F("Read accel, temp and gyro, error = "));
  Serial.println(error,DEC);
  

  // Print the raw acceleration values
  Serial.print(F("accel x,y,z: "));
  Serial.print(accel_t_gyro.value.x_accel, DEC);
  Serial.print(F(", "));
  Serial.print(accel_t_gyro.value.y_accel, DEC);
  Serial.print(F(", "));
  Serial.print(accel_t_gyro.value.z_accel, DEC);
  Serial.println(F(""));
*/ 

  // The temperature sensor is -40 to +85 degrees Celsius.
  // It is a signed integer.
  // According to the datasheet: 
  //   340 per degrees Celsius, -512 at 35 degrees.
  // At 0 degrees: -512 - (340 * 35) = -12412
/*  
  Serial.print(F("temperature: "));
  dT = ( (double) accel_t_gyro.value.temperature + 12412.0) / 340.0;
  Serial.print(dT, 3);
  Serial.print(F(" degrees Celsius"));
  Serial.println(F(""));
  

  // Print the raw gyro values.
  Serial.print(F("raw gyro x,y,z : "));
  Serial.print(accel_t_gyro.value.x_gyro, DEC);
  Serial.print(F(", "));
  Serial.print(accel_t_gyro.value.y_gyro, DEC);
  Serial.print(F(", "));
  Serial.print(accel_t_gyro.value.z_gyro, DEC);
  Serial.print(F(", "));
  Serial.println(F(""));
*/

    // Convert gyro values to degrees/sec
    for(i=3; i<accel_gyro.length; i++) {
        (accel_gyro[i] - base_accel_gyro[i])/FS_SEL;
    }  
  
    // Get raw acceleration values
    //float G_CONVERT = 16384;
    for(i=3; i<accel_gyro.length; i++) {
        (accel_gyro[i] - base_accel_gyro[i]);
    }  
  
    // Get angle values from accelerometer
    var RADIANS_TO_DEGREES = 180/3.14159;
//  float accel_vector_length = sqrt(pow(accel_x,2) + pow(accel_y,2) + pow(accel_z,2));
    var accel_angle_y = Math.atan(-1*accel_gyro[0]/Math.sqrt(Math.pow(accel_gyro[1],2) + Math.pow(accel_gyro[2],2)))*RADIANS_TO_DEGREES;
    var accel_angle_x = Math.atan(   accel_gyro[1]/Math.sqrt(Math.pow(accel_gyro[0],2) + Math.pow(accel_gyro[3],2)))*RADIANS_TO_DEGREES;
//  var accel_angle_y = atan(-1*accel_x/sqrt(pow(accel_y,2) + pow(accel_z,2)))*RADIANS_TO_DEGREES;
//  var accel_angle_x = atan(accel_y/sqrt(pow(accel_x,2) + pow(accel_z,2)))*RADIANS_TO_DEGREES;

    var accel_angle_z = 0;
    console.log("accel_angle_x = " + accel_angle_x);
    console.log("accel_angle_y = " + accel_angle_y);
    console.log("accel_angle_z = " + accel_angle_z);
/*
  // Compute the (filtered) gyro angles
  var dt =(Date() - get_last_time())/1000.0;
  float gyro_angle_x = gyro_x*dt + get_last_x_angle();
  float gyro_angle_y = gyro_y*dt + get_last_y_angle();
  float gyro_angle_z = gyro_z*dt + get_last_z_angle();
/*  
  // Compute the drifting gyro angles
  float unfiltered_gyro_angle_x = gyro_x*dt + get_last_gyro_x_angle();
  float unfiltered_gyro_angle_y = gyro_y*dt + get_last_gyro_y_angle();
  float unfiltered_gyro_angle_z = gyro_z*dt + get_last_gyro_z_angle();
  
  // Apply the complementary filter to figure out the change in angle - choice of alpha is
  // estimated now.  Alpha depends on the sampling rate...
  float alpha = 0.96;
  float angle_x = alpha*gyro_angle_x + (1.0 - alpha)*accel_angle_x;
  float angle_y = alpha*gyro_angle_y + (1.0 - alpha)*accel_angle_y;
  float angle_z = gyro_angle_z;  //Accelerometer doesn't give z-angle
  
  // Update the saved data with the latest values
  set_last_read_angle_data(t_now, angle_x, angle_y, angle_z, unfiltered_gyro_angle_x, unfiltered_gyro_angle_y, unfiltered_gyro_angle_z);
  
  // Send the data to the serial port
  Serial.print(F("DEL:"));              //Delta T
  Serial.print(dt, DEC);
  Serial.print(F("#ACC:"));              //Accelerometer angle
  Serial.print(accel_angle_x, 2);
  Serial.print(F(","));
  Serial.print(accel_angle_y, 2);
  Serial.print(F(","));
  Serial.print(accel_angle_z, 2);
  Serial.print(F("#GYR:"));
  Serial.print(unfiltered_gyro_angle_x, 2);        //Gyroscope angle
  Serial.print(F(","));
  Serial.print(unfiltered_gyro_angle_y, 2);
  Serial.print(F(","));
  Serial.print(unfiltered_gyro_angle_z, 2);
  Serial.print(F("#FIL:"));             //Filtered angle
  Serial.print(angle_x, 2);
  Serial.print(F(","));
  Serial.print(angle_y, 2);
  Serial.print(F(","));
  Serial.print(angle_z, 2);
  Serial.println(F(""));
  
  // Delay so we don't swamp the serial port
  delay(5);
  */
}


mpu.initialize();

if (!mpu.testConnection()) {
    console.log("Connection Failed");
}
    calibrate_sensors();
    set_last_read_angle_data(Date(), 0, 0, 0, 0, 0, 0);

    loop();  

mpu.setSleepEnabled(1);

