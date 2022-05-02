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
list1		.word	1,2,3,4,5,6,7,8,9,10
list2		.word	0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

			push 	#list1					;passed address of list1 to stack
			push 	#list2					;passed address of list2 to stack
			push 	r5       				;passed addresses to stack
			call 	#adderFunc				;use function


finish		jmp		$						;finish
			nop

adderFunc 	mov.w 	#0, r10    				;create int i (could done with local variable but increases complexity?)
			sub.w	#2, sp					;create sum variable
			mov.w 	sp,r13     				;created frame pointer
			mov.w 	#0, 0(r13)				;sum variable = 0
			mov.w 	6(r13), r7    			;to obtain list2 values use r7 register
			mov.w 	8(r13), r6     			;to obtain list1 values use r6 register

addLoop	 	add.w 	0(r6), 0(r7)    		;list1(i)+list2(i)=list2(i)
			add.w 	0(r7), 0(r13)      		;list2(i) value to *result
			add.w 	#2, r10      			;increased i value
			add.w 	#2, r6 	 				;list(i) to list(i+1)
			add.w 	#2, r7 					;list(i) to list(i+1)
			cmp 	#20, r10    			;check is all array is summed
			jnz 	addLoop      			;dont finish unless condition met
			mov.w	r13, r5					;passed address of r13
			pop 	r5        				;re allocate r5
			ret         					;quit subrotine


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

                                            

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
            
