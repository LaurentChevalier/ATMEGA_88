// PROGRAMME AVEC GESTION MENU VIA JOYSTICK

// INCLUDE

//#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>


#include "main.h"
#include "button.h"

#include "menu.h"



//DECLARATION DES AUTRES VARIABLES GLOGALES



//Mes variables globales pour la machine d'états
unsigned char state;  // holds the current state, according to "menu.h"  



//DECLARATION DES FONCTIONS

int main(void)
{   
   	unsigned char nextstate;
    PGM_P statetext; // chaîne de texte sauvegardé dans la mémoire programme
    char (*pStateFunc)(char); // pointeur d'une fonction 
    unsigned char input;
    unsigned char i, j; 
        
    // Initialisation des variables qui concernent la machine d'états
    state = ST_START_TXT;
    nextstate = ST_START_TXT;
	statetext = TXT_START;
    pStateFunc = NULL;

    // Initialisation des périphériques
    Initialization();
		
    // Boucle infinie !!
    for(;;)
    {         
	 
	 if (statetext) 
      {
	    //Afficher_LCD(statetext);
		statetext = NULL;
     }

	  // Read buttons
      input = getkey();
	  // When in this state, we must call the state function           
      if (pStateFunc)
	  {
	  	 nextstate = pStateFunc(input); 
	  }	
      else
	  {
	  	if (input != KEY_NULL)
		{
			 nextstate = StateMachine(state, input);
	    }
      } 
      if (nextstate != state)  // il y a changement d'état 
      {
         state = nextstate; // l'état est maintenant le nouveau état de la séquence définie dans main.h
         for (i=0; (j=pgm_read_byte(&Menu_State[i].state)); i++)
         {
           if (j == state)
           {
              statetext =  (PGM_P) pgm_read_word(&Menu_State[i].pText);
              pStateFunc = (PGM_VOID_P) pgm_read_word(&Menu_State[i].pFunc);
              break;
           }
         }
      }
    } 
	return 1;            
}


//DETAIL DES FONCTIONS

unsigned char StateMachine(char state, unsigned char stimuli)
{
    unsigned char nextstate = state;    // Default stay in same state
    unsigned char i, j;
    for (i=0; ( j=pgm_read_byte(&menu_nextstate[i].state) ); i++ )
    {
        if ( j == state && 
             pgm_read_byte(&menu_nextstate[i].input) == stimuli)
        {
            // This is the one!
            nextstate = pgm_read_byte(&menu_nextstate[i].nextstate);
            break;
        }
    }
    return nextstate;
}


void Initialization(void)
{
	// *** INITIALISATION DES PERIPHERIQUES
	
	
	// *** ACTIVATION INTERRUPTIONS ***
	sei();   
}


// FONCTION APPELEES VIA POINTEURS...









