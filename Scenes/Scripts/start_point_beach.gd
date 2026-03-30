extends Area2D

@onready var game_data = SaveManager.load_game("save_file")

func _on_body_entered(body):
	if body.name == "Player":
		print("player entered")
		game_data["global_position"] = Vector2(-637.0, 376.0)
		SaveManager.save_game(game_data, "save_file")
		SceneLoader.load_scene("uid://x8j1q0cr8ykf")
	
