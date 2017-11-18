// Main.h

#ifndef _main_h_
#define _main_h_

//****************************************
//  CONSIGNES ET OBJECTIFS DU PROGRAMME
//****************************************

/*

Objectifs:
Utilisation du TIMER1 (16 bits) pour g�n�rer une interruption toutes les 1ms
Utilisation de l'entr�e INT0 en interruption externe
Utilisation de l'USART en mode transmission � 9600 bauds
Gestion des ports I/O
Gestion des interruptions et de la boucle infinie

Consignes du programme
1. Clignotement de la LED � 0.5 Hertz 
2. Si bouton poussoir appuy� 1X alors activation relais et envoi du texte "RELAIS ACTIVE" sur port USART
3. Si bouton poussoir ON 2X alors d�sactivation du relais et envoi du texte "RELAIS DESACTIVE" sur port USART

*/


// DEFINE 

// Gestion registre par bit unique
#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port


#define TRUE				1
#define FALSE				0




#endif /* _main.h */
