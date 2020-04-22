// ================================================= GLOBAL VARIABLES ========================================= //

        		.data							// begin "data" section
zero_cons:		.double 0r0.0						// constant 0.0
half_cons:		.double 0r0.5						// constant 0.5
one_cons:		.double 0r1.0						// constant 1.0
two_cons:		.double 0r2.0						// constant 2.0
three_cons:		.double 0r3.0						// constant 3.0
four_cons:		.double 0r3.0						// constant 3.0
abs_error:		.double 0r1.0e-13                                       // constant for error checking 

// ================================================= EQUATES =================================================== //
                        .text

                        buf_size = 8                                            // create buffer for reading 8-byte inputs
                        alloc = -(16 + buf_size)&-16                            // memory allocation
                        dealloc = -alloc                                        // de-allocation amount
                        buf_s = 16                                              // location of buffer in memory

argc_r                  .req w20                                                // total number of arguments input at command line
	
argv_r                  .req x21                                                // arg-values, the base address of array of pointers
fd_r                    .req w22                                                // file descriptor register
buf_base_r              .req x23                                                // base register of buffer
nread_r                 .req x24                                                // base address of bytes read from input file

temp_x1			.req d1							// 1: x double register 
temp_x2			.req d2							// 2: x double register
temp_x3			.req d3							// 3: x double register
temp_r			.req d4
temp_x4			.req d5
	
// ================================================= PRINT FUNCTIONS =========================================== //

print_1:                .string "Opening file: %s\n"                            			// string output
print_space1:		.string " -----------------------------------------------\n"			// string pretty lines
print_header:           .string " |	Input value (x)	| 	  ln(x)	 	 |\n"			// String output for header
print_space2:		.string " -----------------------------------------------\n"			// string pretty lines 	
print_2:                .string " |	%.10f	|	%.10f	|\n "                              	// output of number
print_space3:		.string " -----------------------------------------------\n"                     // string pretty lines 
print_3:                .string "\n End of file reached.\n"                        			// print "end of file reached"

print_err1:             .string "Error: Incorrect number of arguments. Usage: ./a6 <filename.bin>\n"
        												// error message for incorrect input
print_err2:             .string "Error: Filename %s not found.\n"               			// error message for file not found
print_err3:             .string "Input %f out of range.\n"                      			// error message if number is not between 0.75 and 25.0
	

// ================================================== SUBROUTINES =============================================== //

                        .balign 4

// ------------------------------------------------ LN(X) --------------------------------------------------------//

ln:              	stp     x29, x30, [sp, -16]!                            // memory allocation for ln subroutine
                        mov     x29, sp

                        // Set up the temporary registers with all required values.

                        fmov    d9, d0                                          // move input d0 into temporary register d9
	
                        adrp    x10, abs_error  	                        // get address pointer for error constant 1.0e-13
                        add     x10, x10, :lo12:abs_error
        		ldr     d10, [x10]                                      // load value of error constant 1.0e-13 into d10        		

			adrp    x11, zero_cons                                 	// get address pointer for 0.0
                        add     x11, x11, :lo12:zero_cons			// add address
                        ldr     d11, [x11]                                      // load value of 0.0 into d11

			adrp    x12, half_cons                                 	// get address pointer for 0.5
                        add     x12, x12, :lo12:half_cons			// add address
                        ldr     d12, [x12]                                      // load value of 0.5 into d11
			
        		adrp    x13, one_cons                                 	// get address pointer for 1.0
                        add     x13, x13, :lo12:one_cons			// add address
                        ldr     d13, [x13]                                      // load value of 1.0 into d12
			
			adrp    x14, two_cons                                	// get address pointer for 2.0
                        add     x14, x14, :lo12:two_cons
                        ldr     d14, [x14]                                      // load value of 2.0 into d14

			adrp    x15, three_cons                                 // get address pointer for 3.0
                        add     x15, x15, :lo12:three_cons
                        ldr     d15, [x15]                                      // load value of 3.0 into d15

			adrp    x16, four_cons                                 // get address pointer for 4.0
                        add     x16, x16, :lo12:four_cons
                        ldr     d16, [x16]                                      // load value of 4.0 into d16	


