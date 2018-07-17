.globl skip_whitespace

skip_whitespace:
# Function that takes a string and returns a pointer to its first byte that isn't a space character.
# Argument:
#	$a0: the address of the string.
# Returns:
#	$v0: address of the first non-space character.
# Registers used:
#	$t0: the character pointed to.

	# Increment the pointer until the character pointed to by it isn't a space.
	increment:
		lbu $t0, ($a0)
		bne $t0, 32, return
		nop
		add $a0, $a0, 1
		j increment
	# Return.
	return:
		move $v0, $a0
		jr $ra
		nop