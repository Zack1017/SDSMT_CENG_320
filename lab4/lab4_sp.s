	.data
prompt: .asciz "Enter text(hit return followed by ctrl-D or hit ctrl-D twice to end):\n"
format_str: .asciz "%s\n"
checksum_str: .asciz "\nThe checksum is %08X\n"
	.text
	.global checksum
	.global main

checksum:
	stp x29, x30, [sp, #-16]!
	mov w1, #0
	mov w2, #0

loop: 
	ldrb w3, [x0, x1]
	cbz w3, done
	add w2, w2, w3
	add w1, w1, #1
	b loop

done: 
	mov w0, w2
	ldp x29, x30, [sp], #16
	ret

main:
	stp x29, x30, [sp, #-32]!
	sub sp , sp , #4096
	mov x1, sp 
	mov w2, #0
	adr x0, prompt	
	bl printf

read_loop:
	mov w3, #0
	bl getchar
	cmp w0, #-1
	beq done_reading
	mov w4, #4095
	cmp w2, w4
	bge done_reading
	strb w0, [x1, x2]
	add w2, w2, #1
	b read_loop

done_reading:
	strb w3, [x1, x2] 
	adr x0, format_str
	mov x1, x1
	bl printf
	mov x0, x1
	bl checksum
	adr x0, checksum_str
	mov x1, x0
	mov x0, x1
	bl printf
	mov x0, x1
	bl checksum
	adr x0, checksum_str
	mov x1, x0
	mov x0, x1
	bl printf
	mov w0, #0
	ldp x29, x30, [sp], #32	
	ret
	
