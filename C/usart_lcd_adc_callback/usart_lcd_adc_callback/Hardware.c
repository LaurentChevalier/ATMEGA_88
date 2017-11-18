/*
 * Hardware.c
 *
 * Created: 29-09-16 10:38:15
 *  Author: piani
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>

#include "main.h"
#include "Callbacks.h"
#include "TIMERS.h"
#include "lcd.h"
#include "USART.h"
#include "Hardware.h"

void hardware_Init()
{
	/* initialise Port Sortie */
	
	DDRD |=(1<<DDD7)|(1<<DDD6); //On initialise les bits 7 et 6 du DDRD à 1 pour les définir en output
	PORTD |=(1<<PD7);
	
	// Configuration de l'interruption
	
	EICRA |= (1<<ISC01); //set bit ISC01 in EICRA // interruption sur flanc descendant de INTO
	EIMSK |= (1<<INT0); //set bit in port EIMSK // activation de l'interruption sur INT0
	

}