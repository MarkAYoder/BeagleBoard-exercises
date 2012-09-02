/*************************************************** 
  This is a library for our I2C LED Backpacks

  Designed specifically to work with the Adafruit LED Matrix backpacks 
  ----> http://www.adafruit.com/products/
  ----> http://www.adafruit.com/products/

  These displays use I2C to communicate, 2 pins are required to 
  interface. There are multiple selectable I2C addresses. For backpacks
  with 2 Address Select pins: 0x70, 0x71, 0x72 or 0x73. For backpacks
  with 3 Address Select pins: 0x70 thru 0x77

  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/

//#include <Wire.h>
#include "hack.h"
#include "Adafruit_LEDBackpack.h"
#include "Adafruit_GFX.h"

#include "i2c-dev.h"
#include "i2cbusses.h"

static const uint8_t numbertable[] = { 
	0x3F, /* 0 */
	0x06, /* 1 */
	0x5B, /* 2 */
	0x4F, /* 3 */
	0x66, /* 4 */
	0x6D, /* 5 */
	0x7D, /* 6 */
	0x07, /* 7 */
	0x7F, /* 8 */
	0x6F, /* 9 */
	0x77, /* a */
	0x7C, /* b */
	0x39, /* C */
	0x5E, /* d */
	0x79, /* E */
	0x71, /* F */
};

void Adafruit_LEDBackpack::setBrightness(uint8_t b) {
  if (b > 15) b = 15;
//  Wire.beginTransmission(i2c_addr);
//  Wire.write(0xE0 | b);
//  Wire.endTransmission();
    printf("writing: 0x%02x\n", 0xE0 | b);
    res = i2c_smbus_write_byte(i2c_addr, 0xE0 | b);
    if (res < 0) {
	fprintf(stderr, "Error: Adafruit_LEDBackpack::setBrightness, Write failed\n");
	close(i2c_addr);
	exit(1);
    }
}

void Adafruit_LEDBackpack::blinkRate(uint8_t b) {
  if (b > 3) b = 0; // turn off if not sure
//  Wire.beginTransmission(i2c_addr);  
//  Wire.write(HT16K33_BLINK_CMD | HT16K33_BLINK_DISPLAYON | (b << 1)); 
//  Wire.endTransmission();
    printf("writing: 0x%02x\n", HT16K33_BLINK_CMD | 
		HT16K33_BLINK_DISPLAYON | (b << 1));
    res = i2c_smbus_write_byte(i2c_addr, HT16K33_BLINK_CMD | 
		HT16K33_BLINK_DISPLAYON | (b << 1));
    if (res < 0) {
	fprintf(stderr, "Error: Adafruit_LEDBackpack::blinkRate, Write failed\n");
	close(i2c_addr);
	exit(1);
    }
}

Adafruit_LEDBackpack::Adafruit_LEDBackpack(void) {
}

void Adafruit_LEDBackpack::begin(uint8_t _addr = 0x70) {
//  i2c_addr = _addr;

//  Wire.begin();
    i2cbus = lookup_i2c_bus("3");
    printf("i2cbus = %d\n", i2cbus);

//	address = parse_i2c_address("0x70");
    printf("_addr = 0x%2x\n", _addr);

    size = I2C_SMBUS_BYTE;

    i2c_addr = open_i2c_dev(i2cbus, filename, sizeof(filename), 0);
    printf("file = %d\n", file);
    if (file < 0
//     || check_funcs(file, size)
     || set_slave_addr(i2c_addr, _addr, 0)) // 0 == don't force
    	exit(1);

//  Wire.beginTransmission(i2c_addr);
//  Wire.write(0x21);  // turn on oscillator
//  Wire.endTransmission();
    printf("writing: 0x%02x\n", 0x21);
    res = i2c_smbus_write_byte(i2c_addr, 0x21);
    if (res < 0) {
	fprintf(stderr, "Error: Adafruit_LEDBackpack::blinkRate, Write failed\n");
	close(i2c_addr);
	exit(1);
    }

  blinkRate(HT16K33_BLINK_OFF);
  
  setBrightness(15); // max brightness
}

void Adafruit_LEDBackpack::writeDisplay(void) {
//  Wire.beginTransmission(i2c_addr);
//  Wire.write((uint8_t)0x00); // start at address $00
    printf("writing: 0x%02x\n", 0x00);
    res = i2c_smbus_write_byte(i2c_addr, 0x00);
    if (res < 0) {
	fprintf(stderr, "Error: Adafruit_LEDBackpack::writeDisplay, Write failed\n");
	close(i2c_addr);
	exit(1);
    }
//  for (uint8_t i=0; i<8; i++) {
//    Wire.write(displaybuffer[i] & 0xFF);    
//    Wire.write(displaybuffer[i] >> 8);    
//  }
//  Wire.endTransmission();  
    res = i2c_smbus_write_i2c_block_data(i2c_addr, 0x00, 16, (__u8 *) displaybuffer);
}

void Adafruit_LEDBackpack::clear(void) {
  for (uint8_t i=0; i<8; i++) {
    displaybuffer[i] = 0;
  }
}

Adafruit_8x8matrix::Adafruit_8x8matrix(void) {
  constructor(8, 8);
}

void Adafruit_8x8matrix::drawPixel(int16_t x, int16_t y, uint16_t color) {
  if ((y < 0) || (y >= 8)) return;
  if ((x < 0) || (x >= 8)) return;

 // check rotation, move pixel around if necessary
  switch (getRotation()) {
  case 1:
    swap(x, y);
    x = 8 - x - 1;
    break;
  case 2:
    x = 8 - x - 1;
    y = 8 - y - 1;
    break;
  case 3:
    swap(x, y);
    y = 8 - y - 1;
    break;
  }

  // wrap around the x
  x += 7;
  x %= 8;


  if (color) {
    displaybuffer[y] |= 1 << x;
  } else {
    displaybuffer[y] &= ~(1 << x);
  }
}

// From http://zedcode.blogspot.com/2007/02/gcc-c-link-problems-on-small-embedded.html
extern "C" void __cxa_pure_virtual(void)
{
// call to a pure virtual function happened ... wow, should never happen ... stop
while(1)
;
}
