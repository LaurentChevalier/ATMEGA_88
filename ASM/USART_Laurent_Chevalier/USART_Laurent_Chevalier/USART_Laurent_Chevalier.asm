/*
 * USART_Laurent_Chevalier.asm
 *
 *  Created: 25-04-16 21:18:18
 *   Author: laurent
 */ 

 .def tmp = r16
 .def caract = r17
 .def passage = r18

.org 0  
	rjmp start
.org 0x00E 
	rjmp Timer_CTC_Mode
.org $20

start:

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp

	ldi tmp,0b11111111 //Définition du PORTB comme sortie
	out DDRB,tmp
	ldi tmp,0b00000001
	out PORTB,tmp

	//Configuration de l'usart
	
	ldi tmp,0b00100010 //receiver is ready to receive data, double vitesse
	sts UCSR0A,tmp
	ldi tmp,0b00001000 //Activation de l'émetteur
	sts UCSR0B,tmp
	ldi tmp,0b00000110 //Mode asynchrone, pas de bit de parité, 1 bit de stop, 8 bits de données
	sts UCSR0C,tmp
	ldi tmp,0b00001100 //Baudrate = 9600bps
	sts UBRR0L,tmp
	ldi tmp,0b00000000
	sts UBRR0H,tmp


	//Configuration du timer
	ldi tmp, 0b00000010 ;mise en place du timer
	out TCCR0A, tmp
	ldi tmp, 0b00000101 ;presacaler 1024
	out TCCR0B,tmp
	ldi tmp, 255
	out OCR0A, tmp
	ldi tmp, 0b00000010
	sts TIMSK0, tmp
	
	sei ;Enable interrupts
	
	ldi caract,0b01000011
	ldi passage,0

	rjmp delay

Timer_CTC_Mode:

	ldi tmp,0b00000001
	out PINB,tmp
	
	inc passage

	cpi passage,1
	breq c
	cpi passage,2
	breq h
	cpi passage,3
	breq e
	cpi passage,4
	breq v
	cpi passage,5
	breq a
	cpi passage,6
	breq l
	cpi passage,7
	breq i
	cpi passage,8
	breq ee
	cpi passage,9
	breq r
	cpi passage,10
	breq retour
	cpi passage,11
	breq retourn

	c:
	ldi caract,0b01000011
	sts UDR0,caract
	reti
	h:
	ldi caract,0b01101000
	sts UDR0,caract
	reti
	e:
	ldi caract,0b01100101
	sts UDR0,caract
	reti
	v:
	ldi caract,0b01110110
	sts UDR0,caract
	reti
	a:
	ldi caract,0b01100001
	sts UDR0,caract
	reti
	l:
	ldi caract,0b01101100
	sts UDR0,caract
	reti
	i:
	ldi caract,0b01101001
	sts UDR0,caract
	reti
	ee:
	ldi caract,0b01100101
	sts UDR0,caract
	reti
	r:
	ldi caract,0b01110010
	sts UDR0,caract
	reti
	retour:
	ldi caract,0b00001101 // retour chariot (dec 13)
	sts UDR0,caract
	reti
	retourn:
	ldi caract,0b00001101 
	sts UDR0,caract
	ldi passage,0
	reti



delay: 
rjmp delay

