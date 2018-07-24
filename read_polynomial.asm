.globl	read_polynomial

.include "global_constants.asm"

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
	add $sp, $sp, -4
	sw $t8, ($sp)
	add $sp, $sp, -4
	sw $t9, ($sp)
.end_macro

.macro restore_registers
	lw $t9, ($sp)
	add $sp, $sp, 4
	lw $t8, ($sp)
	add $sp, $sp, 4
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


read_polynomial:
# Function that takes a pointer to a string that represents a polynomial, and returns a pointer
#	to a (self-allocated) array representing that polynomial for evaluation by eval_polynomial.
# Argument:
#	$a0: pointer to the polynomial string.
# Registesrs used:
#	$t0: pointer to the polynomial as a string.
#	$t1: pointer to the polynomial as an array.
#	$t2: pointer to the current char.
#	$t3: current char.
#	$t4: coefficient of the current term.
# 	$t5: degree of the current term.
#	$t6: address of the current element of the array to be set.
#	$t7: the highest exponent that can be handled (POLYNOMIAL_ARRAY_LENGTH − 1).
#	$t9: temp.
# Returns:
#	$v0: pointer to the polynomial array.

	# Save $ra.
		add $sp, $sp, -4
		sw $ra, ($sp)
	# Store the address of the string in $t0.
		move $t0, $a0
	# Allocate space for the polynomial array.
		li $v0, 9
		li $a0, POLYNOMIAL_ARRAY_SIZE
		syscall
		move $t1, $v0
	# Set $t7.
		li $t7, POLYNOMIAL_ARRAY_LENGTH
		add $t7, $t7, -1
	# Initialize $t2 and load the first char into $t3.
		move $t2, $t0
		lbu $t3, ($t2)
	# In a loop, read each of the polynomial's terms.
	main_loop:
		# Skip any leading shitespace.
			save_registers
			move $a0, $t2
			jal skip_whitespace
			nop
			restore_registers
			move $t2, $v0
		# Load the pointed-to char into $t3.
			lbu $t3, ($t2)
		# If it is is a null byte or a newline character, return.
			beq $t3, $0, return
			nop
			beq $t3, 10, return
			nop
		# Get the next coefficient. Check whether the next character is x.
				bne $t3, 120, not_x
				nop
			# If it is, we have no explicit coefficient; set $t4 to 1.
				li $t4, 1
				j after_getting_coefficient
				nop
			# If it isn't, we're pointing to the next coefficient. Read it and store it into $t4.
			not_x:
				save_registers
				move $a0, $t2
				jal atoi
				nop
				restore_registers
				move $t4, $v0
				move $t2, $v1
		after_getting_coefficient:
		# Skip whitespace.
			save_registers
			move $a0, $t2
			jal skip_whitespace
			nop
			restore_registers
			move $t2, $v0
		# If we're not pointing at an x, this term has no x (is a constant term). skip the reading of
		#	 an exponent, pretend we've read x^0 instead.
			lbu $t3, ($t2)
			beq $t3, 120, is_x
			nop
			li $t5, 0
			j store_in_array
			nop
		is_x:
		# Increment $t2. (We're pointing to x; we want to point to what comes after it.)
			add $t2, $t2, 1
		# Get the exponent.
			# Check whether the next char is superscript number.
				lbu $t3, ($t2)
				# If it is a '⁰', store 0 in $t5.
					bne $t3, 112, check_superscript_1
					nop
					li $t5, 0
					add $t2, $t2, 1
					j store_in_array
					nop
				# If it is a '¹', store 1 in $t5.
				check_superscript_1:
					bne $t3, 185, check_superscript_2
					nop
					li $t5, 1
					add $t2, $t2, 1
					j store_in_array
					nop
				# If it is a '²', store 2 in $t5.
				check_superscript_2:
					bne $t3, 178, check_superscript_3
					nop
					li $t5, 2
					add $t2, $t2, 1
					j store_in_array
					nop
				# If it is a '³', store 3 in $t5.
				check_superscript_3:
					bne $t3, 179, check_superscript_4
					nop
					li $t5, 3
					add $t2, $t2, 1
					j store_in_array
					nop
				# If it is a '4', store 4 in $t5.
				check_superscript_4:
					bne $t3, 116, after_superscript_check
					nop
					li $t5, 4
					add $t2, $t2, 1
					j store_in_array
					nop
			after_superscript_check:
			# Check whether the next char is a circumflex.
				lbu $t3, ($t2)
				bne $t3, 94, no_circumflex
				nop
				j circumflex
				nop
				no_circumflex:
				# If it isn't, we have no explicit exponent: store 1 in $t5.
					li $t5, 1
					j store_in_array
					nop
				circumflex:
				# If it is, read the exponent and store it in $t5.
					add $a0, $t2, 1
					save_registers
					jal atoi
					nop
					restore_registers
					move $t5, $v0
					move $t2, $v1
					# If the read exponent is greater than the highest exponent we can handle, terminate.
						ble $t5, $t7, store_in_array
						nop
						li $v0, 4
						la $a0, str_degree_error
						syscall
						jal clear_screen
						nop
						li $v0, 10
						syscall
		# Store the read coefficient in the position of the array determined by the exponent.
		store_in_array:
			# Get the address of the array's word to be set.
				mul $t6, $t5, 4
				add $t6, $t1, $t6
			# Add the read coefficient to what is already there there.
				# Load the word into $t9.
					lw $t9, ($t6)
				# Add to it the coefficient read.
					add $t9, $t9, $t4
					sw $t4 ($t6)
				# Store the sum back in the array.
					sw $t9, ($t6)
		# Reiterate:
			j main_loop
			nop
	return:
	# Recover $ra.
		lw $ra, ($sp)
		add $sp, $sp, 4
	# Return.
		move $v0, $t1
		jr $ra
		nop
