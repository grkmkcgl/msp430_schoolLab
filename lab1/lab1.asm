;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			;Q1 Load the number 123 to R9. Move this value to R7
			mov.w 	#0x007B, r9 ; 123 hex is 007B
			mov.w	r9,r7

			;Q2 Load the number 0x4400 to R5. Load the number 99 to R6. Store the contents of R6 to the memory at the address in R5.
			mov.w	#0x4400, r5
			mov.w	#0x0063, r6
			mov.w	r6, 0(r5)

			;Q3 Continuing from 2, load the contents of the memory at the address 0x4400 to R5.
			mov.w	&0x4400, r5

			;Q4 Starting from the address 0x4400, store the numbers 11, 22, 33, 44 to the memory as bytes.
			mov.w	#0x4400, r10
			mov.w	#0x00FF, 0(r10) ; 22
			mov.w   #0x0B, 2(r10) ; 11
			mov.w	#0x2C, 4(r10)
			mov.w	#0x21, 6(r10)

			;Q5 Continuing from 4, add the numbers stored to the memory and store the result in R6
			add.b	0(r10), 1(r10)
			add.b	1(r10), 2(r10)
			add.b	2(r10),	3(r10)
			mov.b	3(r10), r6 ;result should be decimal 110 which is 0x006E in 4003 address

			jmp $
			nop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
