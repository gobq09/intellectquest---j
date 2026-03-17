extends CharacterBody2D

@export var speed = 90
@export var battle_scene = "res://combat_scene.tscn"

var player = null
var chasing = false
var battle_started = false  # prevent multiple triggers



# DetectionArea triggers chasing
func _on_DetectionArea_body_entered(body: CharacterBody2D) -> void:
	#if body.name == "Player":
	player = body
	player.locked = true
	chasing = true
	print("Player detected, chasing now!")

# BattleTrigger triggers battle when enemy touches player
func _on_BattleTrigger_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player" and not battle_started:
		battle_started = true
		start_battle()

func _physics_process(_delta: float) -> void:
	if chasing and player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Optional: backup distance check
		if not battle_started and global_position.distance_to(player.global_position) < 10:
			battle_started = true
			start_battle()

func start_battle() -> void:
	chasing = false
	velocity = Vector2.ZERO
	if player != null:
		player.velocity = Vector2.ZERO
	print("Starting battle!")
	#Transition.fade_to_scene(battle_scene)

func _on_detection_area_area_entered(_area: Area2D) -> void:
	print("Test")
