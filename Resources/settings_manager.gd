extends Node

@onready var config_data = SaveManager.load_game("config_file")
@onready var default_config = SaveManager.config_data

var joystick_mode
var graphics_mode
var frame_rate
var vsync
var master_vol
var music_vol
var sfx_vol
var ambience_vol

func _ready() -> void:
	SignalManager.settings_updated.connect(_load_settings)
	_load_settings()

func _load_settings():
	config_data = SaveManager.load_game("config_file")
	
	joystick_mode = config_data["Joystick_Mode"]
	graphics_mode = config_data["Graphics_Mode"]
	frame_rate = config_data["Frame_Rate"]
	vsync = config_data["VSync"]
	master_vol = config_data["Master_Vol"]
	music_vol = config_data["Music_Vol"]
	sfx_vol = config_data["SFX_Vol"]
	ambience_vol = config_data["Ambience_Vol"]
	
	if graphics_mode == "Low":
		SignalManager.graphics_mode.emit("Low")
		print("emitted low")
	else:
		SignalManager.graphics_mode.emit("High")
		print("emitted high")
	
	Engine.max_fps = frame_rate
	
	if vsync == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	AudioServer.set_bus_volume_db(0, linear_to_db(master_vol))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_vol))
	AudioServer.set_bus_volume_db(3, linear_to_db(ambience_vol))
