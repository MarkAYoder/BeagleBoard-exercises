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
	
; channel defines code for each pwm channel.
;   num:    channel number being defined
;   next:   next channel to branch to
channel .macro  num, next
ch:num:
	nop     ; These keep all paths the same length.  The lbco takes 3 cycles
	nop
	nop
	nop
	nop
ch:num:on:			
	qbeq	ch:num:off, r:num:, 0
	sub		r:num:, r:num:, 1
	qbne	ch:next:, r:num:, 0
	clr		r30, ch:num:bit
	lbco	&r1:num:, CONST_PRUSHAREDRAM, 8*:num:+4, 4
	qba		ch:next:on
ch:num:off:
	sub		r1:num:, r1:num:, 1
	qbne	ch:next:, r1:num:, 0
	set		r30, ch:num:bit
	lbco	&r:num:, CONST_PRUSHAREDRAM, 8*:num:, 4
	qba		ch:next:on
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
	.asg	r30.t6,		ch4bit	; P8_39
	.asg	r30.t7,		ch5bit	; P8_40
	.asg	r30.t4,		ch6bit	; P8_41
	.asg	r30.t5,		ch7bit	; P8_42

	; .asg    C4,     CONST_SYSCFG         
	.asg    C28,    CONST_PRUSHAREDRAM   
 
	; .asg	0x22000,	PRU0_CTRL
	; .asg    0x24000,    PRU1_CTRL       ; page 19
	; .asg    0x28,       CTPPR0          ; page 75
 
	.asg	0x000,	OWN_RAM
	.asg	0x020,	OTHER_RAM
	.asg    0x100,	SHARED_RAM       ; This is so prudebug can find it.

; Configure the programmable pointer register for PRU0 by setting c28_pointer[15:0]
	; LDI     r0, SHARED_RAM              ; Set C28 to point to shared RAM
	; LDI32   r1, PRU1_CTRL + CTPPR0		; Note we use beginning of shared ram unlike example which
	; SBBO    &r0, r1, 0, 4				;  page 25
	
	LDI 	r30, 0x0				; turn off GPIO outputs
	
	.eval	0, i
	.loop	8
	lbco	&r:i:, CONST_PRUSHAREDRAM, 8*i, 4	; Load on cycles
	ldi		r1:i:, 0							; Clear off cycles
	.eval i+1, i
	.endloop

; Beginning of loop, should always take 64 instructions to complete
    channel 0, 1
    channel 1, 2
    channel 2, 3
    channel 3, 4
    channel 4, 5
    channel 5, 6
    channel 6, 7
    channel 7, 0
    