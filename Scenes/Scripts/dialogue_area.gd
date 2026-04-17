extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_id: String

#@onready var game_data = SaveManager.load_game("save_file")

func _on_body_entered(body: Node2D) -> void:
	var game_data = SaveManager.load_game("save_file")
	
	if body.name == "Player":
		print("triggered")
		SaveManager.play_dialogue_once(dialogue_id, dialogue_resource.resource_path)
		#DialogueManager.show_dialogue_balloon(load("res://Dialogue/meet_pearl.dialogue"))
