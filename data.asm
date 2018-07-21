.include "global_constants.asm"

.globl framebuffer
.globl str_degree_error

.data
	# The framebuffer resides at the start of the data segment for reading by MARS' Bitmap Display tool.
	# Each display unit is represented by one 32-bit word.
	framebuffer:	.space	TOTAL_FRAMEBUFFER_SIZE
	
	# Error string that is printed by abort_with_degree_error.
	str_degree_error:	.asciiz		"The polynomial's degree is too high."