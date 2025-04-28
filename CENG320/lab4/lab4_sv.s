	.data
prompt: .asciz "Enter text (hit return followed by ctrl -D or hit ctrl -D twice to end):\n"
buffer_prompt: .asciz "%s\n"
checksum_prompt: .asciz "The checksum is %08x\n"
buffer:	.skip 4096	
	.text
	.global main
checksum:
	mov x2, #0
	mov x3, #0

checksum_loop:
	ldrb w1, [x0, x3]
	cbz w1, checksum_done
	add x2, x2, x1
	add x3, x3, #1
	b checksum_loop

checksum_done:
	mov x0, x2
	ret

main:
	stp x29, x30, [sp, #-16]! //set up stack
	mov x6, #0
	mov x2, #0
	adr x9, buffer		//gives buffer an address
	//print to screen 
	adr x0, prompt
	bl printf

read_loop:
	bl getchar		//gets char from screen
	cmp w0, #-1
	beq end_read_loop

	strb w0, [x9], #1		//send x0 to butter and move 4
	add x6, x6, #1
	cmp x6, #4096
	bge end_read_loop

	b read_loop

end_read_loop:
	mov w0, #0
	strb w0, [x9], #1

	adr x1, buffer
	bl checksum
	mov x2, x0
	adr x1, checksum_prompt
	bl printf
	mov x0, #0
	ldp x29, x30, [sp], #16
	ret
