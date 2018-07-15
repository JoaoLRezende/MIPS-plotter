.globl	plot_polynomial

.include "global_constants.asm"

plot_polynomial:
# Function that draws the graph of a polynomial (as evaluated by eval_polynomial) on the screen.
# Registers used:
#	$t0: current x.
#	$t1: f(x).
#	$t3: previous x.
#	$t4: previous f(x).
#	$t5: x coordinate of the last visible column (to be used as a stop condition).
#	$t6: y coordinate of the highest visible column.
#	$t7: y coordinate of the lowest visible column.

	# Save $ra.
		add $sp, $sp, -4
		sw $ra, ($sp)
	# Clear the screen and draw the axes.
		jal clear_screen
		nop
		jal draw_vertical_axis
		nop
		jal draw_horizontal_axis
		nop
	# Initialize $t5.
		li $t5, DISPLAY_WIDTH
		div $t5, $t5, 2
	# Initialize $t0.
		mul $t0, $t5, -1
	# Initialize $t3.
		move $t3, $t0
	# Initialize $t6.
		li $t6, DISPLAY_HEIGHT
		div $t6, $t6, 2
	# Initialize $t7.
		mul $t7, $t6, -1
	# Draw the graph
	for_every_x:
		# Calculate f(x).
			# Save $t0, $t1, $t3, $t4, $t5, $t6, $t7.
				add $sp, $sp, -4
				sw $t0, ($sp)
				add $sp, $sp, -4
				sw $t1, ($sp)
				add $sp, $sp, -4
				sw $t3, ($sp)
				add $sp, $sp, -4
				sw $t4, ($sp)
				add $sp, $sp, -4
				sw $t5, ($sp)
				add $sp, $sp, -4
				sw $t6, ($sp)
				add $sp, $sp, -4
				sw $t7, ($sp)
			# Call eval_polynomial.
				move $a0, $t0
				jal eval_polynomial
				nop
			# Recover $t0, $t1, $t3, $t4, $t5, $t6, $t7.
				lw $t7, ($sp)
				add $sp, $sp, 4
				lw $t6, ($sp)
				add $sp, $sp, 4
				lw $t5, ($sp)
				add $sp, $sp, 4
				lw $t4, ($sp)
				add $sp, $sp, 4
				lw $t3, ($sp)
				add $sp, $sp, 4
				lw $t1, ($sp)
				add $sp, $sp, 4
				lw $t0, ($sp)
				add $sp, $sp, 4
			# Store eval_polynomial's return value in $t1.
				move $t1, $v0
		# Check whether the display row of index f(x) is visible in the graph window. If it isn't, don't try to paint anything.
			bgt $t1, $t6, update_t3_t4
			nop
			blt $t1, $t7, update_t3_t4
			nop
		# Paint the correspoding point in the plane, and draw a line between it and the previous point.
			# Save $t0, $t1, $t3, $t4, $t5, $t6, $t7.
				add $sp, $sp, -4
				sw $t0, ($sp)
				add $sp, $sp, -4
				sw $t1, ($sp)
				add $sp, $sp, -4
				sw $t3, ($sp)
				add $sp, $sp, -4
				sw $t4, ($sp)
				add $sp, $sp, -4
				sw $t5, ($sp)
				add $sp, $sp, -4
				sw $t6, ($sp)
				add $sp, $sp, -4
				sw $t7, ($sp)
			# Call draw_line.
				move $a0, $t3
				move $a1, $t4
				move $a2, $t0
				move $a3, $t1
				jal draw_line
				nop
			# Recover $t0, $t1, $t3, $t4, $t5, $t6, $t7.
				lw $t7, ($sp)
				add $sp, $sp, 4	
				lw $t6, ($sp)
				add $sp, $sp, 4	
				lw $t5, ($sp)
				add $sp, $sp, 4				
				lw $t4, ($sp)
				add $sp, $sp, 4
				lw $t3, ($sp)
				add $sp, $sp, 4
				lw $t1, ($sp)
				add $sp, $sp, 4
				lw $t0, ($sp)
				add $sp, $sp, 4
		# Update $t3 and $t4.
		update_t3_t4:
			move $t3, $t0
			move $t4, $t1
		# Reiterate unless this was the last visible column.
			beq $t0, $t5, return
			nop
			add $t0, $t0, 1
			j for_every_x
			nop
	# Return.
	return:
		lw $ra, ($sp)
		add $sp, $sp, 4
		jr $ra
		nop
	
