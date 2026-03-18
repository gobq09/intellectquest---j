extends Control


func _ready() -> void:
	SaveManager.load_game()

func _on_confirm_pressed() -> void:
	print("Confirm Pressed")
	SaveManager.save_game(SaveManager.default_game_data)
	SceneLoader.load_scene("uid://dt532wlk4w78h")


func _on_cancel_pressed() -> void:
	print("Cancel Pressed")
	SceneLoader.load_scene("uid://dkefgsuwak2hj")
