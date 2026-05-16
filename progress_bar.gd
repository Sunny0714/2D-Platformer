extends ProgressBar



signal half
signal dead

@onready var health : int = 100

func _ready() -> void:
	z_index = 999
	hide()
	await get_tree().create_timer(5).timeout
	show()
	for p in get_tree().get_nodes_in_group("Perjectile"):
		p.connect("hit", Callable(self, "damage_"))

func damage_():
	health -= 10
	value = health
	if health <= 50:
		emit_signal("half")
		add_theme_color_override("fill_color", Color(0.179, 0.004, 0.0, 1.0))
	if health <= 0:
		emit_signal("dead")
		await get_tree().create_timer(0.01).timeout
		get_tree().call_group("Player", "set_physics_process", true)
		hide()
