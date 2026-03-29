extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not FileAccess.file_exists("user://save_game.json"):
		$Control/Continue.disabled = true
		$Control/Continue.self_modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		$Control/Continue.disabled = false
		$Control/Continue.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_new_game_pressed() -> void:
	print("New Game Pressed")
	SceneLoader.load_scene("uid://c7tt14ff1tmn0")
	#get_tree().change_scene_to_file("res://Scenes/new_game.tscn")

func _on_continue_pressed() -> void:
	print("Continue Pressed")
	SceneLoader.load_scene("uid://dt532wlk4w78h")
	#get_tree().change_scene_to_file("res://Scenes/start_point_beach.tscn")

func _on_settings_pressed() -> void:
	print("Settings Pressed")
	SceneLoader.load_scene("uid://tj4vo1mmxfyt")
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_game_pressed() -> void:
	print("Quit Game Pressed")
	SceneLoader.load_scene("uid://nxlclj2vm1y2")
	#get_tree().change_scene_to_file("res://Scenes/quit.tscn")
