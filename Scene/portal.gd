extends Area2D


func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	
	get_tree().call_group("Player", "set", "position", Vector2(-100, -2300))
