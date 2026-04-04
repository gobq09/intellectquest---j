extends Control

@onready var quest_data = QuestManager._get_quests()
@onready var quests : PackedScene = preload("uid://by4chugqsyn4d")
@onready var quests_container: VBoxContainer = $Control/ScrollContainer/Quests_Container

func _ready() -> void:
	for id in quest_data:
		if quest_data[id]["completed"] == false:
			_load_quests(id)
	
	for id in quest_data:
		if quest_data[id]["completed"] == true:
			_load_quests(id)


func _load_quests(id):
	var instance = quests.instantiate()
	
	instance.quest_id = id
	
	quests_container.add_child(instance)
