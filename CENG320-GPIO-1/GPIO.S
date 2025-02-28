

	.equ PERI_BASE, 0x3F000000
	.equ GPIO_BASE, (PERI_BASE + 0x200000)
	.equ GPIOOFSEL0, (GPIO_BASE + 0x00)
	.equ GPIOOFSEL1,  0x04
	.equ GPIOOFSEL2,  0x08
	
	.equ maskG23_1, (0b111 << 3)
	.equ maskTest, (0b001 << 6)
	.equ maskG24_1, (0b111 << 9)
	.equ maskG5_1, (0b111 << 15)
	.equ maskG5_2, (0b001 << 15)
	.equ maskG6_1, (0b111 << 18)
	.equ maskG6_2, (0b001 << 18)
	.equ maskG16_1, (0b111 << 18)
	.equ maskG16_2, (0b001 << 18)
	.equ maskG26_1, (0b111 << 18)
	.equ maskG26_2, (0b001 << 18)
	
	.equ setZero_5,  (0b1 << 5)
	.equ setZero_6,  (0b1 << 6)
	.equ setZero_16, (0b01 << 16)
	.equ setZero_26, (0b01 << 26)
	
	.equ setOne_5,  (0b0 << 5)
	.equ setOne_6,  (0b1 << 6)
	.equ setOne_16, (0b01 << 16)
	.equ setOne_26, (0b01 << 26)
	
	.equ GPIO_In, 0x34
	.equ GPIO_CLR, 0x28
	.equ GPIO_Set, 0x1C
	.equ Cout_up, 2

	
	
.global main

	


main:
	stp x29, x30, [sp, #-16]!
	bl setup_io
	
IO_Setup:

	//GPIO Select1
	ldr x1, [x0]

	
	
	//GPIO 5
	bic x1,x1, maskG5_1
	mov x2, maskG5_2
	orr x1, x1, x2

	//GPIO 6
	bic x1,x1, maskG6_1
	mov x2, maskG6_2
	orr x1, x1, x2
	
	str x1, [x0]
	
	
	//GPIO Select1
	ldr w1, [x0, GPIOOFSEL1]
	
	//GPIO 16
	bic w1, w1, #maskG16_1
	mov w2, maskG16_2
	orr w1, w1, w2
	
	str w1, [x0, GPIOOFSEL1]
	
	//GPIO Select2
	ldr w1, [x0, GPIOOFSEL2]
	
	//GPIO 23
	bic x1,x1,#maskG23_1

	
	//GPIO 24
	bic x1,x1,#maskG24_1 
	
	//GPIO 26
	bic w1, w1, #maskG26_1
	mov w2, maskG26_2
	orr w1, w1, w2
	
	str w1, [x0, GPIOOFSEL2]
	
	mov x22, #10
	
	b zero
	
	
	
	
	
	
UpdateLight:
	
	
	//cmp x22, #16
	//beq zero
	
	and w5, w22, #1
	eor w5, w5, #1 	//5
	
	lsr w6, w22, #1
	and w6, w6, #1
	eor w6, w6, #1
	
	lsr w7, w22, #2
	and w7, w7, #1
	eor w7, w7, #1
	
	lsr w8, w22, #3
	and w8, w8, #1
	eor w8, w8, #1
	
	
	ldr w2, [x0, GPIO_Set ]
	
	
	
	
	str w2, [x0, GPIO_Set ]
	
	
	
	
	
	
Button_Press:
	ldr w1, [x0, GPIO_In]
	tbnz w1, #23, Count_Up  
	tbnz w1, #24, Count_down	  
	b Button_Press
	
Count_Up:

	add x22, x22, #1
	b UpdateLight	
	
Count_down:

	sub x22, x22, #1
	b UpdateLight

zero:
	ldr w2, [x0, GPIO_Set ]
	
	bic w2, w2, setZero_5
	mov x3, setZero_5
	orr x2, x2, x3
	
	bic w2, w2, setZero_6
	mov x3, setZero_6
	orr x2, x2, x3
	
	bic w2, w2, setZero_16
	mov x3, setZero_16
	orr x2, x2, x3
	
	bic w2, w2, setZero_26
	mov x3, setZero_26
	orr x2, x2, x3
	
	str w2, [x0, GPIO_Set ]
	
	b Button_Press
	
	
	ldp x29, x30, [sp], #16
ret

	//mov x2, maskTest
	//orr x1, x1, x2
	
