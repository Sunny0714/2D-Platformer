extends Button

var y: float
var x: float
var hue := 0.2

func _ready() -> void:
	y = position.y
	x = position.x
	var sender = get_parent()
	if sender:
		sender.connect("up1", Callable(self, "_up"))
		
	if sender:
		sender.connect("down1", Callable(self, "_down"))
		
func _up():
	position.y = y + 5
	position.x = x + 3

func _down():
	position.y = y
	position.x = x
	
func _process(delta):
	hue += delta * 0.1
	if hue > 1.0:
		hue = 0.0

	modulate = Color.from_hsv(hue, 1.0, 1.0)
