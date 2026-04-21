extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false


var player
var player_in_chat_zone = false
var is_cutscene_locked = false
var was_roaming_before_cutscene = true
var move_target: Vector2
var move_duration: float = 1.0

@onready var interact_icon: Sprite2D = $Interaction_Icon

@export var NPC_ID = "null"
@export var Sprite = "male1"
#@export var npc_texture: Texture2D
@export_enum("Down", "Left", "Right", "Up") var face
@export var roam_area_path: NodePath
@onready var roam_area = get_node(roam_area_path)
#@onready var sprite_2d = $Sprite2D

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	SignalManager.npc_freeze.connect(_on_npc_freeze)
	SignalManager.npc_unfreeze.connect(_on_npc_unfreeze)
	SignalManager.npc_force_anim.connect(_on_npc_force_anim)
	SignalManager.look_at_player.connect(_on_look_at_player)
	SignalManager.stop_looking_at_player.connect(_on_stop_looking)
	SignalManager.send_marker.connect(_on_receive_marker)
	
	randomize()
	start_pos = position
	apply_sprite()
	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
func apply_sprite():
	var path = "res://Sprites/npc tres/npc_" + Sprite + ".tres"
	
	if ResourceLoader.exists(path):
		var frames = load(path)
		$AnimatedSprite2D.sprite_frames = frames
	else:
		print("Sprite not found:", path)
	
func _physics_process(delta: float) -> void:
	if is_chatting or is_cutscene_locked:
		velocity = Vector2.ZERO
		return
		
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		elif dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		elif dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		elif dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
			
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
				
	if Input.is_action_just_pressed("quest"):
		print("quest has started")
		$npc_quest.next_quest()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")
				
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		var next_pos = global_position + dir * speed * delta
		
		if is_inside_roam_area(next_pos):
			velocity = dir * speed
			move_and_slide()
		else:
			current_state = NEW_DIR

func is_inside_roam_area(pos: Vector2) -> bool:
	var shape = roam_area.get_node("CollisionShape2D").shape
	
	if shape is RectangleShape2D:
		var extents = shape.extents
		var center = roam_area.global_position
		
		return (
			pos.x > center.x - extents.x and
			pos.x < center.x + extents.x and
			pos.y > center.y - extents.y and
			pos.y < center.y + extents.y
		)
	
	return true

func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true


func _on_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

func _on_dialogue_started(resource):
	is_chatting = true
	is_roaming = false
	velocity = Vector2.ZERO
	#look_at(player.global_position)
	$AnimatedSprite2D.play("idle")
	start_cutscene()
	
func _on_dialogue_ended(resource):
	is_chatting = false
	is_roaming = true
	end_cutscene()
	
func freeze_for_cutscene():
	is_cutscene_locked = true
	velocity = Vector2.ZERO
	
func unfreeze_from_cutscene():
	is_cutscene_locked = false
	
func force_idle(direction: String):
	$AnimatedSprite2D.play(direction)
	
func _on_npc_freeze(npc_id: String):
	if npc_id != NPC_ID:
		return
	
	is_cutscene_locked = true
	velocity = Vector2.ZERO


func _on_npc_unfreeze(npc_id: String):
	if npc_id != NPC_ID:
		return
	
	is_cutscene_locked = false


func _on_npc_force_anim(npc_id: String, animation: String):
	if npc_id != NPC_ID:
		return
	
	$AnimatedSprite2D.play(animation)
	
func _on_look_at_player(target_name: String):
	if target_name != NPC_ID:
		return
		
	if player:
		var direction = (player.global_position - global_position).normalized()
		
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				$AnimatedSprite2D.play("walk_w")
			else:
				$AnimatedSprite2D.play("walk_e")
		else:
			if direction.y < 0:
				$AnimatedSprite2D.play("walk_n")
			else:
				$AnimatedSprite2D.play("walk_s")

func _on_stop_looking(target_name: String):
	if target_name != NPC_ID:
		return
		
	$AnimatedSprite2D.play("idle")
	
func _on_receive_marker(target_name: String, pos: Vector2, duration: float):
	if target_name != NPC_ID:
		return
	
	is_cutscene_locked = true
	is_roaming = false
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, duration)
	
	await tween.finished
	
	is_cutscene_locked = false
	
func start_cutscene():
	was_roaming_before_cutscene = is_roaming
	is_roaming = false
	is_chatting = true
	velocity = Vector2.ZERO
	
func end_cutscene():
	is_chatting = false
	is_roaming = was_roaming_before_cutscene
	is_cutscene_locked = false
	
	$AnimatedSprite2D.play("idle")
	
