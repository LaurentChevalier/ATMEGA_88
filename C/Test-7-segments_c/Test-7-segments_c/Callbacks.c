/*
 * Callbacks.c
 *
 * Created: 22-09-16 11:11:04
 *  Author: piani
 */ 


#include <avr/io.h>
#include <avr/interrupt.h>

#include "main.h"
#include "Callbacks.h"
#include "TIMERS.h"
#include "Segments.h"


// VARIABLES GLOBALES
unsigned char tmp_int; // pour l'interruption du timer
extern unsigned char bouton_on;
// VARIABLES POUR CALLBACKS TIMER
void (*My_CB[MAX_CALLBACKS])(void);
unsigned int Time_CB[MAX_CALLBACKS];
unsigned int TICK_CB[MAX_CALLBACKS];
// DECLARATION DES FONCTIONS INTERNES

// CONTENU DES FONCTIONS EXTERNES
void Callbacks_Init(void)
{
 unsigned char i ;
 // INITIALISATION POUR VARIABLES CALLBACKS TIMER
 for (i = 0 ; i < MAX_CALLBACKS; i++)
 {
 My_CB[i] = 0;
 Time_CB[i] = 0;
 }
} 
// ENREGISTREMENT CALLBACKS TIMER
unsigned char Callbacks_Record_Timer(void(*pt_Function)(void), unsigned int Time)
{
 unsigned int i = 0;
 while (My_CB[i] != 0 && i < MAX_CALLBACKS) i++;
 if (i < MAX_CALLBACKS)
 {
 My_CB[i] = pt_Function;
 Time_CB[i] = Time;
 TICK_CB[i]= 0;
 return i;
}
// IL N’Y A PLUS DE PLACE POUR ENREGISTRER UN CALLBACK
else return 255;
}

// RETIRER FONCTION DE RAPPEL
void Callbacks_Remove_Timer(unsigned char ID_CB)
{
 if (ID_CB > 0 && ID_CB < MAX_CALLBACKS)
 {
 My_CB[ID_CB] = 0; 
 Time_CB[ID_CB] = 0;
}
}
// BOUCLE PRINCIPALE DE L’OS
void callbacks_Start(void)
{
unsigned char idx;


// INITIALISATION DE TOUTES LES INTERRUPTIONS
sei();
// CONFIGURATION TIMER
TIMER0_Init_1ms();
// BOUCLE INFINIE
while (1)
{
 // CHECK LES CONDITIONS POUR RAPPELER LES FONCTIONS LIEES AUTEMPS
 for (idx = 0 ; idx < MAX_CALLBACKS; idx++)
 {
 if (My_CB[idx]) if (TICK_CB[idx] >= Time_CB[idx])
 {
 TICK_CB[idx] = 0;
 My_CB[idx]();
 }
 }
 
 // Programme principal ici
 
}
} 



// INTERRUPTIONS


// INTERRUPTION TIMER
ISR(TIMER1_COMPA_vect)
{
 // AJOURNER TOUS LES TICKS
 for ( tmp_int = 0 ; tmp_int < MAX_CALLBACKS; tmp_int++) TICK_CB[tmp_int]++;
}

ISR(INT0_vect)
{
bouton_on=1;
}