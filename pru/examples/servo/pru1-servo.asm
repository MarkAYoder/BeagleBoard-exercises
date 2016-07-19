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

DELAY	.macro time
	LDI32	R0, time
	QBEQ	$E?, R0, 0
$M?:	SUB	R0, R0, 1
	QBNE	$M?, R0, 0
$E?:	
	.endm
	

	.clink
	.global start
start:
	LDI 	R30, 0xFFFF
	DELAY 	10000
	LDI		R30, 0x0000
	DELAY 	10000
	JMP	start	

	HALT


; these pin definitions are specific to SD-101C Robotics Cape
    .asg    r30.t8,     CH1BIT 
; 	.asg    r30.t10,    CH2BIT
; 	.asg    r30.t9,     CH3BIT
; 	.asg CH4BIT r30.t11
; 	.asg CH5BIT r30.t6
; 	.asg CH6BIT r30.t7
; 	.asg CH7BIT r30.t4
; 	.asg CH8BIT r30.t5

	.asg    C4,    CONST_PRUCFG         
; 	.asg CONST_PRUSHAREDRAM   C28
 
; 	.asg PRU0_CTRL            0x22000
	.asg    0x24000,    PRU1_CTRL            
 
	.asg    0x28,       CTPPR0               
 
; 	.asg OWN_RAM              0x000
; 	.asg OTHER_RAM            0x020
	.asg 0x100,     SHARED_RAM           
	
    ; LBCO	r0, CONST_PRUCFG, 4, 4		; Enable OCP master port
	CLR 	r0, r0, 4					; Clear SYSCFG[STANDBY_INIT] to enable OCP master port
 	SBCO	&r0, CONST_PRUCFG, 4, 4
	LDI     r0, 0x00000120				; Configure the programmable pointer register for PRU0 by setting c28_pointer[15:0]
	LDI     r0, SHARED_RAM              ; Set C28 to point to shared RAM
	LDI32   r1, PRU1_CTRL + CTPPR0		; Note we use beginning of shared ram unlike example which
	SBBO    &r0, r1, 0, 4				; has arbitrary 2048 offset
	LDI		r9, 0x00000000				; erase r9 to use to use later
	
	LDI 	r0, 0x00000000				; clear internal counters
	LDI 	r1, 0x00000000	
	LDI 	r2, 0x00000000
	LDI 	r3, 0x00000000
	LDI 	r4, 0x00000000
	LDI 	r5, 0x00000000
	LDI 	r6, 0x00000000
	LDI 	r7, 0x00000000
	LDI 	r30, 0x00000000				; turn off GPIO outputs