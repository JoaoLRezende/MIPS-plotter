.globl main
.globl framebuffer

.include "global_constants.asm"

.data
	# The framebuffer resides at the start of the data segment for reading by MARS' Bitmap Display tool.
	# Each display unit is represented by one 32-bit word.
	framebuffer:	.space	TOTAL_FRAMEBUFFER_SIZE

.text
main:
	# Allocate space to store a polynomial as a string; store a pointer to that space in $s0.
		li $v0, 9
		li $a0, 200
		syscall
		move $s0, $v0
	# Read a polynomial from the user.
		li $v0, 8
		move $a0, $s0
		li $a1, 200
		syscall
	# Get an array of that polynomial's coefficients; store its address in $s1.
		move $a0, $s0
		jal read_polynomial
		nop
		move $s1, $v0
	# Draw the polynomial's graph.
		move $a0, $s1
		jal plot_polynomial
		nop
	# Let the user do it again.
		j main
		nop
