extends Area2D

@export var dialogue_resource: DialogueManager
@export var dialogue_start: String = "meet_pearl"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("triggered")
		SaveManager.play_dialogue_once("meet_pearl", "res://Dialogue/meet_pearl.dialogue")
