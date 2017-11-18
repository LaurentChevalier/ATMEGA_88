/*
 * Examen_JUIN_2016_AVR.asm
 *
 *  Created: 15-06-16 09:10:04
 *   Author: Laurent Chevalier
 */ 
    //********************************************************************//
   //   Programme Examen Réseaux et Systèmes Informatiques  Juin 2016    //
  //********************************************************************//


.def passage = r16
.def tmp = r17
.def adclow = r18
.def adchigh =r19
.def passage_usart =r20
.def usart_on=r21
.def usart_off=r22
.def buzzer_state=r23


.org 0  
	rjmp start
.org 0x002
	rjmp interrup
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
		
	//Configuration des PORTS
	ldi tmp,0b00001100 //Définition du PB2 et PB3 comme sortie, le reste est en entrée
	out DDRB,tmp
	ldi tmp,0b00010010 //Définition du PD1 et PD4 comme sortie, le reste est en entrée
	out DDRD,tmp
	ldi tmp,0b00000000 //Définition du PORTC en entrée
	out DDRC,tmp


	//Configuration du timer0
	ldi tmp, 0b00000010 // mise en place du timer en mode CTC
	out TCCR0A, tmp
	ldi tmp, 0b00000100 // activation du timer presacaler 256 (incrémentation du timer0 toutes les 0,256 ms)
	out TCCR0B,tmp
	ldi tmp, 0b00000010 // activation de l'interruption sur comparaison avec OCR0A
	sts TIMSK0, tmp
	ldi tmp, 1 // valeur de comparaison pour génération de l'interruption en mode CTC  (2 x 0,256 ms = 0.512 ms ) ==> freq = 976,5625Hz ==> 2,344 % d'erreur par rapport à 1KHz
	out OCR0A, tmp

	//Configuration de l'ADC
	ldi tmp,0b01100101 //on prend AVCC comme reference et justification à gauche (pseudo 8bits) et ADC5 comme entrée
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
	ldi tmp,25 //Baudrate = 4800bps
	sts UBRR0L,tmp
	ldi tmp,0b00000000
	sts UBRR0H,tmp


	//Configuration de l'interruption
	ldi tmp,0b00001000 // interruption sur flanc descendant de INT1
	sts	eicra,tmp
	ldi tmp,0b00000010 // activation de l'interruption sur INT1
	out eimsk,tmp

	clr passage
	clr passage_usart
	clr buzzer_state
	
	sei ;Enable interrupts
	

	rjmp Main

interrup:
	
	cpi passage,0 // Si passage==0 ==>le programme est éteint si passage==1 ==> le programme est allumé
	breq setup
	rjmp reset

	reset:
	in tmp, PORTB
	andi tmp, 0b11110111 // Opération de masquage pour ne pas modifier la valeur du PB2 (alarme) et désactivation de la led en PB
	out PORTB,tmp
	ldi passage,0
	reti // retour d'interruption si désactivation
	

	setup:
	in tmp, PORTB
	ori tmp, 0b00001000 //Opération de masquage pour ne pas modifier la valeur du PB2 (alarme) et activation de la led en PB3
	out PORTB,tmp
	ldi passage,1
	reti // retour d'interruption si activation




Timer_CTC_Mode:
	sbi PIND,4 //TOGGLE du signal PWM en PD4
	lds tmp, ADCSRA
	ori tmp, 0b01000000 // Activation de la conversion lors de chaque interruption du timer
	sts ADCSRA, tmp

reti 

ADC_COMPLETE:

	lds adclow,adcl
	lds adchigh,adch //Attention obligation de lire ADCL avant ADCH et obligation de lire les 2

	cpi adchigh,128 //Activation du Buzzer si tension inférieur à 2,5V
	brsh STOP_BUZ
	rjmp BUZZER

	STOP_BUZ:
	in tmp, PORTB
	andi tmp, 0b11111011 // Opération de masquage pour ne pas modifier la valeur du PB3 (LED) et désactivation du Buzzer en PB2
	out PORTB,tmp
	ldi buzzer_state,0
	reti
	
	BUZZER:
	in tmp, PORTB
	ori tmp, 0b00000100 //Opération de masquage pour ne pas modifier la valeur du PB3 (LED) et activation du Buzzer en PB2
	out PORTB,tmp
	ldi buzzer_state,1
	reti


