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
start:
	LDI 	R30, 0xFFFF
	DELAY 	10000000, r11
	LDI		R30, 0x0000
	DELAY 	10000000, r11
; 	JMP	start	

; 	HALT


; these pin definitions are specific to SD-101C Robotics Cape
    .asg    r30.t8,     ch1bit  ; P8_27
	.asg    r30.t10,    CH2BIT	; P8_28
	.asg    r30.t9,     CH3BIT	; P8_29
	.asg	r30.t11,	CH4BIT	; P8_30
	.asg	r30.t6,		CH5BIT	; P8_39
	.asg	r30.t7,		CH6BIT	; P8_40
	.asg	r30.t4,		CH7BIT	; P8_41
	.asg	r30.t5,		CH8BIT	; P8_42

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
	LDI32   r1, PRU1_CTRL + CTPPR0		; Note we use beginning of shared ram unlike example which
	SBBO    &r0, r1, 0, 4				;  page 25
	
	LDI		r9, 0x0				; erase r9 to use to use later
	
	LDI 	r0, 0x0				; clear internal counters
	LDI 	r1, 0x0	
	LDI 	r2, 0x0
	LDI 	r3, 0x0
	LDI 	r4, 0x0
	LDI 	r5, 0x0
	LDI 	r6, 0x0
	LDI32 	r7, 0x0
	LDI 	r30, 0x0				; turn off GPIO outputs

	ldi		r9, 0x1
	sbco	&r9, CONST_PRUSHAREDRAM, 0, 4	; Default to 1 cycle on
	sbco	&r9, CONST_PRUSHAREDRAM, 4, 4	;   1 cycle off
	
	lbco	&r0, CONST_PRUSHAREDRAM, 0, 4	; Load on cycles
	ldi		r1, 0		; Clear off cycles

; Beginning of loop, should always take 48 instructions to complete
ch1on:			
	qbeq	ch1off, r0, 0	; If timer is 0, jump to clear channel
	sub		r0, r0, 1		; decr "on" counter
	qbne	ch2, r0, 0
	clr		r30, ch1bit
	lbco	&r1, CONST_PRUSHAREDRAM, 4, 4	; Load off cycles
	qba		ch2on
ch1off:
	sub		r1, r1, 1		; decr "off" counter
	qbne	ch2, r1, 0
	set		r30, ch1bit
	nop
	lbco	&r0, CONST_PRUSHAREDRAM, 0, 4

	qba		ch1on					; return to beginning of loop
	; no need to waste a cycle for timing here because of the QBA above
	
		
ch2:
	nop
	nop
	nop
ch2on:
	qba		ch1on