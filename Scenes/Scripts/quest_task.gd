extends HBoxContainer

@onready var quest_data = QuestManager._get_quests()
@onready var task_name = $Name
@onready var progress = $Progress

var quest_id : String = "0"
var task_id : String = "0"

func _ready() -> void:
	task_name.text = quest_data[quest_id]["tasks"][task_id]["task_name"]
	progress.text = str(int(quest_data[quest_id]["tasks"][task_id]["progress"])) + "/" + str(int(quest_data[quest_id]["tasks"][task_id]["goal"]))
	
	if int(quest_data[quest_id]["tasks"][task_id]["progress"]) == int(quest_data[quest_id]["tasks"][task_id]["goal"]):
		self.modulate.a = 0.5
		task_name.text = "[s]" + quest_data[quest_id]["tasks"][task_id]["task_name"]
		progress.text = "[s]" + str(int(quest_data[quest_id]["tasks"][task_id]["progress"])) + "/" + str(int(quest_data[quest_id]["tasks"][task_id]["goal"]))
	
