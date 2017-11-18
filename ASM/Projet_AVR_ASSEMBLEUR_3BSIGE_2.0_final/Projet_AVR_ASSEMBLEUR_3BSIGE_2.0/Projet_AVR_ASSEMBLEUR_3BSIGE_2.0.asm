/*
 * Projet_AVR_ASSEMBLEUR_3BSIGE_2.asm
 *
 *  Created: 19-05-16 09:45:52
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
.def passage_usart = r25

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

	ldi tmp, high(RAMEND) // Initialisation de la pile
	out SPH,tmp
	ldi tmp, low(RAMEND)
	out SPL,tmp

	// Initialisation du PORTB
	ldi tmp,0b11111111 // Définition du PORTB comme sortie
	out DDRB,tmp
	cbi PORTB, 7	// LED OFF

	// Initialisation du PORTC
	ldi tmp,0b00011110 // Définition de PC 1 2 3 4 comme sortie et le PC0 comme entrée le L'ADC
	out DDRC,tmp
	
	// Initialisation du PORTD
	in tmp,DDRD		
	ori tmp,0b00001000 // PD3 en output en PD2 en input, opération réalisée avec masquage pour ne pas modifier PD0 et PD1 utilisés par l'usart
	out DDRD,tmp	   //  PD3 étant utilisé pour le PWM et PD2 pour l'interruption INT0
	

	// Configuration de l'interruption 
	ldi tmp,0b00000010 // interruption sur flanc descendant de INTO
	sts	eicra,tmp
	ldi tmp,0b00000001 // activation de l'interruption sur INT0
	out eimsk,tmp

	// Configuration de l'ADC
	ldi tmp,0b01000000 // on prend AVCC comme reference et justification à droite
	sts admux,tmp
	ldi tmp,0b10001100  // freq à 1MHz/16==>62.500kHz et activation de l'interruption de fin de conversion
	sts adcsra,tmp
	ldi tmp,0b00000000
	sts adcsrb,tmp

	// Configuration du timer
	ldi tmp, 0b00000010 // mise en place du timer en mode CTC
	out TCCR0A, tmp
	ldi tmp, 0b00000101 // presacaler 1024 (incrémentation du timer0 toutes les 1,024 ms)
	out TCCR0B,tmp
	ldi tmp, 10	// valeur de comparaison pour génération de l'interruption en mode CTC  (10 x 1,024 ms = 10,24 ms )
	out OCR0A, tmp
	ldi tmp, 0b00000010 // activation de l'interruption sur comparaison avec OCR0A
	sts TIMSK0, tmp

	// Configuration du PWM
	ldi tmp, 0b00100011 // Compare Output Mode sur OC2B: Fast PWM Mode non inverting mode  and Fast PWM Mode with TOP = 0XFF
	sts TCCR2A, tmp
	ldi tmp,0b00000000 // Désactivation du PWM par défaut
	sts TCCR2B,tmp
	ldi tmp, 0b00000000 // Pas d'interruptions activées
	sts TIMSK2, tmp
	ldi tmp, 1 // Par défaut valeur de comparaison pour génération du PWM à 1
	sts OCR2B, tmp

	// Configuration de l'usart
	ldi tmp,0b00100010 //receiver is ready to receive data, double vitesse
	sts UCSR0A,tmp
	ldi tmp,0b00000000 //Désactivation du récepteur et de l'émetteur par défaut
	sts UCSR0B,tmp
	ldi tmp,0b00000110 //Mode asynchrone, pas de bit de parité, 1 bit de stop, 8 bits de données
	sts UCSR0C,tmp
	ldi tmp,0b00001100 //Baudrate = 9600bps
	sts UBRR0L,tmp
	ldi tmp,0b00000000
	sts UBRR0H,tmp
	
	// Initialisation de passage,seg,cmpt et passage_usart à 0
	clr passage
	clr seg
	clr cmpt
	clr passage_usart
	sei //Enable interrupts
	
	rjmp Main
	
Interrup_INT0:

	cpi passage,0
	brne eteindre
	rjmp allumer
	
	allumer:
	lds tmp, ADCSRA
	ori tmp, 0b01000000
	sts ADCSRA, tmp // Activation de ADC
	ldi tmp, 0b00000001 //no prescaler
	sts TCCR2B,tmp //activation du timer 2 pour le PWM
	ldi tmp,0b00011000 //Activation du récepteur et de l'émetteur
	sts UCSR0B,tmp
	ldi passage,1
	reti	

	eteindre:
	ldi tmp,0b10001100 
	sts adcsra,tmp //Désactivation ADC
	ldi tmp, 0b00000000 //no clock source
	sts TCCR2B,tmp //désactivation du timer 2 pour le PWM
	ldi tmp,0b00000000 //Désactivation du recepteur et de l'émetteur
	sts UCSR0B,tmp
	ldi passage,0
	reti

Timer_CTC_Mode:
	
	cpi passage,0 //Vérifie si on est en mode STOP ou START
	breq ledclignote //Si passage ==1 on est en mode START => mise en marche de la conversion sinon on saute vers ledclignote
	lds tmp, ADCSRA
	ori tmp, 0b01000000 // lancement de la conversion 
	sts ADCSRA, tmp

ledclignote:
	cpi passage, 0 //Vérifie si on est en mode STOP ou START
	brne ledclignote_5HZ //Si passage ==1 on est en mode START si passage==0 on est en mode STOP
	rjmp ledclignote_1HZ 

ledclignote_5HZ:
	inc cmpt
	cpi cmpt, 10   // (10 x 10,24 ms = 102,4 ms) ==> 4,88 Hz
	breq clignote
	rjmp Affichage_val

ledclignote_1HZ:
	inc cmpt
	cpi cmpt, 49  // (49 x 10,24ms = 501,76 ms) ==> 0,996 Hz
	breq clignote
	rjmp Affichage_val

clignote:
	clr cmpt
	sbi PINB,7 //Toggle de la LED 7


Affichage_val:
	
	in tmp, PORTB
	ori tmp, 0b01111111 //(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3)|(1<<PB2)|(1<<PB1)|(1<<PB0) Extinction de tous les segments
	out PORTB, tmp

	cpi passage,0 //Vérifie si on est en mode STOP ou START
	brne affichage //Si passage ==1 on est en mode start si passage==0 on est en mode stop
	rjmp affichage_stop

	affichage_stop:

	cpi seg,0
	breq afficheS
	cpi seg,1
	breq afficheT
	cpi seg,2
	breq afficheO
	cpi seg,3
	breq afficheP
	
	// Le code suivant consiste à afficher STOP sur les 4 Afficheur 7 SEGMENTS.
	afficheS:

	ldi tmp,~(1<<PC1)//ldi tmp,0b11111101 // Allumage du SEGEMENT MILLE
	out portc,tmp
	in tmp,PORTB				
	andi tmp,0b10010010 //(1<<PB4)|(1<<PB1) Incription du S sur le 7 SEG
	out PORTB,tmp
	inc seg
	reti
	
	afficheT:
	
	ldi tmp,~(1<<PC2)//ldi tmp,0b11111011 // Allumage du SEGEMENT CENT
	out portc,tmp
	in tmp,PORTB				
	andi tmp,0b11111000 //(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3) Inscription du T sur le 7 SEG
	out PORTB,tmp
	inc seg
	reti
	
	afficheO:
	
	ldi tmp,~(1<<PC3)//ldi tmp,0b11110111 // Allumage du SEGEMENT DIX
	out portc,tmp
	in tmp,PORTB				
	andi tmp,0b11000000 //(1<<PB6) Inscription du O sur le 7 SEG
	out PORTB,tmp
	inc seg
	reti

	
	afficheP:
	
	ldi tmp,~(1<<PC4)//ldi tmp,0b11101111 // Allumage du SEGEMENT UNITE
	out portc,tmp
	in tmp,PORTB				
	andi tmp,0b10001100 //(1<<PB2)|(1<<PB3) Inscription du P sur le 7 SEG
	out PORTB,tmp
	ldi seg,0
	reti

	affichage:
	
	affichage7seg:
	cpi seg,0
	breq affiche_mille
	cpi seg,1
	breq affiche_cent
	cpi seg,2
	breq affiche_dix
	cpi seg,3
	breq affiche_unit

	affiche_mille:
	ldi tmp,~(1<<PC1)//ldi tmp,0b11111101
	out portc,tmp // On commande le 7 segments affichant les milliers
	mov tmp,mille
	inc seg
	rjmp segment

	affiche_cent:
	ldi tmp,~(1<<PC2)//ldi tmp,0b11111011
	out portc,tmp // On commande le 7 segments affichant les centaines
	mov tmp,cent
	inc seg
	rjmp segment

	affiche_dix:
	ldi tmp,~(1<<PC3)//ldi tmp,0b11110111
	out portc,tmp // On commande le 7 segments affichant les dizaines
	mov tmp,dix
	inc seg
	rjmp segment

	affiche_unit:
	ldi tmp,~(1<<PC4)//ldi tmp,0b11101111
	out portc,tmp // On commande le 7 segments affichant les unités
	mov tmp,unit
	ldi seg,0
	rjmp segment


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
	in tmp,PORTB				
	andi tmp,0b11000000 //(1<<PB6) Inscription du 0 sur le 7 SEG
	out PORTB,tmp
	reti

un:
	in tmp,PORTB				
	andi tmp,0b11111001 //(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3)|(1<<PB0) Inscription du 1 sur le 7 SEG
	out PORTB,tmp
	reti

deux:
	in tmp,PORTB				
	andi tmp,0b10100100 //(1<<PB5)|(1<<PB2) Inscription du 2 sur le 7 SEG
	out PORTB,tmp
	reti

trois:
	in tmp,PORTB				
	andi tmp,0b10110000 //(1<<PB5)|(1<<PB4) Inscription du 3 sur le 7 SEG
	out PORTB,tmp
	reti

quatre:
	in tmp,PORTB				
	andi tmp,0b10011001 //(1<<PB4)|(1<<PB3)|(1<<PB0) Inscription du 4 sur le 7 SEG
	out PORTB,tmp
	reti

cinq:
	in tmp,PORTB
	andi tmp,0b10010010 //(1<<PB4)|(1<<PB1) Inscription de 5 sur le 7 SEG
	out PORTB,tmp
	reti

six:
	in tmp,PORTB
	andi tmp,0b10000010 //(1<<PB1) Inscription de 6 sur le 7 SEG
	out PORTB,tmp
	reti

sept:
	in tmp,PORTB
	andi tmp,0b11111000 //(1<<PB6)|(1<<PB5)|(1<<PB4)|(1<<PB3) Inscription de 7 sur le 7 SEG
	out PORTB,tmp
	reti
	
huit:
	in tmp,PORTB
	andi tmp,0b10000000 //Inscription de 8 sur le 7 SEG
	out PORTB,tmp
	reti

neuf:
	in tmp,PORTB
	andi tmp,0b10010000 //(1<<PB4) Inscription de 9 sur le 7 SEG
	out PORTB,tmp
	reti
	
ADC_COMPLETE:

	lds adclow,adcl
	lds adchigh,adch //Attention obligation de lire ADCL avant ADCH et obligation de lire les 2
	mov tmp,adchigh // On charge la valeur de ADCH dans tmp
	ldi tmp2,0
	shift_left: // On effectue un décalage de 6 vers la gauche de tmp
	lsl tmp
	inc tmp2
	cpi tmp2,6
	brne shift_left
	mov tmp2,adclow // On charge la valeur de ADCL dans tmp2 et on effectue un décalage de 2 vers la droite de tmp2
	lsr tmp2
	lsr tmp2
	or tmp,tmp2 // On effectue un ou entre tmp et tmp2 (tmp contenant ADC9 et ADC8 et tmp2 contenant ADC7 à ADC2)

	sts OCR2B,tmp // On envoit dans OCR2B tmp qui contient ADC9 à ADC2

Decomposition_nombre:
	
	// Mise à 0 des registes contenant le nombre décomposé à chaque décomposition
	ldi mille,0
	ldi cent,0
	ldi dix,0
	ldi unit,0

	mov tmp,adclow // On commence par s'occuper des 8 bits de poids faible de l'ADC (de ADC0 à ADC7) (contenus dans les regsitre ADCL)
	

	centaines:  // On commence par déterminer la valeur des centaines
	subi tmp,100
	brcs ajout100 // On soustrait 100 du registre tmp qui contient les 8 bits de poids faible de l'ADC tant que le résultat est positif
	inc_centaines: // Lorsdue le résultat de la soustraction est négatif on passe aux dizaines mais avant on ajoute 100 au registre
	inc cent	  // A chaque fois que le résultat est positif on incrémente de 1 la valeur du registre cent
	rjmp centaines

	ajout100:
	ldi tmp2,100 //On ajoute 100 lorsque on fait -100 et que le résultat est négatif
	add tmp,tmp2
	rjmp dizaines

	dizaines:  // On détermine la valeur des dizaines
	subi tmp,10
	brcs ajout10 // On soustrait 10 du registre tmp qui contient les 8 bits de poids faible de l'ADC dont on a déjà enlevé les centaines tant que le résultat est positif
	inc_dizaines: // Lorsque le résultat de la soustraction est négatif on passe aux unité mais avant on ajoute 10 au registre
	inc dix		 // A chaque fois que le résultat est positif on incrémente de 1 la valeur du registre dix
	rjmp dizaines

	ajout10:
	ldi tmp2,10 //On ajoute 10 lorsque on fait -10 et que le résultat est négatif
	add tmp,tmp2
	rjmp unites
	
	unites:  // On détermine la valeur des unités
	mov unit,tmp // Ayant déjà soustrait les dizaines et les centaines, le registre tmp ne contient plus rien sauf les unités

	bits_poids_fort: // On s'occupe maintenant des deux bits de poids plus élevés (ADC8 et ADC9) (contenus dans le registre ADCH)
	mov tmp,adchigh
	

	test512: // On commence par test si le bit ADC9 est à 0 ou à 1 
	mov tmp2,tmp
	lsr tmp2
	cpi tmp2,0b00000001
	breq ajouter512 // Si le bit ADC9 est à 1 il faut ajouter 512 à la valeur décomposée précédemment sinon on test si le bit ADC8 est à 0 ou à 1
	rjmp test256

	ajouter512: // Dans le cas ou ADC 9 est à 1 on ajoute 512 aux différents registres contenant le nombre décomposé

	subi cent,-5
	subi dix,-1
	subi unit,-2


	test256: // Quelque soit l'état du bit ADC9, on test le bit ADC8 est à 0 ou à 1
	ldi tmp2,0b00000001
	and tmp2,tmp
	cpi tmp2,0b00000001
	breq ajouter256 //Si le bit ADC8 est à 1 il faut ajouter 256 à la valeur décomposée précédemment sinon on saute vers la fonction de report
	rjmp report

	ajouter256: // Dans le cas ou ADC 8 est à 1 on ajoute 256 aux différents registres contenant le nombre décomposé
	
	subi cent,-2
	subi dix,-5
	subi unit,-6

	rjmp report 

	report: // La fonction report à pour but de faire un report si la valeur du registre unit et/ou dix et/ou cent dépasse 10
	cpi unit,10
	brsh report_unites // Si la valeur contenue dans le registre des unités est plus grande ou égale 10 on fait un report dans le registre dix
	cpi dix,10
	brsh report_dizaines // Si la valeur contenue dans le registre des dizaines est plus grande ou égale 10 on fait un report dans le registre cent
	cpi cent,10
	brsh report_centaines // Si la valeur contenue dans le registre des centaines est plus grande ou égale 10 on fait un report dans le registre mille
	reti // Si il n'y a pas de report à faire on fait le retour d'interruption
	
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

Main: // Programme principal

USART_TEST:
	cpi passage,0 // On test si l'on est en position start ou stop
	breq Main
	rjmp Reception_usart


Reception_usart: // Code pour reception sur USART
	lds tmp,UCSR0A
	andi tmp,0b10000000
	cpi tmp,0b10000000 // On test la valeur contenue dans le bit RXC0 du registre UCSR0A 
	brne Emission_usart // si le bit est à 1 cela signifie qu'il y a une valeur dans le buffer de reception (une valeur reçue mais pas encore lue)
	lds tmp,UDR0
	cpi tmp,115 // la valeur 115 en decimal correspond au caractère "s" dans la table ASCII
	brne Emission_usart
	rjmp Reset

Reset: // Arrêt du programme par USART
	ldi tmp,0b10001100 
	sts adcsra,tmp //Désactivation ADC
	ldi tmp, 0b00000000 //no clock source
	sts TCCR2B,tmp //désactivation du timer 2 pour le PWM
	ldi tmp,0b00000000 //Désactivation du recepteur et de l'émetteur
	sts UCSR0B,tmp
	ldi passage,0
	rjmp Main


Emission_usart: // Code pour emission sur USART
	lds tmp,UCSR0A
	andi tmp,0b00100000
	cpi tmp,0b00100000 // On test la valeur contenue dans le bit UDREO du registre UCSR0A 
	brne Main		  // si le bit est à 1 cela signifie que l'émission précedente est terminée et donc que l'on peut envoyer une nouvelle valeur sur l'usart

Affichage_USART:

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

	caract1:
	sts UDR0,adchigh // On envoit la valeur contenue dans le ADCH en binaire
	rjmp  Main
	caract2:
	sts UDR0,adclow // On envoit le valeur contenue dans le ADCL en binaire
	rjmp  Main
	caract3:
	ldi tmp,59 //Affichage d'un ";"
	sts UDR0,tmp
	rjmp  Main
	caract4:
	mov tmp,mille 
	subi tmp,-48
	sts UDR0,tmp // On envoit la valeur contenue dans le registre des milliers en codage ASCII
	rjmp  Main
	caract5:
	mov tmp,cent 
	subi tmp,-48
	sts UDR0,tmp // On envoit la valeur contenue dans le registre des centaines en codage ASCII
	rjmp  Main
	caract6:
	mov tmp,dix
	subi tmp,-48
	sts UDR0,tmp // On envoir la valeur contenue dans le registre des dizaines en codage ASCII
	rjmp  Main
	caract7:
	mov tmp,unit
	subi tmp,-48
	sts UDR0,tmp // On envoit la valeur contenue dans le registre des unités en codage ASCII
	rjmp Main
	caract8:
	ldi tmp,13 // carriage return 
	sts UDR0,tmp
	ldi passage_usart,0
	rjmp Main

	
rjmp Main




