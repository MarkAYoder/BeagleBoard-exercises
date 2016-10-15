; PRUSS program to flash a LED on P9_27 (pru0_pru_r30_5) until a button 
; that is connected to P9_28 (pru0_pru_r31_3 is pressed). This program 
; was writen by Derek Molloy for the book Exploring BeagleBone
; Modified by Mark A. Yoder to use clpru and remote proc

; Passed the number of cycles to delay in R14

	.clink
	.global start
start:
	lsr		r14, r14, 1		; Divide number of delay cycles by 2 since each loop takes 2 cycles
	set		r30, r30.t5     ; turn on the output pin (LED on)
	mov		r0, r14         ; store the length of the delay in REG0
delayon:
	sub		r0, r0, 1        ; Decrement REG0 by 1
	qbne	delayon, r0, 0   ; Loop to DELAYON, unless REG0=0
ledoff:
	clr		r30,	r30.t5           ; clear the output bin (LED off)
	mov		r0, r14	        ; Reset REG0 to the length of the delay
delayoff:
	sub		r0, r0, 1        ; decrement REG0 by 1
	qbne	delayoff, r0, 0  ; Loop to DELAYOFF, unless REG0=0

	qbbc	start, r31, 3    ; is the button pressed? If not, loop

END:                             ; notify the calling app that finished
	jmp		r3				; r3 contains the return address
