/*
 * MULTIPLEXAGE_7SEG_TIMER_SIMU_Common_Anode.asm
 *
 *  Created: 16-05-16 10:48:30
 *   Author: laurent
 */ 

    //**************************************************************************************************************//
   // CE PROGRAMME EST UN TEST DE MULTIPLEXAGE 7 SEGMENTS AVEC TIMER !!! AFFICHEURS 7 SEGMENTS A Anode Commune !!! //
  //**************************************************************************************************************//

.def tmp = r16
.def seg = r17

.org 0  
	rjmp start
.org 0x00E  
	rjmp compteur_ctc

.org $20

start:

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp
		

	ldi tmp,0b11111111 //Définition du PORTB comme sortie
	out DDRB,tmp
	ldi tmp,0b00011110 //Définition de PC 1 2 3 4 comme sortie
	out DDRC,tmp


	//Configuration du timer0

	ldi tmp, 0b00000010 // mise en place du timer
	out TCCR0A, tmp
	ldi tmp, 0b00000101 //prescaler de 1024
	//ldi tmp, 0b00000001
	out TCCR0B,tmp
	ldi tmp, 0b00000010
	sts TIMSK0, tmp
	ldi tmp, 10
	out OCR0A, tmp
	
	sei ;Enable interrupts
	clr seg

	rjmp delay

compteur_ctc:

	//ldi tmp,0b00000000
	//out PORTB,tmp

	cpi seg,0
	breq zero
	cpi seg,1
	breq un
	cpi seg,2
	breq deux
	cpi seg,3
	breq trois

	// Le code suivant consiste à afficher STOP sur les 4 Afficheur 7 SEGMENTS.

zero:
	//S
	ldi seg,1
	//ldi tmp,0b00000010 // Allumage du SEGEMENT MILLE
	ldi tmp,0b11111101 //Inversion de la logique car AFFICHEURS à anode commune
	out portc,tmp
	//ldi tmp,0b01101101 // Incription du S sur le 7 SEG
	ldi tmp,0b00010010 //Invsersion de la logique
	out PORTB,tmp
	reti
	
	un:
	//T
	ldi seg,2
	//ldi tmp,0b00000100 // Allumage du SEGEMENT CENT
	ldi tmp,0b11111011 //Invsersion de la logique
	out portc,tmp
	//ldi tmp,0b00000111 // Inscription du T sur le 7 SEG
	ldi tmp,0b01111000 //Invsersion de la logique
	out PORTB,tmp
	reti

	deux:
	//O
	ldi seg,3
	//ldi tmp,0b00001000 // Allumage du SEGEMENT DIX
	ldi tmp,0b11110111 //Invsersion de la logique
	out portc,tmp
	//ldi tmp,0b00111111 // Inscription du O sur le 7 SEG
	ldi tmp,0b01000000 //Invsersion de la logique
	out PORTB,tmp
	reti

	trois:
	//P
	ldi seg,0
	//ldi tmp,0b00010000 // Allumage du SEGEMENT UNITE
	ldi tmp,0b11101111 //Invsersion de la logique
	out portc,tmp
	//ldi tmp,0b01110011 // Inscription du P sur le 7 SEG
	ldi tmp,0b00001100 //Invsersion de la logique
	out PORTB,tmp
	reti
	
	delay:
	rjmp delay


