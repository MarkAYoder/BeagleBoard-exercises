#include <linux/types.h>
#include <unistd.h>

#define delay(x)	usleep(1000*x)

#define ARDUINO 100

typedef __u8	uint8_t;
typedef __s8	int8_t;
typedef __u16	uint16_t;
typedef __s16	int16_t;
typedef char	boolean;
//typedef short	size_t;
