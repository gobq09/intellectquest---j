extends Node2D

@onready var game_data = SaveManager.load_game("save_file")
@export var Chunk_Name : String = name
var x_axis : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var y_axis : Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

func _ready() -> void:
	if name == game_data["last_chunk"]:
		print("true")
		self.visible = true
		self.process_mode = Node.PROCESS_MODE_INHERIT

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["last_chunk"] = name
		SaveManager.save_game(game_data, "save_file")
		
		SignalManager.entered_chunk.emit(name)
		print("entered ", name)

func _on_grid_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 1
		SaveManager.save_game(game_data, "save_file")


func _on_grid_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 2
		SaveManager.save_game(game_data, "save_file")


func _on_grid_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 3
		SaveManager.save_game(game_data, "save_file")


func _on_grid_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 4
		SaveManager.save_game(game_data, "save_file")
