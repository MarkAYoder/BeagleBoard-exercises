;*
;* Copyright (C) 2016 Zubeen Tolani <ZeekHuge - zeekhuge@gmail.com>
;*
;* This file is as an example to show how to develope
;* and compile inline assembly code for PRUs
;*
;* This program is free software; you can redistribute it and/or modify
;* it under the terms of the GNU General Public License version 2 as
;* published by the Free Software Foundation.

; This is to work for both PRUs 0 and 1.  Set PRU_NUM for the one you are compiling for.
; PRU 0 has 6 outputs, PRU 1 has 12.
; The timing for PRU 0 seems a bit off.  The period is a bit short measuring
;	966us when it should be 1000.
; WARNING:  The PRUs use the same SHAREDRAM addresses for the on/off cycles.
;	The aught to be fixed some time.

;	Mark A. Yoder, 29-July-2016

	.cdecls "main_pru1.c"

DELAY	.macro time, reg
	LDI32	reg, time
	QBEQ	$E?, reg, 0
$M?:	SUB	reg, reg, 1
	QBNE	$M?, reg, 0
$E?:	
	.endm

	.asg	96,	PRU_ENABLE		;  Address in shared memory for enable

; channel defines code for each pwm channel.
;   num:    channel number being defined
;   next:   next channel to branch to
channel .macro  num, next
	.eval	2*:num:,	Ron	
	.asg	r:Ron:,		Ron		; On count register
	.eval	2*:num:+1,	Roff	
	.asg	r:Roff:,	Roff	; Off count register
ch:num:
	.if		num=0		; Add for extra nops for channel 0
	lbco	&r28, CONST_PRUSHAREDRAM, PRU_ENABLE, 4
	and		r30, r29, r28	; And with enable bits
	nop	;
	nop
	nop
	nop
	nop
	.else
	nop     ; These keep all paths the same length.  The lbco takes 3 cycles
	nop
	nop
	nop
	nop
	.endif
ch:num:on:	
	.if num=0
	.if PRU_NUM=0		; Make both PRUs the same length
	.loop 49			; Seems like this should be 48
	nop
	.endloop
	.endif
	.endif
	qbeq	ch:num:off, Ron, 0
	sub		Ron, Ron, 1
	qbne	ch:next:, Ron, 0
	clr		r29, ch:num:bit
	lbco	&Roff, CONST_PRUSHAREDRAM, 8*:num:+4, 4
	qba		ch:next:on
ch:num:off:
	sub		Roff, Roff, 1
	qbne	ch:next:, Roff, 0
	set		r29, ch:num:bit
	lbco	&Ron, CONST_PRUSHAREDRAM, 8*:num:, 4
	qba		ch:next:on
    .endm

; these pin definitions are specific to SD-101C Robotics Cape
	.if PRU_NUM = 0
    .asg    r29.t7,     ch0bit  ; P9_25		PRU_0 only has 6 outputs
	.asg    r29.t5,    	ch1bit	; P9_27
	.asg    r29.t3,    	ch2bit	; P9_28
	.asg	r29.t1,		ch3bit	; P9_29
	.asg	r29.t2,		ch4bit	; P9_30
	.asg	r29.t0,		ch5bit	; P9_31
	.endif
	.if PRU_NUM = 1
	.asg	r29.t0,		ch0bit  ; P8_45
	.asg	r29.t1,		ch1bit	; P8_46
	.asg	r29.t2,		ch2bit	; P8_43
	.asg	r29.t3,		ch3bit	; P8_44
	.asg	r29.t4,		ch4bit	; P8_41
	.asg	r29.t5,		ch5bit	; P8_42
	.asg	r29.t6,		ch6bit	; P8_39
	.asg	r29.t7,		ch7bit	; P8_40
    .asg    r29.t8,     ch8bit	; P8_27
	.asg    r29.t9,     ch9bit	; P8_29
	.asg    r29.t10,    ch10bit	; P8_28
	.asg	r29.t11,	ch11bit	; P8_30
	.endif

	; .asg    C4,     CONST_SYSCFG         
	.asg    C28,    CONST_PRUSHAREDRAM   
 
	; .asg	0x22000,	PRU0_CTRL
	; .asg    0x24000,    PRU1_CTRL       ; page 19
	; .asg    0x28,       CTPPR0          ; page 75
 
	.asg	0x000,	OWN_RAM
	.asg	0x020,	OTHER_RAM
	.asg    0x100,	SHARED_RAM       ; This is so prudebug can find it.
	
	.clink
	.global start
start:
	ldi 	r30, 0x0	; turn off GPIO outputs
	mov		r29, r30	; r29 is a shadow register for r30.  We'll update r29 for
						; each channel, them copy it to r30 to output all at the
						; same time

	; Preload all the count registers
	lbco	&r0, CONST_PRUSHAREDRAM, 0, 80	; Load on cycles
	
	.if PRU_NUM = 0
	.asg (16), PRU0_PRU1_EVT		; Tell PRU1 to start
	ldi	r31,  (PRU0_PRU1_EVT - 16) | (1 << 5)
	.else

wait:							; Wait for PRU0
	qbbc	wait, r31, 31		; HOST1_MASK
	ldi		r28, 50				; I don't know why this delay is needed to
	; nop							; keep the 2 PRUs in sync
delay:
	sub		r28, r28, 1
	qbne	delay, r28, 0
	.endif

; Beginning of loop, should always take 64 instructions to complete
    channel 0, 1
    channel 1, 2
    channel 2, 3
    channel 3, 4
    channel 4, 5
    .if PRU_NUM=0		; Only do 6 channels for PRU 0
    channel 5, 0
    .endif
    .if PRU_NUM=1
    channel 5, 6
    channel 6, 7
    channel 7, 8
    channel 8, 9
    channel 9, 10
    channel 10, 11
    channel 11, 0
    .endif
    