extends Control

@onready var game_data = SaveManager.load_game("save_file")

func _on_general_pressed() -> void:
	pass # Replace with function body.

func _on_audio_pressed() -> void:
	pass # Replace with function body.

func _on_video_pressed() -> void:
	pass # Replace with function body.

func _on_return_pressed() -> void:
	SceneLoader.load_scene(game_data["last_scene"])
