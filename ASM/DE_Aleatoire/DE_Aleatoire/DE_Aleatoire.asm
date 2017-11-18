/*
 * DE_Aleatoire.asm
 *
 *  Created: 11-03-16 20:54:03
 *   Author: laurent
 */ 
.def passage = r16
.def tmp = r17
.def seg = r18

.org 0  
	rjmp start
.org 0x002
	rjmp interrup
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


	//Configuration du timer
	ldi tmp, 0b00000010
	out TCCR0A, tmp
	ldi tmp, 0b00000101
	out TCCR0B,tmp
	ldi tmp, 0b00000010
	//sts TIMSK0, tmp
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
	
	
	in tmp, tcnt0
	decr:
	subi tmp,9
	cpi tmp,10
	brlo affichage
	rjmp decr
	
affichage:
	mov seg,tmp

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
	
	ldi tmp,0b00111111
	out PORTB,tmp
	reti

un:
	
	ldi tmp,0b00000110
	out PORTB,tmp
	reti

deux:
	
	ldi tmp,0b01011011
	out PORTB,tmp
	reti

trois:
	
	ldi tmp,0b01001111
	out PORTB,tmp
	reti

quatre:
	
	ldi tmp,0b01100110
	out PORTB,tmp
	reti

cinq:
	
	ldi tmp,0b01101101
	out PORTB,tmp
	reti

six:
	
	ldi tmp,0b01111101
	out PORTB,tmp
	reti

sept:
	
	ldi tmp,0b00000111
	out PORTB,tmp
	reti
	
huit:
	
	ldi tmp,0b01111111
	out PORTB,tmp
	reti

neuf:
	
	ldi tmp,0b01101111
	out PORTB,tmp
	reti


delay: 
rjmp delay

