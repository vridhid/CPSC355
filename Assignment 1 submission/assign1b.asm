/*  CPSC 355 - Assignment 1: Part B
	
Find the maximum of y = -2x^3 - 22x^2 + 11x + 57 in the range -10 <= x <= 4
For version 2, set a breakpoint just after the place where the final result is calculated, and then print out the maximum. 
Do not single step through this version.
*/
		define(x_r, x19)								// x19 register set to x_r ( x val )
		define(y_r, x20)								// x21 register set to y_r ( y val )
		define(ymax, x21)								// x21 register set to ymax ( maximum Y value )
		define(temp, x22)								// x22 register set to temporary variable
	
		define(coef1, x23)								// x23: coefficient for the 1st term
		define(coef2, x24)								// x24: coefficient for the 2nd term
		define(coef3, x25)								// x25: coefficient for the 3rd term
		define(coef4, x26)								// x26: coefficient for the 4th term
		define(counter, x28)								// Loop counter: initialize the first Y_max.	

	
values:		.string " || For X =  %d	|| Y = %d	|| The current maximum of Y = %d	|| \n"		//Format of string visible to user  
		.global main 									//Makes the label "main" visible to the OS
		.balign 4									// Aligning the code by 4 bits
	

main:		stp x29, x30, [sp, -16]! 							// stores the contents of the pair of registers to RAM by allocating 16 bytes in SM
		mov x29, sp 									//Update frame pointer to current stack pointer 

		mov coef1, -2 									 // x23 contains -2
		mov coef2, -22									 // x24 contains -22
		mov coef3, 11									 // x25 contains 11
		mov coef4, 57 									 // x26 contains 57 
		mov x_r, -10	  							         // x19 set to a value of -10

		mov counter, 0									// Set loop counter to 0.
		b test										// Branch to test at bottom of loop.

top:		mov y_r, 0									//Re-initialize Y to 0 for the beginning of each iteration.
		mov temp, 0									//Re-set temp_r to 0

		add y_r, y_r, coef4								//Add 57 to Y

		madd y_r, coef3, x_r, y_r							//y_r = y_r + (x_r * coef3_r) (Y = -22 + 11X)	

		mul temp, coef2, x_r								//temp_r = coef2_r * x_r (Temp = -22X)
		madd y_r, temp, x_r, y_r							//y_r = temp_r * x_r + temp_r   (Y = 22 + 4X - 22X^2)

		mov temp, 0									//Re-set temp_r to 0
		mul temp, coef1, x_r								// temp_r = coef1_r * X ( = -2X)
		mul temp, temp, x_r								// temp_r = temp_r * X ( = -2X^2)
		madd y_r, temp, x_r, y_r							// y_r = temp_r * X + y_r   (Y = 57 + 11X - 22X^2 - 2X^3)

		cmp counter, 0									//If the loop counter is 0, then the Y_max should be set to the current Y value.
		b.eq updateYmax
		
		cmp y_r, ymax									//Compares Y and Y_max. If Y is greater than current Y_max, then branch to update Y max.
		b.gt updateYmax									// If Y > Y-Max, set Y-Max = Y 

loopend:
		adrp x0, values									// Set the 1st argument of printf
		add x0, x0, :lo12:values							// Add the low 12 bits to x0
		mov x1, x_r									// Place the value of X into the x1 register for the printf argument.
		mov x2, y_r									// Place the value of Y into the x2 register for the printf argument.
		mov x3, ymax									// Place the value of Y-maximum into the x3 register for the printf argument.

		bl printf									//Calls the printf function.
		add x_r, x_r, 1									//Increments X by 1.
		add counter, counter, 1								//Increments loop counter by 1.
		b test										// <--- End of code inside the loop. Return to test if loop should go again.

	
updateYmax:	mov ymax, y_r									//Places the value of Y into Y_max
		b loopend									//Returns to the end of the loop.
	
test:		cmp x_r, 4									//Compare X variable with the immediate 4
		b.le top									//If X < 5, branch to "top"

done:		mov x0, 0									// <--- Code upon completion. (When X > 4) 
												// Return the x0 register to 0.
		ldp x29, x30, [sp], 16								// Restore FP and LR from stack, post-increment SP

		ret										// Return to caller
