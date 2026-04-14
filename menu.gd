extends Control

signal play
signal unplay
signal play1
signal unplay1

func _on_play_button_pressed() -> void:
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scene/level.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_quit_button_mouse_entered() -> void:
	emit_signal("play")


func _on_quit_button_mouse_exited() -> void:
	emit_signal("unplay")


func _on_play_button_mouse_entered() -> void:
	emit_signal("play1")


func _on_play_button_mouse_exited() -> void:
	emit_signal("unplay1")
