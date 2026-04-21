extends Node

@onready var game_data = SaveManager.load_game("save_file")
@onready var quest_source = Quests.quests
var last_task_id := ""

var default_quest = {
	"none": {
		"name": "",
		"tasks": {
				"0": {
					"task_name": "",
					"progress": 0,
					"goal": 0,
					"type": "",
					"target": ""
				},
			},
		"completed": false,
		"type": "main"
		},
	"1": {
	"name": "The Chosen Challenger",
	"tasks": {
		"0": {
			"task_name": "Look Around",
			"progress": 0,
			"goal": 1,
			"type": "talk",
			"target": "pearl"
		},
		"1": {
			"task_name": "Go to Greymoor Town",
			"progress": 0,
			"goal": 1,
			"type": "area",
			"target": "path_area"
		},
		"2": {
			"task_name": "Defeat the Enemy",
			"progress": 0,
			"goal": 1,
			"type": "kill",
			"target": "English"
		}
	},
	"completed": false,
	"type": "main"
	},
}

func _ready():
	SignalManager.quest_start.connect(_on_quest_start)
	SignalManager.quest_advance.connect(_on_quest_advance)
	SignalManager.enemy_killed.connect(_on_enemy_killed)
	SignalManager.npc_talked.connect(_on_npc_talked)
	SignalManager.area_entered.connect(_on_area_entered)
	#SignalManager.quest_completed.connect(_on_quest_completed)
	print("QUEST MANAGER LOADED")

func _clear_quests():
	SaveManager.save_game(default_quest, "quest_file")
	#SaveManager.save_game({"none": quest_source["none"]}, "quest_file")

func _get_quests():
	var quest_data = SaveManager.load_game("quest_file")
	var changed = false
	
	if quest_data.size() > 1:
		for quest in quest_data:
			quest = quest_data[quest]
			var completed = true
			for tasks in quest["tasks"]:
				if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
					completed = false
			
			if completed != quest["completed"]:
				changed = true
			
			print(changed)
			print(completed)
			
			
			if changed == true:
				quest["completed"] = completed
				SaveManager.save_game(quest_data, "quest_file")
			
		return quest_data
	
	return {"none" : quest_source["none"]}

func _add_quest(quest_id: String):
	var quest_data = _get_quests()
	
	quest_data[quest_id] = quest_source[quest_id]
	SaveManager.save_game(quest_data, "quest_file")
	
	game_data = SaveManager.load_game("save_file")
	game_data["active_quest"] = quest_id
	SaveManager.save_game(game_data, "save_file")
	
func _on_quest_start(quest_id: String):
	_add_quest(quest_id)
	advance_current_task()
	
func _on_quest_advance():
	advance_current_task()

func _update_task(quest_id: String, task_id: String, progress: int):
	var quest_data = _get_quests()
	var quest = quest_data[quest_id]
	var task = quest["tasks"][task_id]
	var completed = true
	
	SignalManager.quest_updated.emit()
	
	for tasks in quest["tasks"]:
		if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
			completed = false
	
	task["progress"] += progress
	quest["completed"] = completed
	SaveManager.save_game(quest_data, "quest_file")
	
func get_current_task_id() -> String:
	var game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")
	
	var quest_id = game_data["active_quest"]
	if quest_id == "none":
		return ""
		
	var quest = quest_data[quest_id]
	
	for task_id in quest["tasks"]:
		var task = quest["tasks"][task_id]
		if task["progress"] < task["goal"]:
			return task_id
	
	return ""
	
func get_current_task():
	var game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")
	
	var quest_id = game_data["active_quest"]
	if quest_id == "none":
		return null
		
	var task_id = get_current_task_id()
	if task_id == "":
		return null
		
	return quest_data[quest_id]["tasks"][task_id]
	
func _handle_event(event_type: String, target: String):
	print("HANDLE EVENT:", event_type, target)
	var game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")

	var quest_id = game_data["active_quest"]
	if quest_id == "none":
		return

	var task_id = get_current_task_id()
	if task_id == "":
		return

	var task = quest_data[quest_id]["tasks"][task_id]

	if not task.has("type"):
		return
	if task["type"] != event_type:
		return
	if task["target"] != "any" and task["target"] != target:
		return

	task["progress"] = int(task["progress"]) + 1
	quest_data[quest_id]["tasks"][task_id] = task

	# clamp
	if task["progress"] > task["goal"]:
		task["progress"] = task["goal"]

	# check completion
	var all_done = true
	for t in quest_data[quest_id]["tasks"]:
		if quest_data[quest_id]["tasks"][t]["progress"] < quest_data[quest_id]["tasks"][t]["goal"]:
			all_done = false

	quest_data[quest_id]["completed"] = all_done

	SaveManager.save_game(quest_data, "quest_file")
	SignalManager.quest_updated.emit()

	if all_done:
		print("QUEST COMPLETED:", quest_data[quest_id]["name"])

		game_data["active_quest"] = "none"
		SaveManager.save_game(game_data, "save_file")
		
	var new_task_id = get_current_task_id()
	
	if new_task_id != last_task_id:
		last_task_id = new_task_id
		
		quest_data = SaveManager.load_game("quest_file")
		game_data = SaveManager.load_game("save_file")
		quest_id = game_data["active_quest"]
		
		if quest_id != "none" and new_task_id != "":
			task = quest_data[quest_id]["tasks"][new_task_id]
			SignalManager.new_objective.emit(task["task_name"])
		
func _on_enemy_killed(subject: String):
	_handle_event("kill", subject)
	
func _on_npc_talked(npc_id: String):
	_handle_event("talk", npc_id)
	#incomplete_quests("talk", npc_id)
	
func _on_area_entered(area_id: String):
	_handle_event("area", area_id)
	#incomplete_quests("talk", area_id)
	

func advance_current_task(amount: int = 1):
	var game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")
	
	var quest_id = game_data["active_quest"]
	if quest_id == "":
		return
		
	var task_id = get_current_task_id()
	if task_id == "":
		return
		
	var task = quest_data[quest_id]["tasks"][task_id]
	task["progress"] += amount
	
	if task["progress"] > task["goal"]:
		task["progress"] = task["goal"]
		
	var all_done = true
	for t in quest_data[quest_id]["tasks"]:
		if quest_data[quest_id]["tasks"][t]["progress"] < quest_data[quest_id]["tasks"][t]["goal"]:
			all_done = false
			
	quest_data[quest_id]["completed"] = all_done
	
	SaveManager.save_game(quest_data, "quest_file")
	SignalManager.quest_updated.emit()
	
	if all_done:
		print("QUEST COMPLETED: ", quest_data[quest_id]["name"])
		
		game_data["active_quest"] = "none"
		SaveManager.save_game(game_data, "save_file")
		
	var new_task_id = get_current_task_id()
	
	if new_task_id != last_task_id:
		last_task_id = new_task_id
		
		quest_data = SaveManager.load_game("quest_file")
		game_data = SaveManager.load_game("save_file")
		quest_id = game_data["active_quest"]
		
		if quest_id != "none" and new_task_id != "":
			task = quest_data[quest_id]["tasks"][new_task_id]
			SignalManager.new_objective.emit(task["task_name"])

#for overworld hud task tracker display
func _active_quest():
	var game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")
	var active_quest_id = game_data["active_quest"]
	
	if active_quest_id == "none":
		return null
	
	var quest = quest_data[active_quest_id]
	
	for task_id in quest["tasks"]:
		var task = quest["tasks"][task_id]
		
		if task["progress"] < task["goal"]:
			return {
				"quest_id": active_quest_id,
				"task_id": task_id,
				"task_data": task
			}
	
	return null
