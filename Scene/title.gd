extends Label

var hue := 0.0

func _process(delta):
	hue += delta * 0.2
	if hue > 1.0:
		hue = 0.0

	modulate = Color.from_hsv(hue, 1.0, 1.0)
