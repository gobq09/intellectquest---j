extends Node

var save_file: String 
var player: String 
var player_questions: String 
var enemy: String



#region default
var default_game_data: Dictionary = {
	"new_game": true,
	"global_position": Vector2(-473.0, 17.0),
	"last_scene": "uid://dt532wlk4w78h",
	"defeated_enemies": {},
	"eng_topics": {},
	"sci_topics": {},
	"math_topics": {},
	"fil_topics": {},
}

var default_player_data: Dictionary = {
	"player_name": "Quinn",
	"difficulty": "Elementary",
	"chosen": "Male",
	"player_level": 1,
	"player_exp": 0,
	"player_hp": 100,
	"player_int": 1,
	"player_end": 1,
	"player_wis": 1,
	"player_str": 1,
	"unused_stats": 0,
}

var default_enemy_data: Dictionary = {
	"enemy_id": "eng_0",
	"enemy_size": "Small",
	"enemy_subject": "English",
}
#endregion

#region data
var game_data: Dictionary = {
	"new_game": true,
	"global_position": Vector2(-473.0, 17.0),
	"last_scene": "uid://dt532wlk4w78h",
	"defeated_enemies": {},
	"eng_topics": {},
	"sci_topics": {},
	"math_topics": {},
	"fil_topics": {},
}

var player_data: Dictionary = {
	"player_name": "Quinn",
	"difficulty": "Elementary",
	"chosen": "Male",
	"player_level": 1,
	"player_exp": 0,
	"player_hp": 100,
	"player_int": 1,
	"player_end": 1,
	"player_wis": 1,
	"player_str": 1,
	"unused_stats": 0,
}

var enemy_data: Dictionary = {
	"enemy_id": "eng_0",
	"enemy_size": "Small",
	"enemy_subject": "English",
}
#endregion

func _ready():
	if OS.has_feature("editor"):
		save_file = "res://save_game.json"
		player = "res://player.json"
		player_questions= "res://player_questions.json"
		enemy= "res://enemy_data.json"
	else:
		save_file = OS.get_executable_path().get_base_dir() +  "/save_game.json"
		player = OS.get_executable_path().get_base_dir() + "/player.json"
		player_questions= OS.get_executable_path().get_base_dir() + "/player_questions.json"
		enemy= OS.get_executable_path().get_base_dir() + "/enemy_data.json"


func save_game(data: Dictionary, savePath: String) -> void:
	if savePath == "save_file":
		savePath = save_file
	elif savePath == "player_file":
		savePath = player
	elif savePath == "player_questions":
		savePath = player_questions
	elif savePath == "enemy_file":
		savePath = enemy
	
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Game saved at: ", savePath)
	else:
		print("Failed to save! Error: ", FileAccess.get_open_error())

func load_game(savePath: String) -> Dictionary:
	if savePath == "save_file":
		savePath = save_file
	elif savePath == "player_file":
		savePath = player
	elif savePath == "player_questions":
		savePath = player_questions
	elif savePath == "enemy_file":
		savePath = enemy
	
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
