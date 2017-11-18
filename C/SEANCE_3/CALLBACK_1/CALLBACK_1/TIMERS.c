//FONCTIONS TIMER0


//INCLUDE
#include "TIMERS.h"
#include "Main.h"

#include <avr/io.h>



//DECLARATION DES VARIABLES GLOGALES


//PROTOTYPE FONCTIONS INTERNES


//CONTENU FONCTIONS EXTERNES


void TIMER0_Init_1ms(void)
{
	// fréquence horloge = 1000000 hz
	// Utilisation du TIMER 0, comptage sur 8 bits
	// Si diviseur par 8 --> 1000000/8 = 125 Khz
	// Une période = 8µS
	// Si je compte jusque 125 --> 125 X 8 = 1 ms
	TCCR0A = 0x00; // |= (0<<CS02)|(1<<CS01)|(0<<CS00);
	TCCR0B |= (0<<CS02)|(1<<CS01)|(0<<CS00);
	// Valeur initiale du compteur = 256 - 125 = 131
	TCNT0 = 131;
	// Autorisation de l'interruption en cas d'overflow
	TIMSK0 = (1<<TOIE0);
}


//CONTENU FONCTIONS INTERNES
