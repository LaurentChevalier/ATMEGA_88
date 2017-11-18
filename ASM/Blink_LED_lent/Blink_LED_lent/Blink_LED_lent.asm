/*
 * Blink_LED_lent.asm
 *
 *  Created: 19-02-16 12:35:42
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
	sbi DDRB,0 //on met le bit 0 du DDRB à 1 ==> en sortie
	sbi PORTB,0 //On écrit 1 dans le bit 0 de portb on active la sortie
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
