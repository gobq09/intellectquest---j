extends Marker2D

@export var marker_name: String

func _ready() -> void:
	SignalManager.move_to_marker.connect(move_to_marker)
	SignalManager.move_pearl_to.connect(pearl_marker)
	SignalManager.spawn_point_set.connect(spawn_point_set)

func move_to_marker(target_name: String, duration: float = 1.0):
	if target_name == marker_name:
		print(global_position)
		SignalManager.send_marker.emit(global_position, duration)
	
signal send_marker(global_position: Vector2, duration: float)

func pearl_marker(target_name: String, duration: float = 1.0):
	if target_name == marker_name:
		print(global_position)
		SignalManager.pearl_marker.emit(global_position, duration)

func spawn_point_set(spawn_point: String):
	var coords: Vector2
	if spawn_point == "Greymoor":
		coords = Vector2(400, 144)
	elif spawn_point == "Linguara":
		coords = Vector2(2544, -1376)
	elif spawn_point == "Forest":
		coords = Vector2(3584, 192)
	
	var game_data = SaveManager.load_game("save_file")
	game_data["respawn_point"] = coords
	SaveManager.save_game(game_data, "save_file")
