	# The screen's width and height are measured by the Bitmap Display tool in display units;
	# their number is equal to the total number of pixels divided by the number of pixels per unit.
	# Each display unit corresponds to one cartesian-plane point of integral coordinates.
	.eqv	DISPLAY_WIDTH		256	# = 512 / 2
	.eqv	DISPLAY_HEIGHT		128	# = 256 / 2
	# The framebuffer's size (in bytes) must then be 4 * DISPLAY_WIDTH * DISPLAY_HEIGHT.
	.eqv	TOTAL_FRAMEBUFFER_SIZE	131072	# = 4 * 256 *128


	# Colors.
	.eqv  BG_COLOR     0xFFFFFF  # white
	.eqv  GRAPH_COLOR  0xFF0000  # red
	.eqv  AXES_COLOR   0x000000  # black

	
	# The structure that represents a polynomial is an array of 32-bit signed integers representing the
	# coefficients of the polynomial's terms.
	# The n-th element of the array is the coefficient of the term of degree n.
	# The highest polynomial degree that can be handled is equal to the array's length minus one.
	.eqv	POLYNOMIAL_ARRAY_LENGTH		5	# in words
	.eqv	POLYNOMIAL_ARRAY_SIZE		20	# in bytes; equal to 4 * POLYNOMIAL_ARRAY_LENGTH
