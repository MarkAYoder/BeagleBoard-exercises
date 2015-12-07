#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <inttypes.h>
#include "spi-driver.h"
#include "cfaf128128b-0145t.h"
#include "boris-image.h"

#define pabort(s) {perror(s); abort();}

typedef struct _6bit { int val:6;} uint6_t;

typedef struct _bitDStruct {
	unsigned int b0:1;
	unsigned int b1:1;
	unsigned int b2:1;
	unsigned int b3:1;
	unsigned int b4:1;
	unsigned int b5:1;
	unsigned int b6:1;
	unsigned int b7:1;
} bitDStruct;

typedef struct _pixel { int val:12;} uint12_t;

typedef struct _Transfer {
	uint8_t data;
	uint8_t type:1;
	uint8_t pad:7;
} Transfer;

static int initResetPin(){
	int ret = 0;
	FILE* ex = fopen("/sys/class/gpio/export","w");
	fprintf(ex,"49");
	fclose(ex);
	
	if(errno!=0)
		errno=0;
		
	FILE* pindir = fopen("/sys/class/gpio/gpio49/direction","w");
	fprintf(pindir,"out");
	fclose(pindir);
	
	FILE* pinval = fopen("/sys/class/gpio/gpio49/value","w");
	fprintf(pinval,"0");
	fclose(pinval);
	
	return ret;
}

static void resetClear(){
	FILE* pin = fopen("/sys/class/gpio/gpio49/value","w");
	fprintf(pin,"0");
	fclose(pin);
}

static void resetSet(){
	FILE* pin = fopen("/sys/class/gpio/gpio49/value","w");
	fprintf(pin,"1");
	fclose(pin);
}

int LCDSendCommand(int len, ...){
	if(len < 1)
		return 0;

	va_list ap;

	va_start(ap, len);
	
	Transfer *transfer_buffer = (Transfer *)malloc(sizeof(Transfer)*len);
	int ret = 0;
	int repack = 0;
		
	for(repack=0;repack<len;repack++){
		int data = va_arg(ap, int);
		transfer_buffer[repack].data = (uint8_t)data;
		if(repack==0){
			transfer_buffer[repack].type=0;
		}else{
			transfer_buffer[repack].type=1;
		}
	}

	ret = SPIWriteChunk(transfer_buffer, len*sizeof(Transfer));
	
	va_end(ap);

	free(transfer_buffer);

	return ret;
}

void init_tft(int deviceNum) {
	int ret=0;
	int SPISpeed = 15000000;
	ret = initResetPin();

	if(ret == -1){
		pabort("Unable to initialize reset PIN");
	}
	
	ret = SPIInit(deviceNum, 9, SPISpeed);
	if(ret < 0){
		pabort("Unable to initialize SPI");
	}

	//***************************RESET LCD Driver*******************************
	// SET RST Pin high
	resetSet();
	usleep(1000);

	// SET RST Pin low
	resetClear();
	usleep(20000);

	// SET RST Pin high
	resetSet();
	usleep(120000);

	LCDSendCommand(1, 0x11); // Sleep out and charge pump on
	usleep(120000);

	LCDSendCommand(4, 0xB1, 0x02, 0x25, 0x36); //SETPWCTR

	LCDSendCommand(4, 0xB2, 0x02, 0x35, 0x36); //SETDISPLAY	

	LCDSendCommand(7, 0xB3, 0x02, 0x35, 0x36, 0x02, 0x35, 0x36); //Doesn't exist

	LCDSendCommand(2, 0xB4, 0x07); //SETCYC

	LCDSendCommand(4, 0xC0, 0xA2, 0x02, 0x04); //SETSTBA

	LCDSendCommand(2, 0xC1, 0xC5); //Doesn't exist

	LCDSendCommand(3, 0xC2, 0x0D, 0x00); //Doesn't exist

	LCDSendCommand(3, 0xC3, 0x8D, 0x1A); //SETID

	LCDSendCommand(3, 0xC4, 0x8D, 0xEE); //Doesn't exist

	LCDSendCommand(2, 0xC5, 0x09); //Doesn't exist

	LCDSendCommand(17, 0xE0, 0x0A, 0x1C, 0x0C, 0x14, 0x33, 0x2B, 0x24, 0x28, 0x27, 0x25, 0x2C, 0x39, 0x00, 0x05, 0x03, 0x0D);

	LCDSendCommand(17, 0xE1, 0x0A, 0x1C, 0x0C, 0x14, 0x33, 0x2B, 0x24, 0x28, 0x27, 0x25, 0x2C, 0x39, 0x00, 0x05, 0x03, 0x0D);

	LCDSendCommand(2, 0x3A, 0x06); // set for 3-wire 18-bits per pixel, p115

	LCDSendCommand(1, 0x29);		// Display On, p99
	usleep(150);

}

