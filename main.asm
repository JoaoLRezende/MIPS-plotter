.globl main
.globl framebuffer

.include "global_constants.asm"

.data
	# The framebuffer resides at the start of the data segment for reading by MARS' Bitmap Display tool.
	# Each display unit is represented by one 32-bit word in the framebuffer.
	framebuffer:	.space	TOTAL_FRAMEBUFFER_SIZE

.text
main:
	
	# Stub.
	jal plot_polynomial
	nop
