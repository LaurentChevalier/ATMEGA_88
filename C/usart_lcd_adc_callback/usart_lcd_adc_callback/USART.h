// USART.h

#ifndef _USART_H_
#define _USART_H_

//INCLUDE



//DEFINE
// F_CPU (fr�quencehorloge du �C) est connu par le compilateur (lors de la configuration du projet)
// La formule du BAUD_RATE est renseign�e dans la DS du 8088 (page 174)
// Asynchronous normal mode (U2X0=0)
//#define UART_BAUD_RATE 							9600L		//9600 bauds
//#define UART_BAUD_CALC(UART_BAUD_RATE,F_CPU)	((F_CPU)/((UART_BAUD_RATE)*16L)-1)

#define MAX_BUFFER 50

//PROTOTYPE FONCTIONS EXTERNES
void Usart_Tx(char data);
void Usart_Tx_String(char *String);
void USART_Init_9600(void);
void USART_Delay(void);
char Usart_Rx(void);



#endif /* _USART_H */
