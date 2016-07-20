;*
;* Copyright (C) 2016 Zubeen Tolani <ZeekHuge - zeekhuge@gmail.com>
;*
;* This file is as an example to show how to develope
;* and compile inline assembly code for PRUs
;*
;* This program is free software; you can redistribute it and/or modify
;* it under the terms of the GNU General Public License version 2 as
;* published by the Free Software Foundation.


	.cdecls "main_pru1.c"

DELAY	.macro time, reg
	LDI32	reg, time
	QBEQ	$E?, reg, 0
$M?:	SUB	reg, reg, 1
	QBNE	$M?, reg, 0
$E?:	
	.endm
	

	.clink
	.global start
	
	; Blink the LED so we know it's working
start:
	LDI 	R30, 0xFFFF
	DELAY 	10000000, r11
	LDI		R30, 0x0000
	DELAY 	10000000, r11


    .asg    r30.t3,     LED
    .asg    r30.t7,     CH1BIT      ; P8_40

	.asg    C4,     CONST_SYSCFG         
	.asg    C28,    CONST_PRUSHAREDRAM   
 
	.asg	0x22000,	PRU0_CTRL
	.asg    0x24000,    PRU1_CTRL       ; page 19
	.asg    0x28,       CTPPR0          ; page 75
 
	.asg	0x000,	OWN_RAM
	.asg	0x020,	OTHER_RAM
	.asg    0x100,	SHARED_RAM       ; This is so prudebug can find it.
	
; Configure the programmable pointer register for PRU0 by setting c28_pointer[15:0]
	LDI     r0, SHARED_RAM              ; Set C28 to point to shared RAM
	LDI32   r1, PRU1_CTRL + CTPPR0		; Note we use beginning of shared ram, page 25
	SBBO    &r0, r1, 0, 4
	
	ldi32   r11, 0xdeadbeef				; Use the C28 constant to copy to SHARED_RAM
    sbco	&r11, CONST_PRUSHAREDRAM, 0, 4	
	
	LDI 	r0, 0x00000000				; Set in easy to find values
	LDI 	r1, 0x00000001	
	LDI 	r2, 0x00000002
	LDI 	r3, 0x00000003
	LDI 	r4, 0x00000004
	LDI 	r5, 0x00000005
	LDI 	r6, 0x00000006
	LDI 	r7, 0x00000007
	
	LDI		r9, 0x00000000				; erase r9 to use to use later
	LDI 	r30, 0x00000000				; turn off GPIO outputs
	
	LDI     r10, OWN_RAM
	sbbo    &r0, r10, 0, 32		; Copy 8 registers

    halt
