#@tool
extends Node2D

@export var item_id : String = "0"

@onready var inv_data = SaveManager.load_game("inv_file")

@onready var item_quantity = inv_data[item_id]["Quantity"]
@onready var item_sprite : String = inv_data[item_id]["Sprite"]
@onready var interact : PackedScene = preload("uid://dflg8r076r3qe")

var scene_path: String = "uid://gbgxli02186y"

@onready var icon_sprite = $Sprite2D

var player_in_range = false
signal interactable

func _ready() -> void:
	if not Engine.is_editor_hint():
		icon_sprite.texture = load(item_sprite)

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("picked up")
		pickup_item()

func pickup_item():
	InventoryManager.add_item(item_id)
	$Sprite2D.visible = false
	$Effects.visible = true
	$Effects/AnimationPlayer.play("spawn")
	await $Effects/AnimationPlayer.animation_finished
	self.queue_free()

func _on_area_2d_body_entered(body):
	print("in range")
	if body.is_in_group("Player"):
		player_in_range = true
		interactable.emit()
		#body.interact_ui.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		#body.interact_ui.visible = false

#func set_item_data(data):
	#item_type = data["type"]
	#item_name = data["name"]
	#item_effect = data["effect"]
	#item_texture = data["texture"]
	#
#func initiate_items(type, name, effect, texture):
	#item_type = type
	#item_name = name
	#item_effect = effect
	#item_texture = texture
