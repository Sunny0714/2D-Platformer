extends Sprite2D

func _ready() -> void:
	z_index=100
	var sender = get_parent()
	hide()
	if sender:
		sender.connect("start1", Callable(self, "_on_start"))

func _on_start():
	show()
