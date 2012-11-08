#include "HT1632.h"
#include "glcdfont.c"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "../../BoneHeader/BoneHeader.h"

#define swap(a, b) { uint16_t t = a; a = b; b = t; }

uint16_t _BV(uint8_t value) {
  return (uint16_t)BIT0 << value;     
}

HT1632LEDMatrix::HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, uint8_t cs1) {
  matrices = (HT1632 *)malloc(sizeof(HT1632));

  matrices[0] = HT1632(bank, data, wr, cs1);
  matrixNum  = 1;
  _width = 24 * matrixNum;
  _height = 16;
}

HT1632LEDMatrix::HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, 
				 uint8_t cs1, uint8_t cs2) {
  matrices = (HT1632 *)malloc(2 * sizeof(HT1632));

  matrices[0] = HT1632(bank, data, wr, cs1);
  matrices[1] = HT1632(bank, data, wr, cs2);
  matrixNum  = 2;
  _width = 24 * matrixNum;
  _height = 16;
}

HT1632LEDMatrix::HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, 
				 uint8_t cs1, uint8_t cs2, uint8_t cs3) {
  matrices = (HT1632 *)malloc(3 * sizeof(HT1632));

  matrices[0] = HT1632(bank, data, wr, cs1);
  matrices[1] = HT1632(bank, data, wr, cs2);
  matrices[2] = HT1632(bank, data, wr, cs3);
  matrixNum  = 3;
  _width = 24 * matrixNum;
  _height = 16;
}

HT1632LEDMatrix::HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, 
				 uint8_t cs1, uint8_t cs2, 
				 uint8_t cs3, uint8_t cs4) {
  matrices = (HT1632 *)malloc(4 * sizeof(HT1632));

  matrices[0] = HT1632(bank, data, wr, cs1);
  matrices[1] = HT1632(bank, data, wr, cs2);
  matrices[2] = HT1632(bank, data, wr, cs3);
  matrices[3] = HT1632(bank, data, wr, cs4);
  matrixNum  = 4;
  _width = 24 * matrixNum;
  _height = 16;
}


void HT1632LEDMatrix::setPixel(uint8_t x, uint8_t y) {
  drawPixel(x, y, 1);
}
void HT1632LEDMatrix::clrPixel(uint8_t x, uint8_t y) {
  drawPixel(x, y, 0);
}

void HT1632LEDMatrix::drawPixel(uint8_t x, uint8_t y, uint8_t color) {
  if (y >= _height) return;
  if (x >= _width) return;

  uint8_t m;
  // figure out which matrix controller it is
  m = x / 24;
  x %= 24;

  uint16_t i;

  if (x < 8) {
    i = 7;
  } else if (x < 16) {
    i = 128 + 7;
  } else {
    i = 256 + 7;
  }
  i -= (x % 8);

  if (y < 8) {
    y *= 2;
  } else {
    y = (y-8) * 2 + 1;
  } 

  i += y * 8;

  if (color) 
    matrices[m].setPixel(i);
  else
    matrices[m].clrPixel(i);
}


uint8_t HT1632LEDMatrix::width() {
  return _width;
}

uint8_t HT1632LEDMatrix::height() {
  return _height;
}

void HT1632LEDMatrix::begin(uint8_t type) {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].begin(type);
  }
}

void HT1632LEDMatrix::clearScreen() {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].clearScreen();
  }
}

void HT1632LEDMatrix::fillScreen() {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].fillScreen();
  }
}

void HT1632LEDMatrix::setBrightness(uint8_t b) {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].setBrightness(b);
  }
}

void HT1632LEDMatrix::blink(bool b) {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].blink(b);
  }
}

void HT1632LEDMatrix::writeScreen() {
  for (uint8_t i=0; i<matrixNum; i++) {
    matrices[i].writeScreen();
  }
}

