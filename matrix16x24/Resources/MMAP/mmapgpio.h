#define GPIO_BANK_0 0x44E07000
#define GPIO_BANK_1 0x4804C000
#define GPIO_BANK_2 0x481AC000
#define GPIO_BANK_3 0x481AE000
#define GPIO_DATAOUT 0x13C
#define GPIO_DATAIN 0x138

#include <stdint.h>

class GPIO_MMAP {

  private:
    volatile unsigned long *value;
  public:
    GPIO_MMAP(uint8_t gpioBank);
    ~GPIO_MMAP();
    uint8_t read(uint8_t gpioNum);
    void write(uint8_t gpioNum, uint8_t out);   
};

