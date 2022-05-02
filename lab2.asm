;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.


            .data
array		.word	9712, 2454, 1275, 3312, 4243, 2395, 4387, 12236, 9454, 32221
arrayfinish .word	0						;to understand data is finished
cmpvalue	.word	10000					;value for comparasion
			.bss	buffer, 20				;20 byte long uninitialized space
			.bss	end,1					;to understand bss section finished
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;1 -  Using assembler directives, create an array in the memory,
;and initialize it with thenumbers below (use .word)
;2 - Find the number of elements that are greater than 10000 in the array created in step 1

			mov.w	#arrayfinish,r7
			mov.w	#0x0000, r6				;0 value in r6
			mov.w	#array, r4				;passed arrays first address
			mov.w	cmpvalue, r5			;changed r5 registers value


comparator	cmp 	r4,r7					;conditions to understand whether array is finished
			jz		filler					;zero flags set to 1, comperasion task is finished
			cmp		@r4+, r5				;compare r5 with r4 and increase array address
			jn		found					;N flags turns to 1 if a value found bigger then jmp
			jmp 	comparator				;jump back to start

found		add.w	#1, r6					;increase r6 value if number bigger than 10000 is found
			jmp comparator					;go back to comparator

;3 – Create a 20 byte-long uninitialized section in the memory (use .bss).
;4 – Fill the buffer created in step 3 with even numbers starting from 2.

filler		mov.w	#buffer, r10			;send buffer address to r10
			mov.w	#end, r12				;send end of section address to r12
			mov.w	#2, r11					;set first value
			clrz							;clear zero bit (to be sure for end of buffer)

adder		cmp		r10,r12					;conditions to understand whether bss is finished
			jz		finish					;finish when zero flag is set(end of buffer)
			mov.w 	r11, 0(r10)				;pass value of r11 to buffer segment
			add.w   #2, r11					;add 2 and repeat to get even numbers
			add.w	#2,	r10					;pass to next word
			jmp 	adder					;turn back to loop until finish

;To fill 1 by 1 we can use .b commands instead of .w

finish      jmp $
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
            
