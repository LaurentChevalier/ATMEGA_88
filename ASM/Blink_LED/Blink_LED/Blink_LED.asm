/*
 * Blink_LED.asm
 *
 *  Created: 19-02-16 09:46:17
 *   Author: laurent
 */ 


 .def temp = r16 // on donne le nom temp à r16
 .def temp2= r17
 .org 0

	rjmp START

.org $20

START:

	ser temp
	//sbi DDRB, 0
	out DDRB,temp //on met la valeur de temp dans DDRB ==> touts les B sont en sortie
	out PORTB,temp //On écrit temp dans PORTB on met toutes les sorties à 1
	//sbi PORTB, 0
	mov temp2,temp
	
	rjmp decr

decr: 
	dec temp2
	cpi r17,0
	breq affichage
	rjmp decr
	
affichage:
	clr temp
	out PORTB,temp
	rjmp incr

incr:
	inc temp2
	cpi r17,255
	breq START
	rjmp incr


END: rjmp END