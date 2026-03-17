extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
