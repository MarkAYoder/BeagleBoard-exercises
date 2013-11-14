// From: http://www.geekmomprojects.com/?wpdmact=process&did=Mi5ob3RsaW5r
// http://www.geekmomprojects.com/gyroscopes-and-accelerometers-on-a-chip/http://www.geekmomprojects.com/gyroscopes-and-accelerometers-on-a-chip/
// MPU-6050 Accelerometer + Gyro
// -----------------------------
//
// By arduino.cc user "Krodal".
// June 2012
// Open Source / Public Domain
//
// Using Arduino 1.0.1
// It will not work with an older version, 
// since Wire.endTransmission() uses a parameter 
// to hold or release the I2C bus.
//
// Documentation:
// - The InvenSense documents:
//   - "MPU-6000 and MPU-6050 Product Specification",
//     PS-MPU-6000A.pdf
//   - "MPU-6000 and MPU-6050 Register Map and Descriptions",
//     RM-MPU-6000A.pdf or RS-MPU-6000A.pdf
//   - "MPU-6000/MPU-6050 9-Axis Evaluation Board User Guide"
//     AN-MPU-6000EVB.pdf
// 
// The accuracy is 16-bits.
//
// Temperature sensor from -40 to +85 degrees Celsius
//   340 per degrees, -512 at 35 degrees.
//
// At power-up, all registers are zero, except these two:
//      Register 0x6B (PWR_MGMT_2) = 0x40  (I read zero).
//      Register 0x75 (WHO_AM_I)   = 0x68.
// 

// #include <Wire.h>


// The name of the sensor is "MPU-6050".
// For program code, I omit the '-', 
// therefor I use the name "MPU6050....".

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "i2c-dev.h"
#include "i2cbusses.h"
#include "mpu6050.h"

int i2c_init(const char* bus, const char* address_string);
static int check_funcs(int file);

// Use the following global variables and access functions to help store the overall
// rotation angle of the sensor
unsigned long last_read_time;
float         last_x_angle;  // These are the filtered angles
float         last_y_angle;
float         last_z_angle;  
float         last_gyro_x_angle;  // Store the gyro angles to compare drift
float         last_gyro_y_angle;
float         last_gyro_z_angle;

void set_last_read_angle_data(unsigned long time, float x, float y, float z, float x_gyro, float y_gyro, float z_gyro) {
  last_read_time = time;
  last_x_angle = x;
  last_y_angle = y;
  last_z_angle = z;
  last_gyro_x_angle = x_gyro;
  last_gyro_y_angle = y_gyro;
  last_gyro_z_angle = z_gyro;
}

inline unsigned long get_last_time() {return last_read_time;}
inline float get_last_x_angle() {return last_x_angle;}
inline float get_last_y_angle() {return last_y_angle;}
inline float get_last_z_angle() {return last_z_angle;}
inline float get_last_gyro_x_angle() {return last_gyro_x_angle;}
inline float get_last_gyro_y_angle() {return last_gyro_y_angle;}
inline float get_last_gyro_z_angle() {return last_gyro_z_angle;}

//  Use the following global variables and access functions
//  to calibrate the acceleration sensor
float    base_x_accel;
float    base_y_accel;
float    base_z_accel;

float    base_x_gyro;
float    base_y_gyro;
float    base_z_gyro;

int read_gyro_accel_vals(int file, accel_t_gyro_d*  accel_t_gyro_ptr) {
        int count, i, tmp;
    // Read the raw values.
    // Read 14 bytes at once, 
    // containing acceleration, temperature and gyro.
    // With the default settings of the MPU-6050,
    // there is no filter enabled, and the values
    // are not very stable.  Returns the error value
  
    // accel_t_gyro_union* accel_t_gyro = (accel_t_gyro_union *) accel_t_gyro_ptr;

    count = i2c_smbus_read_i2c_block_data(file, MPU6050_ACCEL_XOUT_H, 
                                            sizeof(*accel_t_gyro_ptr), accel_t_gyro_ptr);
    //  int error = MPU6050_read (MPU6050_ACCEL_XOUT_H, (uint8_t *) accel_t_gyro, sizeof(*accel_t_gyro));
    // Swap all high and low bytes.
    // After this, the registers values are swapped, 
    // so the structure name like x_accel_l does no 
    // longer contain the lower byte.    
    for(i=0; i<7; i++) {
        printf("%6d: %6d\t\t", i, accel_t_gyro_ptr->value[i]);
        tmp = accel_t_gyro_ptr->byte[2*i];
        accel_t_gyro_ptr->byte[2*i] = accel_t_gyro_ptr->byte[2*i+1];
        accel_t_gyro_ptr->byte[2*i+1] = tmp;
        printf("%6d: %6d\n", i, accel_t_gyro_ptr->value[i]);
    }
    printf("count = %d\n", count);
    printf("x_accel = %d\n", accel_t_gyro_ptr->name.x_accel);
    printf("y_accel = %d\n", accel_t_gyro_ptr->name.y_accel);
    printf("z_accel = %d\n", accel_t_gyro_ptr->name.z_accel);
}

