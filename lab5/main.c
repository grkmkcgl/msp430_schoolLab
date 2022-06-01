#include <msp430.h>

float temp[100];               // array to hold temperatures
unsigned int i=0;              // initialized for using in loop

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    /* PIN SETTINGS */
    PM5CTL0 &= ~LOCKLPM5;       // activate gpio
    P1SEL0 |= BIT2;             // activate A2 for ADC function
    P1SEL1 |= BIT2;



    /* ADC SETTINGS */
    while (REFCTL0 & REFGENBUSY);
    REFCTL0 |= REFVSEL_2 + REFON; // 2.5v reference enable

    ADC12CTL0 &= ~ADC12ENC;       // disable ADC to make settings
    ADC12CTL0 = ADC12SHT0_2 + ADC12ON; // set sample hold time
    ADC12CTL1 = ADC12SHP;         // enable sample timer
    ADC12MCTL0 = ADC12VRSEL_1 + ADC12INCH_2; // select A2 channel and set
    // Vr+ = Vref buffered, Vr- = AVSS (ground)
    while (!(REFCTL0 & REFGENRDY));  // wait to settle

    /* TIMER SET UP */
    TA0CCTL0 |= CCIE;           // enable timer interrupts
    TA0CCR0 = 50000;            // 50 ms timer
    TA0CTL |= TASSEL_2 + MC_1;  // use SMCLK clock 1 MHz, count up mode

    _BIS_SR(LPM0_bits + GIE);   // Enter LPM0 with interrupt enable


    while(1) {

    ADC12CTL0 |= ADC12ENC | ADC12SC;    // Sampling and conversion
    _BIS_SR(LPM0_bits + GIE);           // Enter LPM0 with interrupt enable


    if(i == 100) {
        i = 0;                          // start over if array is full
    }

    __no_operation();                   // FOR DEBUGGING PURPOSES
}
}
#pragma vector = TIMER0_A0_VECTOR         // Timer0 A0 ISR
__interrupt void Timer0_A0 (void) {
    temp[i] = ADC12MEM0 * 0.06105;       // read sensor and write value to array
    i++;   // increment i to write next memory location when new interrupt came

    /* Calculation of 0.061035:
     * We select 2.5V as reference, 2.5/10m = 250 celcius
     * 250 celcius = 4095 (since we are using 12 bit conversion)
     * so 1 interval is equal to 250/4095 = 0.06105 celcius
     */


    __bic_SR_register_on_exit(LPM0_bits); // Exit LPM on exit
}

