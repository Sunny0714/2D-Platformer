extends Area2D

signal stop

@export var move_direction : Vector2
@export var move_speed : float = 50

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var sprite : Sprite2D = $Sprite

func _ready (): 
	$AnimationPlayer.play("fly")
	for p in get_tree().get_nodes_in_group("Perjectile"):
		p.connect("hit", Callable(self, "_hit"))

func _physics_process(delta):
	get_tree().call_group("Player", "set_physics_process", false)
	await get_tree().create_timer(2).timeout
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	emit_signal("stop")
	await get_tree().create_timer(5).timeout
	get_tree().call_group("Player", "set_physics_process", true)

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		body.take_damage(3)

func _hit():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
