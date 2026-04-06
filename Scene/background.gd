extends TextureRect

@export var pulse_speed := 2.0
@export var min_alpha := 0.8
@export var max_alpha := 1.0

func _process(delta):
	var alpha = lerp(min_alpha, max_alpha, 0.5 + 0.5 * sin(Time.get_ticks_msec() / 500.0))
	modulate.a = alpha
