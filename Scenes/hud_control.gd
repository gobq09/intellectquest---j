extends Control

@export var Task_Expanded:bool = true
@onready var game_data = SaveManager.load_game("save_file")
@onready var hp_bar: TextureProgressBar = $"HP/HP Bar"
@onready var player_data = SaveManager.load_game("player_file")
@onready var bar: Sprite2D = $"HP/Interface-hud-hpbar1"

# 100 = 82, 19
# 0 = 32, 19

func _ready() -> void:
	hp_bar.value = (player_data["player_hp"] / (100 + player_data ["player_end"])) * 100
	bar.position.x = (hp_bar.value / 2) + 32

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
