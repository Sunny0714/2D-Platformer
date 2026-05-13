extends Sprite2D


var speed = 100
var player_position
var target_position

@onready var player = get_parent()

func ready():
	hide()

func _physics_process(delta):
	player_position = player.position
	target_position = (player_position - global_position).normalized()
	if position.distance_to(player_position) > 80:
		position += target_position * speed * delta
