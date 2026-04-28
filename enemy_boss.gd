extends Area2D

signal stop

@export var move_direction : Vector2
@export var move_speed : float = 50

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction
@onready var sprite : Sprite2D = $Sprite

func _ready (): 
	$AnimationPlayer.play("fly")
	var sender = get_node("/Perjectile")
	if sender:
		sender.connect("hit", Callable(self, "_hit1"))

func _physics_process(delta):
	await get_tree().create_timer(2).timeout
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	emit_signal("stop")

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	body.take_damage(3)

func _hit1():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE
