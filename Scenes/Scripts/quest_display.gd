extends VBoxContainer

# load quest_data[id]
@onready var quest_data : Dictionary = QuestManager._get_quests()
@onready var game_data = SaveManager.load_game("save_file")
@onready var active_quest = game_data["active_quest"]

@onready var quest_name = $Control/Quest_Name
@onready var tasks_container = $Control/ScrollContainer/Tasks_Container
@onready var tasks : PackedScene = preload("uid://oo72od1grphs")
@onready var texture : TextureButton = $Control

@onready var incomplete : String = "uid://cjnmf543iuwoh"
@onready var complete : String = "uid://prfrlbcnm1ih"

var quest_id: String = "none"

func _ready() -> void:
	if active_quest == quest_id:
		$Control/Button.visible = true
		$Control/Button.text = "Untrack"
		$Control.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		$Control/Button.visible = false
		$Control.modulate = Color(0.6, 0.6, 0.6, 1.0)
	
	SignalManager.quest_selected.connect(quest_select)
	
	var quest = quest_data[quest_id]
	quest_name.text = "[b]" + str(quest["name"])
	
	for tasks in quest["tasks"]:
		if quest["tasks"][tasks]["progress"] < quest["tasks"][tasks]["goal"]:
			_load_tasks(quest_id, tasks)
	
	for tasks in quest["tasks"]:
		if quest["tasks"][tasks]["progress"] >= quest["tasks"][tasks]["goal"]:
			_load_tasks(quest_id, tasks)
	
	if quest["completed"] == true:
		texture.texture_normal = load(complete)
		$Control.disabled = true
		quest_name.modulate.a = 0.6
	else:
		texture.texture_normal = load(incomplete)
		$Control.disabled = false
		quest_name.modulate.a = 1.0

func _load_tasks(quest_id, task_id):
	var instance = tasks.instantiate()
	
	instance.quest_id = quest_id
	instance.task_id = task_id
	#instance.press.connect(_item_select)
	
	tasks_container.add_child(instance)


func _on_button_pressed() -> void: 
	if $Control/Button.text == "Track":
		$Control/Button.text = "Untrack"
		game_data["active_quest"] = quest_id
		SaveManager.save_game(game_data, "save_file")
	elif $Control/Button.text == "Untrack":
		$Control/Button.text = "Track"
		game_data["active_quest"] = "none"
		SaveManager.save_game(game_data, "save_file")
	

func quest_select(id):
	game_data = SaveManager.load_game("save_file")
	active_quest = game_data["active_quest"]
	
	if quest_id == id:
		$Control/Button.visible = true
		if active_quest == quest_id:
			$Control/Button.text = "Untrack"
		else:
			$Control/Button.text = "Track"
		$Control.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		$Control/Button.visible = false
		$Control.modulate = Color(0.6, 0.6, 0.6, 1.0)


func _on_control_pressed() -> void:
	SignalManager.quest_selected.emit(quest_id)
	
