extends Area2D

signal start
@onready var anim = $AnimationPlayer
@export var scene_to_load : PackedScene

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("start")
	anim.play("Start")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(scene_to_load)
	
