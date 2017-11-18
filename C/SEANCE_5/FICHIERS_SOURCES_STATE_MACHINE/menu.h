// menu.h
#ifndef _menu_h_
#define _menu_h_


#include "main.h"


#ifndef PGM_P
#define PGM_P const rom char *  
#endif


typedef struct PROGMEM
{
    unsigned char state;
    unsigned char input;
    unsigned char nextstate;
} MENU_NEXTSTATE;


typedef struct PROGMEM
{
    unsigned char state;
    PGM_P pText;	
    char (*pFunc)(char input);
} MENU_STATE;


// Menu text
const char TXT_START[] PROGMEM =	"HELHA";
const char TXT_TEMP[] PROGMEM =	 	"TEMP ";
const char TXT_T_INST[] PROGMEM =	"INST ";
const char TXT_T_MIN[] PROGMEM =	"MIN  ";
const char TXT_T_MAX[] PROGMEM = 	"MAX ";
const char TXT_USART[] PROGMEM =	"USART";
const char TXT_ENVOI[] PROGMEM =	"ENVOI";
const char TXT_RECEP[] PROGMEM =	"RECEP";
const char TXT_TIMER[] PROGMEM =	"TIMER";
const char TXT_CHRON[] PROGMEM =	"CHRON";
const char TXT_PWM[] PROGMEM = 		"PWM  ";


const MENU_NEXTSTATE menu_nextstate[] PROGMEM = {
//  STATE                       INPUT       NEXT STATE
// MENUS

	{ST_START_TXT,              KEY_DOWN,   ST_TEMPERATURE_TXT},
    {ST_START_TXT,              KEY_RIGHT,  ST_TEMPERATURE_TXT},
	{ST_START_TXT,              KEY_LEFT,   ST_TEMPERATURE_TXT},
	{ST_START_TXT,				KEY_UP,		ST_TEMPERATURE_TXT},
	{ST_START_TXT,				KEY_PUSH,	ST_TEMPERATURE_TXT},
	
 
// SOUS-MENUS 1

    {ST_TEMPERATURE_TXT,        KEY_RIGHT, 	ST_USART_TXT},
    {ST_TEMPERATURE_TXT,        KEY_UP,    	ST_START_TXT},
    {ST_TEMPERATURE_TXT,        KEY_DOWN, 	ST_TEMP_INST_TXT},
		
	{ST_USART_TXT,				KEY_RIGHT,	ST_TIMER_TXT},
	{ST_USART_TXT,				KEY_UP, 	ST_START_TXT},
	{ST_USART_TXT,				KEY_DOWN,	ST_ENVOI_TXT},
	{ST_USART_TXT,				KEY_LEFT,	ST_TEMPERATURE_TXT},

	{ST_TIMER_TXT,				KEY_UP,		ST_START_TXT},
	{ST_TIMER_TXT,				KEY_LEFT,	ST_USART_TXT},
	{ST_TIMER_TXT,				KEY_DOWN,	ST_CHRON_TXT},
	

// SOUS-MENUS 2

	{ST_TEMP_INST_TXT,          KEY_UP, 	ST_TEMPERATURE_TXT},	 
	{ST_TEMP_INST_TXT, 			KEY_DOWN,	ST_TEMP_MIN_TXT},
	{ST_TEMP_INST_TXT, 			KEY_PUSH,	ST_TEMPERATURE_PROC},
   	
	{ST_TEMP_MIN_TXT,			KEY_UP,		ST_TEMP_INST_TXT},
	{ST_TEMP_MIN_TXT,			KEY_DOWN,	ST_TEMP_MAX_TXT},
	{ST_TEMP_MIN_TXT,			KEY_PUSH,	ST_TEMP_MIN_PROC},

	{ST_TEMP_MAX_TXT,			KEY_UP, 	ST_TEMP_MIN_TXT},
	{ST_TEMP_MAX_TXT,			KEY_PUSH,	ST_TEMP_MAX_PROC},

	{ST_ENVOI_TXT,				KEY_UP, 	ST_USART_TXT},
	{ST_ENVOI_TXT,				KEY_DOWN,	ST_RECEP_TXT},
	{ST_ENVOI_TXT,				KEY_RIGHT,	ST_ENVOI_TEMP_TXT},

	{ST_RECEP_TXT,				KEY_UP, 	ST_ENVOI_TXT},
	{ST_RECEP_TXT,				KEY_PUSH,	ST_RECEP_PROC},

	{ST_CHRON_TXT,				KEY_UP, 	ST_TIMER_TXT},
	{ST_CHRON_TXT,				KEY_DOWN,	ST_PWM_TXT},
	{ST_CHRON_TXT,				KEY_PUSH,	ST_INIT_CHRONO_PROC},

	{ST_PWM_TXT,				KEY_UP, 	ST_CHRON_TXT},
	{ST_PWM_TXT,				KEY_PUSH,	ST_PWM_PROC},
	

// SOUS-MENUS 3

	{ST_ENVOI_TEMP_TXT,			KEY_LEFT,	ST_ENVOI_TXT},
	{ST_ENVOI_TEMP_TXT,			KEY_DOWN,	ST_ENVOI_TMAX_TXT},				
	{ST_ENVOI_TEMP_TXT,			KEY_PUSH,	ST_ENVOI_TEMP_PROC},

	
// SOUS-MENUS 4

	
	{ST_ENVOI_TMAX_TXT,			KEY_PUSH,	ST_ENVOI_TMAX_PROC},
	{ST_ENVOI_TMAX_TXT,			KEY_DOWN,	ST_ENVOI_TMIN_TXT},
	{ST_ENVOI_TMAX_TXT,			KEY_UP,		ST_ENVOI_TEMP_TXT},

	{ST_ENVOI_TMIN_TXT,			KEY_UP,		ST_ENVOI_TMAX_TXT},
	{ST_ENVOI_TMIN_TXT,			KEY_PUSH,	ST_ENVOI_TMIN_PROC},

		
	{0,                         0,          0},
};


