/*
 * SEANCE_22_09_2016.c
 *
 * Created: 22-09-16 10:43:23
 *  Author: piani
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

#include "main.h"
#include "Callbacks.h"
#include "TIMERS.h"
#include "Segments.h"


// VARIABLES GLOBALES
unsigned char ID_clignotement;
unsigned char ID_bouton;
unsigned char ID_relais;
unsigned char ID_clignotement_rapide;
unsigned char ID_segments;
unsigned char bouton_on=0;
unsigned char clignotement_rapide_ok=TRUE;

unsigned char segment_a_afficher;
int nombre_a_afficher=0;
int nombre=500;
int nombre0;
int nombre1; 
int nombre2;
int nombre3;  

// FONCTIONS DONT ON PASSE LES ADRESSES A callbacks.c POUR QU’ELLES PUISSENT
// ÊTRE RAPPELEES TOUTES LES X MS
void clignotement(void) ;
void bouton(void) ;
void relais(void) ;
void clignotement_rapide(void);
void segments(void);
// FONCTION PRINCIPALE
int main(void)
{
 // INITIALISATION HARDWARE
 hardware_Init() ; 
 //INITIALISATION CALLBACKS
 Callbacks_Init() ;
 //ID_clignotement = Callbacks_Record_Timer(clignotement, 1000) ;
 ID_bouton = Callbacks_Record_Timer(bouton, 100) ;
 ID_clignotement = Callbacks_Record_Timer(clignotement,100) ;
 ID_segments = Callbacks_Record_Timer(segments,10) ;
 
 callbacks_Start();
 // N’ARRIVE JAMAIS ICI
}

// CONTENU DES FONCTIONS CALLBACKS

void bouton()
{
	if(bouton_on==1 && clignotement_rapide_ok==TRUE)
	{
		clignotement_rapide_ok=FALSE;
		//PIND =0b01000000;
		//ID_relais = Callbacks_Record_Timer(relais, 3000) ;
		Callbacks_Remove_Timer(ID_clignotement );
		ID_clignotement = Callbacks_Record_Timer(clignotement, 100) ;
		ID_clignotement_rapide = Callbacks_Record_Timer(clignotement_rapide, 5000);
		bouton_on=0;
	}
}
void relais()
{
	PIND =0b01000000;
	Callbacks_Remove_Timer(ID_relais);
}
void clignotement_rapide()
{
		Callbacks_Remove_Timer(ID_clignotement);
		ID_clignotement = Callbacks_Record_Timer(clignotement,1000) ;
		Callbacks_Remove_Timer(ID_clignotement_rapide);
		clignotement_rapide_ok=TRUE;
}

void clignotement()
{
	PIND |=(1<<nombre0);
	nombre--;
	 if(nombre<0) 
	 {
		Callbacks_Remove_Timer(ID_clignotement);
		Callbacks_Remove_Timer(ID_segments);
		PORTC=0b00000000;
		PORTD=0b11111111;
	 }
}

void segments()
{

	 
	 segment_a_afficher++;
	 if(segment_a_afficher>3) segment_a_afficher=0;
	 
	 nombre3=nombre/1000;
	 nombre2=(nombre-(nombre3*1000))/100;
	 nombre1=(nombre-(nombre3*1000)-(nombre2*100))/10;
	 nombre0=nombre-(nombre3*1000)-(nombre2*100)-(nombre1*10);
	 
	 
	 switch(segment_a_afficher)
	 {
		 case 3:
		 PORTC=0;
		 segnbr(nombre0);
		 PORTC=0b00001000;
		 break;
		 
		 case 2:
		 PORTC=0;
		 segnbr(nombre1);
		 PORTC=0b00000100;
		 PORTB |= (1<<PB7);
		 break;
		
		 case 1:
		 PORTC=0;
		 segnbr(nombre2);
		 PORTC=0b00000010;
		 nombre_a_afficher=nombre1;
		 break;
		 
		 case 0:
		 PORTC=0;
		 segnbr(nombre3);
		 PORTC=0b00000001;
		 break;
		 
	 }
	 
}

// CONTENU DES AUTRES FONCTIONS
hardware_Init()
{
	/* initialise Port Sortie */
	
	DDRD =0b11111111; //On initialise les bits 7 et 6 du DDRD à 1 pour les définir en output
	DDRB=0b11111111;
	DDRC=0b11111111;
	
	// Configuration de l'interruption
	
	EICRA |= (1<<ISC01); //set bit ISC01 in EICRA // interruption sur flanc descendant de INTO
	EIMSK |= (1<<INT0); //set bit in port EIMSK // activation de l'interruption sur INT0
	

}