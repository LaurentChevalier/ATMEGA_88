#include "Callback.h"
#include "Main.h"
#include "TIMERS.h"

#include <avr/interrupt.h>
#include <avr/io.h>


//VARIABLES GLOBALES

void (*My_CB[MAX_CALLBACKS])(void);
unsigned int Time_CB[MAX_CALLBACKS];
volatile unsigned int Tick_CB[MAX_CALLBACKS];
volatile unsigned char Door_Open = FALSE;

// DECLARATION DES FONCTIONS INTERNES


// DECLARATION DES FONCTIONS EXTERNES

// ****************  OSInitialiser ******************************
// Initialise l'OS: initialise les variables et démarre le Timer
// ****************************************************************
void Callbacks_Init(void)
{
 	unsigned char i;
 	//Initialisation pour variables CallBack 
 	for (i=0; i< MAX_CALLBACKS; i++)
 	{
  		 My_CB[i] = 0;
  	}
  
	//Initialisation du LCD
	
	//Initialisation USART 	
} 


// ENREGISTREMENT CALLBACKS TIMER
// ****************  EnregistrerFonctionDeRappel ******************************
// Sauve l'adresse de la fonction à rappeler. Lorsque le nombre d'interruptions
// aura atteint temps millisecondes, le système rappellera la fonction
// *************************************************************************
unsigned char Callbacks_Record_Timer(void(*ptFonction)(void), unsigned int Time)
{
 	unsigned int i= 1; //(+1 car la valeur 0 doit signifier que la fonction n'est pas appelée)
 	while (My_CB[i]!=0 && i< (MAX_CALLBACKS+1)) i++;
	 //S'il reste de la place on enregistre et on retourne i (opération réussie)
 	if (i< (MAX_CALLBACKS+1))
 	{
  		 My_CB[i] = ptFonction;
  		 Time_CB[i] = Time; 
  		 Tick_CB[i] = 0; //Initialiser le compteur à 0;
   		return i; // ID du call back 
  	}
 	else return 255; //Il n'y a plus de place pour enregistrer un callback
}

// RETIRER FONCTION DE RAPPEL
// ****************  Retirer fonction de rappel ******************************
// Libère l'emplacement de la callback
// *************************************************************************
char Callbacks_Remove_Timer(unsigned char ID_CB)
{
	 My_CB[ID_CB] = 0;
	 return 0;
}
	 


// BOUCLE PRINCIPALE DE L'OS
// ****************  Boucle principale de l'OS ******************************
// Boucle infinie qui attend des événement liés aux interruptions pour 
// appeler les fonctions enregistrées
// *************************************************************************
void Callbacks_Start(void)
{
	unsigned char idx;

 	
	//Création, configuration et démarrage de Timer0pour générer une interruption toutes les mS
 	TIMER0_Init_1ms(); //A partir d'ici, interruption toutes les ms par Timer0
	
	// Initialisation des interruptions, on autorise toutes les interruptions
	// Pour les interruptions particulières, voir chaque fonction
 	sei();  


 	// BOUCLE INFINIE
	// Boucle principale de l'OS d'où on ne sort jamais
	 while(1)
 	 {
  		 // Check les conditions pour rappeler les fonctions liées au temps 
  		 for (idx = 0; idx < MAX_CALLBACKS; idx++)
    	 {
	 		if (My_CB[idx]) //Si on a l'adresse d'une fonction CB à cet index
     		//Si on est arrivé au nombre de mS demandé, on appelle la fonction 
			{	
     			if (Tick_CB[idx] >= Time_CB[idx])
      			{ 
	  				 Tick_CB[idx] = 0;
      				 My_CB[idx]();  //Rappel de la fonction enregistrée!
	 			}
			}
  		 }
  	 }
}


// CONTENU DES FONCTIONS INTERNES


// INTERRUPTIONS

           

// ***********************
// INTERRUPTION TIMER
// **********************
ISR(TIMER0_OVF_vect)
{
	TCNT0 = 131;  // reconfiguration du Timer1
	// Ajourner tous les TICKS
	unsigned char Int_Counter;
  	for (Int_Counter = 0; Int_Counter < MAX_CALLBACKS; Int_Counter++)
	{
		Tick_CB[Int_Counter]++;
	}
	 
	
}

// ******************
// INTERRUPTION INT0
// ******************
ISR(INT0_vect)
{	
	Door_Open = TRUE;
	
}








