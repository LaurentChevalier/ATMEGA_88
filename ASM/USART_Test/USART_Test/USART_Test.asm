/*
 * USART_Test.asm
 *
 *  Created: 25-04-16 19:37:53
 *   Author: laurent
 */ 
 
 .def tmp = r16
 .def caract= r17

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

	rjmp delay

Timer_CTC_Mode:
	
	sts UDR0,caract
	ldi tmp,0b00000001
	out PINB,tmp
	reti

delay: 
rjmp delay

