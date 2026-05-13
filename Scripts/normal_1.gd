extends Label


func _ready() -> void:
	$".".set("theme_override_constants/outline_size", 0)
	$".".set("theme_override_colors/font_outline_color", Color.WHITE)
	var sender = get_parent()
	if sender:
		sender.connect("up", Callable(self, "_up"))
		
	if sender:
		sender.connect("down", Callable(self, "_down"))
		
func _up():
	var tween = create_tween()
	tween.tween_property($".", "theme_override_constants/outline_size", 10, 0.2)

func _down():
	var tween = create_tween()
	tween.tween_property($".", "theme_override_constants/outline_size", 0, 0.2)
