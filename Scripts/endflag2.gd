extends Area2D

signal finish1
signal start1
@onready var anim = $AnimationPlayer
@export var scene_to_load : PackedScene

func _ready():
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("finish1")
	anim.play("finish")
	await get_tree().create_timer(0.1).timeout
	$AudioStreamPlayer.stream = load("res://SlideOpen.wav")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_INHERIT)



func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("start1")
	anim.play("start")
	$AudioStreamPlayer2.stream = load("res://SlideClose.wav")
	$AudioStreamPlayer2.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(scene_to_load)
