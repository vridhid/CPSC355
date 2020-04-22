// GLOBAL VARIABLES
MAXOP = 20					// Maxop == 20
NUMBER = 0					// Number == 0 
TOOBIG = 9					// Toobig == 9
MAXVAL = 100					// Maxval == 100

// PRINT STATEMENTS THROUGHOUT THE CODE
stackFull:	.string "error: stack full\n"
stackEmpty:	.string "error: stack empty\n"
ungetch:	.string "ungetch: too many characters\n"

.data
sp: .word 0

.bss						// bss section starts
val: .skip MAXVAL * 4				// queue int array global variable

.text	


.balign 4
.global push					// make push global
.global pop					// make pop global
.global clear					// make clear global 

//PUSH()	
push:	
	stp x29, x30, [sp, -16]!		// allocate memory
	mov x29, sp				// update x29

	mov w10, w0				// place value of input f into w9

	adrp x11, sp				// place sp address in x11 register
	add x11, x11, :lo12:sp			// format lower 12 bits correctly
	ldr w11, [x11]				// set w11 to the value of x11	
	
	adrp x12, val				// place val address in x12 register
	add x12, x12, :lo12:val			// format lower 12 bits correctly
	ldr w12, [x12]				// set w12 to the value of x12	
	
	cmp w11, MAXVAL				// compare sp and MAXVAL
	b.ge push_else				// if sp >= MAXVAL jump to push_else, else continue down
	
	add w11, w11, 1				// sp--: sp, sp, 1 (add 1 to sp)
	str w11, [x11]				// replace new sp entry with old one
	str w10, [x12, w11, SXTW 2]		// f = val[sp++]; sp has already been incremented and value is placed into f 
	
	b push_ret				// now go branch to push_ret to end function

push_else:
	adrp x9, stackFull			// print error message: "error: stack full\n"
	add x9, x9, :lo12:stackFull		// add string to x9 register
	bl printf				// print message
	bl clear				// branch to clear function 
	mov w0, 0				// get function to return 0

push_ret:		
	ldp x29, x30, [sp], 16			// de-allocate memory 
	ret					// return to main function

//POP()
pop:			
	stp x29, x30, [sp, -16]!		// allocate memory
	mov x29, sp				// update x29

	adrp x11, sp				// place sp address in x11 register
	add x11, x11, :lo12:sp			// format lower 12 bits correctly
	ldr w11, [x11]				// set w11 to the value of x11	

	cmp w11, 0				// compare sp and 0
	b.gt pop_else				// if sp > 0 jump to pop_else, else continue down 

	adrp x9, stackEmpty			// print error message: "error: stack empty\n"
	add x9, x9, :lo12:stackEmpty		// add string to x9 register	
	bl printf				// print message
	bl clear				// branch to clear function 
	mov w0, 0				// get function to return 0

	b pop_ret

pop_else:
	sub w11, w11, 1				// sp--: sp, sp, 1  (subtract 1 from sp)		
	
	adrp x12, val			// place val address in x10 register
	add x12, x12, :lo12:val	// format lower 12 bits correctly
	ldr w12, [x12, w11, SXTW 2]	// set w12 to the value of val[--sp] 
			
	mov w0, w11			// get function to return w0 which holds val[--sp] now

pop_ret:		
	ldp x29, x30, [sp], 16			// de-allocate memory
	ret					// return to main function

//CLEAR()
clear:			
	stp x29, x30, [sp, -16]!		// allocate memory
	mov x29, sp				// update x29

	adrp x11, sp				// place sp address in x11 register
	add x11, x11, :lo12:sp			// format lower 12 bits correctly
	ldr w11, [x11]				// set w11 to the value of x11

	mov w11, 0				// sp = 0: move 0 into w11
	str w11, [x11]				// Store new value of sp into memory.

	ldp x29, x30, [sp], 16			// de-allocate memory
	ret					// return to main function

