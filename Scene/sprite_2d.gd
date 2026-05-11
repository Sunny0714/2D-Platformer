extends Sprite2D


func _ready() -> void:
	var sender = get_parent()
	hide()
	if sender:
		sender.connect("half", Callable(self, "blur"))

func blur():
	show()
