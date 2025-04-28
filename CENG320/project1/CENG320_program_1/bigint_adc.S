    /*
        This funciton is required to be rewrote to
        achive full points.  The algorithum used 
        is bad and was refactored.  This function       
        adds with a carry bit. 
    */
        .text
        .type bigint_adc, %function
        .global bigint_adc
        .equ shift, 63
        .equ mul64, 3

bigint_adc:
        stp x29, x30, [sp, #-16]! //sets up stack
        stp x27, x28, [sp, #-16]!
        stp x25, x26, [sp, #-16]!
        stp x23, x24, [sp, #-16]!
        stp x21, x22, [sp, #-16]!
        stp x19, x20, [sp, #-16]!

        mov x23, x0 //stores first int
        mov x24, x1 //stores second int 
        mov x25, x2 //stores carry 

        ldr x19, [x23] //saves adr of first int
        ldr x20, [x24] //saves adr of sedond  int
        ldr w26, [x23, #8]//loads size of big int 1
        ldr w27, [x24, #8]//loads size of big int 2

        cmp x26, x27 //compares size sets p flag
        csel x28, x26, x27, gt // select greater address to x8
        add x28, x28, #1 //add one as correction 

        mov x0, x28
        bl bigint_alloc //allocates new size 
        mov x22, x0 //saves address

        cmp x26, x27 ////compares size sets p flag
        csel x5, x20, x19, le //bit 
        csel x6, x26, x27, le //Small 
        csel x7, x19 , x20, le //eql

        ldr x4, [x22] 
        sub w28, w28, #1

        mov x8, xzr //i
        mov x9, xzr //j
        mov x0, xzr 
        mov x2, xzr 

 first:
        cmp x8, x28 //i cmp with big size 
        bge result

        asr x0, x2, shift //sine shift 

        cmp x9, x6 //other is big
        bge second

        mov x15,x9
        lsl x15, x15, mul64
        ldr x2, [x7, x15]
        add w9, w9, #1 //j +1

        mov x0, x2 //move first t0 x0

second:
        mov x15, x8 //second numb 
        lsl x15, x15, mul64 // shift
        ldr x1, [x5, x15]

add_ints:
        cmp x25, #1 //set p flags 
        adcs x3, x0, x1 //carry addition 

        cset x25, cs //store flags 

store_ints:
        mov x15, x8
        lsl x15, x15, mul64 //sore in x8*64
        str x3, [x4, x15]

        add w8, w8, #1 //i++
        b first

result:
        asr x1, x1, shift //shift to sign
        asr x2, x2, shift
        cmp x25, #1 //set p flags for sign bits
        adc x1, x2, x1 //adds the carry 

        lsl x3, x8, mul64 //stores 
        str x1, [x4, x3]

        mov x0, x22
        bl cleanup //cleans leading zeros by reference(Could not get to work in assembly)

        mov x0, x22//return 
        ldp x19, x20, [sp], #16//clean up 
        ldp x21, x22, [sp], #16
        ldp x23, x24, [sp], #16
        ldp x25, x26, [sp], #16
        ldp x27, x28, [sp], #16
        ldp x29, x30, [sp], #16
        ret