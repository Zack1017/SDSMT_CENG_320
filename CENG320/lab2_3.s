/***************************************************************
/* lab2_3.s
/*      The code will print "Hello World" on the output
/*      Zackery Holloway
/*      Tue, Jan 23 2024
/*
/*      Compilatoin instructions
/*      gcc -o lab2_2 lab2_2.s
/*
/*      This cersion will run without C standard libary. It
/*      uses system call
****************************************************************/

//data section 
	.data
message:	.asciz "Hello World!!!\n"
len		=. - message

//code section 
	.text
	.global main
	.type main, %function 
main:
	//Store the return address in stack 
	stp x29, x30, [sp, #-16]!

	//preparing the arguments for system call
	
	mov x0, #1
	ldr x1, =message
	ldr x2, =len
	//system call number to write 
	mov x8, #64
	//make the system call
	svc #0

	//return 0
	mov x0, #0
	//getting the return address from stack 
	ldp x29, x30, [sp], #16
ret
