/*
 * _7_SEG_MULTIPLEX.asm
 *
 *  Created: 05-05-16 20:00:52
 *   Author: laurent
 */ 
    //****************************************************//
   // CE PROGRAMME EST UN TEST DE MULTIPLEXAGE 7 SEGMENTS//
  //****************************************************//

.def tmp = r16
.def seg = r17

.org 0  
	rjmp start

.org $20

start:

	ldi tmp, high(RAMEND) ;Initialisation pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp
		

	ldi tmp,0b11111111 //Définition du PORTB comme sortie
	out DDRB,tmp
	ldi tmp,0b00001111 //Définition de PC 0 1 2 3 comme sortie
	out DDRC,tmp
	

	// Le code suivant consiste à afficher STOP sur les 4 Afficheur 7 SEGMENTS.

	
	S:

	ldi tmp,0b00000001 // Allumage du SEGEMENT MILLE
	out portc,tmp
	ldi tmp,0b01101101 // Incription du S sur le 7 SEG
	out PORTB,tmp

	//Temporisation pour bel affichage du S
	ldi tmp,255
	tempo1:
	cpi tmp,0
	breq T
	rjmp decr1
	decr1:
	dec tmp
	rjmp tempo1
	
	T:
	
	ldi tmp,0b00000010 // Allumage du SEGEMENT CENT
	out portc,tmp
	ldi tmp,0b00000111 // Inscription du T sur le 7 SEG
	out PORTB,tmp
	
	//Temporisation pour bel affichage du T
	ldi tmp,255
	tempo2:
	cpi tmp,0
	breq O
	rjmp decr2
	decr2:
	dec tmp
	rjmp tempo2
	
	O:
	
	ldi tmp,0b00000100 // Allumage du SEGEMENT DIX
	out portc,tmp
	ldi tmp,0b00111111 // Inscription du O sur le 7 SEG
	out PORTB,tmp
	
	//Temporisation pour bel affichage du O
	ldi tmp,255
	tempo3:
	cpi tmp,0
	breq P
	rjmp decr3
	decr3:
	dec tmp
	rjmp tempo3
	
	P:
	
	ldi tmp,0b00001000 // Allumage du SEGEMENT UNITE
	out portc,tmp
	ldi tmp,0b01110011 // Inscription du P sur le 7 SEG
	out PORTB,tmp
	
	//Temporisation pour bel affichage du P
	ldi tmp,255
	tempo4:
	cpi tmp,0
	breq Retour
	rjmp decr4
	decr4:
	dec tmp
	rjmp tempo4
	
	Retour:
	rjmp start
	
