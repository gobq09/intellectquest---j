extends Control

@onready var position_data = SaveManager.load_game("position_file")
@onready var quest_data = QuestManager._get_quests()
@onready var quests : PackedScene = preload("uid://by4chugqsyn4d")
@onready var quests_container: VBoxContainer = $Control/ScrollContainer/Quests_Container

func _ready() -> void:
	_on_main_pressed()

func _update_quests(type: String = "main"):
	for child in quests_container.get_children():
		child.queue_free()
	
	for id in quest_data:
		if quest_data[id]["type"] == type:
			if not id == "none":
				if quest_data[id]["completed"] == false:
					_load_quests(id)
	
	for id in quest_data:
		if quest_data[id]["type"] == type:
			if not id == "none":
				if quest_data[id]["completed"] == true:
					_load_quests(id)

func _load_quests(id):
	var instance = quests.instantiate()
	
	instance.quest_id = id
	
	quests_container.add_child(instance)


func _on_close_pressed() -> void:
	#SceneLoader.load_scene(position_data["last_scene"])
	SignalManager.show_hud.emit()
	self.queue_free()


func _on_main_pressed() -> void:
	_update_quests("main")
	$Control/Main.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Control/Side.modulate = Color(0.6, 0.6, 0.6, 1.0)


func _on_side_pressed() -> void:
	_update_quests("side")
	$Control/Side.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Control/Main.modulate = Color(0.6, 0.6, 0.6, 1.0)
