extends Area2D

signal finish1
signal start1
@onready var anim = $AnimationPlayer
@export var scene_to_load : PackedScene

func _ready():
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("finish1")
	anim.play("finish")
	await get_tree().create_timer(0.4).timeout
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_INHERIT)



func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("start1")
	anim.play("start")
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_packed(scene_to_load)
	
	
