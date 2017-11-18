// Main.h

#ifndef _main_h_
#define _main_h_

// INCLUDE (si applicable)


// DEFINE 

// Gestion registre par bit unique
#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port

// I/O
		 	




// Interruptions		 


// USART

//Divers
#define TRUE				1
#define FALSE				0




#endif /* _main.h */
