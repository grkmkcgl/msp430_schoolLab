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
list2		.word	11,12,13,14,15,16,17,18,19,20
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
			push	#list2					;passed address of list2 to stack
			mov.w 	#20, r5 				;array length
			push 	r5       				;passed addresses to stack
			call 	#switcher				;use function

			jmp		$
			nop

switcher	mov.w	r5, r10					;create int i
			sub.w   #2, sp					;create tmp
			mov.w	sp, r13					;frame pointer
			mov.w   8(r13), r6				;pass list1 to r6
			mov.w	6(r13), r7				;pass list2 to r7
			sub.w 	#2, r5					;to start 2nd array from ending
			add.w	r5, r7					;start r7 from ending

swloop		mov.w	0(r6), 0(r13)			;pass first element to tmp
			mov.w	0(r7), 0(r6)			;ls1[i]=ls2[len-1-i]
			mov.w	0(r13), 0(r7)			;give tmp value to list element
			sub.w	#2, r10					;increase i
			add.w 	#2, r6					;lower one array while increase other
			sub.w	#2, r7
			cmp		#0, r10					;check i condition
			jnz		swloop
			add.w   #2, sp					;clear tmp
			ret

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
            
