extends Node

var SAVE_PATH: String #= "user://save_game.json"

var default_game_data: Dictionary = {
	"player_name": "Quinn",
	"difficulty": "Elementary",
	"player_level": 1,
	"player_exp": 0,
	"new_game": true,
	"player_int": 1,
	"player_end": 1,
	"player_wis": 1,
	"player_str": 1,
	"unused_stats": 0,
	"global_position": Vector2(0,0),
	"last_scene": "uid://dt532wlk4w78h"
}

var game_data: Dictionary = {
	"player_name": "Quinn",
	"difficulty": "Elementary",
	"player_level": 1,
	"player_exp": 0,
	"new_game": true,
	"player_int": 1,
	"player_end": 1,
	"player_wis": 1,
	"player_str": 1,
	"unused_stats": 0,
	"global_position": Vector2(0,0),
	"last_scene": "uid://dt532wlk4w78h"
}

func _ready():
	if OS.has_feature("editor"):
		SAVE_PATH = "res://save_game.json"
	else:
		SAVE_PATH = OS.get_executable_path().get_base_dir() + "/save_game.json"
	print("Save path: ", SAVE_PATH)

func save_game(data: Dictionary, savePath: String = SAVE_PATH) -> void:
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Game saved at: ", savePath)
	else:
		print("Failed to save! Error: ", FileAccess.get_open_error())

func load_game(savePath: String = SAVE_PATH) -> Dictionary:
	print(savePath)
	if not FileAccess.file_exists(savePath):
		print("No save file found!")
		return {}
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if result is Dictionary:
			return result
	return {}
