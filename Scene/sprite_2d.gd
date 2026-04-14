extends Sprite2D

func _process(delta: float) -> void:
	if PlayerStats.score >= 5:
		modulate = Color(1.3, 1.3, 1.3, 0.85)
	else:
		modulate = Color(0.305, 0.305, 0.305, 0.5)
