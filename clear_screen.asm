.globl clear_screen

.include "global_constants.asm"

clear_screen:
# Function that sets all display units to BG_COLOR.
# Registers used:
#	$t0: BG_COLOR.
#	$t1: address of current display unit.
#	$t2: address of the framebuffer's last display unit.

	# Initialize $t0 and $t1.
		li $t0, BG_COLOR
		la $t1, framebuffer
	# Initialize $t2, which will be equal to &framebuffer + 4 * DISPLAY_HEIGHT * DISPLAY_WIDTH.
		li $t2, DISPLAY_HEIGHT
		mul $t2, $t2, DISPLAY_WIDTH
		mul $t2, $t2, 4
		add $t2, $t2, $t1
	# Paint every unit.
	for_each_unit:
		sw $t0, ($t1)
		add $t1, $t1, 4
		bne $t1, $t2, for_each_unit
		nop
	# Return.
		jr $ra
		nop
