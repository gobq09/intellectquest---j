extends CharacterBody2D

@onready var NPC_Name: String = "Pearl"
@export_enum("Sleep", "Down", "Up", "Left", "Right") var State: String = "Down"

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var interact_icon: Sprite2D = $Interaction_Icon

@onready var looking_at_player = false
@onready var npc_position: Vector2 = self.global_position
@onready var default_direction: String

var talk = "uid://j43jxnnk3bmp"
var quest1 = "uid://fhnu6hyv2fye"
var quest2 = "uid://q5xpeqahi40m"
var quest3 = "uid://dlj8k0iq5sgcd"

var player_in_range = false

func _ready() -> void:
	SignalManager.send_player_position.connect(look_at_player)
	SignalManager.stop_looking_at_player.connect(stop_looking_at_player)
	SignalManager.player_look_at.connect(send_position)
	SignalManager.pearl_marker.connect(move_pearl_to)
	SignalManager.pearl_anim.connect(pearl_state)
	
	if State == "Sleep":
		anim_player.play("pearl-sleep")
		default_direction = "idle_down"
	elif State == "Down":
		anim_player.play("idle_down")
		default_direction = "idle_down"
	elif State == "Up":
		anim_player.play("idle_up")
		default_direction = "idle_up"
	elif State == "Left":
		anim_player.play("idle_left")
		default_direction = "idle_left"
	elif State == "Right":
		anim_player.play("idle_right")
		default_direction = "idle_right"

func look_at_player(npc_name: String, player_pos: Vector2):
	if npc_name == NPC_Name:
		var distance
		looking_at_player = true
		#while looking_at_player == true:
		distance = (player_pos - self.global_position).normalized()
		
		if abs(distance.x) > abs(distance.y):
			if distance.x < 0:
				anim_player.play("idle_left")
			else:
				anim_player.play("idle_right")
		else:
			if distance.y < 0:
				anim_player.play("idle_up")
			else:
				anim_player.play("idle_down")

func stop_looking_at_player(npc_name: String):
	if looking_at_player == true:
		if npc_name == NPC_Name:
			looking_at_player = false
			anim_player.play(default_direction)

func send_position(npc_name: String):
	if npc_name == NPC_Name:
		SignalManager.send_node_position.emit(NPC_Name, self.global_position)

func move_pearl_to(target_pos: Vector2, duration: float = 1.0):
	self.set_physics_process(true)
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, duration)
	var direction = self.global_position - target_pos
	var face: String
	
	direction = direction.normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			face = "idle_right"
		elif direction.x > 0:
			face =  "idle_left"
	else:
		if direction.y < 0:
			face = "idle_down"
		elif direction.y > 0:
			face = "idle_up"
	
	anim_player.play(face)

func pearl_state(state: String):
	if state == "Sleep":
		anim_player.play("pearl-sleep")
	if state == "Wake Up":
		anim_player.play("pearl-wakeup")
	elif state == "Down":
		anim_player.play("idle_down")
	elif state == "Up":
		anim_player.play("idle_up")
	elif state == "Left":
		anim_player.play("idle_left")
	elif state == "Right":
		anim_player.play("idle_right")
