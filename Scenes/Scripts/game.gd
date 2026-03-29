extends Node2D

@onready var game_data = SaveManager.load_game("save_file")

func _ready():
	game_data["last_scene"] = "uid://x8j1q0cr8ykf"
	SaveManager.save_game(game_data, "save_file")
