.globl  eval_polynomial

.include "global_constants.asm"

eval_polynomial:
# Function that returns the value of a polynomial (received as an array of coefficients) for a given x.
# Arguments:
#	$a0: x.
#	$a1: address of the integer array that represents the polynomial.
# Returns:
#	$v0: the value of the polynomial for the given x.
# Registers used:
#	$t0: x
#	$t1: degree of the current term (= index of the array element being dealt with).
#	$t4: base address of the array.
#	$t5; address of current element of the array.
#	$t6: current element of the array.
#	$t7: the result.

	# Set $t0, $t4.
		move $t0, $a0
		move $t4, $a1
	# Initialize $t1 to the highest degree of the polynomial.
		li $t1, POLYNOMIAL_ARRAY_LENGTH
		add $t1, $t1, -1
	# Initialize $t5 to the address of the last element of the array.
		mul $t5, $t1, 4
		add $t5, $t5, $t4
	# Initialize $t7.
		li $t7, 0
	# Execute Horner's method, as described in https://en.wikipedia.org/wiki/Horner%27s_method.
	main_loop:
		# Load the next coefficient into $t6.
			lw $t6, ($t5)
		# Multiply the current result by x.
			mul $t7, $t7, $t0
		# Add it to the current coefficient.
			add $t7, $t7, $t6
		# Prepare for the next iteration.
			# If this was the last coefficient, return,
				beq $t5, $t4, return
				nop
			# Else, decrement $t1, $t5 and reiterate.
				add $t1, $t1, -1
				add $t5, $t5, -4
				j main_loop
				nop
	return:
	# Return.
		move $v0, $t7
		jr $ra
		nop
