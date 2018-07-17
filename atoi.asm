.macro save_registers
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
	add $sp, $sp, -4
	sw $t5, ($sp)
	add $sp, $sp, -4
	sw $t6, ($sp)
	add $sp, $sp, -4
	sw $t7, ($sp)
.end_macro

.macro restore_registers
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
	lw $t2, ($sp)
	add $sp, $sp, 4
	lw $t1, ($sp)
	add $sp, $sp, 4
	lw $t0, ($sp)
	add $sp, $sp, 4
.end_macro


atoi:	.globl atoi
# Function that takes a pointer to a string of decimal ASCII digits and returns the value of the number represented
# 	by that string as a 32-bit signed integer. Before the digits, the string may contain whitespace and either
#	a plus sign or a minus sign,
#	The function stops reading when it finds any non-digit character, and also returns a pointer to that character.
# Argument:
#	$a0: pointer to string.
# Registers used:
#	$t0: pointer to the first digit.
#	$t1: pointer to the current char.
#	$t2: the current char.
#	$t3: 1 if the number is positive, −1 if negative.
#	$t4: length of the number (in digits).
#	$t5: the number's value.
#	$t6: the index of the current digit. (The digit of least value, which is the rightmost one, has index 0.)
#	$t7: weight of the current digit; its index multiplied by 10.
# Returns:
#	$v0: the number.
#	$v1: address of the first byte after the digit string.

	# Save $ra.
		add $sp, $sp, -4
		sw $ra, ($sp)
	# Store in $t1 the address of the first visible character in the string (which might be a plus or minus sign).
		jal skip_whitespace
		nop
		move $t1, $v0
	# Check whether it is a plus or minus sign and set $t3 accordingly. If it is, also increment the pointer.
		# Load the char into $t2.
			lbu $t2, ($t1)
		# Initialize $t3 to 1. (If it has no sign, it's positive.)
			li $t3, 1
		# If it is a plus sign, simply increment the pointer.
			bne $t2, 43, minus_verification
			nop
			add $t1, $t1, 1
			j after_sign_verification
			nop
		# If it is a minus sign, set $t3 to −1 and increment the pointer.
		minus_verification:
			bne $t2, 45, after_sign_verification
			nop
			li $t3, -1
			add $t1, $t1, 1
	after_sign_verification:
	# Skip any other space characters that might exist.
		move $a0, $t1
		save_registers
		jal skip_whitespace
		nop
		restore_registers
		move $t1, $v0
	# Store the resulting pointer in $t0.
		move $t0, $t1
	# Count how many digits the number has.
		# Initialize $t4 to 0.
			li $t4, 0
		# Do the counting in a loop.
		count_loop:
			# Get the pointed-to char.
				lbu $t2, ($t1)
			# If it is not a digit, break out of the loop. Else, increment $t4 and $t1 and reiterate.
				blt $t2, 48, after_count_loop
				nop
				bgt $t2, 57, after_count_loop
				nop
				add $t4, $t4, 1
				add $t1, $t1, 1
				j count_loop
				nop
	after_count_loop:
	# Calculate the number's value.
		# Start from the first digit.
			move $t1, $t0
		# Initialize $t5 to 0.
			li $t5, 0
		# Initialize $t6 to the index of the leftmost digit, which is equal to $t4 − 1.
			add $t6, $t4, -1
		# Initialize $t7 to the weight of the leftmost digit, which is equal to the base (10) raised to its index.
			# Call pow.
				save_registers
				li $a0, 10
				move $a1, $t6
				jal pow
				nop
				restore_registers
				move $t7, $v0
		# Take the sum of the values of all digits; store in $t5.
		main_loop:
			# Get the current digit.
				lbu $t2, ($t1)
			# Its value is equal to itself times its weight.
				add $t2, $t2, -48
				mul $t2, $t2, $t7
				add $t5, $t5, $t2
			# If this was the last digit, return.
				beq $t6, $zero, end_main_loop
				nop
			# Prepare for the next iteration and reiterate.
				# Increment $t1.
					add $t1, $t1, 1
				# The next digit's weight will be equal to be the current digit's weight divided by 10.
					div $t7, $t7, 10
				# The next digit's index will be this one's index minus one.
					add $t6, $t6, -1
				# Reiterate.
					j main_loop
					nop
			
		end_main_loop:
		# If a minus sign was found before the digit string, negate $t5.
			mul $t5, $t5, $t3
	# Restore $ra.
		lw $ra, ($sp)
		add $sp, $sp, 4
	# Return.
		move $v0, $t5
		add $v1, $t1, 1
		jr $ra
		nop
		


# Yes, this would've been easier, simpler, faster, and wouldn't have needed a pow function if I had just traversed the string
# backwards. idgaf, it works.