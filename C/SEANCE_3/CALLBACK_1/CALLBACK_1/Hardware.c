//FONCTIONS Hardware


//INCLUDE
#include <avr/io.h>
#include "Main.h"



//DECLARATION DES VARIABLES GLOGALES
unsigned char Led;
unsigned char Relais;

//PROTOTYPE FONCTIONS INTERNES


//CONTENU FONCTIONS EXTERNES

void Init_Hardware(unsigned char Number_Manip)
{
	if (Number_Manip == 3)
	{
		/* Configuration I/O */
		//LED en PD7 en mode Output
  		sbiBF(DDRD,DDD7);
		// LED OFF au démarrage
		Led = FALSE;
		cbiBF(PORTD,PD7);
		// RELAIS en PD6 en mode Output
		sbiBF(DDRD,DDD6);
		// Contacts RELAIS ouverts au démarrage
		Relais = FALSE;
		cbiBF(PORTD,PD6);
		// Bouton poussoir en PD2 en mode Input avec pull up
		cbiBF(DDRD,DDD2);
		// Pull UP en PD2 enabled
		cbiBF(PORTD,PD2);
		// Interruption externe via INT0 de la broche PD2 enabled
		sbiBF(EIMSK,INT0);
		// Interruption sur Front Descendant
		EICRA|=(1<<ISC01)|(0<<ISC00);
	}

}


//CONTENU FONCTIONS INTERNES
