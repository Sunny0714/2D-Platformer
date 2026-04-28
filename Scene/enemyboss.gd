extends Area2D

@export var move_direction : Vector2
@export var move_speed : float = 50

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

var shake : int = 1

func _ready (): 
	$AnimationPlayer.play("fly")

func _physics_process(delta):
	await get_tree().create_timer(2).timeout
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(randf_range(-10, 10)*shake, shake*randf_range(-10, 10)), 0.05)
	tween.tween_property(camera, "global_position", camera.global_position, 0.05)
	await get_tree().create_timer(4).timeout
	tween.kill()
	shake = 0
	camera.position = global_position

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	body.take_damage(3)
