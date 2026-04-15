extends Area2D

@export_enum("joystick", "settings", "level", "interact", "task", "archive", "map") var tutorial_name: String
@onready var player_data = SaveManager.load_game("player_file")
@onready var tutorial_progress = player_data["ui_tutorial"]

func _ready() -> void:
	check_data()

func check_data():
	player_data = SaveManager.load_game("player_file")
	tutorial_progress = player_data["ui_tutorial"]
	
	if tutorial_progress[tutorial_name] == true:
		self.queue_free()
		print("freed")

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	check_data()
	player_data = SaveManager.load_game("player_file")
	tutorial_progress = player_data["ui_tutorial"]
	
	if tutorial_progress[tutorial_name] == false:
		SignalManager.ui_tutorial.emit(tutorial_name)
