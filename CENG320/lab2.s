/***************************************************************
/* lab2.s
/* 	The code will print "Hello World" on the output
/*	Zackery Holloway
/*	Tue, Jan 23 2024
/*	
/*	Compilatoin instructions
/*	gcc -o lab2 lab2.s
/*
/*	gcc calls the assembler and linker. It includes the C
/*	standard libary in the executable code. 
****************************************************************/
//data section 
	.data
message:	.asciz "Hello World\n" //The message to print 


//code section 
	.text
	.global main 
	.type main, %function 
main: 
	// Store the return address in stack 
	stp x29, x30, [sp,#-16]!

	adr x0, message 
	
	bl printf

	//return 0 
	mov x0, #0
	//getting the return address from stack 
	ldp x29, x30, [sp],#16
ret
