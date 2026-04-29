extends Area2D

signal hit

var rotate_speed: float = 3

@export var move_direction: Vector2
@export var move_speed: float = 50
@export var wait_time: float = 10

@onready var start_pos: Vector2 = global_position
@onready var target_pos: Vector2 = global_position + move_direction
@onready var sprite: Sprite2D = $Sprite

var can_move := false

func _ready() -> void:
	await get_tree().create_timer(wait_time).timeout
	can_move = true

func _physics_process(delta):
	var time = Time.get_unix_time_from_system()
	sprite.scale.x = sin(time * rotate_speed)
	if can_move:
		global_position = global_position.move_toward(target_pos, move_speed * delta)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		_move_boss()

func _move_boss():
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(200, -150), 0.4)




func _on_enemy_boss_area_entered(area: Area2D) -> void:
	emit_signal("hit")
	await get_tree().create_timer(0.01).timeout
	queue_free()
