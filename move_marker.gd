extends Marker2D

@export var marker_name: String

func _ready() -> void:
	SignalManager.move_to_marker.connect(move_to_marker)
	SignalManager.move_pearl_to.connect(pearl_marker)

func move_to_marker(target_name: String, duration: float = 1.0):
	if target_name == marker_name:
		print(global_position)
		SignalManager.send_marker.emit(global_position, duration)
	
signal send_marker(global_position: Vector2, duration: float)

func pearl_marker(target_name: String, duration: float = 1.0):
	if target_name == marker_name:
		print(global_position)
		SignalManager.pearl_marker.emit(global_position, duration)
