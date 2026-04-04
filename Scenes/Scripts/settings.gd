extends Node

@onready var config_data = SaveManager.load_game("config_file")
@onready var graphics_mode = config_data["Graphics_Mode"]
@onready var frame_rate = config_data["Frame_Rate"]
@onready var joystick_mode = config_data["Joystick_Mode"]
@onready var vsync = config_data["VSync"]
@onready var master_volume = config_data["Master_Vol"]
@onready var music_volume = config_data["Joystick_Mode"]
@onready var sfx_volume = config_data["SFX_Vol"]
@onready var ambience_volume = config_data["Ambience_Vol"]

@onready var new_config = config_data.duplicate()
@onready var default_config = SaveManager.config_data

@onready var graphics_low = $Settings/Graphics/Mode/Low
@onready var graphics_high = $Settings/Graphics/Mode/High
@onready var fps_30 = $"Settings/Graphics/FPS/30"
@onready var fps_60 = $"Settings/Graphics/FPS/60"
@onready var vsync_check = $Settings/Graphics/VSync/CheckBox
@onready var joystick_fixed = $Settings/General/Joystick/Fixed
@onready var joystick_dynamic = $Settings/General/Joystick/Dynamic
@onready var master_slider = $Settings/Audio/Master/MasterSlider
@onready var music_slider = $Settings/Audio/Music/MusicSlider
@onready var sfx_slider = $Settings/Audio/SFX/SfxSlider
@onready var ambience_slider = $Settings/Audio/Ambience/AmbienceSlider

func _ready() -> void:
	_load_config(config_data)

func _load_config(data):
	if data["Graphics_Mode"] == "Low":
		graphics_low.button_pressed = true
	else:
		graphics_high.button_pressed = true
	
	if data["Frame_Rate"] == 30:
		fps_30.button_pressed = true
	else:
		fps_60.button_pressed = true
	
	if data["VSync"] == true:
		vsync_check.button_pressed = true
	else:
		vsync_check.button_pressed = false
	
	if data["Joystick_Mode"] == "Fixed":
		joystick_fixed.button_pressed = true
	else:
		joystick_dynamic.button_pressed = true
	
	master_slider.value = data["Master_Vol"]
	music_slider.value = data["Music_Vol"]
	sfx_slider.value = data["SFX_Vol"]
	ambience_slider.value = data["Ambience_Vol"]

func _on_reset_pressed() -> void:
	new_config = default_config
	_load_config(new_config)

func _on_revert_pressed() -> void:
	new_config = config_data.duplicate()
	_load_config(new_config)

func _on_save_pressed() -> void:
	SaveManager.save_game(new_config, "config_file")
	SignalManager.settings_updated.emit()
	SettingsManager._load_settings()

#region Volume
func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	new_config["Master_Vol"] = value

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	new_config["Music_Vol"] = value

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	new_config["SFX_Vol"] = value

func _on_ambience_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3, linear_to_db(value))
	new_config["Ambience_Vol"] = value

#endregion

#region Graphics

func _on_low_pressed() -> void:
	new_config["Graphics_Mode"] = "Low"


func _on_high_pressed() -> void:
	new_config["Graphics_Mode"] = "High"


func _on_check_box_pressed() -> void:
	if vsync_check.button_pressed == true:
		new_config["VSync"] = true
	else:
		new_config["VSync"] = false


func _on_30_pressed() -> void:
	new_config["Frame_Rate"] = 30


func _on_60_pressed() -> void:
	new_config["Frame_Rate"] = 60
#endregion

#region Joystick

func _on_fixed_pressed() -> void:
	new_config["Joystick_Mode"] = "Fixed"


func _on_dynamic_pressed() -> void:
	new_config["Joystick_Mode"] = "Dynamic"
#endregion