// bresenham's algorithm - thx wikpedia
void HT1632LEDMatrix::drawLine(int8_t x0, int8_t y0, int8_t x1, int8_t y1, 
		      uint8_t color) {
  uint16_t steep = abs(y1 - y0) > abs(x1 - x0);
  if (steep) {
    swap(x0, y0);
    swap(x1, y1);
  }

  if (x0 > x1) {
    swap(x0, x1);
    swap(y0, y1);
  }

  uint16_t dx, dy;
  dx = x1 - x0;
  dy = abs(y1 - y0);

  int16_t err = dx / 2;
  int16_t ystep;

  if (y0 < y1) {
    ystep = 1;
  } else {
    ystep = -1;}

  for (; x0<=x1; x0++) {
    if (steep) {
      drawPixel(y0, x0, color);
    } else {
      drawPixel(x0, y0, color);
    }
    err -= dy;
    if (err < 0) {
      y0 += ystep;
      err += dx;
    }
  }
}

// draw a rectangle
void HT1632LEDMatrix::drawRect(uint8_t x, uint8_t y, uint8_t w, uint8_t h, 
		      uint8_t color) {
  drawLine(x, y, x+w-1, y, color);
  drawLine(x, y+h-1, x+w-1, y+h-1, color);

  drawLine(x, y, x, y+h-1, color);
  drawLine(x+w-1, y, x+w-1, y+h-1, color);
}

// fill a rectangle
void HT1632LEDMatrix::fillRect(uint8_t x, uint8_t y, uint8_t w, uint8_t h, 
		      uint8_t color) {
  for (uint8_t i=x; i<x+w; i++) {
    for (uint8_t j=y; j<y+h; j++) {
      drawPixel(i, j, color);
    }
  }
}



// draw a circle outline
void HT1632LEDMatrix::drawCircle(uint8_t x0, uint8_t y0, uint8_t r, 
			uint8_t color) {
  int16_t f = 1 - r;
  int16_t ddF_x = 1;
  int16_t ddF_y = -2 * r;
  int16_t x = 0;
  int16_t y = r;

  drawPixel(x0, y0+r, color);
  drawPixel(x0, y0-r, color);
  drawPixel(x0+r, y0, color);
  drawPixel(x0-r, y0, color);

  while (x<y) {
    if (f >= 0) {
      y--;
      ddF_y += 2;
      f += ddF_y;
    }
    x++;
    ddF_x += 2;
    f += ddF_x;
  
    drawPixel(x0 + x, y0 + y, color);
    drawPixel(x0 - x, y0 + y, color);
    drawPixel(x0 + x, y0 - y, color);
    drawPixel(x0 - x, y0 - y, color);
    
    drawPixel(x0 + y, y0 + x, color);
    drawPixel(x0 - y, y0 + x, color);
    drawPixel(x0 + y, y0 - x, color);
    drawPixel(x0 - y, y0 - x, color);
    
  }
}


// fill a circle
void HT1632LEDMatrix::fillCircle(uint8_t x0, uint8_t y0, uint8_t r, uint8_t color) {
  int16_t f = 1 - r;
  int16_t ddF_x = 1;
  int16_t ddF_y = -2 * r;
  int16_t x = 0;
  int16_t y = r;

  drawLine(x0, y0-r, x0, y0+r+1, color);

  while (x<y) {
    if (f >= 0) {
      y--;
      ddF_y += 2;
      f += ddF_y;
    }
    x++;
    ddF_x += 2;
    f += ddF_x;
  
    drawLine(x0+x, y0-y, x0+x, y0+y+1, color);
    drawLine(x0-x, y0-y, x0-x, y0+y+1, color);
    drawLine(x0+y, y0-x, x0+y, y0+x+1, color);
    drawLine(x0-y, y0-x, x0-y, y0+x+1, color);
  }
}

void HT1632LEDMatrix::setCursor(uint8_t x, uint8_t y) {
  cursor_x = x; 
  cursor_y = y;
}