// The sensor should be motionless on a horizontal surface 
//  while calibration is happening
void calibrate_sensors(int file) {
  int                   num_readings = 10;
  float                 x_accel = 0;
  float                 y_accel = 0;
  float                 z_accel = 0;
  float                 x_gyro = 0;
  float                 y_gyro = 0;
  float                 z_gyro = 0;
  accel_t_gyro_d          accel_t_gyro;
  int i;
  
  //Serial.println("Starting Calibration");

  // Discard the first set of values read from the IMU
  read_gyro_accel_vals(file, &accel_t_gyro);
  
  // Read and average the raw values from the IMU
  for (i = 0; i < num_readings; i++) {
    read_gyro_accel_vals(file, &accel_t_gyro);
    x_accel += accel_t_gyro.name.x_accel;
    y_accel += accel_t_gyro.name.y_accel;
    z_accel += accel_t_gyro.name.z_accel;
    x_gyro += accel_t_gyro.name.x_gyro;
    y_gyro += accel_t_gyro.name.y_gyro;
    z_gyro += accel_t_gyro.name.z_gyro;
    usleep(100000);
  }
  x_accel /= num_readings;
  y_accel /= num_readings;
  z_accel /= num_readings;
  x_gyro /= num_readings;
  y_gyro /= num_readings;
  z_gyro /= num_readings;
  
  // Store the raw calibration values globally
  base_x_accel = x_accel;
  base_y_accel = y_accel;
  base_z_accel = z_accel;
  base_x_gyro = x_gyro;
  base_y_gyro = y_gyro;
  base_z_gyro = z_gyro;
  
  //Serial.println("Finishing Calibration");
}

// void setup()
int main(int argc, char *argv[]) {      
    int error, file, res;
    int count, i;
    accel_t_gyro_d test;


    printf("InvenSense MPU-6050/n");
    printf("November 2013/n");

    // Initialize the 'Wire' class for the I2C-bus.
    //Wire.begin();
    file = i2c_init("1", "0x68");

    // default at power-up:
    //    Gyro at 250 degrees second
    //    Acceleration at 2g
    //    Clock source at internal 8MHz
    //    The device is in sleep mode.

    res = i2c_smbus_read_byte_data(file, MPU6050_WHO_AM_I);
    printf("MPU6050_WHO_AM_I = %d (0x%x)\n", res, res);

     // Clear the 'sleep' bit to start the sensor.
    res = i2c_smbus_read_byte_data(file, MPU6050_PWR_MGMT_1);
    printf("MPU6050_PWR_MGMT_1 = %d (0x%x)\n", res, res);
    i2c_smbus_write_byte_data(file, MPU6050_PWR_MGMT_1, 0);
    res = i2c_smbus_read_byte_data(file, MPU6050_PWR_MGMT_1);
    printf("MPU6050_PWR_MGMT_1= %d (0x%x)\n", res, res);
    
  
    printf("Starting Calibration\n");
  
    // Discard the first set of values read from the IMU
    read_gyro_accel_vals(file, &test);
  
    //Initialize the angles
  
    calibrate_sensors(file);  
//  set_last_read_angle_data(millis(), 0, 0, 0, 0, 0, 0);

// }


// void loop()
#ifdef HACK
while(1)
{
  double dT;
  // accel_t_gyro_union accel_t_gyro;

  /*
  Serial.println(F(""));
  Serial.println(F("MPU-6050"));
  */
  
  // Read the raw values.
  error = read_gyro_accel_vals((uint8_t*) &accel_t_gyro);
  
  // Get the time of reading for rotation computations
  unsigned long t_now = millis();
   
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
  float FS_SEL = 131;
  /*
  float gyro_x = (accel_t_gyro.value.x_gyro - base_x_gyro)/FS_SEL;
  float gyro_y = (accel_t_gyro.value.y_gyro - base_y_gyro)/FS_SEL;
  float gyro_z = (accel_t_gyro.value.z_gyro - base_z_gyro)/FS_SEL;
  */
  float gyro_x = (accel_t_gyro.value.x_gyro - base_x_gyro)/FS_SEL;
  float gyro_y = (accel_t_gyro.value.y_gyro - base_y_gyro)/FS_SEL;
  float gyro_z = (accel_t_gyro.value.z_gyro - base_z_gyro)/FS_SEL;
  
  
  // Get raw acceleration values
  //float G_CONVERT = 16384;
  float accel_x = accel_t_gyro.value.x_accel;
  float accel_y = accel_t_gyro.value.y_accel;
  float accel_z = accel_t_gyro.value.z_accel;
  
  // Get angle values from accelerometer
  float RADIANS_TO_DEGREES = 180/3.14159;
//  float accel_vector_length = sqrt(pow(accel_x,2) + pow(accel_y,2) + pow(accel_z,2));
  float accel_angle_y = atan(-1*accel_x/sqrt(pow(accel_y,2) + pow(accel_z,2)))*RADIANS_TO_DEGREES;
  float accel_angle_x = atan(accel_y/sqrt(pow(accel_x,2) + pow(accel_z,2)))*RADIANS_TO_DEGREES;

  float accel_angle_z = 0;
  
  // Compute the (filtered) gyro angles
  float dt =(t_now - get_last_time())/1000.0;
  float gyro_angle_x = gyro_x*dt + get_last_x_angle();
  float gyro_angle_y = gyro_y*dt + get_last_y_angle();
  float gyro_angle_z = gyro_z*dt + get_last_z_angle();
  
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
}
#endif

} // End of main

