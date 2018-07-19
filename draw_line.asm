.globl draw_line

.macro save_registers
	add $sp, $sp, -4
	sw $a3, ($sp)
	add $sp, $sp, -4
	sw $t0, ($sp)
	add $sp, $sp, -4
	sw $t1, ($sp)
	add $sp, $sp, -4
	sw $t2, ($sp)
	add $sp, $sp, -4
	sw $t3, ($sp)
	add $sp, $sp, -4
	sw $t4, ($sp)
.end_macro

.macro restore_registers
	lw $t4, ($sp)
	add $sp, $sp, 4
	lw $t3, ($sp)
	add $sp, $sp, 4
	lw $t2, ($sp)
	add $sp, $sp, 4
	lw $t1, ($sp)
	add $sp, $sp, 4
	lw $t0, ($sp)
	add $sp, $sp, 4
	lw $a3, ($sp)
	add $sp, $sp, 4
.end_macro

.include "global_constants.asm"

draw_line:
# Function that takes two coordinates (that is, two ordered pairs representing two points in the plane)
#	in adjacent columns and draws a line connecting them.
# Arguments:
#	$a0 and $a1: x and y coordinates of the leftmost point.
#	$a2 and $a3: x and y coordinates of the rightmost point.
# Registers used:
#	$t0: +1 if the second point has a higher y coordinate than the first, -1 otherwise (to be used as a delta).
#	$t1: the average between the y coordinates of the points.
#	$t2: x coordinate of the point being currently painted.
#	$t3: y coordinate of the point being currently painted.
#	$t4: y coordinate of the rightmost point plus the content of $t0, to be used as a stop condition.


	# Save $ra.
		add $sp, $sp, -4
		sw $ra, ($sp)
	# Initialize $t0.
		bgt $a3, $a1, second_is_higher
		nop
		second_is_lower:
			li $t0, -1
			j initialize_t1
			nop
		second_is_higher:
			li $t0, +1
	# Initialize $t1.
	initialize_t1:
		add $t1, $a1, $a3
		div $t1, $t1, 2
	# Initialize $t2, $t3, $t4. (We're gonna start at the leftmost point.)
		move $t2, $a0
		move $t3, $a1
		add $t4, $a3, $t0
	# If the leftmost point isn't actually in the column to the left of the second point, simply paint the second point.
		sub $t9, $a2, 1
		beq $t9, $a0, draw_loop
		nop
		move $t2, $a2
		move $t3, $a3
	# Draw the line.
	draw_loop:
		# Call paint_coordinate.
			save_registers
			move $a0, $t2
			move $a1, $t3
			jal paint_coordinate
			nop
			restore_registers
		# Move towards the second point vertically.
			add $t3, $t3, $t0
		# If we've reached the midpoint between the points, switch to the column of the rightmost point.
			bne $t3, $t1, reiterate
			nop
			add $t2, $t2, +1
		# Reiterate unless this was the last point to paint.
		reiterate:
			bne $t3, $t4, draw_loop
			nop
	# Restore $ra and return.
	return:
		lw $ra, ($sp)
		add $sp, $sp, 4
		jr $ra
		nop
		
