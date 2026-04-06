extends Area2D

@export var dialogue_resource: DialogueManager
@export var dialogue_start: String = "meet_pearl"
#@onready var game_data = SaveManager.load_game("save_file")

func _on_body_entered(body: Node2D) -> void:
	var game_data = SaveManager.load_game("save_file")
	if game_data["ui_tutorial"] == false:
		SignalManager.trigger_ui.emit()
	if body.name == "Player":
		print("triggered")
		#SaveManager.play_dialogue_once("meet_pearl", "res://Dialogue/meet_pearl.dialogue")
