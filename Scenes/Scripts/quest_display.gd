extends VBoxContainer

# load quest_data[id]
@onready var quest_data = SaveManager.load_game("quest_file")

@onready var quest_name = $Control/Quest_Name
@onready var tasks_container = $Control/ScrollContainer/Tasks_Container
@onready var quest_tasks : PackedScene = preload("uid://oo72od1grphs")

var quest_id

func _ready() -> void:
	quest_name.text = quest_data[quest_id]
	pass

func _load_tasks():
	#var instance = item.instantiate()
	#
	#instance.id = item_id
	#instance.press.connect(_item_select)
	#
	#box.add_child(instance)
	pass
