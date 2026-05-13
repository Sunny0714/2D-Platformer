extends Control

@export var follow_speed := 10.0

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	position = position.lerp(mouse_pos, delta * follow_speed)
