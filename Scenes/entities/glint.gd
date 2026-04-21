extends Node2D

@export var NPC_Name : String
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $Sprite2D/AnimationPlayer
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
	SignalManager.player_look_at.connect(send_position)
	
func send_position(npc_name: String):
	if npc_name == NPC_Name:
		SignalManager.send_node_position.emit(NPC_Name, self.global_position)


func _on_near_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		sprite2d.show()
		anim_player.play("loop")


func _on_near_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		sprite2d.hide()
		anim_player.stop()
