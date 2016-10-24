; PRUSS program to flash a LED on P9_27 (pru0_pru_r30_5) until a button 
; that is connected to P9_28 (pru0_pru_r31_3 is pressed). This program 
; was writen by Derek Molloy for the book Exploring BeagleBone
; Modified by Mark A. Yoder to use clpru and remote proc

; Passed the number of cycles to delay in R14
; Register conventions are in "PRU Optimizing C/C++ Compiler v2.1 User's Guide"
; http://www.ti.com/lit/ug/spruhv7a/spruhv7a.pdf
; Section 6.3, Page 105

	.clink
	.global start
start:
	ldi		r1, 0x200		; This is the sum of STACK_SIZE and HEAP_SIZE in Makefile
	lbbo	&r0, r1, 0, 4   ; Load the length of the delay in r0
	set		r30, r30.t5     ; turn on the output pin (LED on)

delayon:
	sub		r0, r0, 1        ; Decrement REG0 by 1
	qbne	delayon, r0, 0   ; Loop to DELAYON, unless REG0=0

ledoff:
	clr		r30, r30.t5     ; clear the output bin (LED off)
	lbbo	&r0, r1, 4, 4   ; Load the length of the delay in r0

delayoff:
	sub		r0, r0, 1        ; decrement REG0 by 1
	qbne	delayoff, r0, 0  ; Loop to DELAYOFF, unless REG0=0

	qbbc	start, r31, 3    ; is the button pressed? If not, loop

end:
	jmp		r3				; r3 contains the return address
							; Return value is in r14