void setOrientation(int orientation) {
	switch(orientation) {
		case 0:
			LCDSendCommand(5, 0x2A, 0x00, 0x02, 0x00, 0x81);
			LCDSendCommand(5, 0x2B, 0x00, 0x01, 0x00, 0x80);
			LCDSendCommand(2, 0x36, 0x40);
			break;
		case 1:
		       	LCDSendCommand(5, 0x2A, 0x00, 0x03, 0x00, 0x82);
			LCDSendCommand(5, 0x2B, 0x00, 0x02, 0x00, 0x81);	
			LCDSendCommand(2, 0x36, 0xE0);
			break;
		case 2:
			LCDSendCommand(5, 0x2A, 0x00, 0x02, 0x00, 0x81);
			LCDSendCommand(5, 0x2B, 0x00, 0x03, 0x00, 0x82);
			LCDSendCommand(2, 0x36, 0x80);
			break;
		case 3: 
			LCDSendCommand(5, 0x2A, 0x00, 0x01, 0x00, 0x80);
			LCDSendCommand(5, 0x2B, 0x00, 0x02, 0x00, 0x81);
			LCDSendCommand(2, 0x36, 0x20);
			break;
	}
}

void fillScreenRandom(){
	int i = 0;
	char inbyte;
	Transfer tbuffer[491512];
	FILE *random = fopen("/dev/urandom", "r");

	LCDSendCommand(1, 0x2C);

	for(i=0;i<49152;i++){
		fread(&inbyte, 1, 1, random);
		tbuffer[i].data = inbyte;
		tbuffer[i].type = 1;	
	}

	void *buff_ptr = tbuffer;
	for(i=0;i<128;i++){
		SPIWriteChunk(buff_ptr, 768);
		buff_ptr += 768;
	}

	fclose(random);
}

void displayimage(){
	char pixel[5], *data = header_data;
	int i = width * height;
	Transfer tbuffer[128*128*3+1];
	void *buff_ptr = tbuffer;
	
		LCDSendCommand(1, 0x2C);
		int j = 0;
	    while(i-- > 0) {
			HEADER_PIXEL(data,pixel);
		
			tbuffer[j+0].data=(pixel[2] & 0xff);
			tbuffer[j+0].type=1;
		
			tbuffer[j+1].data=(pixel[1] & 0xff);
			tbuffer[j+1].type=1;
		
			tbuffer[j+2].data=(pixel[0] & 0xff);
			tbuffer[j+2].type=1;
			j +=3;
		    }
		// SPIWriteChunk(buff_ptr, 128*128*3);
		for(i=0;i<128;i++){
	        SPIWriteChunk(buff_ptr, 768);
	        buff_ptr += 768;
		}
}

void fillScreenBars(){
    int i = 0;
    Transfer tbuffer[49152];

    LCDSendCommand(1, 0x2C);

    for(i=0;i<49152;i++){
        if(((i%3) == 0 && (i%384)>=256) ||
           ((i%3) == 1 && (i%384)>=128 && (i%384)<256) || 
           ((i%3) == 2 && (i%384)<128)){
            tbuffer[i].data = 0xFF;
            tbuffer[i].type = 1;
        }else{
            tbuffer[i].data = 0x00;
            tbuffer[i].type = 1;
        }
    }

    void *buff_ptr = tbuffer;
    for(i=0;i<128;i++){
        SPIWriteChunk(buff_ptr, 768);
        buff_ptr += 768;
    }
}

int main(void){
	init_tft(0);
	setOrientation(0);
	fillScreenBars();
	sleep(1);
	for(int i=0; i<4; i++) {
		setOrientation(i);
		displayimage();
		usleep(500000);
	}
	setOrientation(0);
	displayimage();
	return 0;
}
