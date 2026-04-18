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

@onready var graphics_custom = $Settings/Graphics/Mode/Custom
@onready var graphics_low = $Settings/Graphics/Mode/Low
@onready var graphics_high = $Settings/Graphics/Mode/High
@onready var fps_30 = $"Settings/Graphics/FPS/30"
@onready var fps_60 = $"Settings/Graphics/FPS/60"
@onready var animals_check = $Settings/Graphics/Animals/CheckBox
@onready var clouds_check = $Settings/Graphics/Clouds/CheckBox
@onready var particles_check = $Settings/Graphics/Particles/CheckBox
@onready var lights_check = $Settings/Graphics/Lights/CheckBox
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
	elif data["Graphics_Mode"] == "Custom":
		graphics_custom.button_pressed = true
	else:
		graphics_high.button_pressed = true
	
	if data["Frame_Rate"] == 30:
		fps_30.button_pressed = true
	else:
		fps_60.button_pressed = true
	
	if data["Animals"] == true:
		animals_check.button_pressed = true
	else:
		animals_check.button_pressed = false
	if data["Clouds"] == true:
		clouds_check.button_pressed = true
	else:
		clouds_check.button_pressed = false
	if data["Particles"] == true:
		particles_check.button_pressed = true
	else:
		particles_check.button_pressed = false
	if data["Lights"] == true:
		lights_check.button_pressed = true
	else:
		lights_check.button_pressed = false
	
	if data["VSync"] == true:
		vsync_check.button_pressed = true
	else:
		vsync_check.button_pressed = false
	
	if data["Joystick_Mode"] == "Fixed":
		joystick_fixed.button_pressed = true
	else:
		joystick_dynamic.button_pressed = true
	
	master_slider.value = data.get("Master_Vol", 1.0) * 100 
	music_slider.value = data.get("Music_Vol", 1.0) * 100 
	sfx_slider.value = data.get("SFX_Vol", 1.0) * 100 
	ambience_slider.value = data.get("Ambience_Vol", 1.0) * 100 

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
	var normalized = value / 100.0
	AudioServer.set_bus_volume_db(0, linear_to_db(normalized))
	new_config["Master_Vol"] = normalized

func _on_music_slider_value_changed(value: float) -> void:
	var normalized = value / 100.0
	AudioServer.set_bus_volume_db(1, linear_to_db(normalized))
	new_config["Music_Vol"] = normalized

func _on_sfx_slider_value_changed(value: float) -> void:
	var normalized = value / 100.0
	AudioServer.set_bus_volume_db(2, linear_to_db(normalized))
	new_config["SFX_Vol"] = normalized

func _on_ambience_slider_value_changed(value: float) -> void:
	var normalized = value / 100.0
	AudioServer.set_bus_volume_db(3, linear_to_db(normalized))
	new_config["Ambience_Vol"] = normalized

#endregion

#region Graphics

func _on_low_pressed() -> void:
	new_config["Graphics_Mode"] = "Low"
	new_config["Frame_Rate"] = 30
	new_config["Animals"] = false
	new_config["Clouds"] = false
	new_config["Particles"] = false
	new_config["Lights"] = false
	
	animals_check.button_pressed = false
	clouds_check.button_pressed = false
	particles_check.button_pressed = false
	lights_check.button_pressed = false
	fps_30.button_pressed = true
	


func _on_high_pressed() -> void:
	new_config["Graphics_Mode"] = "High"
	new_config["Frame_Rate"] = 60
	new_config["Animals"] = true
	new_config["Clouds"] = true
	new_config["Particles"] = true
	new_config["Lights"] = true
	
	animals_check.button_pressed = true
	clouds_check.button_pressed = true
	particles_check.button_pressed = true
	lights_check.button_pressed = true
	fps_60.button_pressed = true


func _on_custom_pressed() -> void:
	new_config["Graphics_Mode"] = "Custom"

func _on_check_box_pressed() -> void:
	if vsync_check.button_pressed == true:
		new_config["VSync"] = true
	else:
		new_config["VSync"] = false


func _on_30_pressed() -> void:
	new_config["Frame_Rate"] = 30
	checkboxes()


func _on_60_pressed() -> void:
	new_config["Frame_Rate"] = 60
	checkboxes()


func checkboxes():
	var checks : Array = []
	var result
	
	if fps_60.button_pressed == false:
		checks.append(false)
	else:
		checks.append(true)
	if animals_check.button_pressed == false:
		checks.append(false)
	else:
		checks.append(true)
	if clouds_check.button_pressed == false:
		checks.append(false)
	else:
		checks.append(true)
	if particles_check.button_pressed == false:
		checks.append(false)
	else:
		checks.append(true)
	if lights_check.button_pressed == false:
		checks.append(false)
	else:
		checks.append(true)
	
	if checks.has(true):
		if checks.has(false):
			result = "Custom"
			new_config["Graphics_Mode"] = "Custom"
		else:
			result = "High"
			new_config["Graphics_Mode"] = "High"
	else:
		result = "Low"
		new_config["Graphics_Mode"] = "Low"
	
	if result == "Custom":
		graphics_custom.button_pressed = true
	elif result == "Low":
		graphics_low.button_pressed = true
	else:
		graphics_high.button_pressed = true

func _on_animals_pressed() -> void:
	checkboxes()
	if animals_check.button_pressed == true:
		new_config["Animals"] = true
	else:
		new_config["Animals"] = false

func _on_clouds_pressed() -> void:
	checkboxes()
	if clouds_check.button_pressed == true:
		new_config["Clouds"] = true
	else:
		new_config["Clouds"] = false


func _on_particles_pressed() -> void:
	checkboxes()
	if particles_check.button_pressed == true:
		new_config["Particles"] = true
	else:
		new_config["Particles"] = false


func _on_lights_pressed() -> void:
	checkboxes()
	if lights_check.button_pressed == true:
		new_config["Lights"] = true
	else:
		new_config["Lights"] = false

#endregion

#region Joystick

func _on_fixed_pressed() -> void:
	new_config["Joystick_Mode"] = "Fixed"


func _on_dynamic_pressed() -> void:
	new_config["Joystick_Mode"] = "Dynamic"
#endregion


func _on_unstick_pressed() -> void:
	var game_data = SaveManager.load_game("save_file")
	SceneLoader.load_map("uid://d4dgymuee0bxt", game_data["respawn_point"])
