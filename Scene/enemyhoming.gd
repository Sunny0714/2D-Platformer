extends Area2D

var speed = 100
var player_position
var target_position
var chase_player = false

@onready var player = get_parent().get_node("Player")
@export var wait_time : int

func _ready() -> void:
	$AnimationPlayer.play("fly")
	hide()
	var sender = get_parent().get_children()[2].get_node("ProgressBar")
	await get_tree().create_timer(wait_time).timeout
	if sender:
		sender.connect("half", Callable(self, "_on_half"))
	for p in get_tree().get_nodes_in_group("enemy"):
		p.connect("dead", Callable(self, "_dead"))

func _dead():
	queue_free()

func _on_half():
	chase_player = true
	show()
	await get_tree().create_timer(20).timeout
	hide()
	chase_player = false
	await get_tree().create_timer(5).timeout
	show()
	chase_player = true

func _physics_process(delta):
	await get_tree().create_timer(wait_time).timeout
	if not chase_player:
		return
	player_position = player.position
	target_position = (player_position - global_position).normalized()
	if position.distance_to(player_position) > 1:
		position += target_position * speed * delta

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	elif visible:
		body.take_damage(1)
		hide()
