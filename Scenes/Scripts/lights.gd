extends Node2D

@onready var config_file = SaveManager.load_game("config_file")
@onready var light1 = $PointLight2D
@onready var light2 = $PointLight2D2

func _ready() -> void:
	SignalManager.settings_updated.connect(load_graphics)
	load_graphics()

func load_graphics():
	config_file = SaveManager.load_game("config_file")
	var mode = config_file["Lights"]
	
	if mode == false:
		light1.visible = false
		light2.visible = false
		light1.enabled = false
		light2.enabled = false
	else:
		light1.visible = true
		light2.visible = true
		light1.enabled = true
		light2.enabled = true
