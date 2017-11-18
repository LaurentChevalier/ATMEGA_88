/*
 * Callbacks.h
 *
 * Created: 22-09-16 11:09:23
 *  Author: piani
 */ 


#ifndef CALLBACKS_H_
#define CALLBACKS_H_

// DEFINE
#define MAX_CALLBACKS 10
// PROTOTYPE DES FONCTIONS EXTERNES
//INITIALISATION DES CALLBACKS
void Callbacks_Init(void) ;
//ENREGISTRER DES FONCTIONS CALLBACKS LIEES AU TEMPS
// RETOURNE UN ID ASSOCIE A L’ENREGISTREMENT
unsigned char Callbacks_Record_Timer(void(*pt_Function)(void), unsigned int Time);
// RETIRER DES FONCTIONS CALLBACKS LIEES AU TEMPS, PREND L’ID DU CALLBACK
// COMME ARGUMENT
void Callbacks_Remove_Timer(unsigned char ID_CB) ;
//DEMARRAGE DE LA BOUCLE PRINCIPALE
void callbacks_Start(void) ; 





#endif /* CALLBACKS_H_ */