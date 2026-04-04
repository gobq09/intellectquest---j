extends Node

@onready var quest_source = Quests.quests

func _clear_quests():
	SaveManager.save_game({}, "quest_file")

func _get_quests():
	var quest_data = SaveManager.load_game("quest_file")
	var completed = true
	var changed = false
	
	for quest in quest_data:
		quest = quest_data[quest]
		for tasks in quest["tasks"]:
			if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
				completed = false
				
			if completed != quest["completed"]:
					changed = true
		
		if changed == true:
			quest["completed"] = completed
			SaveManager.save_game(quest_data, "quest_file")
	
	return quest_data

func _add_quest(quest_id: String):
	var quest_data = _get_quests()
	
	quest_data[quest_id] = quest_source[quest_id]
	SaveManager.save_game(quest_data, "quest_file")

func _update_task(quest_id: String, task_id: String, progress: int):
	var quest_data = _get_quests()
	var quest = quest_data[quest_id]
	var task = quest["tasks"][task_id]
	var completed = true
	
	for tasks in quest["tasks"]:
		if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
			completed = false
	
	task["progress"] = progress
	quest["completed"] = completed
	SaveManager.save_game(quest_data, "quest_file")
