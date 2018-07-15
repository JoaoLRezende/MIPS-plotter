.globl  eval_polynomial
eval_polynomial:
# Function that returns the value of the input polynomial for a given x.
# Argument:
#	$a0: x.

	# Stub: return x².
		mul $v0, $a0, $a0
		jr $ra
		nop
