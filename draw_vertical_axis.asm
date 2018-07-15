.globl draw_vertical_axis

.include "global_constants.asm"

draw_vertical_axis:
# Draws a horizontal line across the whole screen's height, horizontally centered.
# Registers used:
#	$t0: address of the current framebuffer word.
#	$t1: address of the last display unit of the column (to be used as a stop condition).
#	$t2: COLOR.
# 	$t3: address of the framebuffer.
#	$t4: DISPLAY_WIDTH * 4 = the difference between the address of a display unit and the address of the unit below it.

	# Initialize $t2, $t3 and $t4.
		li $t2, AXES_COLOR
		la $t3, framebuffer
		li $t4, DISPLAY_WIDTH
		mul $t4, $t4, 4
	# Initialize $t0 to the address of the first display unit of the column.
		li $t0, DISPLAY_WIDTH
		div $t0, $t0, 2
		mul $t0, $t0, 4
		add $t0, $t0, $t3
	# Initialize $t1 to the address of the last display unit of the column, which is equal to $t0 + (height-1) * width * 4.
		li $t1, DISPLAY_HEIGHT
		sub $t1, $t1, 1
		mul $t1, $t1, DISPLAY_WIDTH
		mul $t1, $t1, 4
		add $t1, $t1, $t0
	# Paint each unit.
	for_each_unit:
		sw $t2, ($t0)
		add $t0, $t0, $t4
		bne $t0, $t1, for_each_unit
		nop
	# Return.
		jr $ra
		nop
