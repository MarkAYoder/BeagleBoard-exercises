#include <linux/types.h>
#include <unistd.h>

#define delay(x)	usleep(1000*x)

//Arduino has a small RAM (2k), so often large tables are put in Program memory (32k)
// The PROGMEM directive does this.  The Beagle has plenty of memory, so
// here I define it as NULL so arrays delared with it will appear in RAM.
//http://blog.makezine.com/2011/08/18/arduino-cookbook-excerpt-large-tables-of-data-in-program-memory/
// pgm_read_byte() is used to read things from program memory.
// Here is turn it into a memory reference.
#define PROGMEM
#define pgm_read_byte(x)	*(x)

// This is from arduino-0015/hardware/tools/avr/avr/include/avr/sfr_defs.h
// http://urbanhonking.com/ideasfordozens/2009/05/18/an_tour_of_the_arduino_interna/
#define _BV(bit) (1 << (bit))

#define ARDUINO 100

typedef __u8	uint8_t;
typedef __s8	int8_t;
typedef __u16	uint16_t;
typedef __s16	int16_t;
typedef char	boolean;
//typedef short	size_t;
