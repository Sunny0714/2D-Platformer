extends Sprite2D

func _ready() -> void:
	z_index=100
	var sender = get_parent()
	hide()
	if sender:
		sender.connect("start", Callable(self, "_on_start"))

func _on_start():
	show()
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10)), 0.05)
	tween.tween_property(camera, "global_position", camera.global_position, 0.05)
