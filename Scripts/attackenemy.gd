extends Area2D

@export var move_direction : Vector2
@export var move_speed : float = 50
@export var _wait_time : float = 5

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
var state := "waiting"
var timer := 0.0

func _ready (): 
	$AnimationPlayer.play("fly")
	hide()

func _physics_process(delta):
	timer += delta
	if state == "waiting":
		if timer >= _wait_time:
			show()
			state = "moving"
			timer = 0
	elif state == "moving":
		global_position = global_position.move_toward(target_pos, move_speed * delta)
		if global_position == target_pos:
			hide()
			state = "reset_wait"
			timer = 0
	elif state == "reset_wait":
		if timer >= 24.0:
			global_position = start_pos
			state = "waiting"
			timer = 0

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	elif visible:
		body.take_damage(1)
