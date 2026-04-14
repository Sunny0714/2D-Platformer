extends Control

signal up
signal down
signal up1
signal down1
signal up2
signal down2

func _on_normal_pressed():
	PlayerStats.health = 3
	PlayerStats.revive = 0
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")


func _on_hard_pressed():
	PlayerStats.health = 1
	PlayerStats.revive = 0
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_easy_pressed() -> void:
	PlayerStats.health = 3
	PlayerStats.score = 15
	PlayerStats.revive = 1
	get_tree().call_group("Player", "easy")
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")
	
func _on_normal_mouse_entered() -> void:
	emit_signal("up")


func _on_normal_mouse_exited() -> void:
	emit_signal("down")


func _on_easy_mouse_entered() -> void:
	emit_signal("up1")


func _on_easy_mouse_exited() -> void:
	emit_signal("down1")


func _on_hard_mouse_entered() -> void:
	emit_signal("up2")


func _on_hard_mouse_exited() -> void:
	emit_signal("down2")
