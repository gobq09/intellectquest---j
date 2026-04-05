extends Node

@onready var game_data = SaveManager.load_game("save_file")
@onready var quest_source = Quests.quests

func _clear_quests():
	SaveManager.save_game({"none": quest_source["none"]}, "quest_file")

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

func _update_task(quest_id: String, task_id: String, progress: int):
	var quest_data = _get_quests()
	var quest = quest_data[quest_id]
	var task = quest["tasks"][task_id]
	var completed = true
	
	SignalManager.quest_updated.emit()
	
	for tasks in quest["tasks"]:
		if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
			completed = false
	
	task["progress"] = progress
	quest["completed"] = completed
	SaveManager.save_game(quest_data, "quest_file")

func _active_quest():
	game_data = SaveManager.load_game("save_file")
	var quest_data = SaveManager.load_game("quest_file")
	var active_quest_id = game_data["active_quest"]
	
	if active_quest_id == "none":
		return null
	
	var active_quest = quest_data[active_quest_id]
	var tasks_list = active_quest["tasks"]
	
	return tasks_list
