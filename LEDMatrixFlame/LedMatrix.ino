#include <avr/wdt.h>
#include <avr/io.h>

#include "Arduino.h"

/* 
  This code is aimed at ATMEGA/ATTINY MCUs connected to led matrixes. 
  It allows for controlling them directly doing manual PWM for all pixels using Timer1. 
  General description ofhow it workS:
  
  1. Color depth: 
		We save the whole frame for each bit of color depth. This frame is later shown for an amount of time 
		coresponding to the significance of that bit. meaning: The frame for the least significant bit will be shown for 
		1us, the second least significant bit will be shown for 2us, the next 4us and so on. 
  
  2. Interlacing: 
		We scan the matrix from left to right (to achieve a higher frame rate of 5*8 matrices).
		for each column we save in the frame buffer the state of all of the bits, including the column bit (on is HIGH, for 
		each frame only one of the column bits should be high) and the row bits (on is LOW, set according to frame)

  3. Buffering:
		We have 3 frame buffers: the DIAPLYED buffer, which is the frame currently shown by the interrupt code.
		The READY buffer - which is a buffer that was declared "ready for display" by the user. this is the next frame to be displayed.
		the EDIT buffer - the buffer on which the user draws at the moment. 

  4. Drawing:
		We expose 3 functions:
		* Clear Frame - Delete all of the frame data
		* SetPixel - Sets the brightness of a single pixel
		* FrameReady - When done drawing a frame you should call this method. it does NOT clear the edit buffer-
						You can still edit the current frame and submit only changes. 


*/


// The clock spead of the ATMEGA chip. if you use a crystal other than 16Mhz you should change this. 
#define CLK_SPEED 16000000
// The prescalar set for the timer. do not change unless you also chage the CS10/11/12 bits as well for Timer1.
#define PRESCALAR 8
// Height of the led matrix
#define HEIGHT 8
// Width of the LED matrix
#define WIDTH 8
// How many BPP (bits per pixel )you want to use.
#define BPP 4

#define FPS 512
// from FREQ es deduce the value for the time prescalar. 
#define TIMER_PRESCALAR ((byte)(CLK_SPEED / PRESCALAR / FPS / WIDTH / (1 << BPP)))

/*
Pin mapping: 
This table describes how the led matrix is connected to the controller. 
this is designed for the easiest physical conection when building a pendant with dead bug soldering. 

ROWS (active low):
No.:			0	1	2	3	4	5	6	7
Matrix Pin:		9	14	8	12	1	7	2	5		
Arduin Pin:		PB1	PC3	PB0	PC1	PD0	PD7	PD1 PD5

COLS (active high):
No.:			0	1	2	3	4	5	6	7
Matrix Pin:		13	3	4	10	6	11	15	16
Arduin Pin:		PC2	PD2	PD3	PB2	PD6	PC0	PC4	PC5

*/


