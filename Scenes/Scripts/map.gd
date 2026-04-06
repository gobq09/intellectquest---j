extends Control

@onready var game_data = SaveManager.load_game("save_file")

func _on_close_pressed() -> void:
	SceneLoader.load_scene(game_data["last_scene"])
