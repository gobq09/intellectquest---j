extends CharacterBody2D

enum DuckState { FLOATING, SWIMMING }

var current_state = DuckState.FLOATING
var swim_direction = Vector2.ZERO

var type: String = "Chicken"
var swim_speed: float = 80.0
var min_idle_time: float = 1.0
var max_idle_time: float = 3.0
var min_swim_time: float = 2.0
var max_swim_time: float = 5.0
var left_limit: float = 50.0
var right_limit: float = 1100.0
var top_limit: float = 50.0
var bottom_limit: float = 600.0

#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var change_state_timer: Timer = $changestatetimer
@onready var swimming_timer: Timer = $swimmingtimer
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@onready var chicken_sprite = preload("res://Sprites/npc/animals/animal-chicken.png")
@onready var chick_sprite = preload("res://Sprites/npc/animals/animal-chick.png")

func _ready() -> void:
	if type == "Chicken":
		sprite.texture = chicken_sprite
	elif type == "Chick":
		sprite.texture = chick_sprite
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	change_state_timer.one_shot = true
	swimming_timer.one_shot = true

	if change_state_timer.timeout.is_connected(_on_change_state_timer_timeout):
		change_state_timer.timeout.disconnect(_on_change_state_timer_timeout)
	if swimming_timer.timeout.is_connected(_on_swimming_timer_timeout):
		swimming_timer.timeout.disconnect(_on_swimming_timer_timeout)

	change_state_timer.timeout.connect(_on_change_state_timer_timeout)
	swimming_timer.timeout.connect(_on_swimming_timer_timeout)

	# Start animating immediately on spawn
	anim_player.play("idle")
	_enter_float_state()

func _set_animal(animal, speed, min_idle, max_idle, min_swim, max_swim, left, right, top, bottom):
	type = animal
	swim_speed = speed
	min_idle_time = min_idle
	max_idle_time = max_idle
	min_swim_time = min_swim
	max_swim_time = max_swim
	left_limit = left
	right_limit = right
	top_limit = top
	bottom_limit = bottom
	
	_ready()

func _physics_process(_delta: float) -> void:
	if current_state == DuckState.SWIMMING:
		velocity = lerp(velocity, swim_speed * swim_direction, 0.15)  # snappier acceleration
	else:
		anim_player.play("idle")
		velocity = lerp(velocity, Vector2.ZERO, 0.12)

	# Animation always playing — never stopped
	if current_state == DuckState.SWIMMING:
		if swim_direction.x > 0:
			anim_player.play("walk")
			sprite.flip_h = true
			#animated_sprite.play("right")
		elif swim_direction.x < 0:
			anim_player.play("walk")
			sprite.flip_h = false
			#animated_sprite.play("left")
		else:
			anim_player.play("walk")
			# Pure up/down — keep last direction animation
			pass
	else:
		# FLOATING — keep animating whichever direction it was last going
		# animation keeps playing, duck just slows to a stop
		pass

	# Boundary checks
	if global_position.x <= left_limit:
		global_position.x = left_limit
		swim_direction.x = abs(swim_direction.x)
		anim_player.play("walk")
		sprite.flip_h = true
		#animated_sprite.play("right")
	elif global_position.x >= right_limit:
		global_position.x = right_limit
		swim_direction.x = -abs(swim_direction.x)
		anim_player.play("walk")
		sprite.flip_h = false
		#animated_sprite.play("left")

	if global_position.y <= top_limit:
		global_position.y = top_limit
		swim_direction.y = abs(swim_direction.y)
	elif global_position.y >= bottom_limit:
		global_position.y = bottom_limit
		swim_direction.y = -abs(swim_direction.y)

	move_and_slide()

func _pick_random_direction() -> Vector2:
	var dirs = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(1, 1).normalized(),
		Vector2(-1, 1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, -1).normalized(),
	]
	return dirs[randi() % dirs.size()]

func _enter_float_state() -> void:
	current_state = DuckState.FLOATING
	# Do NOT stop animation — let it keep playing
	change_state_timer.wait_time = randf_range(min_idle_time, max_idle_time)
	change_state_timer.start()
	#print(">> FLOATING for ", change_state_timer.wait_time, "s")

func _enter_swim_state() -> void:
	current_state = DuckState.SWIMMING
	swim_direction = _pick_random_direction()
	swimming_timer.wait_time = randf_range(min_swim_time, max_swim_time)
	swimming_timer.start()
	#print(">> SWIMMING dir:", swim_direction, " for ", swimming_timer.wait_time, "s")

func _on_change_state_timer_timeout() -> void:
	#print(">> change_state_timer fired!")
	if randi() % 2 == 0:
		_enter_swim_state()
	else:
		_enter_float_state()

func _on_swimming_timer_timeout() -> void:
	#print(">> swimming_timer fired!")
	_enter_float_state()
