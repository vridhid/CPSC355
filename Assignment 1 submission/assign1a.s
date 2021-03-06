/* CPSC 355 - Assignment 1 - Part A

QUESTION:
	Find the maximum of y = -2x^3 - 22x^2 + 11x + 57 in the range -10 <= x <= 4
	For version 1, single step through the program (use ni) for at least one iteration of your loop,
	displaying the instruction being executed (use display/i $pc).
	Also print out the contents of particular registers (use p) at key points in your program to show that it is working as expected..
	*/

values:		.string " || For X = %d	|| Y = %d	|| The current maximum of Y = %d.	|| \n"// Format of string visible to user.
	.balign 4							 // Aligns instructions by 4 bits.

	.global main							 // Makes the label "main" visible.

main:		stp x29, x30, [sp, -16]!					 // stores the contents of the pair of registers to the RAM.
	// allocates 16 bytes.
	mov x29, sp							 // Updates FP to current SP.

	mov x19, -10							 // Reserve a register for X to start with a value is -10
	mov x20, 0							 // Reserve a register for Y and initialize to 0.
	mov x21, 0							 // Reserve a register for maximum Y.

	mov x28, 0							 // Loop counter. Used to initialize the first Y_max.

test:		cmp x19, 4							 // Compare x19 (variable X) with the constant 4
	b.gt done							 // If X > 4, branch to "done".

	mov x20, 0							 // Re-initialize Y to 0 for the beginning of each iteration.

	add x20, x20, 57						 // Add 57 to Y

	mov x22,11							 // x22 register used as temporary register. Start by placing 11 into it.
	mul x22, x22, x19						 // Multiply 11*x and store in x22
	add x20, x20, x22						 // x20 = x20 + x22 (Y = 57 + 11x)

	mov x22, -22							 // Place -22 into x22 register
	mul x22, x22, x19						 // x22 = x22 * x19 ( == -22x)
	mul x22, x22, x19						 // x22 = x22 * x19 ( == -22x^2)
	add x20, x20, x22						 // x20 = x20 + x22 ( Y = 57 + 11x - 22x^2)

	mov x22, -2							 // Place -2 into x22 register
	mul x22, x22, x19						 // x22 = x22 * x19 ( == -5x)
	mul x22, x22, x19						 // x22 = x22 * x19 ( == -5x^2)
	mul x22, x22, x19						 // x22 = x22 * x19 ( == -5x^3)
	add x20, x20, x22						 // x20 = x20 + x22 ( Y = 31 + 4x - 31x^2 -5x^3)

	cmp x28, 0							 // If the loop counter is 0, then the y_max should be set to the current Y value.
	b.eq up_Y

	cmp x20, x21							 // Compares Y and Y_max. If Y is greater than current Y_max, then branch to update Y max.
	b.gt up_Y							 // If Y > Y-Max, set Y-Max = Y

l_end:		adrp x0, values							 // Set the 1st argument to printf
	add x0, x0, :lo12: values					 // Add the low 12 bits to x0
	mov x1, x19							 // Place value of X into x1 register
	mov x2, x20							 // Place value of Y into x2 register
	mov x3, x21							 // Place value of Y-maximum into x3 register

	bl printf							 // Calls the printf function
	add x19, x19, 1							 // Increments X by 1
	add x28, x28, 1							 // Increments loop counter by 1
	b test								 // End of code inside the loop. Return to test if loop should repeat

up_Y:		mov x21, x20							 // Places the value of Y into Y_max
	b l_end								 // Returns to the end of the loop

done:		mov x0, 0							 // Code upon completion
	// Return the x0 register to 0
	ldp x29, x30, [sp], 16						 // Restore FP and LR from stack, post-increment SP

	ret								 // Return to caller
	
