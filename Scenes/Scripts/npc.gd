extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false


var player
var player_in_chat_zone = false

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
	randomize()
	start_pos = position
	
	apply_sprite()
	
func apply_sprite():
	var path = "res://Sprites/npc tres/npc_" + Sprite + ".tres"
	
	if ResourceLoader.exists(path):
		var frames = load(path)
		$AnimatedSprite2D.sprite_frames = frames
	else:
		print("Sprite not found:", path)
	
func _physics_process(delta: float) -> void:
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
			
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
				
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")
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


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true


func _on_npc_quest_quest_menu_closed() -> void:
	is_chatting = false
	is_roaming = true