#ifdef HACK
// --------------------------------------------------------
// MPU6050_read
//
// This is a common function to read multiple bytes 
// from an I2C device.
//
// It uses the boolean parameter for Wire.endTransMission()
// to be able to hold or release the I2C-bus. 
// This is implemented in Arduino 1.0.1.
//
// Only this function is used to read. 
// There is no function for a single byte.
//
int MPU6050_read(int start, uint8_t *buffer, int size)
{
  int i, n, error;

  Wire.beginTransmission(MPU6050_I2C_ADDRESS);
  n = Wire.write(start);
  if (n != 1)
    return (-10);

  n = Wire.endTransmission(false);    // hold the I2C-bus
  if (n != 0)
    return (n);

  // Third parameter is true: relase I2C-bus after data is read.
  Wire.requestFrom(MPU6050_I2C_ADDRESS, size, true);
  i = 0;
  while(Wire.available() && i<size)
  {
    buffer[i++]=Wire.read();
  }
  if ( i != size)
    return (-11);

  return (0);  // return : no error
}


// --------------------------------------------------------
// MPU6050_write
//
// This is a common function to write multiple bytes to an I2C device.
//
// If only a single register is written,
// use the function MPU_6050_write_reg().
//
// Parameters:
//   start : Start address, use a define for the register
//   pData : A pointer to the data to write.
//   size  : The number of bytes to write.
//
// If only a single register is written, a pointer
// to the data has to be used, and the size is
// a single byte:
//   int data = 0;        // the data to write
//   MPU6050_write (MPU6050_PWR_MGMT_1, &c, 1);
//
int MPU6050_write(int start, const uint8_t *pData, int size)
{
  int n, error;

  Wire.beginTransmission(MPU6050_I2C_ADDRESS);
  n = Wire.write(start);        // write the start address
  if (n != 1)
    return (-20);

  n = Wire.write(pData, size);  // write data bytes
  if (n != size)
    return (-21);

  error = Wire.endTransmission(true); // release the I2C-bus
  if (error != 0)
    return (error);

  return (0);         // return : no error
}

// --------------------------------------------------------
// MPU6050_write_reg
//
// An extra function to write a single register.
// It is just a wrapper around the MPU_6050_write()
// function, and it is only a convenient function
// to make it easier to write a single register.
//
int MPU6050_write_reg(int reg, uint8_t data)
{
  int error;

  error = MPU6050_write(reg, &data, 1);

  return (error);
}
#endif

// --------------------------------------------------------
// i2c_init
//
// Open the i2c device and set the address
//
int i2c_init(const char* bus, const char* address_string) {
    int res, i2cbus, address, file;
	char filename[20];
	int force = 0;

	i2cbus = lookup_i2c_bus(bus);
	printf("i2cbus = %d\n", i2cbus);
//	if (i2cbus < 0)
//		help();

	address = parse_i2c_address(address_string);
	printf("address = 0x%2x\n", address);
//	if (address < 0)
//		help();

	file = open_i2c_dev(i2cbus, filename, sizeof(filename), 0);
	printf("file = %d\n", file);
	if (file < 0
	 || check_funcs(file)
	 || set_slave_addr(file, address, force))
		exit(1);

    return file;
}

static int check_funcs(int file) {
    unsigned long funcs;

	/* check adapter functionality */
	if (ioctl(file, I2C_FUNCS, &funcs) < 0) {
		fprintf(stderr, "Error: Could not get the adapter "
			"functionality matrix: %s\n", strerror(errno));
		return -1;
	}

	if (!(funcs & I2C_FUNC_SMBUS_WRITE_BYTE)) {
		fprintf(stderr, MISSING_FUNC_FMT, "SMBus send byte");
		return -1;
	}
	return 0;
}