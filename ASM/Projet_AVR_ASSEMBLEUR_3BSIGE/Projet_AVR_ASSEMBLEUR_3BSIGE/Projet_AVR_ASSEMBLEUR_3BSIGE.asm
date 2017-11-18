/*
 * Projet_AVR_ASSEMBLEUR_3BSIGE.asm
 *
 *  Created: 18-05-16 09:31:59
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
.def mille =r19
.def cent = r20
.def dix = r21
.def unit = r22
.def passage = r23
.def cmpt = r24

.org 0  
	rjmp start
.org 0x001
	rjmp Interrup_INT0
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
	ldi tmp,0b00011110 //Définition de PC 1 2 3 4 comme sortie
	out DDRC,tmp

	// Définition du PORTD en sortie (définition du PD3 commme sortie qui est utilisé comme sortie du PWM)
	// Sauf PD2 défini en entrée pour INT0
	//ldi tmp,0b11111011
	ldi tmp,~(1<<DDD2)
	out ddrd,tmp
	//ldi tmp,0b00001000
	ldi tmp,(1<<PD3) // Allumage de la led sur le PD3 (utilisé comme sortie pour le PWM)
	out portd,tmp

	//Configuration de l'interruption 
	ldi tmp,0b00000010 //interruption sur flanc descendant de INTO
	sts	eicra,tmp
	ldi tmp,0b00000001 //activation de l'interruption sur INT0
	out eimsk,tmp

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
	//ldi tmp, 0b00000101 //presacaler 1024
	ldi tmp,0b00000000 //désactivation du timer0 par défaut
	out TCCR0B,tmp
	ldi tmp, 1		//valeur de comparaison pour génération de l'interruption en mode CTC
	out OCR0A, tmp
	ldi tmp, 0b00000010 // activation de l'interruption sur
	sts TIMSK0, tmp

	//Configuration du PWM
	ldi tmp, 0b00100011
	sts TCCR2A, tmp
	//ldi tmp, 0b00000001
	ldi tmp,0b00000000 //Désactivation du PWM par défaut
	sts TCCR2B,tmp
	ldi tmp, 0b00000000
	sts TIMSK2, tmp
	ldi tmp, 1
	sts OCR2B, tmp
	
	// Initialisation de passage à 0
	ldi passage,0

	sei ;Enable interrupts
	
	rjmp Main
	
Interrup_INT0:

	cpi passage,0
	brne eteindre
	rjmp allumer
	
	allumer:
	ldi tmp, 0b00000101 //presacaler 1024
	out TCCR0B,tmp //activation du timer pour ADC
	ldi tmp, 0b00000001 //no prescaler
	sts TCCR2B,tmp //activation du timer 2 pour le PWM
	ldi passage,1
	reti	

	eteindre:
	ldi tmp, 0b00000000 //no clock source
	out TCCR0B,tmp //désactivation du timer pour ADC
	ldi tmp, 0b00000000 //no clock source
	sts TCCR2B,tmp //désactivation du timer 2 pour le PWM
	ldi passage,0
	reti

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
//reti
Decomposition_nombre:

	mov tmp,adclow
	//ser tmp//pour essais

	centaines:
	subi tmp,100
	brmi dizaines
	inc_centaines:
	inc cent
	rjmp centaines

	dizaines:
	ldi tmp2,100 //On rajoute 100 lorsque on fait -100 et que c'est négatif
	add tmp,tmp2
	subi tmp,10
	brmi unites
	inc_dizaines:
	inc dix
	rjmp dizaines

	unites:
	ldi tmp2,10
	add tmp,tmp2
	mov unit,tmp

	bits_poids_fort:
	mov tmp,adchigh
	
	//ldi tmp,0b00000011 pour essais
	test512:
	mov tmp2,tmp
	lsr tmp2
	cpi tmp2,0b00000001
	breq ajouter512
	rjmp test256

	ajouter512:
	ldi tmp2,0

	ajouter500:
	inc cent
	inc tmp2
	cpi tmp2,5
	brne ajouter500
	inc dix
	ldi tmp2,0

	ajouter2:
	inc unit
	inc tmp2
	cpi tmp2,2
	brne ajouter2
	rjmp test256

	test256:
	ldi tmp2,0b00000001
	and tmp2,tmp
	cpi tmp2,0b00000001
	breq ajouter256
	rjmp report

	ajouter256:
	ldi tmp2,0

	ajouter200:
	inc cent
	inc tmp2
	cpi tmp2,2
	brne ajouter200
	ldi tmp2,0

	ajouter50:
	inc dix
	inc tmp2
	cpi tmp2,5
	brne ajouter50
	ldi tmp2,0

	ajouter6:
	inc unit
	inc tmp2
	cpi tmp2,6
	brne ajouter6
	rjmp report

	report:
	cpi unit,10
	brsh report_unites
	cpi dix,10
	brsh report_dizaines
	cpi cent,10
	brsh report_centaines
	reti
	
	report_unites:
	subi unit,10
	inc dix
	cpi dix,10
	brsh report_dizaines
	cpi cent,10
	brsh report_centaines
	reti

	report_dizaines:
	subi dix,10
	inc cent
	cpi cent,10
	brsh report_centaines
	reti

	report_centaines:
	subi cent,10
	inc mille
	reti

Main: 

	cpi passage,0
	brne affichage
	
	// Le code suivant consiste à afficher STOP sur les 4 Afficheur 7 SEGMENTS.
	S:

	ldi tmp,0b11111101 // Allumage du SEGEMENT MILLE
	out portc,tmp
	ldi tmp,(1<<PB4)|(1<<PB1) // Incription du S sur le 7 SEG
	//ldi tmp,0b01101101 
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
	
	ldi tmp,0b11111011 // Allumage du SEGEMENT CENT
	out portc,tmp
	ldi tmp,(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3) // Inscription du T sur le 7 SEG
	//ldi tmp,0b00000111 
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
	
	ldi tmp,0b11110111 // Allumage du SEGEMENT DIX
	out portc,tmp
	ldi tmp,(1<<PB6) // Inscription du O sur le 7 SEG
	//ldi tmp,0b00111111 
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
	
	ldi tmp,0b11101111 // Allumage du SEGEMENT UNITE
	out portc,tmp
	ldi tmp,(1<<PB2)|(1<<PB3) // Inscription du P sur le 7 SEG
	//ldi tmp,0b01110011 
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
	rjmp Main

	affichage:
	ldi mille,1
	ldi cent,0
	ldi dix,2
	ldi unit,4

	ldi tmp2,0

	affichage7seg:
	cpi tmp2,0
	breq affiche_mille
	cpi tmp2,1
	breq affiche_cent
	cpi tmp2,2
	breq affiche_dix
	cpi tmp2,3
	breq affiche_unit

	affiche_mille:
	ldi tmp,0b11111101
	out portc,tmp
	mov tmp,mille
	inc tmp2
	rjmp segment

	affiche_cent:
	ldi tmp,0b11111011
	out portc,tmp
	mov tmp,cent
	inc tmp2
	rjmp segment

	affiche_dix:
	ldi tmp,0b11110111
	out portc,tmp
	mov tmp,dix
	inc tmp2
	rjmp segment

	affiche_unit:
	ldi tmp,0b11101111
	out portc,tmp
	mov tmp,unit
	inc tmp2
	rjmp segment

	retourmain:
	rjmp Main

	segment:
	cpi tmp,0
	breq zero
	cpi tmp,1
	breq un
	cpi tmp,2
	breq deux
	cpi tmp,3
	breq trois
	cpi tmp,4
	breq quatre
	cpi tmp,5
	breq cinq
	cpi tmp,6
	breq six
	cpi tmp,7
	breq sept
	cpi tmp,8
	breq huit
	cpi tmp,9
	breq neuf


zero:
	ldi tmp,(1<<PB6)//ldi tmp,0b00111111
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

un:
	ldi tmp,(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3)|(1<<PB0)//ldi tmp,0b00000110
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

deux:
	ldi tmp,(1<<PB5)|(1<<PB2)//ldi tmp,0b01011011
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

trois:
	ldi tmp,(1<<PB5)|(1<<PB4)//ldi tmp,0b01001111
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

quatre:
	ldi tmp,(1<<PB4)|(1<<PB3)|(1<<PB0)//ldi tmp,0b01100110
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

cinq:
	ldi tmp,(1<<PB4)|(1<<PB1)//ldi tmp,0b01101101
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

six:
	ldi tmp,(1<<PB1)//ldi tmp,0b01111101
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg

sept:
	ldi tmp,(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3)//ldi tmp,0b00000111
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain
	rjmp affichage7seg
	retourmain2:
	rjmp retourmain
	
huit:
	ldi tmp,~(1<<PB6)//ldi tmp,0b01111111
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain2
	rjmp affichage7seg

neuf:
	ldi tmp,(1<<PB4)//ldi tmp,0b01101111
	out PORTB,tmp
	cpi tmp2,4
	breq retourmain2
	rjmp affichage7seg

rjmp retourmain2


