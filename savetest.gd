extends Control

var game_data = SaveManager.game_data

func _on_save_pressed() -> void:
	game_data.player_level += 1
	game_data.player_name = "test"
	
	SaveManager.save_game(game_data)
	print("Saved")

func _on_load_pressed() -> void:
	var data = SaveManager.load_game()
	print(data)

func _on_new_pressed() -> void:
	print("Confirm Pressed")
	SaveManager.save_game(SaveManager.default_game_data)
