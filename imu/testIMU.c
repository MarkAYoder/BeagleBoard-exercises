/*
    testIMU.c - Reads values from the MPU6050 IMU
    Mark A. Yoder, 13-Nov-2013.
    From: http://www.geekmomprojects.com/?wpdmact=process&did=Mi5ob3RsaW5r
    http://www.geekmomprojects.com/gyroscopes-and-accelerometers-on-a-chip/http://www.geekmomprojects.com/gyroscopes-and-accelerometers-on-a-chip/
    MPU-6050 Accelerometer + Gyro

*/
/*
    i2cset.c - A user-space program to write an I2C register.
    Copyright (C) 2001-2003  Frodo Looijaard <frodol@dds.nl>, and
                             Mark D. Studebaker <mdsxyz123@yahoo.com>
    Copyright (C) 2004-2010  Jean Delvare <khali@linux-fr.org>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
    MA 02110-1301 USA.
*/

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "i2c-dev.h"
#include "i2cbusses.h"
#include "mpu6050.h"

static void help(void) __attribute__ ((noreturn));

static void help(void) {
	fprintf(stderr, "Usage: testIMU (hardwired to bus 1, address 0x68)\n");
	exit(1);
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

// Writes block of data to the display
static int write_block(int file, __u16 *data) {
	int res;
#ifdef BICOLOR
	res = i2c_smbus_write_i2c_block_data(file, 0x00, 16, 
		(__u8 *)data);
	return res;
#else
/*
 * For some reason the single color display is rotated one column, 
 * so pre-unrotate the data.
 */
	int i;
	__u16 block[I2C_SMBUS_BLOCK_MAX];
//	printf("rotating\n");
	for(i=0; i<8; i++) {
		block[i] = (data[i]&0xfe) >> 1 | 
			   (data[i]&0x01) << 7;
	}
	res = i2c_smbus_write_i2c_block_data(file, 0x00, 16, 
		(__u8 *)block);
	return res;
#endif
}

int main(int argc, char *argv[])
{
	int res, i2cbus, address, file;
	char filename[20];
	int force = 0;

	i2cbus = lookup_i2c_bus("1");
	printf("i2cbus = %d\n", i2cbus);
	if (i2cbus < 0)
		help();

	address = parse_i2c_address("0x68");
	printf("address = 0x%2x\n", address);
	if (address < 0)
		help();

	file = open_i2c_dev(i2cbus, filename, sizeof(filename), 0);
//	printf("file = %d\n", file);
	if (file < 0
	 || check_funcs(file)
	 || set_slave_addr(file, address, force))
		exit(1);
    
      // default at power-up:
      //    Gyro at 250 degrees second
      //    Acceleration at 2g
      //    Clock source at internal 8MHz
      //    The device is in sleep mode.
      //
//    error = MPU6050_read (MPU6050_WHO_AM_I, &c, 1);
    res = i2c_smbus_read_byte_data(file, MPU6050_WHO_AM_I);
    printf("MPU6050_WHO_AM_I = %d (0x%x)\n", res, res);

     // Clear the 'sleep' bit to start the sensor.
    res = i2c_smbus_read_byte_data(file, MPU6050_PWR_MGMT_1);
    printf("MPU6050_PWR_MGMT_1 = %d (0x%x)\n", res, res);
	i2c_smbus_write_byte_data(file, MPU6050_PWR_MGMT_1, 0);
    res = i2c_smbus_read_byte_data(file, MPU6050_PWR_MGMT_1);
    printf("MPU6050_PWR_MGMT_1= %d (0x%x)\n", res, res);
    exit(1);
// Fade the display
	int daddress;
	for(daddress = 0xef; daddress >= 0xe0; daddress--) {
//	    printf("writing: 0x%02x\n", daddress);
	    res = i2c_smbus_write_byte(file, daddress);
	    usleep(100000);	// Sleep 0.1 seconds
	}

	if (res < 0) {
		fprintf(stderr, "Error: Write failed\n");
		close(file);
		exit(1);
	}
	exit(0);
}