branch1:			
			fsub	temp_x1, d9, d13				// holds value of temp_x1 = input - 1
			fdiv	temp_x1, temp_x1, d9				// holds value of temp_x1 = temp_x1 / input
			
			fmov	temp_r, temp_x1

			fmul	temp_x2, temp_x1, temp_x1			// (temp_x1)^2
			fmov	temp_x3, temp_x2

			fmul	temp_x2, temp_x2, d13				// ((temp_x1)^2) * 1
			fdiv	temp_x2, temp_x2, d14				// (new value of) temp_x1 / 2
			
			fmul	temp_x1, temp_x3, temp_x1			// (temp_x1)^3
			fdiv	temp_x1, temp_x1, d15				

			fadd	temp_x1, temp_x1, temp_x2
			fadd	temp_x1, temp_x1, temp_r

			fmul	temp_x3, temp_x3, temp_x3			// (temp_x1)^4
			fdiv	temp_x3, temp_x3, d16				// (temp_x1)^4 / 4

			fadd	temp_x1, temp_x1, temp_x3


			
			ldp 	x29, x30, [sp], 16				// de-allocate memory from stack
			ret

	
// ================================================= MAIN =========================================================//

                        .global main

main:                   stp     x29, x30, [sp, alloc]!                          // allocate memory for main
                        mov     x29, sp

                        mov     argc_r, w0
                        mov     argv_r, x1

                        // Check number of arguments input. Should equal 1 to work
                        cmp     argc_r, 2                                       // compare number of arguments
        		b.eq    next_1                                          // if equal to 1, continue

                        adrp    x0, print_err1                                  // otherwise, print error message
                        add     x0, x0, :lo12:print_err1
                        bl      printf
                        b       end                                             // and branch to end
		                              

                        // Print out "reading input from file".
next_1:                 adrp    x0, print_1                                     // set up print_1 argument
                        add     x0, x0, :lo12:print_1
                        ldr     x1, [argv_r, 8]                                 // load input string into x1.
                        bl      printf                                          // branch link to printf.

                        mov     w0, -100                                        // reading input from file.
                        ldr     x1, [argv_r, 8]                                 // place input string into x1
                        mov     w2, 0                                           // 3rd Argument (read-only)
                        mov     w3, 0                                           // 4th Argument (not used)
                        mov     x8, 56                                          // openat I/O request
                        svc     0                                               // call system function
                        mov     fd_r, w0                                        // move result into file descriptor

                        // Do error checking for openat()
                        cmp     fd_r, 0                                         // error check: branch over
                        b.ge    next_2                                          // if fd_r > 0, open successful

                        adrp    x0, print_err2                                  // otherwise, set up error message "file not found"
                        add     x0, x0, :lo12:print_err2
                        ldr     x1, [argv_r, 8]                                 // move input string into x1
                        bl      printf                                          // branch link to printf
                        b       end                                             // branch to end

                       // If input string has been successfully opened:
next_2:

			adrp    x0, print_space1                                // print the header
        		add     x0, x0, :lo12:print_space1
                        bl      printf

	
                        adrp    x0, print_header                                // print the header
                        add     x0, x0, :lo12:print_header
        		bl      printf

			adrp    x0, print_space2                                // print the header
        		add     x0, x0, :lo12:print_space2
                        bl      printf


                        add     buf_base_r, x29, buf_s                          // set memory base address of buffer (FP + 16)

open_ok:                mov     w0, fd_r                                        // 1st Argument (file descriptor)
                        mov     x1, buf_base_r                                  // 2nd Argument (buffer)
                        mov     w2, buf_size                                    // 3rd Argument (Size of buffer = 8 bytes)
                        mov     x8, 63                                          // read I/O request
                        svc     0                                               // call system function
                        mov     nread_r, x0                                     // record the address of bytes actually read

                        cmp     nread_r, buf_size                               // do error checking for read()
                        b.ne    exit                                            // if read was not 8 bytes, then branch to end

			// Calculate cube root 

                        ldr     d0, [buf_base_r]				// load input integer
			bl      ln	                                  	// branch link to ln

                        adrp    x0, print_2	                                // set up print statement for input and output value
        		add     x0, x0, :lo12:print_2
			ldr     d0, [buf_base_r]
                        bl      printf                                          // branch link to print()

        		b       open_ok                                         // read the next input
exit:	
			adrp    x0, print_space3                                // print the header                                                                                                               
        		add     x0, x0, :lo12:print_space3
                        bl      printf

			adrp    x0, print_3                                     // set up print_3 statement: Reached end of file
                        add     x0, x0, :lo12:print_3                           // add low 12 bits
                        bl      printf                                          // branch to print()

			// Close the binary file.
                        mov     w0, fd_r                                        // 1st argument (file descriptor)
                        mov     x8, 57                                          // close I/O request
                        svc     0                                               // call system function

end:                    ldp     x29, x30, [sp], dealloc                         // de-allocate memory from stack
                        ret                                                     // return to caller

