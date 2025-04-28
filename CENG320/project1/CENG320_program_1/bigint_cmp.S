
/*
This is the compare function, It compares by size, 

if the size are equal,
it check the sign of the numbers are returs the comparision accordingly,
If the signs are the ssame it comares all the numbers from the end to the
star.

if the sizes are unequal, it check the sign, the positive one is greater
if both are positive, the longer one is greater

*/


	.text
	.type bigint_cmp, %function
	.global bigint_cmp

bigint_cmp:

		//store the registers on the stack 
        stp     x29, x30, [sp, #-16]!     
        stp     x27, x28, [sp, #-16]!
        stp     x25, x26, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!


	//move the address of the two bigints to x27 and x28
	mov x27, x0
	mov x28, x1

	//get the size of the bigints
	ldr w25, [x27,#8]
	ldr w26, [x28,#8]

	//compare the sizes



	cmp x25,x26
	
	//decrement size by 1 to get the last 64 bits
	sub x25, x25, #1
	sub x26, x26, #1

	bgt First_one_longer //branch to First_one_longer if size1>size2
	blt Second_one_longer// branch to second longer if size1<size2


	//size is equal


	//lets check if any of these numbers are negative


	ldr x23, [x27]  //load the  first 64 bits of a
	ldr x24, [x28]   //load the  first 64 bits of b


	mov x12, x25
	lsl x12, x12 ,#3
	ldr  x1, [x23, x12] //load the last 64 bits
	ldr  x2, [x24, x12] //load the last 64 bits

	//get the last bit
	lsr  x1, x1, #63
	//get the last bit
	lsr  x2, x2, #63



	//compare the last bit to find out whether the signs are different
	cmp x1, x2
	beq Compare_all_chunks //compare all chunks if size and sign are equal

	//if signs are different, check the positive one
	mov x3, #0 	//move 0 to x3
	cmp x1, x3
	beq First_one_greater
	bgt Second_one_greater


	//first number is greater
First_one_greater: 
	//return 1
	mov x0, #1
	//branch to restor and return
	b restore_return


	//second number is greater
Second_one_greater:
	//return -1
	mov x0, #-1
	//branch to restore and return
	b restore_return


	//both numbers are equal
Both_equal:
	//return 0
	mov  x0, #0
	//branch to restore and return
	b restore_return





//compare all the chunks
Compare_all_chunks:

	//compare till size is 0
	 cmp x25, #0
	 //if size is 0, both are equal
	 blt Both_equal

	//load the 64 bits from the end
	mov x12, x25
	lsl x12, x12 ,#3
	 ldr x1, [x23, x12]
	 ldr x2, [x24, x12]

	//decrement size
	 sub x25, x25, #1

	//compare bits
	cmp x1, x2

	beq  Compare_all_chunks //branch back to top if equal
    blo  Second_one_greater  //if less than, branch to second greater
	b First_one_greater //else branch to first greater


	//first one longer
First_one_longer: 
	//load the first 64 bits
	ldr x24, [x27]
	//load the last 64 bits, last=first+ (size-1)*64

	mov x12, x25
	lsl x12, x12 ,#3
	ldr x23, [x24, x12]

	//shift by 63 to check the sign
	lsr x23, x23, #63

	//compare the sign bit
	cmp  x23, #0
	beq First_one_greater //if first one is positive, its greater
	b Second_one_greater //second one is greater

Second_one_longer:
		//load the first 64 bits
		ldr x24, [x28]

		//load the last 64 bits, last=first+ (size-1)*64

		mov x12, x26
	    lsl x12, x12 ,#3
		ldr  x23, [x24, x26, lsl #3]
		//shift by 63 to check tyhe sign
		lsr  x23, x23, #63

		cmp x23, #0
		beq  Second_one_greater //if second one i spositive, its greater
		b First_one_greater //else first one is greater

restore_return:


		//restore the stack
        ldp     x19, x20, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x23, x24, [sp], #16
        ldp     x25, x26, [sp], #16
        ldp     x27, x28, [sp], #16
        ldp     x29, x30, [sp], #16 	
		//return
	ret	
	//get the size
	.size bigint_cmp,(. - bigint_cmp)
	
