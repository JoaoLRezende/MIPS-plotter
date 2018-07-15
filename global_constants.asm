	# The screen's width and height are measured by the Bitmap Display tool in display units;
	# their number is equal to the total number of pixels divided by the number of pixels per unit.
	# Each display unit corresponds to one cartesian-plane point of integral coordinates.
	.eqv	DISPLAY_WIDTH		256	# = 512 / 2
	.eqv	DISPLAY_HEIGHT		128	# = 256 / 2
	# The framebuffer's size (in bytes) must then be 4 * DISPLAY_WIDTH * DISPLAY_HEIGHT.
	.eqv	TOTAL_FRAMEBUFFER_SIZE	131072	# = 4 * 256 *128


	.eqv  BG_COLOR     0xFFFFFF  # white
	.eqv  GRAPH_COLOR  0xFF0000  # red
	.eqv  AXES_COLOR   0x000000  # black
