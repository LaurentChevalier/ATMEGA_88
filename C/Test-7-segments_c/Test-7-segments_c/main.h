/*
 * main.h
 *
 * Created: 22-09-16 11:22:05
 *  Author: piani
 */ 


#ifndef MAIN_H_
#define MAIN_H_

#define sbiBF(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbiBF(port,bit)  (port &= ~(1<<bit))  //clear bit in port
#define tgBF(port,bit) (port ^=(1<<bit))

#define TRUE				1
#define FALSE				0



#endif /* MAIN_H_ */