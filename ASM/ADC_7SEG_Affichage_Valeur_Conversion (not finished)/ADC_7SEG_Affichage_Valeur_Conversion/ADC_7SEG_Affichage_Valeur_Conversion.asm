/*
 * ADC_7SEG_Affichage_Valeur_Conversion.asm
 *
 *  Created: 13-05-16 11:47:59
 *   Author: laurent
 */ 

 
     //*******************************************************************************************//
	// On va travailler en mode de conversion sur 10Bits afin de pouvoir afficher les 10bits sur //
   // les 4 afficheur 7 segments et utiliser également la valeur de conversion pour le PWM pour //
  // ce faire nous allons devoir travailler en justification à droite et devoir utilise un     //
 // algorithme pour l'affichage et pour l'envoit de la valeur de conversion vers le PWM       //
//*******************************************************************************************//

.def adclow = r0
.def adchigh = r1
.def tmp = r16
.def seg = r17
.def tmp2 = r18
.def cent = r19
.def dix = r20
.def unit = r21

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

	ldi tmp,0b11111111 // Définition du PORTD en sortie (définition du PD3 commme sortie qui est utilisé comme sortie du PWM)
	out ddrd,tmp
	ldi tmp,0b00001000 // Allumage de la led sur le PD3 (utilisé comme sortie pour le PWM)
	out portd,tmp

	//Configuration de l'ADC
	ldi tmp,0b01000000 //on prend AVCC comme reference et justification à droite
	sts admux,tmp
	ldi tmp,0b10001100  //freq à 1MHz/16==>62.500kHz et activation de l'interruption de fin de conversion
	sts adcsra,tmp
	ldi tmp,0b00000000
	sts adcsrb,tmp

	//Configuration du timer
	ldi tmp, 0b00000010 //mise en place du timer
	out TCCR0A, tmp
	ldi tmp, 0b00000101 //presacaler 1024
	out TCCR0B,tmp
	ldi tmp, 1		//valeur de comparaison pour génération de l'interruption en mode CTC
	out OCR0A, tmp
	ldi tmp, 0b00000010 // activation de l'interruption sur
	sts TIMSK0, tmp

	//Configuration du PWM
	ldi tmp, 0b00100011
	sts TCCR2A, tmp
	ldi tmp, 0b00000001
	sts TCCR2B,tmp
	ldi tmp, 0b00000000
	sts TIMSK2, tmp
	ldi tmp, 1
	sts OCR2B, tmp
	
	sei ;Enable interrupts
	
	rjmp delay

Timer_CTC_Mode:

	lds tmp, ADCSRA
	ori tmp, 0b01000000
	sts ADCSRA, tmp
	//rjmp ledclignote
	reti
	
ADC_COMPLETE:

	lds adclow,adcl
	lds adchigh,adch //Attention obligation de lire ADCL avant ADCH et obligation de lire les 2
	mov tmp,adchigh
	ldi tmp2,0
	shift_left:
	lsl tmp
	inc tmp2
	cpi tmp2,6
	brne shift_left
	mov tmp2,adclow
	lsr tmp2
	lsr tmp2
	or tmp,tmp2

	sts OCR2B,tmp


reti

delay: 
rjmp delay
