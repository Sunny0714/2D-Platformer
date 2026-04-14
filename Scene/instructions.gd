extends Label

var bob_height : float = 2
var bob_speed : float = 4

func _input(event):
	if event.is_pressed():
		hide()


func _physics_process(delta):
	var time = Time.get_unix_time_from_system()

	var y_pos = ((1+sin(time * bob_speed))/2) * bob_height
	global_position.y = 535 - y_pos
