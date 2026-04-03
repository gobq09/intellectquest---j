extends Node

@onready var config_data = SaveManager.load_game("config_file")
@onready var graphics_mode = config_data["Graphics_Mode"]
@onready var joystick_mode = config_data["Joystick_Mode"]
@onready var vsync = config_data["VSync"]
@onready var master_volume = config_data["Master_Vol"]
@onready var music_volume = config_data["Joystick_Mode"]
@onready var sfx_volume = config_data["SFX_Vol"]
@onready var ambience_volume = config_data["Ambience_Vol"]

@onready var new_config = config_data
@onready var default_config = SaveManager.config_data

@onready var graphics_low = $VBoxContainer/Graphics/Mode/Low
@onready var graphics_high = $VBoxContainer/Graphics/Mode/High
@onready var vsync_check = $VBoxContainer/Graphics/VSync/CheckBox
@onready var joystick_fixed = $VBoxContainer/General/Joystick/Fixed
@onready var joystick_dynamic = $VBoxContainer/General/Joystick/Dynamic
@onready var master_slider = $VBoxContainer/Audio/Master/MasterSlider
@onready var music_slider = $VBoxContainer/Audio/Music/MusicSlider
@onready var sfx_slider = $VBoxContainer/Audio/SFX/SfxSlider
@onready var ambience_slider = $VBoxContainer/Audio/Ambience/AmbienceSlider

func _ready() -> void:
	_load_config(config_data)

func _load_config(data):
	if data["Graphics_Mode"] == "Low":
		graphics_low.toggled = true
	else:
		graphics_high.toggled = true
	
	if data["VSync"] == true:
		vsync_check.toggled = true
	else:
		vsync_check.toggled = false
	
	if data["Joystick_Mode"] == "Fixed":
		joystick_fixed.pressed
	else:
		joystick_dynamic.pressed
	
	master_slider.value = data["Master_Vol"]
	music_slider.value = data["Music_Vol"]
	sfx_slider.value = data["SFX_Vol"]
	ambience_slider.value = data["Ambience_Vol"]

func _on_reset_pressed() -> void:
	new_config = default_config
	_load_config(new_config)

func _on_revert_pressed() -> void:
	_load_config(new_config)

func _on_save_pressed() -> void:
	SaveManager.save_game(new_config, "config_file")

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
	if vsync.toggled:
		new_config["VSync"] = true
	else:
		new_config["VSync"] = false
#endregion

#region Joystick

func _on_fixed_pressed() -> void:
	new_config["Joystick_Mode"] = "Fixed"


func _on_dynamic_pressed() -> void:
	new_config["Joystick_Mode"] = "Dynamic"
#endregion
