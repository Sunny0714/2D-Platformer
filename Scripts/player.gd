extends CharacterBody2D

signal OnUpdateHealth (health : int)
signal OnUpdateScore (score : int)
signal OnUpdateRevive (revive : int)
signal up3
signal up4
signal down3
signal down4
signal dash
signal double
signal hide1

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200
@export var health : int = 3
@export var revive : int = 0
@export var score : int = 0

var shake : int = 1
var move_input : float
var combo_active = false

@onready var flash : CanvasLayer = $CanvasLayer
@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

var take_damage_sfx : AudioStream = preload("res://Audio 2/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio 2/coin.wav")
var revive_sfx : AudioStream = preload("res://Scripts/totem.wav")
var gameover : AudioStream = preload("res://Scene/767605__minimalistiga__gameover-sfx.wav")

	
func _ready():
	health = PlayerStats.health
	OnUpdateHealth.emit(health)
	revive = PlayerStats.revive
	OnUpdateRevive.emit(revive)
	score = PlayerStats.score
	OnUpdateScore.emit(score)
	if PlayerStats.revive >= 1:
		show()
	if move_input !=0:
		emit_signal("hide1")
	var sender = get_parent().get_node("EnemyBoss")
	if sender:
		sender.connect("stop", Callable(self, "_on_stop"))
	if sender:
		sender.connect("ded", Callable(self, "_ded"))
	for p in get_tree().get_nodes_in_group("Healthpack"):
		p.connect("hp", Callable(self, "_hp"))

func _ded():
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	camera.global_position = Vector2(150,-275)
	await get_tree().create_timer(10).timeout
	tween.kill()
	process_mode = Node.PROCESS_MODE_INHERIT
	shake = 0
	camera.offset = Vector2.ZERO
	camera.global_position = global_position + Vector2(0,-23)

func _hp():
	health += 1 
	OnUpdateHealth.emit(health)

func _on_stop():
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(randf_range(-10, 10)*shake, shake*randf_range(-10, 10)), 0.05)
	tween.tween_property(camera, "global_position", camera.global_position, 0.05)
	await get_tree().create_timer(3).timeout
	tween.kill()
	shake = 0
	camera.offset = Vector2.ZERO
	camera.global_position = global_position + Vector2(0,-23)
	
func _physics_process(delta):	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_input = Input.get_axis("move_left","move_right")
	
	if move_input !=0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://Scene/level_1.tscn")
		PlayerStats.score = 0
		_check()
	if Input.is_action_just_pressed("dash"):
		if PlayerStats.score >= 10:
			move_input = Input.get_axis("move_left", "move_right")
			move_input = sign(velocity.x)
			PlayerStats.score -= 10
			emit_signal("double")
			await get_tree().create_timer(0.1).timeout
			OnUpdateScore.emit(PlayerStats.score)
			if move_input !=0:
				velocity.x = lerp(velocity.x, move_input * move_speed * 25, acceleration * delta)
			else:
				move_input = 15
				velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)

			

	if Input.is_action_just_pressed("double_jump") and not is_on_floor():
		if PlayerStats.score >= 5:
			velocity.y = -jump_force
			emit_signal("dash")
			if position.y >= -2000:
				PlayerStats.score -= 5
				await get_tree().create_timer(0.1).timeout
				OnUpdateScore.emit(PlayerStats.score)
			else:
				PlayerStats.health = 1
				health = 1
				await get_tree().create_timer(0.1).timeout
				OnUpdateHealth.emit(PlayerStats.health)

	move_and_slide()
	

	
func _check():
	if revive >= 1:
		PlayerStats.score = 15
		score = 15
		OnUpdateScore.emit(PlayerStats.score)

func _process(delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	if Input.is_action_pressed("score1") \
	and Input.is_action_pressed("score2") \
	and Input.is_action_pressed("score3") \
	and Input.is_action_pressed("score4"):
		

		if not Input.is_action_pressed("false"):
			revive = 100000000
			PlayerStats.score += 500
			OnUpdateScore.emit(PlayerStats.score)
			combo_active = true
	
	if global_position.y > 200:
		game_over()

	_manage_animation()

const DASH_THRESHOLD = 300

func _manage_animation ():
	if abs(velocity.x) > DASH_THRESHOLD:
		anim.play("dash")
		await anim.animation_finished
		return
	else:
		if not is_on_floor():
			anim.play("jump")
		elif move_input !=0:
			anim.play("move")

		else:
			anim.play("idle")

func take_damage (amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	
	if health <= 0 and revive > 0:
		PlayerStats.health = 1
		health = 1
		revive -= 1
		OnUpdateHealth.emit(PlayerStats.health)
		OnUpdateRevive.emit(PlayerStats.revive)
		_on_finish()
		play_sound(revive_sfx)
	elif health <=0:
		play_sound(gameover)
		call_deferred("game_over")	
	
func easy():
	await get_tree().create_timer(0.1).timeout
	PlayerStats.revive = 1
	revive = 1
	OnUpdateRevive.emit(PlayerStats.revive)


func red():
	flash.color = Color.RED
	

func flash_red():
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_method(red, 0, 0.6, 0.2)
	tween.tween_interval(0.3)
	tween.tween_method(red, 0.6, 0, 0.4)

func game_over():
	flash_red()
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.8).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	
func _on_finish():
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(camera, "global_position", camera.global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10)), 0.05)
	tween.tween_property(camera, "global_position", camera.global_position, 0.05)
	await get_tree().create_timer(0.8).timeout
	tween.kill()
	camera.offset = Vector2.ZERO
	camera.global_position = global_position + Vector2(0,-23)

func increase_score (amount : int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)

func increase_health (amount : int):
	if health < 3:
		PlayerStats.health += amount
		#health += amount
		OnUpdateHealth.emit(PlayerStats.health)

func _damage_flash ():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE
	
	
	
func play_sound (sound : AudioStream):
	audio.stream = sound
	audio.play()
	
func _on_update_health(new_health: int):
	health = new_health


func _on_double__mouse_entered() -> void:
	emit_signal("up3")


func _on_dash__mouse_entered() -> void:
	emit_signal("up4")


func _on_double__mouse_exited() -> void:
	emit_signal("down3")


func _on_dash__mouse_exited() -> void:
	emit_signal("down4")


func _on_double__input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.action_press("double_jump")
			Input.action_release("double_jump")

func _on_dash__input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				Input.action_press("dash")
				Input.action_release("dash")
				
