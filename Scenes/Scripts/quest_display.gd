extends VBoxContainer

# load quest_data[id]
@onready var quest_data : Dictionary = QuestManager._get_quests()

@onready var quest_name = $Control/Quest_Name
@onready var tasks_container = $Control/ScrollContainer/Tasks_Container
@onready var tasks : PackedScene = preload("uid://oo72od1grphs")
@onready var texture : TextureRect = $Control

@onready var incomplete : String = "uid://cjnmf543iuwoh"
@onready var complete : String = "uid://prfrlbcnm1ih"

var quest_id: String = "0"

func _ready() -> void:
	var quest = quest_data[quest_id]
	quest_name.text = "[b]" + str(quest["name"])
	
	if quest["completed"] == true:
		texture.texture = load(complete)
		quest_name.modulate.a = 0.5
	else:
		texture.texture = load(incomplete)
		quest_name.modulate.a = 1.0
	
	for tasks in quest["tasks"]:
		_load_tasks(quest_id, tasks)

func _load_tasks(quest_id, task_id):
	var instance = tasks.instantiate()
	
	instance.quest_id = quest_id
	instance.task_id = task_id
	#instance.press.connect(_item_select)
	
	tasks_container.add_child(instance)
