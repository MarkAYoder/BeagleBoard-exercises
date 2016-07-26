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
    .asg    r30.t8,     ch0bit  ; P8_27
	.asg    r30.t10,    ch1bit	; P8_28
	.asg    r30.t9,     ch2bit	; P8_29
	.asg	r30.t11,	ch3bit	; P8_30
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
	
	LDI 	r30, 0x0				; turn off GPIO outputs

	; ldi		r9, 0x1
	; sbco	&r9, CONST_PRUSHAREDRAM, 0, 4	; Default to 1 cycle on
	; sbco	&r9, CONST_PRUSHAREDRAM, 4, 4	;   1 cycle off
	; sbco	&r9, CONST_PRUSHAREDRAM, 8, 4
	; sbco	&r9, CONST_PRUSHAREDRAM, 12, 4
	
	lbco	&r0, CONST_PRUSHAREDRAM, 0, 4	; Load on cycles
	ldi		r10, 0		; Clear off cycles
	lbco	&r1, CONST_PRUSHAREDRAM, 8, 4
	ldi		r11, 0
	lbco	&r2, CONST_PRUSHAREDRAM, 16, 4
	ldi		r12, 0
	lbco	&r3, CONST_PRUSHAREDRAM, 16, 4
	ldi		r13, 0

; Beginning of loop, should always take 48 instructions to complete
ch0:
	nop
	nop
	nop
ch0on:			
	qbeq	ch0off, r0, 0	; If timer is 0, jump to clear channel
	sub		r0, r0, 1		; decr "on" counter
	qbne	ch1, r0, 0
	clr		r30, ch0bit
	lbco	&r10, CONST_PRUSHAREDRAM, 4, 4	; Load off cycles
	qba		ch1on
ch0off:
	sub		r10, r10, 1		; decr "off" counter
	qbne	ch1, r10, 0
	set		r30, ch0bit
	lbco	&r0, CONST_PRUSHAREDRAM, 0, 4
	qba		ch1on
ch1:
	nop
	nop
	nop
ch1on:
	qbeq	ch1off, r1, 0	; If timer is 0, jump to clear channel
	sub		r1, r1, 1		; decr "on" counter
	qbne	ch2, r1, 0
	clr		r30, ch1bit
	lbco	&r11, CONST_PRUSHAREDRAM, 12, 4	; Load off cycles
	qba		ch2on
ch1off:
	sub		r11, r11, 1		; decr "off" counter
	qbne	ch2, r11, 0
	set		r30, ch1bit
	lbco	&r1, CONST_PRUSHAREDRAM, 8, 4
	qba		ch2on
ch2:
	nop
	nop
	nop
ch2on:
	qbeq	ch2off, r2, 0	; If timer is 0, jump to clear channel
	sub		r2, r2, 1		; decr "on" counter
	qbne	ch3, r2, 0
	clr		r30, ch2bit
	lbco	&r12, CONST_PRUSHAREDRAM, 20, 4	; Load off cycles
	qba		ch3on
ch2off:
	sub		r12, r12, 1		; decr "off" counter
	qbne	ch3, r12, 0
	set		r30, ch2bit
	lbco	&r2, CONST_PRUSHAREDRAM, 16, 4
	qba		ch3on
ch3:
	nop
	nop
	nop
ch3on:
	qbeq	ch3off, r3, 0	; If timer is 0, jump to clear channel
	sub		r3, r3, 1		; decr "on" counter
	qbne	ch0, r3, 0
	clr		r30, ch3bit
	lbco	&r13, CONST_PRUSHAREDRAM, 28, 4	; Load off cycles
	qba		ch0on
ch3off:
	sub		r13, r13, 1		; decr "off" counter
	qbne	ch0, r13, 0
	set		r30, ch3bit
	lbco	&r3, CONST_PRUSHAREDRAM, 24, 4
	qba		ch0on
