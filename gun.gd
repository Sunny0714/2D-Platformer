extends Area2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

var gun_sfx : AudioStream = preload("res://universfield-gunshot-352466.mp3")

func _ready() -> void:
	hide()


func _process(delta: float) -> void:
	pass
		


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		show()
		anim.play("Gun")
		await get_tree().create_timer(0.2).timeout
		area.take_damage(3)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		show()
		anim.play("Gun")
		play_sound(gun_sfx)
		await get_tree().create_timer(0.3).timeout
		body.take_damage(3)

func play_sound (sound : AudioStream):
	audio.stream = sound
	audio.play()
