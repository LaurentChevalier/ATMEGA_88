/*
 * Test_chenillard.asm
 *
 *  Created: 20-02-16 11:02:32
 *   Author: laurent
 */ 
 .def Temp =r16 ; Temporary register	
.def Delay =r17 ; Delay variable 1	
.def Delay2 =r18 ; Delay variable 2	
.def Delay3 =r19
.def Delay4 =r20
;***** Initialization
.org 0

	rjmp RESET

.org $20	

RESET:	
ldi Temp,0b11111111
	
out DDRB,Temp ; 	

Programme:
	
ror Temp

 
	Attendreunpeu4:	
	dec Delay ;
	brne Attendreunpeu4 


	dec delay3
	brne Attendreunpeu4 


out PORTB,temp ; 	 
brcc programme2
rjmp programme


programme2:
	
rol Temp

    	Attendreunpeu1:	
	dec Delay ;
	brne Attendreunpeu1 


	dec delay2
	brne Attendreunpeu1 
 

out PORTB,temp ; 	 
brcc programme
rjmp programme2

	 	 



fin:
nop
rjmp fin

	

rjmp programme

