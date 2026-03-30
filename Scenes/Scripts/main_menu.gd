extends Control

# Called when the node enters the scene tree for the first time.

@onready var game_data = SaveManager.load_game("save_file")
@onready var menu_anim = $Control/AnimationPlayer
@onready var menu = $Control/Control

func _ready() -> void:
	game_data["in_game"] = false
	SaveManager.save_game(game_data, "save_file")
	
	if not FileAccess.file_exists("user://player.json"):
		$Control/Control/Continue.disabled = true
		$Control/Control/Continue.self_modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		$Control/Control/Continue.disabled = false
		$Control/Control/Continue.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	await menu_anim.animation_finished
	menu.process_mode = Node.PROCESS_MODE_INHERIT

func _on_new_game_pressed() -> void:
	print("New Game Pressed")
	SceneLoader.load_scene("uid://c7tt14ff1tmn0")
	#get_tree().change_scene_to_file("res://Scenes/new_game.tscn")

func _on_continue_pressed() -> void:
	print("Continue Pressed")
	game_data["in_game"] = true
	SaveManager.save_game(game_data, "save_file")
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
