extends Node2D

@onready var game_data = SaveManager.load_game("save_file")

func _ready():
	game_data["in_game"] = true
	game_data["last_scene"] = "uid://x8j1q0cr8ykf"
	
	if game_data["tutorial"] == true:
		%Player.position = Vector2(-637.0, 376.0)
		game_data["global_position"] = Vector2(-637.0, 376.0)
		game_data["tutorial"] = false
	
	game_data["respawn_point"] = Vector2(-637.0, 376.0)
	print(game_data["last_scene"])
	SaveManager.save_game(game_data, "save_file")
	
	SignalManager.map_changed.emit("uid://x8j1q0cr8ykf")
