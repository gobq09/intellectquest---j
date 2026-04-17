extends ColorRect

func _ready() -> void:
	load_graphics()

func load_graphics():
	var config_file = SaveManager.load_game("config_file")
	var mode = config_file["Clouds"]
	
	if mode == false:
		self.queue_free()
	else:
		self.visible = true
		self.process_mode = Node.PROCESS_MODE_INHERIT
