#include <msp430.h> 

#define SW  BIT1 //switch P1.1
#define LED BIT0 //green led P1.0

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;       // enable current to outputs

    P1SEL0 = 0x0;               // select gpio function
    P1SEL1 = 0x0;               // select gpio function
    P1DIR = LED;                // set P1 as output (LED)
    P1REN |= 0x02;              // enable pull up resistor for switch
    P1OUT = SW;                 // select pull up for switch

    while(1) {
        if((P1IN & SW) == 0) {              // check if button is pressed
            P1OUT ^= LED;                   // change bit according to previous value (toggle)
            __delay_cycles(1000000);        // wait for 1 second (1 hz)
        }                                   // blinking process when button is pressed
        else {
            P1OUT &= ~LED;                  // close led when button is not pressed.
        }
    }


    return 0;
}
