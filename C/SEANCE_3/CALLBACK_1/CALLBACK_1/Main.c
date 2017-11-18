// Callback_1

// INCLUDE
#include <avr/io.h>
#include <avr/interrupt.h>
#include "Main.h"
#include "Callback.h"
#include "Hardware.h"

// Mes variables globales
unsigned char IDCB_Led = 0; 
unsigned char IDCB_Porte = 0;
unsigned char IDCB_GACHE = 0;
unsigned char IDCB_STOP_LED = 0;
extern volatile unsigned char Door_Open ;
unsigned char Relais = FALSE;


// Prototype des fonctions

//********************************************************
// Fonctions dont on passe les adresses à TIOS 
void Switch_LED(void);
void Check_PORTE(void);
void Stop_GACHE(void);
void Stop_LED(void);


//****************** fonction principale *****************
int main (void)
{
 	//Initialisation hardware 
	Init_Hardware(3);

	Callbacks_Init();

	// Initialisation des Callbacks
 	IDCB_Led = Callbacks_Record_Timer(Switch_LED, 500);
	IDCB_Porte = Callbacks_Record_Timer(Check_PORTE, 1000);
 	
	
 	// Lancement OS (Boucle infinie)
	Callbacks_Start();

	return 0;

 	//N'arrive jamais ici
}



//**************** Switch LED ************************************
//  Signalisation par clignotement de la LED  pendant 500 ms 
//****************************************************************
void Switch_LED(void)
{
	PIND = (1<<PIND7);
	//sbiBF(PIND, PIND7);	// Toggle	
}


//**************** Chech PORTE *******************************************************
//  Si switch =TRUE alors Activation du relais (qui commande une gâche électrique)
//************************************************************************************
void Check_PORTE(void)

{
	if (Door_Open)
	{
		Door_Open = FALSE;
		if (!Relais)
		{	
			sbiBF(PORTD,PD6);  // on active le RELAIS
			Relais = TRUE;
			// On lance une callback qui sera appelée dans 3 secondes pour désactiver la 
			// gache 
			IDCB_GACHE = Callbacks_Record_Timer(Stop_GACHE, 3000);
			IDCB_Led = Callbacks_Remove_Timer(IDCB_Led);
			IDCB_Led = Callbacks_Record_Timer(Switch_LED, 50);
			IDCB_STOP_LED = Callbacks_Record_Timer(Stop_LED, 5000);
		}		
	}
}


//**************** Stop_GACHE*******************
// Appelée pour désactiver la gâche électrique  
// Cette tâche est appelée une seule fois !!
//**********************************************
void Stop_GACHE(void)
{
	cbiBF(PORTD,PD6);  // on désactive le RELAIS
	
	IDCB_GACHE = Callbacks_Remove_Timer(IDCB_GACHE); // on efface cette Callback, IDCB_GACHE est remis à 0 !
}

void Stop_LED(void)
{
	IDCB_Led = Callbacks_Remove_Timer(IDCB_Led);
	IDCB_Led = Callbacks_Record_Timer(Switch_LED, 1000);
	Relais = FALSE;	
	IDCB_STOP_LED = Callbacks_Remove_Timer(IDCB_STOP_LED);
}



