  //Assignment 2b
  //This program implements a integer multiplication program

 //Defining the strings
  initialv:     .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d) \n\n"
  productp:     .string "product = 0x%08x  multiplier = 0x%08x\n"
  resultp:      .string "64-bit result = 0x%016lx (%ld)\n"

                                                                                                // defining the macros
define(FALSE,0)                                                                                 // defining FALSE and assigning 0 to it
define(TRUE, 1)                                                                                 // defining TRUE and assigning 1 to it
define(multiplier, w19)                                                                         // defining multiplier and setting it to register w19
define(multiplicand,w20)                                                                        // defining multiplicand
define(product, w21)                                                                            // defining product and setting it to register w21
define(i, w22)                                                                                  // defining i and setting it to register w22
define(negative, w23)                                                                           // defining negative and setting it to register w23
define(result, x24)                                                                             // defining result and setting it to register x24
define(temp1, x25)                                                                              // defining temp1 and setting it to register x25
define(temp2, x26)                                                                              // defining temp2 and setting it to register x26
define(product64,x21)                                                                           // defined to store new 64 bit version of product
define(multiplier64,x19)                                                                        // defined to store new 64 bit version of multiplier


        .balign 4                                                                               //align instructions
        .global main                                                                            //make main visible to OS
main:
        stp     x29, x30, [sp, -16]!                                                            // allocates stack space, pre-incrementing SP by -16
        mov     x29, sp                                                                         // update FP to current FP

        mov     multiplicand, 522133279                                                         // initializing multiplicand to 522133279
        mov     multiplier, 200                                                                  // initializing multiplier to 200
        mov     product, 0                                                                      // initializing product to 0
        mov     i, 0                                                                            // initializing i to 0
                                                                                                // print out initial values and variables
        adrp    x0, initialv                                                                    // setting first arguement of printf() higher
        add     x0, x0, :lo12:initialv                                                          // setting second arguement of printf() lower
        mov     w1, multiplier                                                                  // move multiplier value into w1 register
        mov     w2, multiplier                                                                  // move multiplier value into unto w2 register
        mov     w3, multiplicand                                                                // move multiplicand value into w3 register
        mov     w4, multiplicand                                                                // move multiplicand value into w4 register
        bl      printf                                                                          // call printf function and print initialv values

        cmp     multiplier, 0                                                                   // determining if multiplier is negatuve
        b.ge    first                                                                           // if multplier is bigger than or eq to 0, branch to first
        mov     negative, TRUE                                                                  // if multiplier is less than 0, TRUE is stored into negative
first:
        mov     i, 0                                                                            // setting i to 0
        b       check1                                                                          // branch to check1, to do repeated add and shift
loop:
        tst      multiplier, 0x1                                                                // compare multiplier to 1
        b.eq    check2                                                                          // if different, branch to check2
        add     product, product, multiplicand                                                  // if the same, do addition
check2:                                                                                         // arithmetic shift right and combined product and multiplier
        asr     multiplier, multiplier, 1                                                       // arithmetic shift right by 1 of multiplier
        tst     product, 0x1                                                                    // comparing product with 1(start of if statement)
        b.eq    check3                                                                          // if not equal, branch to check 3
        orr     multiplier, multiplier, 0x80000000                                              // if equal, execute orr statment
        b       check4                                                                          // branch to check4
check3:
        and     multiplier, multiplier, 0x7FFFFFFF                                              // else part of the if statement

check4:
        asr     product, product, 1                                                             // arithmetic shift right of product by 1
        add     i, i, 1                                                                         // incrementing i by 1

check1:                                                                                         // do repeated add and shift
        cmp     i, 32                                                                           // comparing i and 32 to check whether loop range condition
        b.lt    loop                                                                            // if i is less than 32, branch to loop to continue
        cmp     negative, TRUE                                                                  // compare the multiplier  with TRUE (1)
        b.ne    print2                                                                          // if not equal, branch to print2
        sub     product, product, multiplicand                                                  // if equal, execute sub statement
print2:
        adrp    x0, productp                                                                    // setting first arguement of printf() higher
        add     x0, x0, :lo12:productp                                                          // setting second arguement of printf() lower
        mov     w1, product                                                                     // moving product value into w1 register
        mov     w2, multiplier                                                                  // moving multiplier value into w2 register
        bl      printf                                                                          // call printf function and print productp value
                                                                                                // converting our prodcy into the 64 bit version
        sxtw    temp1, product                                                                  // move product into temp1 register
        and     temp1, product64, 0xFFFFFFFF                                                    // move product64, and 0xFFFFFFFF in same register temp1
        lsl     temp1, temp1, 32                                                                // shift temp1 values to the left by 32                                                                                                                           // converting our multiplier into the 64 bit version
        sxtw    temp2, multiplier                                                               // move multiplier into temo2 register
        and     temp2, multiplier64, 0xFFFFFFFF                                                 // move multiplier64 and 0xFFFFFFFF into same register temp2
        add     result, temp1, temp2                                                            // execute addition of temp 1 and temp2, store in result

        adrp    x0, resultp                                                                     // setting first arguement of printf() higher
        add     x0, x0, :lo12:resultp                                                           // setting second arguement of printf() lower
        mov     x1, result                                                                      // move result into x1 register
        mov     x2, result                                                                      // move result into x2 register
        bl      printf                                                                          // call function printf and print out resultp value
done:
        mov     w0, 0                                                                           // restoring registers
        ldp     x29, x30, [sp], 16                                                              // restoring FP and LR
        ret                                                                                     // return to caller

