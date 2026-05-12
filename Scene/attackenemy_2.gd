extends Area2D

@export var move_speed: float = 50

var player: Node2D = null

func _ready():
	$AnimationPlayer.play("fly")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player == null:
		return

	var dir: Vector2 = (player.global_position - global_position).normalized()
	global_position += dir * move_speed * delta

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	body.take_damage(1)
