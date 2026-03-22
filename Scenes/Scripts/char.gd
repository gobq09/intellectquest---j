extends CharacterBody2D

signal stick_collected
signal apple_collected
signal enemy_collected

var locked = false
@onready var game_data = SaveManager.load_game("save_file")

@export var speed = 80
@export var friction = 0.3
@export var acceleration = 0.2
@export var ani_tree: AnimationTree

#@onready var ani_tree: AnimationTree = $AnimationTree
@onready var joystick = get_tree().get_first_node_in_group("joystick")
@onready var last_position : String = game_data["global_position"]

func _ready() -> void:
	print(_convert(last_position))
	position = _convert(last_position)
	print(position)
	ani_tree.set("parameters/Idle/blend_position", Vector2(0,1))
	self.set_process_input(false) 
	if  SaveManager.load_game("save_file")["new_game"] == true:
		set_physics_process(false)
		_cutscene("wakeup")
		await ani_tree.animation_finished

func _convert(string):
	var new_string: String = string
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

func _cutscene(animation: String = "null") -> void:
	if animation == "wakeup":
		ani_tree.get("parameters/playback").travel("Wake Up")
		await ani_tree.animation_finished
		game_data["new_game"] = false
		SaveManager.save_game(game_data, "save_file")
	set_physics_process(true)

func _physics_process(_delta):
	var direction = get_input()
	
	# joystick override (for mobile)
	if joystick and joystick.direction != Vector2.ZERO:
		direction = joystick.direction
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		print(position)
		game_data["global_position"] = position
		SaveManager.save_game(game_data, "save_file")
		ani_tree.get("parameters/playback").travel("Walk")
		ani_tree.set("parameters/Walk/blend_position", velocity)
		ani_tree.set("parameters/Idle/blend_position", velocity)

	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		ani_tree.get("parameters/playback").travel("Idle")
	move_and_slide()

func collect(item):
	print(item)
