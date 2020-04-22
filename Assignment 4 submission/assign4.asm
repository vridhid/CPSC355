	// Define macros
	define(FALSE, 0)
	define(TRUE, 1)

	// Printf statements
fpt:		.string "Cuboid %s origin = (%d, %d) Base width = %d Base length = %d Height = %d Volume = %d\n"
spt:		.string "Initial cuboid values:\n"						// Print statement to display initial values
tpt:		.string "\nChanged cuboid values:\n"						// Print statement to dispay changed values

first:		.string "first"									// "first" print statement
second:		.string "second"								// "second" print statement

	.balign 4									// Aligned by 4 bytes

	// STRUCT EQUATES

	// EQUATES FOR POINT
	xPoint_s = 0									// offset of xPoint_s from base of struct point
	yPoint_s = 4									// offset of yPoint_s from base of struct point
	point_size = 8									// size of struct point
	// END STRUCT POINT

	// EQUATES FOR DIMENSION
	wDim_s = 0									// offset of wDim_s from  base of struct dimension
	lDim_s = 4									// offset of lDim_s from base of struct dimension
	dim_size = 8									// base of struct dimension
	// END STRUCT DIMENSION

	// EQUATES FOR CUBOID
	cuboid_origin = 0								// offset of "point" within struct "cuboid"
	cuboid_base = 8									// initialize the base of the cuboid
	cuboid_height = 16								// initialize height
	cuboid_volume = 20								// volume of the struct cuboid
	// END STRUCT CUBOID
	// END STRUCT EQUATES

	// MEMORY ALLOCATION
	base_off = 16									// base offset of the cuboid

	// EQUATES
	cuboid_1 = 20									// assembler equate of cuboid 1
	cuboid_2 = 20									// assembler equate of cuboid 2
	total_size = cuboid_base							// calculate total_size

	alloc = -(16 + total_size) & -16						// define total memory allocation
	dealloc = -alloc								// set size to be deallocated
	cuboid_s = 16									// cuboid volume
	first_s = 16									// offset of cuboid_1
	second_s = 36									// offset of cuboid_2

	// newCuboid Struct Method

newCuboid:
	stp x29, x30, [sp, alloc]!							// Allocate 16 bytes of memory from the newCuboid frame record
	mov x29, sp									// Move the stack pointer to the frame pointer.

	// Initialize cuboid variables
	mov w1, 0									// register w1 --> holds 0
	str w1, [x29, cuboid_s + cuboid_origin + xPoint_s]				// storing w1 back into the stack

	mov w2, 0									// register w2 --> holds 0
	str w2, [x29, cuboid_s + cuboid_origin + yPoint_s]				// storing w2 back into the stack

	mov w3, 2									// register w3 --> holds 2
	str w3, [x29, cuboid_s + cuboid_base + wDim_s]					// storing w3 into the stack

	mov w4, 2									// register w4 --> holds 2
	str w4, [x29, cuboid_s + cuboid_base + lDim_s]					// storing w4 into the stack

	mov w5, 3									// register w5 --> holds 3
	str w5, [x29, cuboid_s + cuboid_height]				// storing w5 into the stack

	mul w6, w3, w4									// multiply w3 and w4 and store in w6
	mul w6, w5, w6									// multiply w5 and w6 and store in w6 (replaces value in w6)
	str w6, [x29, cuboid_s + cuboid_volume]						// storing w6 back into the stack

	// Return c to main
	ldr w9, [x29, cuboid_s + cuboid_origin + xPoint_s]				// load cuboid point x into w9
	str w9, [x8, cuboid_origin + xPoint_s]						// store w9 as cuboid in point x

	ldr w9, [x29, cuboid_s + cuboid_origin +yPoint_s]				// load cuboid point y into w9
	str w9, [x8, cuboid_origin + yPoint_s]						// store w9 as cuboid in point y

	ldr w9, [x29, cuboid_s + cuboid_base + wDim_s]					// load cuboid dim w into w9
	str w9, [x8, cuboid_base + wDim_s]						// store w9 as cuboid in dimension w

	ldr w9, [x29, cuboid_s + cuboid_base + lDim_s]					// load cuboid dim l into w9
	str w9, [x8, cuboid_base + lDim_s]						// store w9 as cuboid in dimension l

	ldr w9, [x29, cuboid_s + cuboid_height]				// load cuboid height into w9
	str w9, [x8, cuboid_height]					// store w9 as cuboid in height

	ldr w9, [x29, cuboid_s + cuboid_volume]						// load cuboid volume into w9
	str w9, [x8, cuboid_volume]							// store w9 as cuboid into cuboid a

	ldp x29, x30, [sp], dealloc							// De-allocate the subroutine memory
	ret										// Return to caller

	// VOID MOVE
