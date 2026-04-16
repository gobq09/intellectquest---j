extends Area2D

@export var Dialogue: DialogueResource
@onready var player_data = SaveManager.load_game("player_file")

var player_in_range: bool = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact():
	#start dialogue
	print("interacted")
	DialogueManager.show_example_dialogue_balloon(Dialogue)
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#interact_icon.visible = true
		get_parent().interact_icon.visible = true
		player_in_range = true
		
		if player_data["ui_tutorial"]["interact"] == false:
			player_data = SaveManager.load_game("player_file")
			if player_data["ui_tutorial"]["interact"] == false:
				SignalManager.ui_tutorial.emit("interact")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#interact_icon.visible = false
		get_parent().interact_icon.visible = false
		player_in_range = false
