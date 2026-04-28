extends Area2D

var rotate_speed : float = 3

@export var move_direction : Vector2
@export var move_speed : float = 50
@export var wait_time : float

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

@onready var sprite : Sprite2D = $Sprite

func _physics_process(delta):
	var time = Time.get_unix_time_from_system()
	
	sprite.scale.x = sin(time * rotate_speed)
	await get_tree().create_timer(wait_time).timeout
	global_position = global_position.move_toward(target_pos, move_speed * delta)


func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	queue_free()
