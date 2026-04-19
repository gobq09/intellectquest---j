extends Camera2D

func _ready() -> void:
	SignalManager.camera_move_to.connect(camera_move_to)
	SignalManager.dialogue_exit.connect(dialogue_exit)
	
	await get_tree().create_timer(0.1).timeout
	self.position_smoothing_enabled = true

func camera_move_to(move_position):
	position = move_position

func dialogue_exit():
	position = Vector2.ZERO
