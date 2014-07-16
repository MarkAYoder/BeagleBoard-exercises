#ifndef spi_driver_h
#define spi_driver_h

#define SPI_INVALID_PARAMETER   (-1)
#define SPI_INVALID_DEVICE      (-2)
#define SPI_DEVICE_ACCESS_ERROR (-3)
#define SPI_MODE_SET_ERROR      (-4)
#define SPI_BITS_SET_ERROR      (-5)
#define SPI_SPEED_SET_ERROR     (-6)
#define SPI_WRITE_ERROR         (-7)

int SPIInit(int devno, int bpw, int speed);
int SPIWriteWord(void *data);
int SPIWriteChunk(void *data, int count);

#endif
