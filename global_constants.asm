	# The screen's width and height are measured by the Bitmap Display tool in display "units"; they're equal
	# to the number of pixels divided by the number pixels per unit.
	.eqv	DISPLAY_WIDTH		256	# = 512 / 2
	.eqv	DISPLAY_HEIGHT		128	# = 256 / 2
	# The framebuffer's size (in bytes) must then be 4 * DISPLAY_WIDTH * DISPLAY_HEIGHT.
	.eqv	TOTAL_FRAMEBUFFER_SIZE	131072	# = 4 * 256 *128
	# This program makes no assumptions about the size of the screen, and should accept
	# viewports of any reasonable size. Each display unit corresponds to one cartesian-plane
	# point of integer coordinates.



	.eqv  BG_COLOR     0xFFFFFF  # white
	.eqv  GRAPH_COLOR  0xFF0000  # red
	.eqv  AXES_COLOR   0x000000  # black
