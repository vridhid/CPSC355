	//Registers for handling command line arguments
	define(c_argument, w23)                                                               	// number of arguments
	define(v_argument, x24)                                                               	// the arguments array

	//Registers for user input and indices
	define(month, w19)                                                                    	// user input for month (to be converted to int)
	define(day, w20)                                                                      	// user input for day (to be converted to int)
	define(year, x21)									// user input for year (to be converted to int)
	
	//Registers for base addresses of arrays
	define(month_r, x22)                                                               	// base address for month array
	define(suffix_r, x23)                                                              	// base address for suffix array
	
	//Declare printout strings (error messages and result output)
	.text
usage:	    .string "usage: a5b mm dd yyyy\n"                                             	// improper number of command line arguments error message
result:	    .string "%s %d%s, %d\n"   								// proper input; result output message
	
	//Declare strings to go into the month array
jan:	    .string "January"                                                             	// january
feb:	    .string "February"                                                            	// february
mar:	    .string "March"                                                               	// march
apr:	    .string "April"                                                               	// april
may:	    .string "May"                                                                 	// may
jun:	    .string "June"                                                                	// june
jul:	    .string "July"                                                                	// july
aug:	    .string "August"                                                              	// august
sep:	    .string "September"                                                           	// september
oct:	    .string "October"                                                             	// october
nov:	    .string "November"                                                            	// november
dec:	    .string "December"                                                            	// december

	//Declare strings to go into the suffix array
th:	    .string "th"                                                                  	// th suffix. th-rd are part of the suffix_m
st:	    .string "st"                                                                  	// st suffix
nd:	    .string "nd"                                                                  	// nd suffix
rd:	    .string "rd"                                                                  	// rd suffix

month_m:	.dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec		
		// create months array
suffix_m:	.dword st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st                                               		
		// create suffix array
                                      		

	.balign 4                                                                 		// align to 4 bits once again
	.global main                                                             		// make main method visible to compiler

main:	     
	stp x29, x30, [sp, -16]!                                                  		// basic program structure
	mov x29, sp                                                               		// update x29

	mov c_argument, w0                                                            		//uStore argc in a safe place 
	mov v_argument, x1                                                            		//Store argv in a dedicated place
	mov w25, 1
	mov w26, 2
	mov w27, 3
	
	cmp c_argument, 4                                                             		// ensure that the number of arguments is equal to 3
	b.lt err                                                              			// if it is, continue on        

conti1:
	// MONTH
	ldr x0, [v_argument, w25, SXTW 3]                                        		// get the first element of v_argument (mm) into x0
	bl atoi                                          					// call atoi to convert from string to int
	mov month, w0     									// place atoi's returned value into the month register
        
	cmp month, 0                                   						// compare month with 0
	b.le err                                         					// if it is less than or equal to, jump to error message
	cmp month, 12                                  						// compare month with 12 
	b.gt err                                         					// if it is, jump to error message
	
       	// DAY            									                                 						
	ldr x0, [v_argument, w26, SXTW 3]               					// get the second element of v_argument (dd) into x0
	bl atoi                                          					// call atoi to convert from string to int
	mov day, w0                                    						// place atoi's returned value into the day register

	cmp day, 0                                     						// compare day with 0
	b.le err                                         					// if it is less than or equal to 0, jump to error message
	cmp day, 31                                    						// compare day with 31 (day should not be greater than 31)
	b.gt err										// if it is greater than 31, jump to error message
	
	// YEAR                                                           		
	ldr x0, [v_argument, w27, SXTW 3] 							// get the third element of v_argument (yy) into x0
	bl atoi											// call atoi to convert from string to int
	mov year, x0										// place atoi's returned value into the year register
	
	cmp year, 0										// compare year with 0
	b.le err                                         					// if year is less than or equal to 0, jump to error message
	
	//Note that atoi returns 0 if it failed to convert the string to an integer
	//This is fine, because 0 is not a valid input for month/day/year anyway.
	
	b output                                         					// otherwise, month ranges from 1-12 and day 1-31

err:	      
	adrp x0, usage                                    					// set up error message
	add x0, x0, :lo12:usage                           					// format its bits correctly
	bl printf                                        					// print error message
	b end                                            					// jump to end of program

output:	   
	adrp month_r, month_m                    						// get month base array into register.
	add month_r, month_r, :lo12:month_m     						// format lower 12 bits correctly
	sub month, month, 1
	
	adrp suffix_r, suffix_m                      						// get suffix base array into register.
	add suffix_r, suffix_r, :lo12:suffix_m  						// format lower 12 bits correctly.
                         									// account for the zero-based indexing of arrays
	adrp x0, result                                   					// set up result string
	add x0, x0, :lo12:result                         					// format bits correctly
	
	ldr x1, [month_r, month, SXTW 3]          						// load the correct month (month is the index)
	
	mov w2, day                                    						// place the day value in w2
	sub day, day, 1
	ldr x3, [suffix_r, day, SXTW 3]        							// load the correct suffix in (suffix is the index)
	
	mov x4, year
	
	bl printf                                        					// call printf

	//End program. Can be reached either from error message or after the successful output statement.
end:	      
	ldp x29, x30, [sp], 16                           					// deallocate memory
	ret                                              					// end program. 
	
