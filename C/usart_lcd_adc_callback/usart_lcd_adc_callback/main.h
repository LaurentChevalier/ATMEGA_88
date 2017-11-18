// Main.h

#ifndef _main_h_
#define _main_h_

//****************************************
//  CONSIGNES ET OBJECTIFS DU PROGRAMME
//****************************************


// DEFINE 

void affichage_USART(char*);

// Gestion registre par bit unique
#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port


#define TRUE				1
#define FALSE				0

#define TEMPERATURE_MAX		30
#define TEMPERATURE_MIN		10

enum {NONE, UP, DOWN, LEFT, CENTER, RIGHT};	// Used with the button variable
enum {OFF, ON};
enum {ZERO = 11,ONE = 22, TWO = 33};        // Used for the DATALOGGER


#endif /* _main.h */
