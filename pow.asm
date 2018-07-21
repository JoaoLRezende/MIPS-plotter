.globl pow

pow:
# Function that returns its first argument raised to its second.
# Arguments:
#	$a0: the base.
#	$a1: the exponent.
# Registers used:
#	$t0: number of times the base has been multiplied by itself.
# Returns:
#	$v0: the result.

	# Initialize $t0 to 0 and $v0 to 1.
		li $t0, 0
		li $v0, 1
	# Multiply $v0 by the base until we've done it $a1 times.
	main_loop:
		beq $t0, $a1, return
		nop
		mul $v0, $v0, $a0
		add $t0, $t0, 1
		j main_loop
		nop
	# Return.
	return:
		jr $ra
		nop
