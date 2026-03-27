extends Label

var hue := 0.0

func _process(delta):
	hue += delta * 0.2  # speed (change this to go faster/slower)
	if hue > 1.0:
		hue = 0.0

	# Convert HSV → RGB and apply color
	modulate = Color.from_hsv(hue, 1.0, 1.0)
