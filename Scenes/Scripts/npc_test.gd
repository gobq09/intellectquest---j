extends CharacterBody2D

@export var NPC_Name: String = "NPC"
@export var Sprite: Texture2D = load("res://Sprites/npc/npc-male1.png")
@export_enum("Down", "Up", "Left", "Right") var Direction: String = "Down"

@onready var sprite2d: Sprite2D = $Sprite2D
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
	
	sprite2d.texture = Sprite
	if Direction == "Down":
		anim_player.play("npc_down")
		default_direction = "npc_down"
	elif Direction == "Up":
		anim_player.play("npc_up")
		default_direction = "npc_up"
	elif Direction == "Left":
		anim_player.play("npc_left")
		default_direction = "npc_left"
	elif Direction == "Right":
		anim_player.play("npc_right")
		default_direction = "npc_right"

func look_at_player(npc_name: String, player_pos: Vector2):
	if npc_name == NPC_Name:
		var distance
		looking_at_player = true
		#while looking_at_player == true:
		distance = (player_pos - npc_position).normalized()
		
		if abs(distance.x) > abs(distance.y):
			if distance.x < 0:
				anim_player.play("npc_left")
			else:
				anim_player.play("npc_right")
		else:
			if distance.y < 0:
				anim_player.play("npc_up")
			else:
				anim_player.play("npc_down")

func stop_looking_at_player(npc_name: String):
	if looking_at_player == true:
		if npc_name == NPC_Name:
			looking_at_player = false
			anim_player.play(default_direction)

func send_position(npc_name: String):
	if npc_name == NPC_Name:
		SignalManager.send_node_position.emit(NPC_Name, self.global_position)
