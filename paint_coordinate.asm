.globl paint_coordinate

.include "global_constants.asm"

paint_coordinate:
# Function that paints the display unit that represents a specific point of the cartesian plane.
# Arguments:
#	$a0: x coordinate.
#	$a1: y coordinate.
# Registers used:
#	$t0: column of the display unit.
#	$t1: row of the display unit.
#	$t2: address of the framebuffer.
#	$t3: address of the display unit.
#	$t4: temp.
#	$t5: GRAPH_COLOR.
#	$t6: temp.

	# Initialize $t2 and $t5.
		la $t2, framebuffer
		li $t5, GRAPH_COLOR
	# Initialize $t0.
		li $t0, DISPLAY_WIDTH
		div $t0, $t0, 2
		add $t0, $t0, $a0
	# Initialize $t1.
		li $t1, DISPLAY_HEIGHT
		div $t1, $t1, 2
		sub $t1, $t1, $a1
	# Check that the row index just stored in $t1 exists (is in the graph window). If it doesn't, simply return.
		blt $t1, 0, return
		nop
		bge $t1, DISPLAY_HEIGHT, return
		nop
	# Initialize $t3 to  &framebuffer   +   $t1 * DISPLAY_WIDTH * 4   +   4 * $t0.
		# Store in $t3:  4 * $t0.
			li $t3, 4
			mul $t3, $t3, $t0
		# Store in $t4:  $t1 * DISPLAY_WIDTH * 4.
			mul $t4, $t1, DISPLAY_WIDTH
			mul $t4, $t4, 4
		# Add those values and the address of the framebuffer and store the result in $t3.
			add $t3, $t3, $t4
			add $t3, $t3, $t2
	# Paint the display unit.
		sw $t5, ($t3)
	# Return.
	return:
		jr $ra
		nop
