 /**
 * LED Etch-a-Sketch v1.0
 * Copyright (c) 2010 Chris Monaco
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *    - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *    - Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 **/
#include <avr/io.h>
#include <avr/interrupt.h>

#define SFT_PRESCAL_MAX 15
#define SPI_DDR         DDRB
#define SPI_PORT        PORTB
#define SPI_SER         PB3
#define SPI_CLK         PB5
#define SPI_LATCH       PB2
#define DIVISOR 		64
#define DIMENSION		16
#define CYCLES			32 //number of cycles after which to average ADC Readings

//ADC on pins C4(row) and C5(col)

//Prototypes
void SPI_Master_Init();
void SPI_Transmit(unsigned long data);
void spi_send(char cData);
void Timer_Init();
unsigned int Analog_Read(unsigned char pin);
void clrscr();
int CycAvg(int arr[CYCLES]);

//Variables
int counter = 0;
int rowReadings[CYCLES] = {0};
int colReadings[CYCLES] = {0};
int currentRow = 0;
unsigned int cRow = 0, cCol = 0;
int rowRead, colRead, factor;
int soft_prescaler = 0;
unsigned long drawing[8] = {0};

int main()
{
	//Set-Up
    Timer_Init();
	SPI_Master_Init();
	DDRD = 0b11111111;
	PORTD = 0;

	DDRC = 0;
	PORTC = 0x03;

	//Main Program Loop
	while(1)
	{
		if(counter < CYCLES)
		{
			rowReadings[counter] = Analog_Read(PC4);
			colReadings[counter] = Analog_Read(PC5);
			counter++;	
		}
		else
		{
			//Average all Row and Col ADC readings
			colRead = CycAvg(colReadings);
			rowRead = CycAvg(rowReadings);
			counter = 0;
			
			if(colRead / DIVISOR != cCol && colRead / DIVISOR < DIMENSION)
			{
    			cCol = colRead / DIVISOR;
			}

  			if(rowRead / DIVISOR != cRow && rowRead / DIVISOR < DIMENSION)
			{
    			if(rowRead / DIVISOR >= 8)
    			{
      				cRow = rowRead / DIVISOR - 8;
     		 		factor = 0;
   		 		}
   		 		else
    			{
    		 		cRow = rowRead / DIVISOR;
    		 		factor = 16;
    			}
			}
		
			//Previous Set Up
			//drawing[cRow] |= (1UL << (cCol + factor));
		
			//New Setup
			drawing[cRow] |= (0x80000000 >> (cCol + factor));
		}		
		
		//Clear Screen if tilt sensors are tripped.
		if(bit_is_clear(PINC,0) && bit_is_clear(PINC, 1))
		{
			clrscr();
		}
	}
	return 0;
}

void SPI_Master_Init()
{
	PORTB = 0;
	//Set MOSI, SCK, and SS to Output
	SPI_DDR = (1 << SPI_SER) | (1 << SPI_CLK) | (1 << SPI_LATCH);

	//Enable SPI, Set as Master, Set Clock to Fosc/64
	SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPR1) | (1 << CPOL) | (0 << DORD) | (1 << CPHA);
	//SPSR = (1 << SPI2X);
}

void SPI_Transmit(unsigned long data)
{
	//Set Latch Pin Low
	//DDR_SPI
	SPI_PORT &= ~(1 << SPI_LATCH);

	//Send data to SPI
	spi_send((char)((data >> 24) & 0xff));
	spi_send((char)((data >> 16) & 0xff));
	spi_send((char)((data >> 8) & 0xff));
	spi_send((char)((data >> 0) & 0xff));
	//spi_send();

	//Set Latch Pin High
	//DDR_SPI
	SPI_PORT |= (1 << SPI_LATCH);
	
}

void spi_send(char cData)
{
	SPDR = cData;

	while(!(SPSR & (1 << SPIF)));
}

void Timer_Init()
{
	//Select Timer 0 in Normal Mode
	TCCR0A = 0;

	//Set Prescalar of 8
	TCCR0B = (1 << CS01);

	//Enable Overflow interrupt
	TIMSK0 = (1 << TOIE0);

	//Enable Global Interrupt
	sei();
}

unsigned int Analog_Read(unsigned char pin)
{
	//Set Reference bits and pin select
	ADMUX = (1 << REFS0) | pin;

	//Control Reg - Enable ADC and start conversion
	ADCSRA = (1 << ADEN) | (1 << ADSC) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);

	//Wait for conversion to complete
	while(ADCSRA & (1 << ADSC));

	return (ADCL + (ADCH << 8));
}

void clrscr()
{
	for(int i = 0; i < 8; i++)
	{
		drawing[i] = 0;
	}
}

int CycAvg(int arr[CYCLES])
{
	int sum = 0;
	
	for(int i = 0; i < CYCLES; i++)
	{
		sum = sum + arr[i];
	}
	
	return (sum / CYCLES);
}




ISR(TIMER0_OVF_vect)
{
	soft_prescaler++;

	if(soft_prescaler == SFT_PRESCAL_MAX)
	{
		currentRow = (currentRow + 1) % 8;

		//Transmit Data on SPI
		SPI_Transmit(drawing[currentRow]);

		PORTD = (1 << currentRow);

		soft_prescaler = 0;
	}
}
