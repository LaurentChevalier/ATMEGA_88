/*
 * CProgram1.c
 *
 * Created: 23-09-16 16:12:24
 *  Author: olivier
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

#include "main.h"
#include "Callbacks.h"
#include "TIMERS.h"
#include "Segments.h"

int nbr;

void segnbr(nbr)
{
	switch(nbr)
	{
		case 0: 
		PORTB=0b00111111;
		break;
		
		case 1: 
		PORTB=0b00000110;
		break;

		case 2: 
		PORTB=0b01011011;
		break;
		
		case 3: 
		PORTB=0b01001111;
		break;
		
		case 4: 
		PORTB=0b01100110;
		break;
		
		case 5: 
		PORTB=0b01101101;
		break;
		
		case 6: 
		PORTB=0b01111101;
		break;
		
		case 7: 
		PORTB=0b00000111;
		break;
		
		case 8: 
		PORTB=0b01111111;
		break;
		
		case 9: 
		PORTB=0b01101111;
		break;
	}
}