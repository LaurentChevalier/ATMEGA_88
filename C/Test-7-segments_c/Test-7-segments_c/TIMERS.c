//FONCTIONS TIMER0


//INCLUDE
#include <avr/io.h>
#include <avr/interrupt.h>

#include "TIMERS.h"
#include "Main.h"
#include "Segments.h"


//DECLARATION DES VARIABLES GLOGALES


//PROTOTYPE FONCTIONS INTERNES


//CONTENU FONCTIONS EXTERNES


void TIMER0_Init_1ms(void)
{
	TCCR1B |=(1<<WGM12)|(1<<CS12);//|(1<<CS10);
	OCR1AL = 0b00000001;
	TIMSK1 |=(1<<OCIE1A);
	


}



//CONTENU FONCTIONS INTERNES
