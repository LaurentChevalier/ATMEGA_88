//FONCTIONS USART


//INCLUDE
#include "USART.h"
#include "main.h"
#include "Callbacks.h"
#include "TIMERS.h"
#include "lcd.h"
#include "Hardware.h"

#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>


//DECLARATION DES VARIABLES GLOGALES

//PROTOTYPE FONCTIONS INTERNES


//CONTENU FONCTIONS EXTERNES

void Usart_Tx(char data)
{
    // UDRE Flag , is the transmit buffer UDR) ready to receive new data ?
	// if UDRE0 =1 the buffer is empty
	USART_Delay();
    UDR0 = data;
}


void Usart_Tx_String(char *String)
{
	char Continue = TRUE;
	while (Continue)
	{
		if(*String==0) Continue = FALSE;
		else 
		{
		Usart_Tx(*String++);		
		}
	}	
}






void USART_Init_9600()
{
// fréquence horloge = 1000000 hz, Si Baudrate = 9600 alors UBRR = 12
	//1xspeed  U2X0 = 1  
	UCSR0A |= (1<<U2X0);

	// 9600 baud
	//UBRR0H = 0x00;
	//UBRR0L = 0x0C;
	UBRR0 = 12;

		// Configuration 
	UCSR0B |= (1<<RXCIE0)|(0<<TXCIE0)|(0<<UDRIE0)|(1<<RXEN0)|(1<<TXEN0)|(0<<UCSZ02)|(0<<RXB80)|(0<<TXB80);

	// Async. mode, 8 bits, 1 bit de stop, pas de contrôle de parité
   	UCSR0C |= (0<<UMSEL00)|(0<<UPM01)|(0<<UPM00)|(0<<USBS0)|(1<<UCSZ01)|(1<<UCSZ00)|(0<<UCPOL0);
	
}

void USART_Delay()
{
	while(!(UCSR0A & (1<<UDRE0)));
}

//CONTENU FONCTIONS INTERNES


// Intéruption USART
