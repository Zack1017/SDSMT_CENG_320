

/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);

*/ 
.data 
	.equ rows, 0 
	.equ width, 8
	.equ height, 12
	.equ red, 0
	.equ blue, 1
	.equ green, 2
	.equ gray, 0
	.equ rgbpixel_size, 3

	.text
	.global	color_to_gray
color_to_gray:
	stp x29, x30, [sp, #-16]

	mov x20, x0
	ldr w21, [x20, width] //heights  aka rows
	ldr w22, [x20, height]
 	
	mov x0, x21
	mov x1, x22

	bl allocate_grayimage
	mov x23, x0

	mov x4, #0 // create i aka rows
	mov x15, #0 //row offset
	ldr x12, [x20, #0] //point to a row of the rgbimage
rowLoop:
	cmp w4, w21
	bge done
	mov x5, #0 // create j aka cols
	mov x6, #0
colLoop:
	cmp w5, w22
	bge nextRow

	ldr x14, [x12, x15] // gets row

	ldr x7, [x14, x6]
	add x6, x6, #1
	ldr x9, [x14, x6]
	add x6, x6, #1
	ldr x9, [x14, x6]
	add x6, x6, #1

	//Mul start
	mov x11, #54
	mul x7, x7, x4
	mov x11, #184
	mul x8, x8, x4
	mov x11, #18
	mul x9, x9, x4

	add w10, w7, w8
	add w10, w10, w9
	lsr x10, x10, #16

	strb w10, [x23, x5]
	add w5, w5, #1
	b colLoop
nextRow:
	add w4, w4, #1
	add w15, w15, #8
	b rowLoop
done:
	ldp x29, x30, [sp], #16
	ret
