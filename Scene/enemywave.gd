extends Area2D

@export var speed: float = 100
@export var amplitude: float = 50
@export var frequency: float = 3
@export var direction: Vector2 = Vector2.LEFT

@export var wait_time: float = 5.0
@export var reset_time: float = 24.0

var start_pos: Vector2
var start_y: float
var time := 0.0
var timer := 0.0
var state := "waiting"

func _ready():
	$AnimationPlayer.play("fly")
	start_pos = global_position
	start_y = global_position.y
	hide()

func _physics_process(delta):
	timer += delta

	if state == "waiting":
		if timer >= wait_time:
			show()
			state = "moving"
			timer = 0
			time = 0
			start_y = global_position.y

	elif state == "moving":
		time += delta

		global_position += direction * speed * delta
		global_position.y = start_y + sin(time * frequency) * amplitude
		if time >= 2.0:
			hide()
			state = "reset_wait"
			timer = 0

	elif state == "reset_wait":
		if timer >= reset_time:
			global_position = start_pos
			state = "waiting"
			timer = 0

func _on_body_entered(body):
	if body.is_in_group("Player") and visible:
		body.take_damage(1)
