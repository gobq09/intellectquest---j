extends CharacterBody2D

signal stick_collected
signal apple_collected
signal enemy_collected

var locked = false

@export var speed = 80
@export var friction = 0.3
@export var acceleration = 0.2

@onready var joystick = get_tree().get_first_node_in_group("joystick")

func _ready():
	$AnimationTree.set("parameters/Idle/blend_position", Vector2(0,1))
	print(velocity)

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

var is_locked = true

func _physics_process(delta):
	var direction = get_input()

	if locked:
		return
		
	
	if is_locked:
		$AnimationTree.get("parameters/playback").travel("Wake Up")
		#$AnimationTree.set("parameters/TimeScale/scale", 0.0)
		#await get_tree().create_timer(1).timeout
		#$AnimationTree.set("parameters/TimeScale/scale", 1.0)
		velocity = Vector2.ZERO
		move_and_slide()
		await $AnimationTree.animation_finished
		is_locked = false
		return

	# joystick override (for mobile)
	if joystick and joystick.direction != Vector2.ZERO:
		direction = joystick.direction

	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)

		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		$AnimationTree.set("parameters/Idle/blend_position", velocity)

	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		$AnimationTree.get("parameters/playback").travel("Idle")

	move_and_slide()

func collect(item):
	print(item)
