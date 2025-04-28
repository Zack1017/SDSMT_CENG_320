.data
.equ array, 0
.equ frontIndex, 208
.equ endIndex, 212
.equ nItems, 216
.equ MAX_QUEUE_SIZE, 52

.text 
.type _ZN5queue5enqueEi, %function 
.type _ZN5queue5dequeERi, %function 

.global	_ZN5queue5enqueEi
.global _ZN5queue5dequeERi

_ZN5queue5enqueEi:
   
    stp x29, x30, [sp, #-16]!
    
    ldr w22, [x0, endIndex] // endindex
    ldr w23, [x0, nItems] //nitem
    

   //checks if full 
    cmp w23, MAX_QUEUE_SIZE
    beq queue_full

    str w1, [x0, x22, lsl #2] //x5 = array at end with shift 
    
    //change index 
    add w22, w22, #1
    cmp w22, MAX_QUEUE_SIZE
    blt not_wrapped
    mov w22, #0

not_wrapped:
    str w22, [x0, endIndex]
    
    add w23, w23, #1
    str w23, [x0, nItems] // n index udpate 

    mov w0, #1
    b done 
    
//return 0
queue_full:
    mov w0, #0
    b done

_ZN5queue5dequeERi:

    stp x29, x30, [sp,#-16]!

    str x24, [x0, frontIndex]
    str x23, [x0, nItems]
    str x22, [x0, endIndex]
     
    cbz x23, queueEmpty
    
    ldr w4, [x0, x24, lsl #2]
    str w4, [x0]

    add x24, x24, #1
    cmp w22, MAX_QUEUE_SIZE
    blt not_wrapped_d
    mov x24, #0

not_wrapped_d:

    sub x23, x23, #1
    str x23, [x0, nItems]
    b done

queueEmpty:
    mov w0, #0
    b done





//clean up 
done:
    ldp x29, x30, [sp], #16
    ret
