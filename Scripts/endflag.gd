extends Area2D

signal finish
signal start

@export var scene_to_load : PackedScene

func _ready():
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	get_tree().call_group("Player","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("finish")
	$AnimationPlayer.play("Finish")
	await get_tree().create_timer(0.1).timeout
	$AudioStreamPlayer.stream = load("res://SlideOpen.wav")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_INHERIT)
	get_tree().call_group("Player","set","process_mode", Node.PROCESS_MODE_INHERIT)


func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	get_tree().call_group("enemies","set","process_mode", Node.PROCESS_MODE_DISABLED)
	get_tree().call_group("Player","set","process_mode", Node.PROCESS_MODE_DISABLED)
	emit_signal("start")
	for p in get_tree().get_nodes_in_group("Player"):
		p.global_position = global_position
		p.position.y = -15
		p.position.x -= 3
	$AnimationPlayer.play("Start")
	$AudioStreamPlayer2.stream =load("res://SlideClose.wav")
	$AudioStreamPlayer2.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(scene_to_load)
	
	
