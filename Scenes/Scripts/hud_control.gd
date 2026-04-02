extends Control

@export var Task_Expanded:bool = true
@onready var game_data = SaveManager.load_game("save_file")
@onready var hp_bar: TextureProgressBar = $"HP/HP Bar"
@onready var player_data = SaveManager.load_game("player_file")
@onready var bar: Sprite2D = $"HP/Interface-hud-hpbar1"
@onready var level: Label = $"HP/Interface-hud-level/RichTextLabel"



# 100 = 82, 19
# 0 = 32, 19

signal interacted

func _ready() -> void:
	level.text = str(int(player_data["player_level"]))
	var max_hp = (player_data["player_end"] * 2) + 50
	hp_bar.value = (player_data["player_hp"] / max_hp) * 100
	#bar.position.x = (hp_bar.value / 2) + 32

func _on_interfacehudtodo_pressed() -> void:
	print("Pressed")
	var tween = create_tween()
	
	if Task_Expanded == false:
		tween.tween_property($Control/Task, "position", Vector2(-44.0, -0), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, -1)
		Task_Expanded = true
	else:
		tween.tween_property($Control/Task, "position", Vector2(-44.0, -30.0), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, 1)
		Task_Expanded = false

func _on_settings_button_pressed() -> void:
	print("Settings")
	SceneLoader.load_scene("uid://tj4vo1mmxfyt")


func _on_map_button_pressed() -> void:
	print("Map")
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_archive_button_pressed() -> void:
	SceneLoader.load_scene("uid://cfvteqvw7wwp")


func _on_interfacehudlevel_pressed() -> void:
	SceneLoader.load_scene("uid://0q5mlknq6fk0")


func _on_interact_button_pressed() -> void:
	Input.action_press("interact")
	Input.action_release("interact")
