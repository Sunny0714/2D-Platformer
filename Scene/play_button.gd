extends Button

var y: float
var hue := 0.0

func _ready() -> void:
	y = position.y
	var sender = get_parent()
	if sender:
		sender.connect("play1", Callable(self, "_up"))
		
	if sender:
		sender.connect("unplay1", Callable(self, "_down"))
		
func _up():
	position.y = y + 5

func _down():
	position.y = y

func _process(delta):
	hue += delta * 0.4 
	if hue > 0.5:
		hue = 0.0

	modulate = Color.from_hsv(hue, 1.0, 1.0)