move:
	stp x29, x30, [sp, -16]!							// Allocate 16 bytes of memory from the newcuboid frame record
	mov x29, sp									// Set x29 to the value of sp

	// c.origin.x += deltaX
	ldr w9, [x0, cuboid_origin + xPoint_s]						// load current cuboid X value
	add w9, w9, w1									// add w9 and w1 and store in w9
	str w9, [x0, cuboid_origin + xPoint_s]						// store new cuboid X value

	// c.origin.y += deltaY
	ldr w10, [x0, cuboid_origin + yPoint_s]						// load current cuboid Y value
	add w10, w10, w2								// add w10 and w2 and store into w10
	str w10, [x0, cuboid_origin + yPoint_s]						// store new cuboid Y value

	ldp x29, x30, [sp], 16								// De-allocate the subroutine memory
	ret										// Return to caller

	// VOID SCALE
scale:
	stp x29, x30, [sp, -16]!							// Allocate 16 bytes of memory from the newcuboid frame record
	mov x29, sp									// setting x29 to the value of sp

	// c.base.width *= factor
	ldr w9, [x0, cuboid_base + wDim_s]						// load current dim W value
	mul w9, w9, w1									// w9 = w9 * w1
	str w9, [x0, cuboid_base + wDim_s]						// store new dim W value

	// c.base.length *= factor
	ldr w10, [x0, cuboid_base + lDim_s]						// load current dim L value
	mul w10, w10, w1								// w10 = w10 * w1
	str w10, [x0, cuboid_base + lDim_s]						// store new dim L value

	// c.height *= factor
	ldr w11, [x0, cuboid_height]					// load current height value
	mul w11, w11, w1								// w11 = w11 * w1
	str w11, [x0, cuboid_height]					// store new height value

	// calculate c.volume
	mul w4, w9, w10									// w4 = w9 * w10
	mul w4, w11, w4									// w4 = w11 * w4 (replace value in w4 with final volume)
	str w4, [x0, cuboid_volume]							// store new value of volume in w4

	ldp x29, x30, [sp], 16								// reallocating space back in the stack
	ret										// return to caller

	// VOID PRINTCUBOID

printCuboid:
	stp x29, x30, [sp, -32]!							// allocating space in the stack
	mov x29, sp									// setting x29 to the value of sp

	str x19, [x29, 16]								// Calculating address of array
	mov x19, x0									// setting x19 to the value of x0

	adrp x0, fpt									// set first print statement
	add x0, x0, :lo12:fpt								// initialize the print statement
	mov w1, w1									// set variables needed to print
	ldr w2, [x19, cuboid_origin + xPoint_s]						// loading point x into w2
	ldr w3, [x19, cuboid_origin + yPoint_s]						// loading point y into w3									// set variables needed to print
	ldr w4, [x19, cuboid_base + wDim_s]						// loading dimension w into w4
	ldr w5, [x19, cuboid_base + lDim_s]						// loading dimension l into w5
	ldr w6, [x19, cuboid_height]					// loading cuboid height into w6									// set variables needed to print
	ldr w7, [x19, cuboid_volume]							// loading cuboid volume into w7

	bl printf									// calling print function

	ldp x29, x30, [sp], 32								// reallocating space back into the stack
	ret										// return to caller

	// int equalSize Method

	define(result, w24)								// define w24 as result

