extends Node2D

@onready var game_data = SaveManager.load_game("save_file")

func _ready() -> void:
	game_data["in_game"] = true
	game_data["last_scene"] = "uid://ff51jtud42m1"
	game_data["tutorial"] = true
	game_data["in_combat"] = false
	game_data["global_position"] = Vector2(-473, 17)
	game_data["respawn_point"] = Vector2(-473, 17)
	
	SaveManager.save_game(game_data, "save_file")
	
	SignalManager.map_changed.emit("uid://ff51jtud42m1")


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