void HT1632LEDMatrix::setTextSize(uint8_t s) {
  textsize = s;
}

void HT1632LEDMatrix::setTextColor(uint8_t c) {
  textcolor = c;
}

void HT1632LEDMatrix::write(uint8_t c) {
  if (c == '\n') {
    cursor_y += textsize*8;
    cursor_x = 0;
  } else if (c == '\r') {
    // skip em
  } else {
    drawChar(cursor_x, cursor_y, c, textcolor, textsize);
    cursor_x += textsize*6;
  }
}

// draw a character
void HT1632LEDMatrix::drawChar(uint8_t x, uint8_t y, char c, 
			      uint16_t color, uint8_t size) {
  for (uint8_t i =0; i<5; i++ ) {
    uint8_t line = font[(c*5)+i];
    for (uint8_t j = 0; j<8; j++) {
      if (line & 0x1) {
	if (size == 1) // default size
	  drawPixel(x+i, y+j, color);
	else {  // big size
	  fillRect(x+i*size, y+j*size, size, size, color);
	} 
      }
      line >>= 1;
    }
  }
}

void HT1632LEDMatrix::drawBitmap(uint8_t x, uint8_t y, 
			const uint8_t *bitmap, uint8_t w, uint8_t h,
			uint8_t color) {
  for (uint8_t j=0; j<h; j++) {
    for (uint8_t i=0; i<w; i++ ) {
      if (bitmap[i/8 + j*(w/8)] & _BV(i%8)) {
	drawPixel(x+i, y+j, color);
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////


HT1632::HT1632(uint8_t bank, int8_t data, int8_t wr, int8_t cs, int8_t rd) {
  _data = data;
  _wr = wr;
  _cs = cs;
  _rd = rd;

  export_gpio(bank * 32 + _data);
  set_gpio_direction(bank * 32 + _data, "out");
  export_gpio(bank * 32 + _wr);
  set_gpio_direction(bank * 32 + _wr, "out");
  export_gpio(bank * 32 + _cs);
  set_gpio_direction(bank * 32 + _cs, "out");
  export_gpio(bank * 32 + _rd);
  set_gpio_direction(bank * 32 + _rd, "out");
  
  gpiobank = new GPIO_MMAP(bank);

  if (_cs > 0) {
    gpiobank->write(_cs, 1);
  }
  if (_wr > 0) {
    gpiobank->write(_wr, 1);
  }
  if (_data > 0) {
    gpiobank->write(_data, 1);
  }
  if (_rd > 0) {  
    gpiobank->write(_rd, 1);
  }
  
  for (uint8_t i=0; i<48; i++) {
    ledmatrix[i] = 0;
  }
  
  ts.tv_sec = 0;
  ts.tv_nsec = DELAY;
}

void HT1632::begin(uint8_t type) {
  sendcommand(HT1632_SYS_EN);
  sendcommand(HT1632_LED_ON);
  sendcommand(HT1632_BLINK_OFF);
  sendcommand(HT1632_MASTER_MODE);
  sendcommand(HT1632_INT_RC);
  sendcommand(type);
  sendcommand(HT1632_PWM_CONTROL | 0xF);
  
  WIDTH = 24;
  HEIGHT = 16;
}

void HT1632::setBrightness(uint8_t pwm) {
  if (pwm > 15) pwm = 15;
  sendcommand(HT1632_PWM_CONTROL | pwm);
}

void HT1632::blink(bool blinky) {
  if (blinky) 
    sendcommand(HT1632_BLINK_ON);
  else
    sendcommand(HT1632_BLINK_OFF);
}

void HT1632::setPixel(uint16_t i) {
  ledmatrix[i/8] |= _BV(i%8); 
}

void HT1632::clrPixel(uint16_t i) {
  ledmatrix[i/8] &= ~_BV(i%8); 
}

void HT1632::dumpScreen() {
  printf("---------------------------------------\n\n");

  for (uint16_t i=0; i<(WIDTH*HEIGHT/8); i++) {
    printf("0x%X ",ledmatrix[i]);
    if (i % 3 == 2) printf("\n");
  }

  printf("\n---------------------------------------\n");
}

void HT1632::writeScreen() {
  writeRAMburst(0, ledmatrix, (WIDTH*HEIGHT/8));
}

void HT1632::clearScreen() {
  for (uint8_t i=0; i<(WIDTH*HEIGHT/8); i++) {
    ledmatrix[i] = 0;
  }
  writeScreen();
}

int HT1632::writedata(uint16_t d, uint8_t bits) {
  uint16_t mask;
  switch (bits) {
    case 0: return 0;
    case 1:
      mask = BIT0;
      break;
    case 2:
      mask = BIT1;
      break;
    case 3:
      mask = BIT2;
      break;
    case 4:
      mask = BIT3;
      break;
    case 5:
      mask = BIT4;
      break;
    case 6:
      mask = BIT5;
      break;
    case 7:
      mask = BIT6;
      break;
    case 8:
      mask = BIT7;
      break;
    case 9:
      mask = BIT8;
      break;
    case 10:
      mask = BIT9;
      break;
    case 11:
      mask = BITA;
      break;
    case 12:
      mask = BITB;
      break;
    case 13:
      mask = BITC;
      break;
    case 14:
      mask = BITD;
      break;
    case 15:
      mask = BITE;
      break;
    case 16:
      mask = BITF;
      break;
    default:
      return 1;
  }
  uint8_t i;
  for (i = 1; i < bits; i++) {
    gpiobank->write(_wr, 0);
    if (d & mask) {
      gpiobank->write(_data, 1);
    } else {
      gpiobank->write(_data, 0);
    }
    nanosleep(&ts, NULL);
    gpiobank->write(_wr, 1);
    nanosleep(&ts, NULL);
    d <<= 1;
  }
  gpiobank->write(_wr, LOW);
  if (d & mask) {
    gpiobank->write(_data, 1);
  } else {
    gpiobank->write(_data, 0);
  }
  nanosleep(&ts, NULL);
  gpiobank->write(_wr, 1);
  nanosleep(&ts, NULL);
  return 0;
}

void HT1632::writeRAMburst(uint8_t addr, uint8_t *data, uint8_t length) {
  uint8_t i;
  gpiobank->write(_cs, 0);
  writedata(HT1632_WRITE, HT1632_HEAD_LENGTH);
  writedata(addr, HT1632_ADDRESS_LENGTH);
  for (i = 0; i < length; i++) {
    //printf("Writing 0x%X to 0x%X\n", data[i], (addr+i)&0x7F);
    writedata(data[i], 2*HT1632_WRITE_LENGTH);
  }
  gpiobank->write(_cs, 1);
}

void HT1632::writeRAM(uint8_t addr, uint8_t data) {
  //printf("Writing 0x%X to 0x%X\n", data&0xF, addr&0x7F);

  gpiobank->write(_cs, 0);
  writedata(HT1632_WRITE, HT1632_HEAD_LENGTH);
  writedata(addr, HT1632_ADDRESS_LENGTH);
  writedata(data, HT1632_WRITE_LENGTH);
  gpiobank->write(_cs, 1);
}


void HT1632::sendcommand(uint8_t cmd) {
  gpiobank->write(_cs, 0);
  writedata(HT1632_COMMAND, HT1632_HEAD_LENGTH);
  writedata((uint16_t)cmd << 1, HT1632_COMMAND_LENGTH);
  gpiobank->write(_cs, 1);
}


void HT1632::fillScreen() {
  for (uint8_t i=0; i<(WIDTH*HEIGHT/8); i++) {
    ledmatrix[i] = 0xFF;
  }
  writeScreen();
}
