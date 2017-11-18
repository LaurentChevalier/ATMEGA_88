/*
 * ADC_freerun.asm
 *
 *  Created: 15-04-16 12:24:38
 *   Author: laurent
 */ 

	 //*****************************************************************************************//
	// Attention puisque l'on veut travailler en mode conversion sur 8bits, il faut se placer  //
   // en mode justifier à gauche afin de travailler sur les bits de point fort et on aura	  //
  // une valeur seulement à partir de 4 (0b00000100)										 //
 //*****************************************************************************************//

.def tmp = r16
.def adclow = r17
.def adchigh =r18

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
	ldi tmp,0b00111111
	out PORTB,tmp

	//Configuration de l'ADC
	ldi tmp,0b01100000 //on prend AVCC comme reference et justification à gauche
	sts admux,tmp
	ldi tmp,0b10001100  //freq à 1MHz/16==>62.500kHz et activation de l'interruption de fin de conversion
	sts adcsra,tmp
	ldi tmp,0b00000000
	sts adcsrb,tmp

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
	
	rjmp delay

Timer_CTC_Mode:

	lds tmp, ADCSRA
	ori tmp, 0b01000000
	sts ADCSRA, tmp
	reti
	
ADC_COMPLETE:

	lds adclow,adcl
	lds adchigh,adch //Attention obligation de lire ADCL avant ADCH et obligation de lire les 2

	out PORTB,adchigh

reti

delay: 
rjmp delay


