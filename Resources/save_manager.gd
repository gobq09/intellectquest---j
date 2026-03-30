extends Node

#@onready var save_file : String = str(OS.get_executable_path().get_base_dir()) + "/save_game.json"
#@onready var player : String = str(OS.get_executable_path().get_base_dir()) + "/player.json"
#@onready var player_questions : String = str(OS.get_executable_path().get_base_dir()) + "/player_questions.json"
#@onready var enemy : String = str(OS.get_executable_path().get_base_dir()) + "/enemy_data.json"

@onready var save_file : String = "user://save_game.json"
@onready var player : String = "user://player.json"
@onready var player_questions : String = "user://player_questions.json"
@onready var enemy : String = "user://enemy_data.json"
# str(OS.get_executable_path().get_base_dir())
#region default
var default_game_data: Dictionary = {
	"new_game": true,
	"player_lost": false,
	"in_game": true,
	"global_position": Vector2(-473.0, 17.0),
	"respawn_point": Vector2(-473.0, 17.0),
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
	"player_hp": 50,
	"player_int": 0,
	"player_end": 0,
	"player_wis": 0,
	"player_str": 0,
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
	"player_lost": false,
	"in_game": true,
	"global_position": Vector2(-473.0, 17.0),
	"respawn_point": Vector2(-473.0, 17.0),
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
	"player_hp": 50,
	"player_int": 0,
	"player_end": 0,
	"player_wis": 0,
	"player_str": 0,
	"unused_stats": 0,
}

var enemy_data: Dictionary = {
	"enemy_id": "eng_0",
	"enemy_size": "Small",
	"enemy_subject": "English",
}
#endregion

func _ready():
	#if OS.has_feature("editor"):
	#save_file = "user://save_game.json"
	#player = "user://player.json"
	#player_questions = "user://player_questions.json"
	#enemy = "user://enemy_data.json"
	#else:
	pass



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
	#print(savePath)
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
