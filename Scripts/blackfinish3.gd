extends Sprite2D

@onready var anim = $AnimationPlayer
func _ready() -> void:
	z_index=100
	var sender = get_parent()
	if sender:
		sender.connect("finish1", Callable(self, "_on_finish"))

func _on_finish():
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10)), 0.05)
	tween.tween_property(camera, "global_position", camera.global_position, 0.05)
	await get_tree().create_timer(0.4).timeout
	hide()
