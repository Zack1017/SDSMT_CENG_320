.section .text
.global bigint_alloc

bigint_alloc:
    // Allocate memory for bigint structure
    mov     x0, x1                  // Move chunks argument to x0 (number of chunks)
    ldr     x1, =sizeof(bigint_struct) // Load size of bigint_struct into x1
    bl      malloc                  // Call malloc to allocate memory for bigint structure
    cmp     x0, #0                  // Check if malloc failed (returned NULL)
    beq     error_exit              // Branch to error_exit if malloc failed
    
    // Initialize bigint structure fields
    str     x0, [x0]                // Store allocated memory address in bigint structure pointer
    str     x1, [x0, #0x8]          // Store size of bigint structure in bigint structure
    
    // Allocate memory for bigint->blks array
    ldr     x1, [x0, #0x8]          // Load size of bigint structure into x1
    ldr     x2, =sizeof(chunk)      // Load size of chunk into x2
    mul     x1, x1, x2              // Calculate total size needed for bigint->blks array
    bl      calloc                  // Call calloc to allocate memory for bigint->blks array
    cmp     x0, #0                  // Check if calloc failed (returned NULL)
    beq     error_exit              // Branch to error_exit if calloc failed
    
    // Initialize bigint->blks array pointer
    str     x0, [x0, #0x10]         // Store allocated memory address in bigint->blks pointer
    
    // Return pointer to allocated bigint structure
    ret

error_exit:
    mov     x0, #0                  // Set return value to NULL
    ret

.section .bss
.align 3
.type bigint_struct, %object
.size bigint_struct, 0x10

.align 3
.type chunk, %object
.size chunk, 0x8