extends ProgressBar

@onready var health : int = 100

func _ready() -> void:
	hide()
	await get_tree().create_timer(5).timeout
	show()
	for p in get_tree().get_nodes_in_group("Perjectile"):
		p.connect("hit", Callable(self, "damage_"))

func damage_():
	health -= 10
	value = health
