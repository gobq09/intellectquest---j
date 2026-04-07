extends Camera2D

func _ready() -> void:
	SignalManager.camera_move_to.connect(camera_move_to)
	

func camera_move_to(move_position):
	position = move_position
