extends Node

#@onready var save_file : String = str(OS.get_executable_path().get_base_dir()) + "/save_game.json"
#@onready var player : String = str(OS.get_executable_path().get_base_dir()) + "/player.json"
#@onready var player_questions : String = str(OS.get_executable_path().get_base_dir()) + "/player_questions.json"
#@onready var enemy : String = str(OS.get_executable_path().get_base_dir()) + "/enemy_data.json"

@onready var save_file : String = "user://save_game.json"
@onready var player : String = "user://player.json"
@onready var player_questions : String = "user://player_questions.json"
@onready var enemy : String = "user://enemy_data.json"
@onready var inventory : String = "user://player_inv.json"
@onready var settings : String = "user://config.json"
@onready var quest: String = "user://player_quests.json"

# str(OS.get_executable_path().get_base_dir())

#region data
var game_data: Dictionary = {
	"new_game": true,
	"player_lost": false,
	"in_game": true,
	"tutorial": true,
	"in_combat": false,
	"player_ran": false,
	"global_position": Vector2(-473.0, 17.0),
	"respawn_point": Vector2(-473.0, 17.0),
	"last_scene": "uid://dt532wlk4w78h",
	"defeated_enemies": {},
	"eng_topics": {},
	"sci_topics": {},
	"math_topics": {},
	"fil_topics": {},
	"active_quest": "none",
	"triggered_dialogues": {},
	"score": 0,
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
	"walk_buff": 0,
}

var enemy_data: Dictionary = {
	"enemy_id": "eng_0",
	"enemy_size": "Small",
	"enemy_subject": "English",
}

var inv_data: Dictionary = {
	"0": {
		"ItemID": 0,
		"Type": "Consumable",
		"Name": "Apple",
		"Desc": "A fresh and juicy apple. Restores a small amount of health.",
		"Quantity": 0,
		"Effect": "Heal",
		"Sprite": "res://ui/inventory/items/items-apple.png"
	},
	"1": {
		"ItemID": 1,
		"Type": "Consumable",
		"Name": "Cheese",
		"Desc": "A well-aged cheese that hardens the body. Reduces damage taken for a short time.",
		"Quantity": 0,
		"Effect": "Damage_Reduction",
		"Sprite": "res://ui/inventory/items/items-cheese.png"
	},
	"2": {
		"ItemID": 2,
		"Type": "Consumable",
		"Name": "Health Potion",
		"Desc": "A powerful red potion brewed to restore a large amount of health.",
		"Quantity": 0,
		"Effect": "Heal",
		"Sprite": "res://ui/inventory/items/items-potion.png"
	},
	"3": {
		"ItemID": 3,
		"Type": "Consumable",
		"Name": "Miracle Leaf",
		"Desc": "A rare leaf said to contain hidden power. Temporarily increases damage.",
		"Quantity": 0,
		"Effect": "Damage",
		"Sprite": "res://ui/inventory/items/items-leaf.png"
	},
	"4": {
		"ItemID": 4,
		"Type": "Consumable",
		"Name": "Moon Blossom",
		"Desc": "A delicate flower from the valley that sharpens a warrior’s instincts, increasing critical hit chance.",
		"Quantity": 0,
		"Effect": "Crit_Chance",
		"Sprite": "res://ui/inventory/items/items-flower.png"
	},
	"5": {
		"ItemID": 5,
		"Type": "Consumable",
		"Name": "Speed Potion",
		"Desc": "A potion that energizes the body and increases movement speed.",
		"Quantity": 0,
		"Effect": "Walk_Speed",
		"Sprite": "res://ui/inventory/items/items-potion2.png"
	},
	"6": {
		"ItemID": 6,
		"Type": "Consumable",
		"Name": "Herbal Pill",
		"Desc": "A pill made from medicinal herbs that strengthens the body and increases maximum health.",
		"Quantity": 0,
		"Effect": "Max_Health",
		"Sprite": "res://ui/inventory/items/items-pill.png"
	},
	"7": {
		"ItemID": 7,
		"Type": "Consumable",
		"Name": "Mushroom",
		"Desc": "A mysterious forest mushroom that enhances the power of critical strikes.",
		"Quantity": 0,
		"Effect": "Crit_Damage",
		"Sprite": "res://ui/inventory/items/items-mushroom.png"
	},
	"8": {
		"ItemID": 8,
		"Type": "Other",
		"Name": "Raw Fish",
		"Desc": "A freshly caught fish. Better cook before eating.",
		"Quantity": 0,
		"Effect": "Raw",
		"Sprite": "res://ui/inventory/items/items-fish.png"
	},
	"9": {
		"ItemID": 9,
		"Type": "Other",
		"Name": "Raw Squid",
		"Desc": "A fresh squid straight from the sea. Not very appetizing uncooked.",
		"Quantity": 0,
		"Effect": "Raw",
		"Sprite": "res://ui/inventory/items/items-squid.png"
	},
	"10": {
		"ItemID": 10,
		"Type": "Consumable",
		"Name": "Cooked Fish",
		"Desc": "A well-cooked fish that restores health when eaten.",
		"Quantity": 0,
		"Effect": "Heal",
		"Sprite": "res://ui/inventory/items/items-cookedfish.png"
	},
	"11": {
		"ItemID": 11,
		"Type": "Consumable",
		"Name": "Grilled Squid",
		"Desc": "Grilled squid that restores health.",
		"Quantity": 0,
		"Effect": "Heal",
		"Sprite": "res://ui/inventory/items/items-grilledsquid.png"
	},
	"12": {
		"ItemID": 12,
		"Type": "Consumable",
		"Name": "Enchanted Scroll",
		"Desc": "A magical scroll infused with ancient power. Grants +5 stat points.",
		"Quantity": 0,
		"Effect": "Stat",
		"Sprite": "res://ui/inventory/items/items-scroll.png"
	},
}

