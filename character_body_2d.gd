extends CharacterBody2D

@export var speed: float = 150.0
@export var trigger_distance: float = 100.0
@export var shake_distance: float = 150.0

var triggered: bool = false
var shaking: bool = false
var shake_time: float = 0.0

@onready var player_sprite = $Node2D/Player
@onready var enemy = $Enemy
@onready var message = $Node2D/Player/UI/Message

func _ready():
	message.visible = false

func _physics_process(_delta):
	if triggered or shaking:
		return

	var input = Vector2.ZERO

	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		input.x += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		input.x -= 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		input.y += 1
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		input.y -= 1

	player_sprite.position += input.normalized() * speed * get_physics_process_delta_time()

	var distance = player_sprite.global_position.distance_to(enemy.global_position)

	if distance <= trigger_distance:
		_trigger_encounter()

func _trigger_encounter():
	triggered = true
	shaking = true
	_do_shake()

func _do_shake():
	var original_pos = enemy.position

	# Shake exactly 3 times
	for i in range(3):
		enemy.position.x = original_pos.x + 6
		await get_tree().create_timer(0.1).timeout
		enemy.position.x = original_pos.x - 6
		await get_tree().create_timer(0.1).timeout

	# Reset enemy position
	enemy.position = original_pos
	shaking = false

	# Show message
	await get_tree().create_timer(0.2).timeout
	message.visible = true
	message.text = "A wild enemy appeared!"
