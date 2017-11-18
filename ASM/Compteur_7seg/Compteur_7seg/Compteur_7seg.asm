/*
 * Compteur_7seg.asm
 *
 *  Created: 12-03-16 00:04:30
 *   Author: laurent
 */ 

.def passage = r16
.def tmp = r17
.def seg = r18

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
		

	ldi tmp,0b11111111 //Définition du PORTB comme sortie
	out DDRB,tmp
	out PORTB,tmp
	ldi tmp,0b00000000 //Définition du PORTD comme entrée
	out DDRD,tmp
	ldi tmp,0b00111111
	out PORTB,tmp

	//Configuration du timer0

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
	clr seg

	rjmp delay

interrup:
	
	cpi passage,0
	breq setup
	rjmp reset

	reset:
	ldi tmp, 0b00000000 // désactivation du timer
	out TCCR0B,tmp
	ldi passage,0
	reti // retour d'interruption si désactivation
	

	setup:
	ldi tmp, 0b00000101 // activation du timer
	out TCCR0B,tmp
	ldi passage,1
	reti // retour d'interruption si activation




switch_led:
	
	cpi seg,0
	breq zero
	cpi seg,1
	breq un
	cpi seg,2
	breq deux
	cpi seg,3
	breq trois
	cpi seg,4
	breq quatre
	cpi seg,5
	breq cinq
	cpi seg,6
	breq six
	cpi seg,7
	breq sept
	cpi seg,8
	breq huit
	cpi seg,9
	breq neuf


zero:
	ldi seg,1
	ldi tmp,0b00111111
	out PORTB,tmp
	reti

un:
	ldi seg,2
	ldi tmp,0b00000110
	out PORTB,tmp
	reti

deux:
	ldi seg,3
	ldi tmp,0b01011011
	out PORTB,tmp
	reti

trois:
	ldi seg,4
	ldi tmp,0b01001111
	out PORTB,tmp
	reti

quatre:
	ldi seg,5
	ldi tmp,0b01100110
	out PORTB,tmp
	reti

cinq:
	ldi seg,6
	ldi tmp,0b01101101
	out PORTB,tmp
	reti

six:
	ldi seg,7
	ldi tmp,0b01111101
	out PORTB,tmp
	reti

sept:
	ldi seg,8
	ldi tmp,0b00000111
	out PORTB,tmp
	reti
	
huit:
	ldi seg,9
	ldi tmp,0b01111111
	out PORTB,tmp
	reti

neuf:
	ldi seg,0
	ldi tmp,0b01101111
	out PORTB,tmp
	reti




delay: 
rjmp delay


