/*
 * SEANCE_22_09_2016.c
 *
 * Created: 22-09-16 10:43:23
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


// VARIABLES GLOBALES
unsigned char ID_clignotement;
unsigned char ID_bouton;
unsigned char ID_relais;
unsigned char ID_clignotement_rapide;
unsigned char bouton_on=0;
unsigned char clignotement_rapide_ok=TRUE;

//extern volatile char buffer[MAX_BUFFER];
// FONCTIONS DONT ON PASSE LES ADRESSES A callbacks.c POUR QU’ELLES PUISSENT
// ÊTRE RAPPELEES TOUTES LES X MS
// FONCTION PRINCIPALE
int main(void)
{
 // INITIALISATION HARDWARE
 hardware_Init() ; 
 //INITIALISATION CALLBACKS
 Callbacks_Init() ;
 USART_Init_9600();
 lcd_init(LCD_DISP_ON);
 lcd_clrscr();
 lcd_puts("Salut, ca va bien ?");
  lcd_clrscr();
 lcd_puts("bien bien");
 
 Usart_Tx_String("salut");
 
 Callbacks_Record_USART(affichage_USART);
 callbacks_Start();
 // N’ARRIVE JAMAIS ICI
}

// CONTENU DES FONCTIONS CALLBACKS
/*
void bouton()
{
	if(bouton_on==1 && clignotement_rapide_ok==TRUE)
	{
		clignotement_rapide_ok=FALSE;
		PIND =0b01000000;
		ID_relais = Callbacks_Record_Timer(relais, 3000) ;
		Callbacks_Remove_Timer(ID_clignotement );
		ID_clignotement = Callbacks_Record_Timer(clignotement, 50) ;
		ID_clignotement_rapide = Callbacks_Record_Timer(clignotement_rapide, 5000);
		bouton_on=0;
	}
}
void relais()
{
	PIND =0b01000000;
	Callbacks_Remove_Timer(ID_relais);
	
}
*/


void affichage_USART(char *trame)
{
	lcd_clrscr();
	lcd_puts(trame);
	
}


// CONTENU DES AUTRES FONCTIONS