const MENU_STATE Menu_State[] PROGMEM = {
//  STATE                               STATE TEXT                  STATE_FUNC

    {ST_START_TXT,                      TXT_START,   		        NULL},
	
	{ST_TEMPERATURE_TXT,				TXT_TEMP,					NULL},
	{ST_TEMP_INST_TXT,					TXT_T_INST,					NULL},
	{ST_TEMPERATURE_PROC,				NULL,						LCD_T_Inst},
	{ST_TEMP_MIN_TXT,					TXT_T_MIN,					NULL},
	{ST_TEMP_MIN_PROC,					NULL,				    	LCD_T_Min},
	{ST_TEMP_MAX_TXT,					TXT_T_MAX,					NULL},
	{ST_TEMP_MAX_PROC,					NULL,						LCD_T_Max},

	{ST_USART_TXT,						TXT_USART,					NULL},
	{ST_ENVOI_TXT, 						TXT_ENVOI,					NULL},
	{ST_ENVOI_TEMP_TXT,   				TXT_TEMP,					NULL},
	{ST_ENVOI_TEMP_PROC,				NULL,						USART_T_Inst},
	{ST_ENVOI_TMAX_TXT,  				TXT_T_MAX,					NULL},
	{ST_ENVOI_TMAX_PROC,				NULL,						USART_T_Max},
	{ST_ENVOI_TMIN_TXT,					TXT_T_MIN,					NULL},
	{ST_ENVOI_TMIN_PROC,				NULL,						USART_T_Min},				
	{ST_RECEP_TXT,						TXT_RECEP,					NULL},
	{ST_RECEP_PROC,						NULL,						USART_RX},

	{ST_TIMER_TXT,						TXT_TIMER,					NULL},
	{ST_CHRON_TXT, 						TXT_CHRON,					NULL},
	{ST_INIT_CHRONO_PROC,				NULL,						Init_Chrono},
	{ST_RUN_CHRONO_PROC, 				NULL,						Run_Chrono},
	{ST_STOP_CHRONO_PROC,				NULL,						Stop_Chrono},

	{ST_PWM_TXT,						TXT_PWM,					NULL},
	{ST_PWM_PROC,  						NULL,						PWM_50},

    {0,                                 NULL,                       NULL},

};




#endif /* _menu.h */
