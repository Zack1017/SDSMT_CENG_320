.global main
.text

.equ STDIN, 0
.equ STDOUT, 1
.equ SYS_READ, 0
.equ SYS_WRITE, 1

.section .data
week_msg:  .asciz "Enter the number of pennies, nickels, dimes, and quarters for week %d: "
total_msg: .asciz "Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters.\n"
dollars_msg: .asciz "This comes to $%.2f\n"
weekly_avg_msg: .asciz "Your weekly average is $%.2f\n"
yearly_savings_msg: .asciz "Your estimated yearly savings is $%.2f\n"

.section .data
total_pennies: .word 0
total_nickels: .word 0
total_dimes: .word 0
total_quarters: .word 0
total_cents: .word 0
total_dollars: .single 0.0
weekly_average: .single 0.0
yearly_savings: .single 0.0

.section .text

main:
    // Loop for four weeks
    mov x8, 1  // Week counter
    mov x9, 4  // Total number of weeks

.week_loop:
    // Print message for input
    ldr x0, =week_msg
    mov x1, x8
    bl printf

    // Read input
    ldr x0, =STDIN
    ldr x1, =week
    ldr x2, =4
    mov x8, SYS_READ
    svc 0

    // Parse input
    ldr x1, =pennies
    ldr x2, =nickels
    ldr x3, =dimes
    ldr x4, =quarters
    bl sscanf

    // Update totals
    ldr w1, [x1]
    add w1, w1, [total_pennies]
    str w1, [total_pennies]

    ldr w2, [x2]
    add w2, w2, [total_nickels]
    str w2, [total_nickels]

    ldr w3, [dimes]
    add w3, w3, [total_dimes]
    str w3, [total_dimes]

    ldr w4, [quarters]
    add w4, w4, [total_quarters]
    str w4, [total_quarters]

    // Move to next week
    add x8, x8, 1
    cmp x8, x9
    bne .week_loop

    // Calculate total cents
    ldr w0, [total_pennies]
    ldr w1, [total_nickels]
    lsl w1, w1, #2   // 5 nickels = 5 * 5 = 25 cents
    add w0, w0, w1

    ldr w1, [total_dimes]
    lsl w1, w1, #3   // 10 dimes = 10 * 10 = 100 cents
    add w0, w0, w1

    ldr w1, [total_quarters]
    lsl w1, w1, #4   // 16 quarters = 16 * 25 = 400 cents
    add w0, w0, w1

    str w0, [total_cents]

    // Convert total cents to dollars
    ldr w1, [total_cents]
    lsr w2, w1, #2   // Divide by 100 (shift right by 2 bits)
    scvtf s0, w2     // Convert to float
    str s0, [total_dollars]

    // Calculate weekly average
    ldr s0, [total_dollars]
    lsr w1, w0, #2   // Divide total cents by 4 (shift right by 2 bits)
    scvtf s1, w1     // Convert to float
    fdiv s0, s0, s1
    str s0, [weekly_average]

    // Calculate yearly savings
    ldr s0, [total_dollars]
    ldr s1, =52.0     // Load constant 52.0
    fmul s0, s0, s1   // Multiply by 52 weeks
    str s0, [yearly_savings]

    // Print results
    ldr x0, =total_msg
    ldr w1, [total_pennies]
    ldr w2, [total_nickels]
    ldr w3, [total_dimes]
    ldr w4, [total_quarters]
    bl printf

    ldr x0, =dollars_msg
    ldr s0, [total_dollars]
    bl printf

    ldr x0, =weekly_avg_msg
    ldr s0, [weekly_average]
    bl printf

    ldr x0, =yearly_savings_msg
    ldr s0, [yearly_savings]
    bl printf

    // Exit
    mov x0, 0
    ret

// Function to read input
sscanf:
    stp x19, x20, [sp, -16]!
    mov x19, x0
    mov x20, x1
    ldr x0, =__sscanf
    blr x0
    ldp x19, x20, [sp], 16
    ret

// Function to print message
printf:
    stp x19, x20, [sp, -16]!
    mov x19, x0
    mov x20, x1
    ldr x0, =__printf
    blr x0
    ldp x19, x20, [sp], 16
    ret