Main: 

Emission_usart: // Code pour emission sur USART
	
	cpi buzzer_state,0
	breq saut_usart_off
	rjmp Affichage_usart_on

Affichage_usart_on:
	cpi usart_on,0
	breq Affichage_on
	rjmp Main

	Affichage_on:

	lds tmp,UCSR0A
	andi tmp,0b00100000
	cpi tmp,0b00100000 // On test la valeur contenue dans le bit UDREO du registre UCSR0A 
	brne Main		  // si le bit est à 1 cela signifie que l'émission précedente est terminée et donc que l'on peut envoyer une nouvelle valeur sur l'usart

	inc passage_usart

	cpi passage_usart,1
	breq caract1
	cpi passage_usart,2
	breq caract2
	cpi passage_usart,3
	breq caract3
	cpi passage_usart,4
	breq caract4
	cpi passage_usart,5
	breq caract5
	cpi passage_usart,6
	breq caract6
	cpi passage_usart,7
	breq caract7
	cpi passage_usart,8
	breq caract8
	cpi passage_usart,9
	breq caract9
	cpi passage_usart,10
	breq caract10


	caract1:
	ldi tmp,65 // "A" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract2:
	ldi tmp,108 // "l" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract3:
	ldi tmp,97 // "a" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract4:
	ldi tmp,114 // "r" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract5:
	ldi tmp,109 // "m" en codage ASCII
	sts UDR0,tmp 
	rjmp Main
	caract6:
	ldi tmp,101 // "e" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract7:
	ldi tmp,32 // "SPACE" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract8:
	ldi tmp,79 // "O" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	
	saut_usart_off:
	rjmp Affichage_usart_off

	caract9:
	ldi tmp,78 // "N" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract10:
	ldi tmp,13 // carriage return 
	sts UDR0,tmp
	ldi passage_usart,0
	ldi usart_on,1
	ldi usart_off,0
	rjmp Main

Affichage_usart_off:
	cpi usart_off,0
	breq Affichage_off
	rjmp Main

	Affichage_off:
	lds tmp,UCSR0A
	andi tmp,0b00100000
	cpi tmp,0b00100000 // On test la valeur contenue dans le bit UDREO du registre UCSR0A 
	brne retour		  // si le bit est à 1 cela signifie que l'émission précedente est terminée et donc que l'on peut envoyer une nouvelle valeur sur l'usart

	inc passage_usart

	cpi passage_usart,1
	breq caract21
	cpi passage_usart,2
	breq caract22
	cpi passage_usart,3
	breq caract23
	cpi passage_usart,4
	breq caract24
	cpi passage_usart,5
	breq caract25
	cpi passage_usart,6
	breq caract26
	cpi passage_usart,7
	breq caract27
	cpi passage_usart,8
	breq caract28
	cpi passage_usart,9
	breq caract29
	cpi passage_usart,10
	breq caract30
	cpi passage_usart,11
	breq caract31

	retour:
	rjmp Main

	caract21:
	ldi tmp,65 // "A" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract22:
	ldi tmp,108 // "l" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract23:
	ldi tmp,97 // "a" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract24:
	ldi tmp,114 // "r" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract25:
	ldi tmp,109 // "m" en codage ASCII
	sts UDR0,tmp 
	rjmp Main
	caract26:
	ldi tmp,101 // "e" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract27:
	ldi tmp,32 // "SPACE" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract28:
	ldi tmp,79 // "O" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract29:
	ldi tmp,70 // "F" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract30:
	ldi tmp,70 // "F" en codage ASCII
	sts UDR0,tmp
	rjmp Main
	caract31:
	ldi tmp,13 // carriage return 
	sts UDR0,tmp
	ldi passage_usart,0
	ldi usart_off,1
	ldi usart_on,0
	rjmp Main


rjmp Main



