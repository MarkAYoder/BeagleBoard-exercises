// This code reads the USER pushbotton from the DSP
// Taken from http://e2e.ti.com/support/embedded/bios/f/355/t/62947.aspx

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <c6x.h>
 
#define GPIO004_PADCONF                 (*((volatile unsigned short *)(0x48002a0c)))
#define GPIO1_OE                        (*((volatile unsigned int   *)(0x48310034)))
#define IRQENABLE2_GPIO1                (*((volatile unsigned int   *)(0x4831002c)))
#define IRQSTATUS2_GPIO1                (*((volatile unsigned int   *)(0x48310028)))
#define IRQRISINGEDGE_GPIO1             (*((volatile unsigned int   *)(0x48310048)))
#define GPIO1_CTRL                      (*((volatile unsigned int   *)(0x48310030)))
#define GPIO1_DEBOUNCE_TIME             (*((volatile unsigned int   *)(0x48310054))) //(Debounce[0-255] time +1) * 31uS
#define GPIO1_DEBOUNCE_ENABLE           (*((volatile unsigned int   *)(0x48310054)))
 
//C6RUN Uses the following ints: IER:0x4033
void userRBInt();
volatile int irq;
 
void userRBInt() {
    IER &= ~(0x40);		//Enable DSP IRQ 4
    IRQSTATUS2_GPIO1 = 0x10;	//Clear IRQ status
    ICR = 0x040;		//Clear DSP IRQ4
    irq = 1;
    IER |= 0x40;		//Enable DSP IRQ 4
}

int main() {
    char option;
    int innerCount;	// count for the inner loop
    int outterCount;	// count for the outter loop

    HWI_disable();
    GPIO004_PADCONF = 4;		//Set GPIO004 to an IO.
    GPIO1_OE |= 0x10;			//Configure GPIO004 as input
    GPIO1_CTRL = 0x0;			//Enable IRQs for GPIO1 with out being gated
    IRQSTATUS2_GPIO1  = 0x10;		//Clear any existing IRQ statuses for GPIO004
    IRQENABLE2_GPIO1 |= 0x10;		//Enable GPIO004 IRQ to DSP
    IRQRISINGEDGE_GPIO1 |= 0x10;	//Configure GPIO004 for rising edge 
					//IRQ detection
    GPIO1_DEBOUNCE_TIME = 0xFF;		//Set debounce time to max (8ms)
    GPIO1_DEBOUNCE_ENABLE |= 0x10;	//Enable debounce time for GPIO004
 
    HWI_eventMap(6, 73);
//    HWI_enableWugen(73);		//Enable INT GPIO1 in WuGEN
 
    //Register userRBInt() function to DSP IRQ4.
    HWI_dispatchPlug(6,(void*)userRBInt, NULL, NULL); 
 
    HWI_enable();
    IER |= 0x0040;                        //Enable DSP IRQ 4
    irq = 0;
    option = 0;
    printf ("waiting for 5 button presses...\n");

    fflush(stdout);	// This doesn't seem to do anything.

    outterCount=0;
    while(outterCount++<100) {
	innerCount=0;
	printf("%3d: innerCount = ", outterCount);
	while ((irq == 0) && innerCount++<100) {
	    if(innerCount%10 == 0) {
		printf("%d, ", innerCount);
		fflush(stdout);
		}
	}
	printf("\n");
	if (irq) {
	    printf ("button press number %d occurred!\n", ++option);
	    irq = 0;
        }
	if (option > 4)
	    break;
	fflush(stdout);
    }
    printf("Done!\n");
    HWI_disable();
    IRQENABLE2_GPIO1 &= ~(0x10);          //Disable GPIO004 IRQ to DSP
    IER &= ~(0x40);                       //Enable DSP IRQ 4
    return 0;
}
