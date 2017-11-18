// Button.h
#ifndef _Button_H_
#define _Button_H_

/*
    
    Bit             7   6   5   4   3   2   1   0
    ---------------------------------------------
    PORTB           B   A       O
    PORTE                           D   C
    ---------------------------------------------
    PORTB | PORTE   B   A       O   D   C
    =============================================
*/


// DEFINE

#define PINB_MASK ((1<<PINB4)|(1<<PINB6)|(1<<PINB7))
#define PINE_MASK ((1<<PINE2)|(1<<PINE3))

#define Joystick_UP		 6
#define Joystick_DOWN    7
#define Joystick_LEFT    2
#define Joystick_RIGHT   3
#define Joystick_PUSH    4 			

//Button definitions
#define KEY_NULL    0
#define KEY_PUSH    1
#define KEY_RIGHT   2
#define KEY_LEFT    3
#define KEY_UP      4
#define KEY_DOWN    5


// PROTOTYPE FONCTIONS EXTERNES
void PinChangeInterrupt(void);
void Button_Init(void);
char getkey(void);


#endif /* _Button_H */



