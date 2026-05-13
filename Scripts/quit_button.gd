extends Button

var y: float

func _ready() -> void:
	y = position.y
	var sender = get_parent()
	if sender:
		sender.connect("play", Callable(self, "_up"))
		
	if sender:
		sender.connect("unplay", Callable(self, "_down"))
		
func _up():
	position.y = y + 5

func _down():
	position.y = y