var config_data: Dictionary = {
	"Joystick_Mode": "Dynamic",
	"Graphics_Mode": "Low",
	"Frame_Rate": 30,
	"VSync": false,
	"Master_Vol": 1.0,
	"Music_Vol": 1.0,
	"SFX_Vol": 1.0,
	"Ambience_Vol": 1.0,
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
	elif savePath == "inv_file":
		savePath = inventory
	elif savePath == "config_file":
		savePath = settings
	elif savePath == "quest_file":
		savePath = quest
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Game saved at: ", savePath)
	else:
		print("Failed to save! Error: ", FileAccess.get_open_error())

func load_game(savePath: String) -> Dictionary:
	var data
	if savePath == "save_file":
		savePath = save_file
		data = game_data
	elif savePath == "player_file":
		savePath = player
		data = player_data
	elif savePath == "player_questions":
		savePath = player_questions
	elif savePath == "enemy_file":
		savePath = enemy
		data = enemy_data
	elif savePath == "inv_file":
		savePath = inventory
		data = inv_data
	elif savePath == "config_file":
		savePath = settings
		data = config_data
	elif savePath == "quest_file":
		savePath = quest
	
	if not FileAccess.file_exists(savePath):
		print("No save file found!")
		var create_file = FileAccess.open(savePath, FileAccess.WRITE)
		
		if savePath == player_questions:
			var diff = load_game("player_file")["difficulty"]
			PlayerQuestions.copy_questions(diff)
		elif savePath == quest:
			QuestManager._clear_quests()
		else:
			save_game(data, savePath) # create dictionary with default data
	
	var file = FileAccess.open(savePath, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if result is Dictionary:
			var added : bool = false
			
			if not savePath == player_questions && not savePath == quest:
				for key in data: # check if all data exist
					if not result.has(key):
						var value = data[key]
						
						result[key] = value # add key with default data
						
						added = true
			
			if savePath == quest:
				if result.size() == 0:
					print("result size is 0")
					QuestManager._clear_quests()
			
			if added == true:
				save_game(result, savePath)
				file = FileAccess.open(savePath, FileAccess.READ)
				if file:
					content = file.get_as_text()
					file.close()
					result = JSON.parse_string(content)
			
			return result
		
	return {}

func has_seen_dialogue(id: String) -> bool:
	return load_game("save_file")["triggered_dialogues"].has(id)

func mark_dialogue_seen(id: String) -> void:
	var game_data = load_game("save_file")
	game_data["triggered_dialogues"][id] = true
	
	save_game(game_data, "save_file")

func play_dialogue_once(id: String, dialogue_path: String):
	if has_seen_dialogue(id):
		return

	mark_dialogue_seen(id)
	DialogueManager.show_dialogue_balloon(load(dialogue_path))
