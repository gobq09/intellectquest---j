extends Node2D

@onready var game_data = SaveManager.load_game("save_file")

func _ready() -> void:
	game_data["in_game"] = true
	game_data["last_scene"] = "uid://dt532wlk4w78h"
	SaveManager.save_game(game_data, "save_file")
