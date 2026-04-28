extends Area2D


func _process(float) -> void:
	if PlayerStats.score >= 10:
		modulate = Color(1.3, 1.3, 1.3, 0.85)
	else:
		modulate = Color(0.305, 0.305, 0.305, 0.5)


var y: float
var x: float

func _ready() -> void:
	y = position.y
	x = position.x
	var sender = get_parent().get_parent()
	if sender:
		sender.connect("up4", Callable(self, "_up"))
		
	if sender:
		sender.connect("down4", Callable(self, "_down"))
		
func _up():
	position.y = y + 5
	position.x = x + 3

func _down():
	position.y = y
	position.x = x
