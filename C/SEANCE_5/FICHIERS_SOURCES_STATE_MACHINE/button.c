// Fonctions liées au joystick

//INCLUDE
#include "button.h"
#include "main.h"
#include <avr/io.h>
#include <avr/interrupt.h>


//DECLARATION DES VARIABLES GLOGALES
volatile char KEY = NULL;
volatile char KEY_VALID;


//PROTOTYPE FONCTIONS INTERNES


//CONTENU FONCTIONS EXTERNES
void Button_Init(void)
{
    // Init port pins
	DDRB |=(0<<DDB7)|(0<<DDB6)|(0<<DDB4);
	PORTB |= PINB_MASK;
	// Pin PE3, PE2 en INPUT
    DDRE |= (0<<DDE3)|(0<<DDE2);
    PORTE |= PINE_MASK;
    // Enable pin change interrupt on PORTB and PORTE
	//PE2 = PCINT2, PE3 =PCINT3, PB4=PCINT12, PB6=PCINT14, PB7=PCINT15
    PCMSK0 = PINE_MASK;
    PCMSK1 = PINB_MASK;
    EIFR = (1<<PCIF0)|(1<<PCIF1); // Delete pin change interrupt flags
    EIMSK = (1<<PCIE0)|(1<<PCIE1);  
}


ISR(PCINT0_vect)
{
    PinChangeInterrupt();
}


ISR(PCINT1_vect)
{
    PinChangeInterrupt();
}


void PinChangeInterrupt(void)
{
    char buttons;
    char key;
    buttons = (~PINB) & PINB_MASK;
    buttons |= (~PINE) & PINE_MASK;

    // Output virtual keys
    if (buttons & (1<<Joystick_UP))
        key = KEY_UP;
    else if (buttons & (1<<Joystick_DOWN))
        key = KEY_DOWN;
    else if (buttons & (1<<Joystick_LEFT))
        key = KEY_LEFT;
    else if (buttons & (1<<Joystick_RIGHT))
        key = KEY_RIGHT;
    else if (buttons & (1<<Joystick_PUSH))
        key = KEY_PUSH;
    else
        key = KEY_NULL;
    if(key != KEY_NULL)
    {
       if (!KEY_VALID)
       {
          KEY = key;          
          KEY_VALID = TRUE;
       }
    }
    EIFR = (1<<PCIF1) | (1<<PCIF0);     // Delete pin change interrupt flags
}


char getkey(void)
{
    char k;
    cli();
    if (KEY_VALID)              // Check for unread key in buffer
    {
        k = KEY;
        KEY_VALID = FALSE;
    }
    else
        k = KEY_NULL;           // No key stroke available
    sei();
    return k;
}
