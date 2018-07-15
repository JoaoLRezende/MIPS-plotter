.globl draw_horizontal_axis

.include "global_constants.asm"

draw_horizontal_axis:
# Draws a horizontal line across the whole screen's width, vertically centered.
# Registers used:
#	$t0: address of the current framebuffer word.
#	$t1: address of the first display unit of the next row (to be used as a stop condition).
#	$t2: AXES_COLOR.
# 	$t3: address of the framebuffer.

	# Initialize $t2 and $t3.
		li $t2, AXES_COLOR
		la $t3, framebuffer
	# Initialize $t0 to the address of the first display unit of the row.
		li $t0, DISPLAY_HEIGHT
		mul $t0, $t0, DISPLAY_WIDTH
		div $t0, $t0, 2
		mul $t0, $t0, 4
		add $t0, $t0, $t3
	# Initialize $t1 to the address of the first display unit of the next row.
		li $t1, 4
		mul $t1, $t1, DISPLAY_WIDTH
		add $t1, $t1, $t0
	# Paint each unit.
	for_each_unit:
		sw $t2, ($t0)
		add $t0, $t0, 4
		bne $t0, $t1, for_each_unit
		nop
	# Return.
		jr $ra
		nop
