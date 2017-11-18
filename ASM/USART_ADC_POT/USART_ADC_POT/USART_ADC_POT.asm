/*
 * USART_ADC_POT.asm
 *
 *  Created: 25-04-16 23:02:21
 *   Author: laurent
 */ 

	 //*****************************************************************************************//
	// Attention puisque l'on veut travailler en mode conversion sur 8bits, il faut se placer  //
   // en mode justifier à gauche afin de travailler sur les bits de point fort et on aura	  //
  // une valeur seulement à partir de 4 (0b00000100)										 //
 //*****************************************************************************************//

.def tmp = r16
.def seg = r17
.def adclow = r18
.def adchigh = r19
.def compteur = r20
.def caract = r21

.org 0  
	rjmp start
.org 0x00E 
	rjmp Timer_CTC_Mode
.org 0x015
	rjmp ADC_COMPLETE
.org $20

start:

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp

	ldi tmp,0b11111111 //Définition du PORTB comme sortie
	out DDRB,tmp
	ldi tmp,0b11111111 //Définition du PORTD comme sortie
	out DDRD,tmp
	ldi tmp,0b00111111
	out PORTB,tmp

	//Configuration de l'ADC
	ldi tmp,0b01100000 //on prend AVCC comme reference et justification à gauche
	sts admux,tmp
	ldi tmp,0b10001100  //freq à 1MHz/16==>62.500kHz et activation de l'interruption de fin de conversion
	sts adcsra,tmp
	ldi tmp,0b00000000
	sts adcsrb,tmp

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
	clr seg

	ldi compteur,0 //initialisation valeur compteur
	
Tempo:

	cpi compteur,255
	brne Fin_tempo
	ldi compteur,0

Fin_tempo:
	rjmp delay


Timer_CTC_Mode:

	lds tmp, ADCSRA
	ori tmp, 0b01000000
	sts ADCSRA, tmp
	inc compteur

reti

ADC_COMPLETE:

	lds adclow,adcl
	lds adchigh,adch //Attention obligation de lire ADCL avant ADCH et obligation de lire les 2
	out PORTD,adchigh
	rjmp affichage
	
affichage:
	mov seg,adchigh

	ldi caract,0b00001101 //Retour à la ligne
	sts UDR0,caract

	cpi seg,28
	brlo zero
	cpi seg,56
	brlo un
	cpi seg,84
	brlo deux
	cpi seg,112
	brlo trois
	cpi seg,140
	brlo quatre
	cpi seg,168
	brlo cinq
	cpi seg,196
	brlo six
	cpi seg,224
	brlo sept
	cpi seg,255
	brlo huit
	cpi seg,255
	breq neuf

zero:
	
	ldi tmp,0b00111111
	out PORTB,tmp
	ldi caract,0b00110000 
	sts UDR0,caract
	reti

un:
	
	ldi tmp,0b00000110
	out PORTB,tmp
	ldi caract,0b00110001
	sts UDR0,caract
	reti

deux:
	
	ldi tmp,0b01011011
	out PORTB,tmp
	ldi caract,0b00110010
	sts UDR0,caract
	reti

trois:
	
	ldi tmp,0b01001111
	out PORTB,tmp
	ldi caract,0b00110011
	sts UDR0,caract
	reti

quatre:
	
	ldi tmp,0b01100110
	out PORTB,tmp
	ldi caract,0b00110100
	sts UDR0,caract
	reti

cinq:
	
	ldi tmp,0b01101101
	out PORTB,tmp
	ldi caract,0b00110101
	sts UDR0,caract
	reti

six:
	
	ldi tmp,0b01111101
	out PORTB,tmp
	ldi caract,0b00110110
	sts UDR0,caract
	reti

sept:
	
	ldi tmp,0b00000111
	out PORTB,tmp
	ldi caract,0b00110111
	sts UDR0,caract
	reti
	
huit:
	
	ldi tmp,0b01111111
	out PORTB,tmp
	ldi caract,0b00111000
	sts UDR0,caract
	reti

neuf:
	
	ldi tmp,0b01101111
	out PORTB,tmp
	ldi caract,0b00111001
	sts UDR0,caract
	reti

delay: 
rjmp delay