// Masks to be applied to the registers for each row / column.
// Example: according to the pin mapping above column 3 is connected to PB2.
//          That means that in gColsB (for PORTB), in cell 3 we should have a 
//			bitmap with bit 2 (remember the count is zero based) enabled, 
//			or: B00000100. Same goes for columns. 
static const byte gRowsB[] = {0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
static const byte gRowsC[] = {0x00, 0x08, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00};
static const byte gRowsD[] = {0x00, 0x00, 0x00, 0x00, 0x01, 0x80, 0x02, 0x20};

static const byte gColsB[] = {0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00};
static const byte gColsC[] = {0x04, 0x00, 0x00, 0x00, 0x00, 0x01, 0x10, 0x20};
static const byte gColsD[] = {0x00, 0x04, 0x08, 0x00, 0x40, 0x00, 0x00, 0x00};


// Here we bitmasks with all of the ROW bits per register 
const byte ALL_ROWS_B = gRowsB[0] | gRowsB[1] | gRowsB[2] | gRowsB[3] | gRowsB[4] | gRowsB[5] | gRowsB[6] | gRowsB[7];
const byte ALL_ROWS_C = gRowsC[0] | gRowsC[1] | gRowsC[2] | gRowsC[3] | gRowsC[4] | gRowsC[5] | gRowsC[6] | gRowsC[7];
const byte ALL_ROWS_D = gRowsD[0] | gRowsD[1] | gRowsD[2] | gRowsD[3] | gRowsD[4] | gRowsD[5] | gRowsD[6] | gRowsD[7];

// Same for colums
const byte ALL_COLS_B = gColsB[0] | gColsB[1] | gColsB[2] | gColsB[3] | gColsB[4] | gColsB[5] | gColsB[6] | gColsB[7];
const byte ALL_COLS_C = gColsC[0] | gColsC[1] | gColsC[2] | gColsC[3] | gColsC[4] | gColsC[5] | gColsC[6] | gColsC[7];
const byte ALL_COLS_D = gColsD[0] | gColsD[1] | gColsD[2] | gColsD[3] | gColsD[4] | gColsD[5] | gColsD[6] | gColsD[7];

// A list of all of the relevant pis, so later we can do a bitmask by them. 
const byte ALL_B = ALL_ROWS_B | ALL_COLS_B;
const byte ALL_C = ALL_ROWS_C | ALL_COLS_C;
const byte ALL_D = ALL_ROWS_D | ALL_COLS_D;

// This struct describes a single column. 
// Each field contains the bits that should be set in the PORT registers
// to display the current column of the current frame. We later on make sure to change only
// the relevant bits and not all of them, to allow use of the spare pins. 
typedef struct _Element{
	byte PortBMask;
	byte PortCMask;
	byte PortDMask;
} Element;



// Stores register masks - per bit of color depth, per column. We have 3 -
// DisplayBuff is displayed at the moment. 
// ReadyBuff is the last frame the user funished drawing
// EditBuff is the currently edited frame. 
volatile Element pDisplayBuff[BPP * WIDTH];
volatile Element pEditBuff[BPP * WIDTH];
volatile Element pReadyBuff[BPP * WIDTH];


// sets the state of a single pixel.
void SetPixel(byte x, byte y, byte brightness) {
	for (byte i = 0; i < BPP; i++) {
		// Find element in the current brightness bit and column
		volatile Element* myEl = &pEditBuff[i*WIDTH + x];
		
		// turn bit off (which means HIGH)
		myEl->PortBMask |= gRowsB[y];
		myEl->PortCMask |= gRowsC[y];
		myEl->PortDMask |= gRowsD[y];

		//If curent depth bit is ON, set register bit to LOW (on);
		if (brightness & 0x01) {
			myEl->PortBMask &= ~gRowsB[y];
			myEl->PortCMask &= ~gRowsC[y];
			myEl->PortDMask &= ~gRowsD[y];
			
		}
		
		brightness >>= 1;
		
	}
}

void FrameReady() {
	// When a frame is all set, stop the time interrupts and copy over the ready buffer. 
	// It will be painted as the next frame once the current frame is done.
	cli();

	memcpy((void*)pDisplayBuff, (void*)pEditBuff, sizeof(pReadyBuff));

	sei();
}

void ClearFrame() {
	// This code clears all of the rows data, (set them to 1, as they are LOW activated)
	// It also sets the column bit to HIGH for each frame according to its place. 
	for (byte b = 0 ; b < BPP * WIDTH; b++) {
		// For port B: Set all of the rows bit to HIGH, meaing off. Also, set the column bit for the current column to ON.
		// If the column isn't connected to PORTB, then the gColsB[column] will be 0 and this has no effect. 
		pEditBuff[b].PortBMask = ALL_ROWS_B | gColsB[b % WIDTH];
		pEditBuff[b].PortCMask = ALL_ROWS_C | gColsC[b % WIDTH];
		pEditBuff[b].PortDMask = ALL_ROWS_D | gColsD[b % WIDTH];

	}
}


volatile byte colCounter = 0;
volatile byte* ptr = (volatile byte*)pDisplayBuff;

void DrawFrame() {
	PORTB = *ptr++;
	PORTC = *ptr++;
	PORTD = *ptr++;
	//PORTB = ((PORTB & ~ALL_B) | currElement->PortBMask);
	//PORTC = ((PORTC & ~ALL_C) | currElement->PortCMask);
	//PORTD = ((PORTD & ~ALL_D) | currElement->PortDMask);
	
	
	if (!(++colCounter %= BPP * WIDTH)) {
		ptr = (byte*)pDisplayBuff;
	}

}

ISR(TIMER1_COMPA_vect)
{
	//return;
	// Set the relevant bits - only bits connected to the matrix will be set
	PORTB = *(ptr++);
	PORTC = *(ptr++);
	PORTD = *(ptr++);
	//PORTB = ((PORTB & ~ALL_B) | currElement->PortBMask);
	//PORTC = ((PORTC & ~ALL_C) | currElement->PortCMask);
	//PORTD = ((PORTD & ~ALL_D) | currElement->PortDMask);
	
	
	if (!(++colCounter %= BPP * WIDTH)) {
		ptr = (byte*)pDisplayBuff;
	}

	//// To allow PWM - the time prescalar value (how long to wait before running again) is 
	//// powered according to the bit significance. it will be 24 for the least significant bit, 
	//// 48 for the second least significant bit, and so on. 
	
	OCR1A = TIMER_PRESCALAR << (colCounter / WIDTH);
    
}



void SetInitialData() {
	// Set the initial data - Clear the edit frame and set it as the other frames as well. 
	ClearFrame();
	memcpy((void*)pReadyBuff, (const void*)pEditBuff, sizeof(pEditBuff));
	memcpy((void*)pDisplayBuff, (const void*)pEditBuff, sizeof(pEditBuff));
}
void setup()
{
	// Stop interrupts so we can init stuff
	cli();

	// Disable watchdog timer
	//wdt_reset();
	//wdt_disable();


	// Set all of the matrix connected pins to OUTPUT
	DDRB |= ALL_B;
	DDRC |= ALL_C;
	DDRD |= ALL_D;

	// Initialize frame buffers
	SetInitialData();
	 // initialize Timer1
    TCCR1A = 0;     // set entire TCCR1A register to 0
    TCCR1B = 0;     // same for TCCR1B
 
    // set compare match register to desired timer count:
	OCR1A = TIMER_PRESCALAR;
    // turn on CTC mode:
    TCCR1B |= (1 << WGM12);
    // Set CS11 bits for 8 prescaler:
    TCCR1B |= (1 << CS11);
    //TCCR1B |= (1 << CS12);
    // enable timer compare interrupt:
    TIMSK1 |= (1 << OCIE1A);
    sei();          // enable global interrupts
	

}

void loop()
{
	for(int i = 0 ; i < 64; i++) {
		ClearFrame();
		SetPixel(i/8, i%8, 15);

		FrameReady();
		delay(100);
	}
	//return;

	byte scn[HEIGHT][WIDTH] = {{0,},};
	byte r, c, t;
		
	ClearFrame();
	FrameReady();
		
	while(1){
		//advance fire
		for(r = 0; r < HEIGHT - 1; r++) for(c = 0; c < WIDTH; c++){
				
			t = scn[r + 1][c] << 1;
			t += scn[r][c] >> 1;
			t += (c ? scn[r + 1][c - 1] : scn[r + 1][WIDTH - 1]) >> 1;
			t += (c == WIDTH - 1 ? scn[r + 1][0] : scn[r + 1][c + 1]) >> 1;
			t >>= 2;
			scn[r][c] = t;
			SetPixel(r, c, t);
		}
			
		//generate random seeds on the bottom
		for(c = 0; c < WIDTH; c++) {
				
			t = (rand() > 0xB0) ? rand() & 0x0F : (scn[HEIGHT - 1][c] ? scn[HEIGHT - 1][c] - 1 : 0);
				
			scn[HEIGHT - 1][c] = t;
			SetPixel(HEIGHT - 1, c, t);
		}
		FrameReady();
		delay(60);
	}


}
