Connect the temperature sensor to the Launchpad through the breadboard. Refer to the datasheets of the respective components. Set ADC reference voltage to be 2.5 V. The voltage change with temperature will roughly be 10 mV per 1 °C.

Using a timer interrupt that activates every 50 ms, write a program that reads the temperature and stores the result in an array. For example, if the array is 100-elements long, first interrupt stores to array[0], second interrupt stores to array[1], etc. When the array is full, loop back to the start (array[0]).
