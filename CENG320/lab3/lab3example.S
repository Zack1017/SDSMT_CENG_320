/******************************************************************
*
* lab3Example.S
*
* Program that gets one 32-bit integer and one 32-bit integer, then 
* a 64-bit and a 64-but adds 
* up and then outputs the sum of the 2
*
* Zackery Holloway 
*
* Tuesday February 13 2024
*
* Compilation Instructions
* gcc -o lab3Example lab3Example.S
*
*******************************************************************/

            .data

scan_32 :   .asciz "%d" // Format for reading int with scanf
            // % d is the keyword for a 32 bit int

scan_64 :   .asciz "%ld" // Format for reading 64 bit int
            // % ld is the keyword of a 64 bit int

            .align 2
max_int32 : .word 0x7FFFFFFF
            .align 3
max_int64 : .dword 0x7FFFFFFFFFFFFFFF

prompt_32 : .asciz "Enter an integer between -%d and %d: "


prompt_64 : .asciz "Enter an integer between -%ld and %ld: "


out_str :   .asciz "The sum is %ld \n"

stored_32 : .word 0
            .align 3
stored_64 : .dword 0

//Second Number home
stored_32_1 : .word 0
	      .align 3
stored_64_1 : .dword 0

            .text
            .global main
main:
            stp x29, x30, [sp, #-16]! //setup program in stack pointer 

            // prompt user for 32 bit int
            adr x0, prompt_32 // promps users input form prompt_32 to x0 address to print

            // load max +-int_32
            adr x1, max_int32 //stores the max_int32 address in x1
            ldr w2, [x1] //Stores value of x1 into w2
            ldr w1, [x1] //stores value of x1 in w1

            bl printf //links to commands to users screen, in formate x0 is address and x1 is size

            // get user input (32-bit)
            adr x0, scan_32 //retrieves format file and places it in x0
            adr x1, stored_32 //retrieves the address to place data from user into 
            bl scanf //calls for user input where x0 is ascii formate and x1 is place to keep
            
            // prompt user for 32 bit int 2
	    adr x0, prompt_32 //gets format for print f command 
	    
	    adr x1, max_int32 
	    ldr w2, [x1] 
	    ldr w1, [x1]

	    bl printf

	    //gets user second input
	    adr x0, scan_32
	    adr x1, stored_32_1
	    bl scanf

	    //Start of addition of 32s
	    adr x1, stored_32 //Gets address from mem sotred in stored_32 to x1
	    ldr w1, [x1] //Gets value of x1 and puts it in w1
	    adr x2, stored_32_1 //Gets address from mem stored in stored_32_1 to x2
	    ldr w2, [x2] //Gets Value of x2 and puts it in w2
	    add x1, x1, x2 //adds the value of x1 and x2 and places it in x1

	    //Start of Print 32
	    adr x0, out_str //Gets format and places it in x0
	    bl printf //value is already in x1 so we can just print

//-------------------------------------------------------------------------------

            // prompt user for 64 bit int
            adr x0, prompt_64

            //load max +-int_64
            adr x1, max_int64
            ldr x2, [x1]
            ldr x1, [x1]

            bl printf

            // get user input (64-bit)
            adr x0, scan_64
            adr x1, stored_64
            bl scanf

	    //promp user for 64 bit 2
	    adr x0, prompt_64

	    adr x1, max_int64
	    ldr x2, [x1]
 	    ldr x1, [x1]

	    bl printf

	    adr x0, scan_64
	    adr x1, stored_64_1
	    bl scanf

	   // startof 64 addion
	   adr x1, stored_64
	   ldr x1, [x1]
	   adr x2, stored_64_1
	   ldr x2, [x2]
	   add x1, x1, x2

	   adr x0, out_str
	   bl printf

            mov x0, #0
            ldp x29, x30, [sp], #16
            ret
