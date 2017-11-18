#ifndef __INITTIMER1_H
#define __INITTIMER1_H


//D�finit le nombre maximal de callback de type Chrono
#define	MAX_CALLBACKS		10

// PROTOTYPE DES FONCTIONS EXTERNES
//**********************************************************
//********** FONCTIONS POUR LE MOTEUR OS *******************
//**********************************************************

//Initialisation des Callbacks
void Callbacks_Init(void);

//Enregistrer des fonctions callback li�es au temps
//Retourne un ID associ� � l'enregistrement
unsigned char Callbacks_Record_Timer(void(*pt_Function)(void), unsigned int Time); 

//Retirer des fonctions callback li�es au temps, prend l'ID du CallBack comme argument
char Callbacks_Remove_Timer(unsigned char IDCB);


//D�marrage de la boucle principale
void Callbacks_Start(void);


#endif //__INITTIMER1_H
