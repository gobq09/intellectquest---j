extends CharacterBody2D

signal stick_collected
signal apple_collected
signal enemy_collected

var locked = false
@onready var game_data = SaveManager.load_game("save_file")
@onready var config_data = SaveManager.load_game("config_file")
@onready var timer = $SaveTimer
@onready var anim_player = $Player_AnimTree/AnimationPlayer

@onready var player_data = SaveManager.load_game("player_file")
@onready var sprite : Sprite2D = $Sprite2D
@onready var male_sprite: CompressedTexture2D = preload("res://Sprites/player/sprite-playermale.png")
@onready var female_sprite: CompressedTexture2D = preload("res://Sprites/player/sprite-playerfemale.png")


@export var speed = 80
@export var friction = 0.3
@export var acceleration = 0.2
@export var ani_tree: AnimationTree

#@onready var ani_tree: AnimationTree = $AnimationTree
@onready var joystick = get_tree().get_first_node_in_group("joystick")
@onready var last_position : String = game_data["global_position"]
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	SignalManager.map_changed.connect(map_changed)
	SignalManager.trigger_ui.connect(disable_movement)
	SignalManager.movement_disabled.connect(disable_movement)
	SignalManager.move_player.connect(move_player)
	SignalManager.player_anim.connect(player_anim)
	SignalManager.send_marker.connect(move_player_to)
	
	if player_data["chosen"] == "Female":
		sprite.texture = female_sprite
	else:
		sprite.texture = male_sprite
	
	#if config_data["Graphics_Mode"] == "Low":
		#particles.process_mode = Node.PROCESS_MODE_DISABLED
	#else:
		#particles.process_mode = Node.PROCESS_MODE_INHERIT
	
	position = _convert(last_position)
	ani_tree.set("parameters/Idle/blend_position", Vector2(0,1))
	self.set_process_input(false) 
	
	if  game_data["new_game"] ||  game_data["player_lost"] == true:
		set_physics_process(false)
		SignalManager.player_defeated.emit()
		_cutscene("wakeup")
		await ani_tree.animation_finished
	
	game_data["global_position"] = position
	SaveManager.save_game(game_data, "save_file")

func _convert(string):
	var new_string: String = str(string)
	new_string = new_string.erase(0, 1)
	new_string = new_string.erase(new_string.length() - 1, 1)
	var array: Array = new_string.split(", ")
	return Vector2(int(array[0]), int(array[1]))

func get_input():
	var input = Vector2()
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	
	return input

func _physics_process(_delta):
	var direction = get_input()
	
	if direction.length() > 0:
		particles.emitting = true
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		#print(position)
		ani_tree.get("parameters/playback").travel("Walk")
		ani_tree.set("parameters/Walk/blend_position", velocity)
		ani_tree.set("parameters/Idle/blend_position", velocity)
		timer.start()
	else:
		particles.emitting = false
		velocity = velocity.lerp(Vector2.ZERO, friction)
		ani_tree.get("parameters/playback").travel("Idle")
	move_and_slide()

func collect(item):
	print(item)

func _cutscene(animation: String = "null") -> void:
	if animation == "wakeup":
		ani_tree.get("parameters/playback").travel("Wake Up")
		await ani_tree.animation_finished
		ani_tree.get("parameters/playback").travel("Stand Up")
		await ani_tree.animation_finished
		game_data["new_game"] = false
		game_data["player_lost"] = false
		SaveManager.save_game(game_data, "save_file")
	set_physics_process(true)
	print("after cutscene: ", game_data["new_game"])

func disable_movement():
	#joystick.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.1).timeout
	print("character movement disabled")
	self.set_process_input(false) 
	self.set_physics_process(false)
	velocity = Vector2(0, 0)
	ani_tree.get("parameters/playback").travel("Idle")
	
	await SignalManager.movement_enabled
	print("character movement enabled")
	self.set_process_input(true)
	self.set_physics_process(true)
	#joystick.process_mode = Node.PROCESS_MODE_INHERIT

func move_player(direction: String, duration: int):
	self.set_physics_process(true)
	
	Input.action_press(direction)
	await get_tree().create_timer(duration).timeout
	Input.action_release(direction)
	
	await get_tree().create_timer(0.1).timeout
	SignalManager.movement_disabled.emit()

func move_player_to(target_pos: Vector2, duration: float = 1.0):
	self.set_physics_process(true)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)
	var direction = self.global_position - target_pos
	var face: String
	
	direction = direction.normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			face = "right"
		elif direction.x > 0:
			face =  "left"
	else:
		if direction.y < 0:
			face = "down"
		elif direction.y > 0:
			face = "up"
	
	Input.action_press(face)
	await get_tree().create_timer(duration).timeout
	Input.action_release(face)

func player_anim(animation: String, direction: String = ""):
	var face: Vector2 = Vector2.ZERO
	
	if animation == "Idle":
		if direction == "Right":
			face = Vector2(1, 0)
		elif direction == "Left":
			face = Vector2(-1, 0)
		elif direction == "Down":
			face = Vector2(0, 1)
		elif direction == "Up":
			face = Vector2(0, -1)
		
		ani_tree.set("parameters/Idle/blend_position", face)
	
	ani_tree.get("parameters/playback").travel(animation)
		#await ani_tree.animation_finished
	#await anim_player.animation_finished
	#ani_tree.get("parameters/playback").travel("Idle")

func map_changed(scene):
	Handler.map_changed(scene, position)

func _on_timer_timeout() -> void:
	game_data = SaveManager.load_game("save_file")
	game_data["global_position"] = position
	SaveManager.save_game(game_data, "save_file")
