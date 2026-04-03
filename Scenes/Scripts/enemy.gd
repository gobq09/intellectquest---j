extends CharacterBody2D

@export var enemy_id: String
@export_enum("small", "med", "large") var enemy_type: String
@export_enum("English", "Science", "Math", "Filipino") var enemy_subject: String

@export var speed = 30
@export var battle_scene = "res://Scenes/combat.tscn"

@onready var detect_area = $detection_area
@onready var battle_area = $BattleTrigger

@onready var game_data = SaveManager.load_game("save_file")
@onready var enemy_data = SaveManager.load_game("enemy_file")
@onready var defeated_enemies: Dictionary = game_data["defeated_enemies"]
@onready var respawn_point = position
@onready var timer = $Timer

var enemy_small = "res://Sprites/npc/sprite-enemy-small.png"
var enemy_med = "res://Sprites/npc/sprite-enemy-med.png"
var enemy_large = "res://Sprites/npc/sprite-enemy-large.png"

var player = null
var chasing = false
var battle_started = false  # prevent multiple triggers
var remaining_time

func _ready() -> void:
	var path = "res://Sprites/npc/sprite-enemy-" + enemy_type +".png"
	if enemy_type != null:
		$Sprite2D.texture = load(path)
	else:
		$Sprite2D.texture = load("res://Sprites/npc/sprite-enemy-med.png")
	
	
	print(defeated_enemies)
	if defeated_enemies.has(enemy_id):
		#print("freed " + str(enemy_id))
		print(str(defeated_enemies[str(enemy_id)]))
		if defeated_enemies[str(enemy_id)] <= Time.get_unix_time_from_system():
			#print("initially respawned")
			self.visible = true
			detect_area.process_mode = Node.PROCESS_MODE_INHERIT
			battle_area.process_mode = Node.PROCESS_MODE_INHERIT
			defeated_enemies.erase(str(enemy_id))
		else:
			#print("not respawned")
			remaining_time = defeated_enemies[str(enemy_id)] - Time.get_unix_time_from_system()
			#print("remaining time: ", remaining_time)
			timer.start(remaining_time)
			self.visible = false
			detect_area.process_mode = Node.PROCESS_MODE_DISABLED
			battle_area.process_mode = Node.PROCESS_MODE_DISABLED
		
		#queue_free()

func _on_timer_timeout() -> void:
	#print("timeout respawned")
	self.visible = true
	
	detect_area.process_mode = Node.PROCESS_MODE_INHERIT
	battle_area.process_mode = Node.PROCESS_MODE_INHERIT
	defeated_enemies.erase(str(enemy_id))

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
		
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		
		move_and_slide()

		# Optional: backup distance check
		if not battle_started and global_position.distance_to(player.global_position) < 10:
			battle_started = true
			$AnimationTree.get("parameters/playback").travel("Idle")
			start_battle()

func start_battle() -> void:
	chasing = false
	velocity = Vector2.ZERO
	if player != null:
		player.velocity = Vector2.ZERO
	print("Starting battle!")
	
	enemy_data["enemy_id"] = enemy_id
	enemy_data["enemy_size"] = enemy_type
	enemy_data["enemy_subject"] = enemy_subject
	game_data["in_combat"] = true
	
	SaveManager.save_game(game_data, "save_file")
	SaveManager.save_game(enemy_data, "enemy_file")
	
	SceneLoader.load_scene(battle_scene)

func _on_detection_area_area_entered(_area: Area2D) -> void:
	#print("Test")
	pass


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player.locked = true
		chasing = true
		print("Player detected, chasing now!")


func _on_battle_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not battle_started:
		battle_started = true
		start_battle()


func _on_detection_area_body_exited(_body: Node2D) -> void:
	$AnimationTree.get("parameters/playback").travel("Idle")
	chasing = false
