/*
 * INT_Timer_LED_clignote.asm
 *
 *  Created: 04-03-16 08:19:38
 *   Author: laurent
 */ 

.def passage = r16
.def tmp = r17


.org 0  
	rjmp start
.org 0x002
	rjmp interrup

.org 0x00E  
	rjmp switch_led
.org $20

start:

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp
		

	ldi tmp,0b00000001 //Définition du PB1 comme sortie
	out DDRB,tmp
	out PORTB,tmp
	ldi tmp,0b00000000 //Définition du PORTD comme entrée
	out DDRD,tmp
	ldi tmp,0b00000100
	out PORTD,tmp


	//Configuration du timer
	ldi tmp, 0b00000010
	out TCCR0A, tmp
	ldi tmp, 0b00000000
	out TCCR0B,tmp
	ldi tmp, 0b00000010
	sts TIMSK0, tmp
	ldi tmp, 255
	out OCR0A, tmp


	//Configuration de l'interruption
	ldi tmp,0b00001000
	sts	eicra,tmp
	ldi tmp,0b00000010
	out eimsk,tmp
	
	sei ;Enable interrupts
	

	rjmp delay

interrup:
	
	cpi passage,0
	breq setup
	rjmp reset

	reset:
	ldi tmp, 0b00000000
	out TCCR0B,tmp
	ldi passage,0
	reti // retour d'interruption si désactivation
	

	setup:
	ldi tmp, 0b00000101
	out TCCR0B,tmp
	ldi passage,1
	reti // retour d'interruption si activation




switch_led:
		sbi PINB,0
reti 


delay: 
rjmp delay