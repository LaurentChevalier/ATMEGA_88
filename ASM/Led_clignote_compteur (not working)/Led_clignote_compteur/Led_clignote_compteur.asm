/*
 * Led_clignote_compteur.asm
 *
 *  Created: 23-02-16 11:30:43
 *   Author: laurent
 */ 


.org 0
rjmp RESET
rjmp INTERRUPTION
//.org 0X00E rjmp TIM0_COMPA
/*
rjmp EXT_INT1
rjmp TIM2_COMP
rjmp TIM2_OVF
rjmp TIM1_CAPT
rjmp TIM1_COMPA
rjmp TIM1_COMPB
rjmp TIM1_OVF
rjmp TIM0_OVF
rjmp SPI_STC
rjmp USART_RXC
rjmp USART_UDRE
rjmp USART_TXC
rjmp ADC
rjmp EE_RDY
rjmp ANA_COMP
rjmp TWSI
rjmp EXT_INT2
rjmp TIM0_COMPPIND 2 16
rjmp SPM_RDY
*/
.org $20
reset:
ldi r16,high(ramend)
out sph,r16
ldi r16,low(ramend)
out spl,r16
sei
//config interuption externe

ldi r20,0b00000011
sts EICRA,r20
ldi r17,0b00000001
out eimsk,r17
//ldi r18,0b00000010
//out mcucr,r18
ldi r19,0b11111111
out ddrb,r19
//config sortie
out portb,r16
//config timer0
ldi r16,0b00000010
out tccr0A,r16
ldi r16,0b00000101
out tccr0A,r16
ldi r16,0b11111111

//Programme principal
Main:

in r16, tcnt0
com r16
out portb,R16
rjmp Main

// Interruption externe
INTERRUPTION:

cpi r19,0
brne eteind
ldi r16,0b00000101
out tccr0B,r16
ldi r19,1
rjmp fin

eteind:
out tcnt0,r16
out tccr0B,r16
ldi r16,0b11111111
ldi r19,0
fin:
reti