oString:
	.string	"Enter the number of pennies, nickels, dimes, and quarters for week %d: "
datainstring:
	.string	"%d %d %d %d"

printStat1:
	.string	"Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters.\n"
printStat2:
	.string	"This comes to $%.2f\n"
printStat3:
	.string	"Your weekly average is $%.2f\n"
printStat4:
	.string	"Your estimated yearly savings is $%.2f\n"
	
	.text
	.align	2
	.global	main
	.type	main, %function

main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!          // Save frame pointer and return address
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80                // Define CFA (Canonical Frame Address) register
	.cfi_offset 30, -72                // Define return address register
	add	x29, sp, 0                     // Set up frame pointer
	.cfi_def_cfa_register 29           // Define CFA register
	adrp	x0, :got:__stack_chk_guard   // Load address of stack guard variable
	ldr	x0, [x0, #:got_lo12:__stack_chk_guard]
	ldr	x1, [x0]                       // Load value of stack guard variable
	str	x1, [x29, 72]                  // Save stack guard value
	mov	x1,0                            // Initialize loop counter
	str	wzr, [x29, 40]                  // Initialize penny accumulator to 0
	str	wzr, [x29, 44]                  // Initialize nickel accumulator to 0
	str	wzr, [x29, 48]                  // Initialize dime accumulator to 0
	str	wzr, [x29, 52]                  // Initialize quarter accumulator to 0
	str	wzr, [x29, 56]                  // Initialize loop terminator to 0
	mov	w0, 1                           // Prepare to load the address of the format string for input
	str	w0, [x29, 36]                  // Save the format string address on the stack
.L3:
	ldr	w0, [x29, 36]                  // Load the format string address from the stack
	cmp	w0, 4                           // Compare loop counter to 4 (number of weeks)
	bgt	.L2                             // If loop counter > 4, exit the loop
	adrp	x0, oString                   // Load address of the input prompt string
	add	x0, x0, :lo12:oString
	ldr	w1, [x29, 36]                  // Load loop counter
	bl	printf                           // Call printf to print the input prompt
	add	x4, x29, 32                     // Load addresses for input variables
	add	x3, x29, 28
	add	x2, x29, 24
	add	x1, x29, 20
	adrp	x0, datainstring               // Load address of the input format string
	add	x0, x0, :lo12:datainstring
	bl	scanf                            // Call scanf to read input values
	ldr	w0, [x29, 20]                  // Load penny count
	ldr	w1, [x29, 40]                  // Load current total penny count
	add	w0, w1, w0                      // Add current and new penny counts
	str	w0, [x29, 40]                  // Store updated penny count
	ldr	w0, [x29, 24]                  // Repeat for nickel, dime, and quarter counts
	ldr	w1, [x29, 44]
	add	w0, w1, w0
	str	w0, [x29, 44]
	ldr	w0, [x29, 28]
	ldr	w1, [x29, 48]
	add	w0, w1, w0
	str	w0, [x29, 48]
	ldr	w0, [x29, 32]
	ldr	w1, [x29, 52]
	add	w0, w1, w0
	str	w0, [x29, 52]
	ldr	w0, [x29, 36]
	add	w0, w0, 1                      // Increment loop counter
	str	w0, [x29, 36]                  // Store updated loop counter
	b	.L3                              // Branch back to loop start
.L2:
	ldr	w1, [x29, 44]                  // Load nickel count
	mov	w0, w1                          // Move nickel count to w0
	lsl	w0, w0, 2                       // Multiply nickel count by 4 (convert to pennies)
	add	w1, w0, w1                      // Add nickel count to itself (multiply by 2)
	ldr	w0, [x29, 40]                  // Repeat for dime and quarter counts
	add	w2, w1, w0
	ldr	w1, [x29, 48]
	mov	w0, w1
	lsl	w0, w0, 2
	add	w0, w0, w1
	lsl	w0, w0, 1
	add	w1, w2, w0
	ldr	w2, [x29, 52]
	mov	w0, 25                          // Load constant 25 (convert quarter count to pennies)
	mul	w0, w2, w0                      // Multiply quarter count by 25
	add	w0, w1, w0                      // Add all the penny counts together
	str	w0, [x29, 56]                  // Store total penny count
	ldr	w0, [x29, 56]                  // Load total penny count
	scvtf	d0, w0                         // Convert total penny count to double
	mov	x0, 4636737291354636288         // Load constant to convert pennies to dollars
	fmov	d1, x0                         // Move constant to double register
	fdiv	d0, d0, d1                     // Divide total penny count by 100 (convert to dollars)
	fcvt	s0, d0                         // Convert double to single precision
	str	s0, [x29, 60]                  // Store total dollar count
	fmov	s0, 4.0e+0                      // Load constant 4.0 (number of weeks)
	ldr	s1, [x29, 60]                  // Load total dollar count
	fdiv	s0, s1, s0                     // Divide total dollar count by 4 (calculate weekly average)
	str	s0, [x29, 64]                  // Store weekly average
	ldr	s0, [x29, 60]                  // Repeat for estimated yearly savings
	mov	w0, 1112539136                  // Load constant 52 (number of weeks in