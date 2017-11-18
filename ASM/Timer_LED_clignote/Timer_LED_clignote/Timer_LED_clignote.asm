/*
 * Timer_LED_clignote.asm
 *
 *  Created: 25-02-16 16:18:14
 *   Author: laurent
 */ 

 .def tmp = r17
.def cmp = r18

.org 0  rjmp start
.org 0x00E  rjmp switch_led

start:
	sbi DDRB, 0
	cbi PORTB, 0

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp
	sei ;Enable interrupts


	ldi tmp, 0b00000010
	out TCCR0A, tmp
	ldi tmp, 0b00000101
	out TCCR0B,tmp
	ldi tmp, 0b00000010
	sts TIMSK0, tmp
	ldi tmp, 255
	out OCR0A, tmp
	rjmp timer

timer:
	rjmp timer


switch_led:
		sbi PINB,0
		reti 

