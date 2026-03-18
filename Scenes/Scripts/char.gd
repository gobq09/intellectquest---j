extends CharacterBody2D

signal stick_collected
signal apple_collected
signal enemy_collected

var locked = false
var game_data = SaveManager.game_data

@export var speed = 80
@export var friction = 0.3
@export var acceleration = 0.2
@export var ani_tree: AnimationTree

#@onready var ani_tree: AnimationTree = $AnimationTree
@onready var joystick = get_tree().get_first_node_in_group("joystick")

func _ready() -> void:
	SaveManager.load_game()
	ani_tree.set("parameters/Idle/blend_position", Vector2(0,1))
	self.set_process_input(false) 
	if  SaveManager.game_data["new_game"] == true:
		set_physics_process(false)
		_cutscene("wakeup")
		#await ani_tree.animation_finished

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
		SaveManager.game_data["new_game"] = false
		SaveManager.save_game(game_data)
	set_physics_process(true)

func _physics_process(_delta):
	var direction = get_input()
	
	# joystick override (for mobile)
	if joystick and joystick.direction != Vector2.ZERO:
		direction = joystick.direction
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)

		ani_tree.get("parameters/playback").travel("Walk")
		ani_tree.set("parameters/Walk/blend_position", velocity)
		ani_tree.set("parameters/Idle/blend_position", velocity)

	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		ani_tree.get("parameters/playback").travel("Idle")

	move_and_slide()

func collect(item):
	print(item)
