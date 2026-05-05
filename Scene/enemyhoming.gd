extends Area2D

@export var speed: float = 120
@export var respawn_time: float = 20.0 
@export var despawn_time: float = 10.0  
@export var turn_speed: float = 3.0

var start_pos: Vector2
var timer := 0.0
var alive_time := 0.0
var state := "idle"
var velocity: Vector2 = Vector2.ZERO

var player: Node2D = null
var activated := false

func _ready():
	$AnimationPlayer.play("fly")
	start_pos = global_position
	hide()

	player = get_tree().get_first_node_in_group("Player")
	connect("body_entered", Callable(self, "_on_body_entered"))

	_on_half_signal() 

func _physics_process(delta):
	if state == "idle":
		return

	elif state == "homing":
		alive_time += delta

		if alive_time >= despawn_time:
			hide()
			state = "respawn_wait"
			timer = 0
			alive_time = 0
			return

		if is_instance_valid(player):
			var to_player = player.global_position - global_position
			var dist = to_player.length()

			var desired_dir = to_player.normalized()

			var target_speed = speed
			if dist < 80:
				target_speed = lerp(20.0, speed, dist / 80.0)

			var desired_velocity = desired_dir * target_speed

			velocity = velocity.lerp(desired_velocity, min(turn_speed * delta, 1.0))

			global_position += velocity * delta

	elif state == "respawn_wait":
		timer += delta
		if timer >= respawn_time:
			global_position = start_pos
			show()
			state = "homing"
			timer = 0
			velocity = Vector2.ZERO

func _on_body_entered(body):
	if body.is_in_group("Player") and visible:
		body.take_damage(1)

func _on_half_signal():
	if not activated:
		activated = true
		state = "homing"
		timer = 0
		show()
