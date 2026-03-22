extends Node2D

func _ready():
	SaveManager.game_data["last_scene"] = "uid://x8j1q0cr8ykf"
	SaveManager.save_game(SaveManager.game_data, "save_file")
