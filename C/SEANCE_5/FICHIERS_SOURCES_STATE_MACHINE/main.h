// main.h

#ifndef _main_h_
#define _main_h_

//INCLUDE


//DEFINE
#define BOOL    char
#define TRUE 1
#define FALSE 0
#define NULL  0  

// Menu state machine states

/*
#define NOM DE l'ETAT		Nombre (2 chiffres)	*/



// Gestion registre par bit unique
#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port


//PROTOTYPE FONCTIONS EXTERNES
void Initialization(void);
unsigned char StateMachine(char state, unsigned char stimuli);

//PROTOTYPE FONCTIONS APPELEES PAR POINTEURS




#endif /* _main.h */













