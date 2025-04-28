	.text
	.align	2
	.global	isprime
	.type	isprime, %function
	.global	_Z6divideiiPiS_
	.type	_Z6divideiiPiS_, %function
isprime:
	sub	sp, sp, #32
	str	w0, [sp, 12]// Store the input argument on the stack at offset 12
	ldr	w0, [sp, 12]
	cmp	w0, 1  // Compare the input argument with 1
	bgt	isPrim		// Branch if greater than 1
	mov	w0, 0
	b	end

isPrim:
	ldr	w0, [sp, 12] // Load the input argument from the stack
	cmp	w0, 3 // Compare the input argument with 3
	bgt	primeCalc
	mov	w0, 1
	b	end

primeCalc:
	ldr	w0, [sp, 12]
	and	w0, w0, 1 // Bitwise AND the input argument with 1
	cmp	w0, 0
	beq	fail  // Branch if equal to 0
	ldr	w2, [sp, 12]
	mov	w0, 21846  // Move the constant 21846 into w0
	movk	w0, 0x5555, lsl 16 // Move the constant 0x5555 left by 16 bits into w0
	smull	x0, w2, w0
	lsr	x1, x0, 32 //shift right
	asr	w0, w2, 31
	sub	w1, w1, w0
	mov	w0, w1
	lsl	w0, w0, 1
	add	w0, w0, w1
	sub	w1, w2, w0
	cmp	w1, 0
	bne	next
fail:
	mov	w0, 0
	b	end
next:
	mov	w0, 5
	str	w0, [sp, 28]
find:
	ldr	w1, [sp, 28] //loads 
	ldr	w0, [sp, 28] //loads
	mul	w0, w1, w0
	ldr	w1, [sp, 12]
	cmp	w1, w0	//compae
	blt	clean
	ldr	w0, [sp, 12]
	ldr	w1, [sp, 28]
	sdiv	w2, w0, w1 // Signed divide of w0 by w1
	ldr	w1, [sp, 28] 
	mul	w1, w2, w1 //multiply
	sub	w0, w0, w1
	cmp	w0, 0
	beq	ret0	//end
	ldr	w0, [sp, 28]
	add	w1, w0, 2
	ldr	w0, [sp, 12]
	sdiv	w2, w0, w1
	mul	w1, w2, w1
	sub	w0, w0, w1
	cmp	w0, 0
	bne	update
ret0:
	mov	w0, 0
	b	end
update:
	ldr	w0, [sp, 28]
	add	w0, w0, 6
	str	w0, [sp, 28]
	b	find
clean:
	mov	w0, 1
end:
	add	sp, sp, 32
	ret

divide:
	sub	sp, sp, #32
	str	w0, [sp, 28]
	str	w1, [sp, 24]
	str	x2, [sp, 16]
	str	x3, [sp, 8]
	ldr	w1, [sp, 28]
	ldr	w0, [sp, 24]
	sdiv	w1, w1, w0 //x/y
	ldr	x0, [sp, 16]
	str	w1, [x0]
	ldr	w0, [sp, 28]
	ldr	w1, [sp, 24]
	sdiv	w2, w0, w1 //x%y
	ldr	w1, [sp, 24]
	mul	w1, w2, w1
	sub	w1, w0, w1
	ldr	x0, [sp, 8]
	str	w1, [x0]
	nop
	add	sp, sp, 32
	ret

out:
	.string	"Enter a natural number n: "
	.align	3
outformat:
	.string	"%d"
	.align	3
.LC2:
	.string	"Prime numbers between 1 and %d:\n"
	.align	3
.LC3:
	.string	"%d "
	.align	3
.LC4:
	.string	"\nTotal prime numbers between 1 and %d: %d\n"


	.text //it breaks when i move this?
	.align	2
	.global	main
	.type	main, %function

main:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, #:got_lo12:__stack_chk_guard] // Load the value of __stack_chk_guard into x0
	ldr	x1, [x0]
	str	x1, [x29, 40] // x29 + 40
	mov	x1,0
	adrp	x0, out
	add	x0, x0, :lo12:out   //i count not get normal printf to work but found this on google and it works 
	bl	printf
	add	x1, x29, 28
	adrp	x0, outformat
	add	x0, x0, :lo12:outformat
	bl	scanf
	ldr	w1, [x29, 28]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	str	wzr, [x29, 32]
	mov	w0, 2
	str	w0, [x29, 36]

printout:
	ldr	w0, [x29, 28]
	ldr	w1, [x29, 36]
	cmp	w1, w0
	bgt	printList
	ldr	w0, [x29, 36]
	bl	isprime
	cmp	w0, 0
	cset	w0, ne
	and	w0, w0, 255
	cmp	w0, 0
	beq	loopUpdate
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	ldr	w1, [x29, 36]
	bl	printf
	ldr	w0, [x29, 32]
	add	w0, w0, 1
	str	w0, [x29, 32]

loopUpdate:
	ldr	w0, [x29, 36]
	add	w0, w0, 1
	str	w0, [x29, 36]
	b	printout

printList:
	ldr	w1, [x29, 28]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	ldr	w2, [x29, 32]
	bl	printf
	mov	w0, 0
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, #:got_lo12:__stack_chk_guard]
	ldr	x2, [x29, 40]
	ldr	x1, [x1]
	eor	x1, x2, x1
	cmp	x1, 0
	beq	done
	bl	__stack_chk_fail
done:
	ldp	x29, x30, [sp], 48

	ret

