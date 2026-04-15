extends CharacterBody2D

signal stick_collected
signal apple_collected
signal enemy_collected

var locked = false
@onready var game_data = SaveManager.load_game("save_file")
@onready var position_data = SaveManager.load_game("position_file")
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
@onready var ani_tree: AnimationTree = $Player_AnimTree

#@onready var ani_tree: AnimationTree = $AnimationTree
@onready var joystick = get_tree().get_first_node_in_group("joystick")
@onready var last_position : String = position_data["global_position"]
@onready var particles: GPUParticles2D = $GPUParticles2D

var getting_tracked : bool = false

@onready var footstep_player = $FootstepPlayer

var footstep_sounds_dirt = [
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-001.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-002.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-003.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-004.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-005.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-006.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-007.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-008.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-009.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-010.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-011.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-012.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-013.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-014.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-015.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-016.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-017.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-018.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-019.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-020.ogg"),
	preload("res://Audio/SFX/Footsteps/Dirt/Steps_dirt-021.ogg"),
]
var current_surface: String = "dirt"
var step_timer := 0.0
var footstep_cooldown = 0.2
var _footstep_timer = 0.0

var current_chunk: Node2D = null

func _ready() -> void:
	SignalManager.map_changed.connect(map_changed)
	SignalManager.movement_disabled.connect(disable_movement)
	SignalManager.move_player.connect(move_player)
	SignalManager.player_anim.connect(player_anim)
	SignalManager.send_marker.connect(move_player_to)
	SignalManager.look_at_player.connect(send_player_pos)
	SignalManager.send_node_position.connect(player_look_at)
	
	if player_data["chosen"] == "Female":
		sprite.texture = female_sprite
	else:
		sprite.texture = male_sprite
	
	if config_data["Particles"] == false:
		particles.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		particles.process_mode = Node.PROCESS_MODE_INHERIT
	
	position = _convert(last_position)
	ani_tree.set("parameters/Idle/blend_position", Vector2(0,1))
	self.set_process_input(false) 
	
	SignalManager.entered_chunk.emit(position_data["last_chunk"])
	
	if game_data["new_game"] == true:
		set_physics_process(false)
		_cutscene("wakeup")
		await ani_tree.animation_finished
	
	if game_data["player_lost"] == true:
		set_physics_process(false)
		SignalManager.player_defeated.emit()
		_cutscene("respawn")
		await ani_tree.animation_finished
	
	game_data["last_scene"] = "uid://d4dgymuee0bxt"
	position_data["global_position"] = position
	SaveManager.save_game(position_data, "position_file")
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
		print("wtf")
		ani_tree.get("parameters/playback").travel("Wake Up")
		await ani_tree.animation_finished
		print("wtf2")
		await get_tree().create_timer(1).timeout
		ani_tree.get("parameters/playback").travel("Look Around")
		await get_tree().create_timer(2).timeout
		ani_tree.get("parameters/playback").travel("Pinch")
		await ani_tree.animation_finished
		await get_tree().create_timer(1).timeout
		ani_tree.get("parameters/playback").travel("Look Around")
		await get_tree().create_timer(1).timeout
		ani_tree.get("parameters/playback").travel("Stand Up")
		await ani_tree.animation_finished
		
		await get_tree().create_timer(1).timeout
		SignalManager.ui_tutorial.emit("joystick")
		game_data["new_game"] = false
		SaveManager.save_game(game_data, "save_file")
	elif animation == "respawn":
		ani_tree.get("parameters/playback").travel("Wake Up")
		await ani_tree.animation_finished
		ani_tree.get("parameters/playback").travel("Stand Up")
		await ani_tree.animation_finished
		
		game_data["player_lost"] = false
		SaveManager.save_game(game_data, "save_file")
	
	SignalManager.movement_enabled.emit()
	#print("after cutscene: ", game_data["new_game"])

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

func send_player_pos(target_name):
	SignalManager.send_player_position.emit(target_name, self.global_position)

func player_look_at(node_name: String, node_pos: Vector2):
	var distance = (node_pos - self.global_position).normalized()
	var face: Vector2
	
	if abs(distance.x) > abs(distance.y):
		if distance.x < 0:
			face = Vector2(-1, 0)
		else:
			face = Vector2(1, 0)
	else:
		if distance.y < 0:
			face = Vector2(0, -1)
		else:
			face = Vector2(0, 1)
		
	ani_tree.set("parameters/Idle/blend_position", face)
	ani_tree.get("parameters/playback").travel("Idle")

func map_changed(scene):
	Handler.map_changed(scene, position)

func _on_timer_timeout() -> void:
	position_data = SaveManager.load_game("position_file")
	position_data["global_position"] = position
	SaveManager.save_game(position_data, "position_file")
	
#region Player Footsteps
func _process(delta):
	if _footstep_timer > 0:
		_footstep_timer -= delta
			
func is_moving() -> bool:
	return velocity.length() > 0
	
func _play_footstep():
	if _footstep_timer > 0:
		return
	_footstep_timer = footstep_cooldown
	
	var surface_sounds: Array
	
	match  current_surface:
		"dirt":
			surface_sounds = footstep_sounds_dirt
		#"grass":
			#surface_sounds = footstep_sounds_grass
		#"stone":
			#suface_sounds = footstep_sounds_stone
		_:
			surface_sounds = footstep_sounds_dirt
			
	if footstep_player.playing:
		footstep_player.stop()
		
	footstep_player.stream = surface_sounds.pick_random()
	#footstep_player.volume_db = linear_to_db(0.5)
	footstep_player.pitch_scale = randf_range(0.9, 1.1)
	footstep_player.play()

#endregion
