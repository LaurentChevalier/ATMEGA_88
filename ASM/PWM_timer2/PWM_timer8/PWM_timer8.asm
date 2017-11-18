/*
 * PWM_timer8.asm
 *
 *  Created: 04-05-16 15:36:56
 *   Author: laurent
 */ 
 
 // Utilisation du Fast-mode PWM

.def tmp = r17

.org 0  
	rjmp start

.org $20

start:
	
	ldi tmp,0b11111111
	out ddrd,tmp
	ldi tmp,0b00001000
	out portd,tmp

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp
	sei ;Enable interrupts

	// Configuration du PWM timer2
	ldi tmp, 0b00100011
	sts TCCR2A, tmp
	ldi tmp, 0b00000001
	sts TCCR2B,tmp
	ldi tmp, 0b00000000
	sts TIMSK2, tmp
	ldi tmp, 1
	sts OCR2B, tmp

	rjmp main

main:
	rjmp main



