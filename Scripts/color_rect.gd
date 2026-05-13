extends ColorRect

func fade_to_black(duration := 0.5):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	await tween.finished
