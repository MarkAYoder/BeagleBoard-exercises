#include <stdint.h>
#include <time.h>
#include "../../MMAP/mmapgpio.h"

#define DELAY 1000

#define HIGH 1
#define LOW 0

#define BIT0 0x0001
#define BIT1 0x0002
#define BIT2 0x0004
#define BIT3 0x0008
#define BIT4 0x0010
#define BIT5 0x0020
#define BIT6 0x0040
#define BIT7 0x0080
#define BIT8 0x0100
#define BIT9 0x0200
#define BITA 0x0400
#define BITB 0x0800
#define BITC 0x1000
#define BITD 0x2000
#define BITE 0x4000
#define BITF 0x8000



#define HT1632_HEAD_LENGTH 3
#define HT1632_ADDRESS_LENGTH 7

#define HT1632_WRITE_LENGTH 4
#define HT1632_COMMAND_LENGTH 9

#define HT1632_WRITE 0x5
#define HT1632_COMMAND 0x4

#define HT1632_SYS_DIS 0x00
#define HT1632_SYS_EN 0x01
#define HT1632_LED_OFF 0x02
#define HT1632_LED_ON 0x03
#define HT1632_BLINK_OFF 0x08
#define HT1632_BLINK_ON 0x09
#define HT1632_SLAVE_MODE 0x10
#define HT1632_MASTER_MODE 0x14
#define HT1632_INT_RC 0x18
#define HT1632_EXT_CLK 0x1C
#define HT1632_PWM_CONTROL 0xA0

#define HT1632_COMMON_8NMOS  0x20
#define HT1632_COMMON_16NMOS  0x24
#define HT1632_COMMON_8PMOS  0x28
#define HT1632_COMMON_16PMOS  0x2C

class HT1632 {

 public:
  HT1632(uint8_t bank, int8_t data, int8_t wr, int8_t cs, int8_t rd = -1);

  void begin(uint8_t type);
  
  void clrPixel(uint16_t i);
  void setPixel(uint16_t i);

  void blink(bool state);
  void setBrightness(uint8_t pwm);

  void clearScreen();
  void fillScreen();
  void writeScreen();
  void dumpScreen();
  
 private:
  GPIO_MMAP *gpiobank;
  int8_t WIDTH, HEIGHT;
  struct timespec ts;
  int8_t _data, _cs, _wr, _rd;
  uint8_t ledmatrix[48];     // 16 * 24 / 8
  void sendcommand(uint8_t c);
  int writedata(uint16_t d, uint8_t bits);
  void writeRAMburst(uint8_t addr, uint8_t *data, uint8_t length);
  void writeRAM(uint8_t addr, uint8_t data);
};

class HT1632LEDMatrix {
 public:
  HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, uint8_t cs1);
  HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, uint8_t cs1, uint8_t cs2);
  HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, uint8_t cs1, 
		  uint8_t cs, uint8_t cs3);
  HT1632LEDMatrix(uint8_t bank, uint8_t data, uint8_t wr, uint8_t cs1, 
		  uint8_t cs2, uint8_t cs3, uint8_t cs4);

 void begin(uint8_t type);
 void clearScreen(void);
 void fillScreen(void);
 void blink(bool b);
 void setBrightness(uint8_t brightness);
 void writeScreen();
 uint8_t width();
 uint8_t height();

  void clrPixel(uint8_t x, uint8_t y);
  void setPixel(uint8_t x, uint8_t y);
  void drawPixel(uint8_t x, uint8_t y, uint8_t color);

  void drawLine(int8_t x0, int8_t y0, int8_t x1, int8_t y1, uint8_t color);
  void drawRect(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t color);
  void fillRect(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t color);
  void drawCircle(uint8_t x0, uint8_t y0, uint8_t r, uint8_t color);
  void fillCircle(uint8_t x0, uint8_t y0, uint8_t r, uint8_t color);

  // Printing
  void setCursor(uint8_t x, uint8_t y);
  void setTextSize(uint8_t s);
  void setTextColor(uint8_t c);
  void write(uint8_t c);
  void drawChar(uint8_t x, uint8_t y, char c, uint16_t color, uint8_t size);

  void drawBitmap(uint8_t x, uint8_t y, 
		  const uint8_t *bitmap, uint8_t w, uint8_t h,
		  uint8_t color);


 private:
  HT1632 *matrices;
  uint8_t matrixNum, _width, _height;
  uint8_t cursor_x, cursor_y, textsize, textcolor;
};
