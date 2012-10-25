/*
    my2cset.c - First try at controlling Adafruit 8x8matrix.
    Mark A. Yoder, 14-Aug-2012.
    Page numbers are from the HT16K33 manual
    http://www.adafruit.com/datasheets/ht16K33v110.pdf

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

#define BICOLOR

static void help(void) __attribute__ ((noreturn));

static void help(void)
{
	fprintf(stderr, "Usage: my2cset (hardwired to bus 3, address 0x70)\n");
	exit(1);
}

static int check_funcs(int file, int size)
{
	unsigned long funcs;

	/* check adapter functionality */
	if (ioctl(file, I2C_FUNCS, &funcs) < 0) {
		fprintf(stderr, "Error: Could not get the adapter "
			"functionality matrix: %s\n", strerror(errno));
		return -1;
	}

	switch (size) {
	case I2C_SMBUS_BYTE:
		if (!(funcs & I2C_FUNC_SMBUS_WRITE_BYTE)) {
			fprintf(stderr, MISSING_FUNC_FMT, "SMBus send byte");
			return -1;
		}
		break;

	case I2C_SMBUS_BYTE_DATA:
		if (!(funcs & I2C_FUNC_SMBUS_WRITE_BYTE_DATA)) {
			fprintf(stderr, MISSING_FUNC_FMT, "SMBus write byte");
			return -1;
		}
		break;

	case I2C_SMBUS_WORD_DATA:
		if (!(funcs & I2C_FUNC_SMBUS_WRITE_WORD_DATA)) {
			fprintf(stderr, MISSING_FUNC_FMT, "SMBus write word");
			return -1;
		}
		break;

	case I2C_SMBUS_BLOCK_DATA:
		if (!(funcs & I2C_FUNC_SMBUS_WRITE_BLOCK_DATA)) {
			fprintf(stderr, MISSING_FUNC_FMT, "SMBus block write");
			return -1;
		}
		break;
	case I2C_SMBUS_I2C_BLOCK_DATA:
		if (!(funcs & I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
			fprintf(stderr, MISSING_FUNC_FMT, "I2C block write");
			return -1;
		}
		break;
	}

	return 0;
}

int main(int argc, char *argv[])
{
	int res, i2cbus, address, size, file;
	int value, daddress;
	char filename[20];
	int force = 0, readback = 1;
	__u16 block[I2C_SMBUS_BLOCK_MAX];
	int len;

	i2cbus = lookup_i2c_bus("3");
	printf("i2cbus = %d\n", i2cbus);
	if (i2cbus < 0)
		help();

	address = parse_i2c_address("0x70");
	printf("address = 0x%2x\n", address);
	if (address < 0)
		help();

	size = I2C_SMBUS_BYTE;

	daddress = 0x21;
	if (daddress < 0 || daddress > 0xff) {
		fprintf(stderr, "Error: Data address invalid!\n");
		help();
	}

	file = open_i2c_dev(i2cbus, filename, sizeof(filename), 0);
	printf("file = %d\n", file);
	if (file < 0
	 || check_funcs(file, size)
	 || set_slave_addr(file, address, force))
		exit(1);


	switch (size) {
	case I2C_SMBUS_BYTE:
		daddress = 0x21;	// Start oscillator (page 10)
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		daddress = 0x81;	// Display on, blinking off (page 11)
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		daddress = 0xe7;	// Full brightness (page 15)
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		daddress = 0x00;	// Start writing to address 0 (page 13)
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		int i;
static __u16 smile_bmp[]={0x3C, 0x42, 0x95, 0xA1, 0xA1, 0x95, 0x42, 0x3C};
static __u16 frown_bmp[]={0x3C, 0x42, 0xA5, 0x91, 0x91, 0xA5, 0x42, 0x3C};
static __u16 neutral_bmp[]={0x3c3C, 0x0042, 0x9595, 0x0091, 0x9191, 0x0095, 0x4242, 0x003C};

/*
 * For some reason the display is rotated one column, so pre-unrotate the
 * data.
 */
		for(i=0; i<8; i++) {
			block[i]   =    (smile_bmp[i]&0xfe) >>1 | 
					(smile_bmp[i]&0x01) << 7;
		}
		res = i2c_smbus_write_i2c_block_data(file, daddress, 16, 
			(__u8 *)block);

		sleep(0);

// Display a new picture
		for(i=0; i<8; i++) {
			block[i]   =    (frown_bmp[i]&0xfe) >>1 | 
					(frown_bmp[i]&0x01) << 7;
		}
		daddress = 0x00;
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		res = i2c_smbus_write_i2c_block_data(file, daddress, 16, 
			(__u8 *)block);

		sleep(0);

// Display yet another picture
		for(i=0; i<8; i++) {
#ifdef BICOLOR
			block[i]   =    neutral_bmp[i];

#else
			block[i]   =    (neutral_bmp[i]&0xfe) >>1 | 
					(neutral_bmp[i]&0x01) << 7;
#endif
		}
		daddress = 0x00;
		printf("writing: 0x%02x\n", daddress);
		res = i2c_smbus_write_byte(file, daddress);

		res = i2c_smbus_write_i2c_block_data(file, daddress, 16, 
			(__u8 *)block);

		for(daddress = 0xef; daddress >= 0xe0; daddress--) {
		    printf("writing: 0x%02x\n", daddress);
		    res = i2c_smbus_write_byte(file, daddress);

		    usleep(100000);	// Sleep 0.5 seconds
		}

		break;

	case I2C_SMBUS_WORD_DATA:
		res = i2c_smbus_write_word_data(file, daddress, value);
		break;
	case I2C_SMBUS_BLOCK_DATA:
		res = i2c_smbus_write_block_data(file, daddress, len, (const __u8 *)block);
		break;
	case I2C_SMBUS_I2C_BLOCK_DATA:
		res = i2c_smbus_write_i2c_block_data(file, daddress, len, (const __u8 *)block);
		break;
	default: /* I2C_SMBUS_BYTE_DATA */
		res = i2c_smbus_write_byte_data(file, daddress, value);
		break;
	}
	if (res < 0) {
		fprintf(stderr, "Error: Write failed\n");
		close(file);
		exit(1);
	}

	if (!readback) { /* We're done */
		close(file);
		exit(0);
	}

	switch (size) {
	case I2C_SMBUS_BYTE:
		res = i2c_smbus_read_byte(file);
		value = daddress;
		break;
	case I2C_SMBUS_WORD_DATA:
		res = i2c_smbus_read_word_data(file, daddress);
		break;
	default: /* I2C_SMBUS_BYTE_DATA */
		res = i2c_smbus_read_byte_data(file, daddress);
	}
	close(file);

	if (res < 0) {
		printf("Warning - readback failed\n");
	} else
	if (res != value) {
		printf("Warning - data mismatch - wrote "
		       "0x%0*x, read back 0x%0*x\n",
		       size == I2C_SMBUS_WORD_DATA ? 4 : 2, value,
		       size == I2C_SMBUS_WORD_DATA ? 4 : 2, res);
	} else {
		printf("Value 0x%0*x written, readback matched\n",
		       size == I2C_SMBUS_WORD_DATA ? 4 : 2, value);
	}

	exit(0);
}
