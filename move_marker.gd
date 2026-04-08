extends Marker2D

@export var marker_name: String

func _ready() -> void:
	SignalManager.move_to_marker.connect(move_to_marker)

func move_to_marker(target_name: String, duration: float = 1.0):
	if target_name == marker_name:
		print(global_position)
		SignalManager.send_marker.emit(global_position, duration)
	