equalSize:
	stp x29, x30, [sp, -32]!							// allocate space in the stack
	mov x29, sp									// set the value of x29 to the value of sp

	mov result, FALSE								// move FALSE into result

	ldr w9, [x0, cuboid_base + wDim_s]						// loading cuboid width into w9
	ldr w10, [x0, cuboid_base + lDim_s]						// loading cuboid length into w10
	ldr w11, [x0, cuboid_height]					// load cuboid height into w11

	ldr w12, [x1, cuboid_base + wDim_s]						// load cuboid width into w12
	ldr w13, [x1, cuboid_base + lDim_s]						// load cuboid length into w13
	ldr w14, [x1, cuboid_height]					// load cuboid height into w14

	cmp w9, w12									// compare w9 and w12
	b.ne next									// if w9 != w12 branch to next

	cmp w10, w13									// compare w10 and w13
	b.ne next									// if w10 != w14 then branch to next

	cmp w11, w14									// compare w11 and w14
	b.ne next									// if w11 and w14 are not equal, branch to next

	mov result, TRUE								// move TRUE into result
	mov w0, result									// output/return w0 into main
	bl end										// branch to end

next:
	mov w0, result									// output/return w0 into main
	bl end										// branch to end

end:
	ldp x29, x30, [sp], 32								// reallocate space in the stack
	ret 										// return to caller

	//------------- MAIN ---------------\\

	.global main			        						// make main() global to call from OS
main:
	stp x29, x30, [sp, alloc]!							// allocating space in the stack
	mov x29, sp									// setting the value of sp to x29

	add x8, x29, first_s								// add x29 and first_s and store in x8
	bl newCuboid									// create a new cuboid by branching to newCuboid

	add x8, x29, second_s								// add x29 and second_s and store in x8
	bl newCuboid									// create a new cuboid by branching to newCuboid

	// Print initial values
	adrp x0, spt									// set print function
	add x0, x0, :lo12:spt								// initialize print function
	bl printf									// call print function

	// Pass arguments to printCuboid and print first Cuboid
	add x0, x29, first_s								// add x29 and first_s and store in x0
	ldr w1, =first									// load =first into w1
	bl printCuboid									// print

	// Pass arguments and print second Cuboid
	add x0, x29, second_s								// add x29 and second_s to x0
	ldr w1, =second									// ldr =second into w1
	bl printCuboid									// print

	// Pass arguments into equalSize and get a result (FALSE or TRUE)
	add x0, x29, first_s								// add x29 and first_s and store in x0
	add x1, x29, second_s								// add x29 and second_s and store in x1
	bl equalSize									// bl equalsize
	cmp w0, TRUE									// compare the output returned from equalSize (w0) and TRUE
	b.ne else									// if w0 != TRUE branch to else

	add x0, x29, first_s								// add x29 anad first_s and store in x0
	mov w1, 3									// set w1 to 3
	mov w2, -6									// set w2 to -6
	bl move										// bl move

	// Pass arguments to expand to change second cuboid values
	add x0, x29, second_s								// add x29 and second_s and store in x0
	mov w1, 4									// set w1 to 4
	bl scale									// bl scale

else:		// Print modified values
	adrp x0, tpt									// set second print statement
	add x0, x0, :lo12:tpt								// initilize the statement
	bl printf									// print

	// Print modified values of first Cuboid
	add x0, x29, first_s								// add x29 and first_s and store in x0
	ldr w1, =first									// load =first into w1
	bl printCuboid									// bl printCuboid

	// Print mdoified values of second Cuboid
	add x0, x29, second_s								// add x29 and second_s and store in x0
	ldr w1, =second									// load =second into w1
	bl printCuboid									// bl printCuboid

	mov w0, 0									// mov w0,0
	ldp x29, x30, [sp], dealloc							// allocate space in stack
	ret										// return to caller
	
