extends Area2D

signal half

@export var speed: float = 120
@export var respawn_time: float = 20.0 
@export var despawn_time: float = 10.0  

var start_pos: Vector2
var timer := 0.0
var alive_time := 0.0
var state := "idle"

var player: Node2D = null
var activated := false

func _ready():
	$AnimationPlayer.play("fly")
	start_pos = global_position
	hide()

	player = get_tree().get_first_node_in_group("Player")

	connect("half", Callable(self, "_on_half_signal"))

func _physics_process(delta):
	alive_time += delta

	# Auto-despawn
	if alive_time >= despawn_time:
		queue_free()
		return

	if state == "idle":
		return

	elif state == "homing":
		if player:
			var dir = (player.global_position - global_position).normalized()
			global_position += dir * speed * delta

		timer += delta
		if timer >= 10.0:
			hide()
			state = "respawn_wait"
			timer = 0

	elif state == "respawn_wait":
		timer += delta
		if timer >= respawn_time:
			global_position = start_pos
			show()
			state = "homing"
			timer = 0

func _on_body_entered(body):
	if body.is_in_group("Player") and visible:
		body.take_damage(1)

func _on_half_signal():
	if not activated:
		activated = true
		state = "homing"
		timer = 0
		show()
