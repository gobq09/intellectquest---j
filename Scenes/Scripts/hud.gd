extends CanvasLayer

@export var animation_player: AnimationPlayer
@onready var hud : Control = $HUD
@onready var game_data = SaveManager.load_game("save_file")
@onready var player_data = SaveManager.load_game("player_file")

@onready var tutorial = $Tutorial
@onready var tutorial_panel = $Tutorial/Panel

@onready var bar = $HUD/HP/Bar
@onready var level = $"HUD/HP/Interface-hud-level"
@onready var archive = $"HUD/HP/Archive Button"
@onready var top_right = $HUD/Control
@onready var top_right1 = $"HUD/Control/Interface-hud-topright1"
@onready var top_right2 = $"HUD/Control/Interface-hud-topright2"
@onready var task = $HUD/Control/Task
@onready var map = $"HUD/Control/Map Button"
@onready var settings = $"HUD/Control/Settings Button"
@onready var joystick = $HUD/Joystick
@onready var interact = $HUD/Interact

@onready var hp_label = $Tutorial/Control/HP_Label
@onready var archive_label = $Tutorial/Control/Archive_Label
@onready var joystick_label = $Tutorial/Control/Joystick_Label
@onready var interact_label = $Tutorial/Control/Interact_Label
@onready var topright_label = $Tutorial/Control/TopRight_Label

@onready var proceed_button = $Tutorial/Proceed
signal proceed_pressed

var top_index = 5
var panel_index = 4
var normal_index = 0

func _ready() -> void:
	SignalManager.ui_tutorial.connect(trigger_tutorial)
	SignalManager.dialogue_enter.connect(dialogue_enter)
	SignalManager.dialogue_exit.connect(dialogue_exit)
	
	check_data()
	
	if game_data["new_game"] == true:
		hud.visible = false
		animation_player.play("cutscene")
		await animation_player.animation_finished
		await get_tree().create_timer(10).timeout
		
		animation_player.play_backwards("cutscene")
		await animation_player.animation_finished
		$Panels.visible = false
		
		hud.visible = true
		animation_player.play("hud_fade")
		await animation_player.animation_finished
	
	hud.visible = true
	hud.modulate.a = 1.0

func check_data():
	var player_data = SaveManager.load_game("player_file")
	var tutorial_progress = player_data["ui_tutorial"]
	
	#"joystick": false, 
	if tutorial_progress["joystick"] == false:
		joystick.visible = false
	else:
		joystick.visible = true
	#"interact": false,
	if tutorial_progress["interact"] == false:
		interact.visible = false
	else:
		interact.visible = true
	#"level": false,  #"hp": false, 
	if tutorial_progress["level"] == false || tutorial_progress["hp"] == false:
		level.visible = false
		bar.visible = false
	else:
		level.visible = true
		bar.visible = true
		
	#"archive": false,
	if tutorial_progress["archive"] == false:
		archive.visible = false
	else:
		archive.visible = true
	#"task": false,
	if tutorial_progress["task"] == false:
		task.visible = false
	else:
		task.visible = true
	#"map": false,
	if tutorial_progress["map"] == false:
		map.visible = false
	else:
		map.visible = true
	#"settings": false,
	if tutorial_progress["settings"] == false:
		settings.visible = false
		top_right.visible = false
	else:
		settings.visible = true
		top_right.visible = true
	

func dialogue_enter():
	hud.visible = false
	hud.set_process_input(false)
	SignalManager.movement_disabled.emit()

func dialogue_exit():
	hud.visible = true
	hud.set_process_input(true)
	SignalManager.movement_enabled.emit()

#region Tutorial
func trigger_tutorial(type) -> void:
	SignalManager.movement_disabled.emit()
	tutorial.visible = true
	tutorial_panel.visible = true
	tutorial.z_index = panel_index
	joystick.process_mode = Node.PROCESS_MODE_DISABLED
	
	match type:
		"hp":
			tutorial_hp()
		"level":
			tutorial_level()
		"archive":
			tutorial_archive()
		"task":
			tutorial_task()
		"map":
			tutorial_map()
		"settings":
			tutorial_settings()
		"joystick":
			tutorial_joystick()
		"interact":
			tutorial_interact()
	
	await get_tree().create_timer(2).timeout
	proceed_button.visible = true

func tutorial_hp():
	var text = "[b]This is your HP Bar.  It displays how much Health you have left."
	level.visible = true
	bar.visible = true
	bar.z_index = top_index
	level.z_index = top_index
	level.modulate = Color(0.5, 0.5, 0.5, 1.0)
	
	hp_label.visible = true
	hp_label.text = text
	hp_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["hp"] = true
	SaveManager.save_game(player_data, "player_file")
	
	await proceed_button.pressed
	
	trigger_tutorial("archive")

func tutorial_level():
	var text = "[b]This is your Level. Tapping this will lead you to your profile, where you can see your stats, and access your inventory."
	level.visible = true
	bar.visible = true
	level.z_index = top_index
	
	hp_label.visible = true
	hp_label.text = text
	hp_label.z_index = top_index
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["level"] = true
	SaveManager.save_game(player_data, "player_file")
	
	await proceed_button.pressed
	
	trigger_tutorial("hp")

func tutorial_archive():
	#var text = "This is your HP Bar.  It displays how much Health you have left."
	archive.z_index = top_index
	archive.visible = true
	
	archive_label.visible = true
	#archive_label.text = text
	archive_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["archive"] = true
	SaveManager.save_game(player_data, "player_file")

func tutorial_task():
	
	var text = "[b]This is the Task Button. Here you can view the progress of your quest. \n\nPressing and Holding this button will lead you to the Quests Screen, where you can view all of your quests."
	top_right.z_index = top_index
	top_right1.modulate = Color(0.5, 0.5, 0.5, 1.0)
	top_right2.modulate = Color(0.5, 0.5, 0.5, 1.0)
	map.modulate = Color(0.5, 0.5, 0.5, 1.0)
	settings.modulate = Color(0.5, 0.5, 0.5, 1.0)
	task.z_index = top_index
	task.modulate = Color(1.0, 1.0, 1.0, 1.0)
	task.visible = true
	
	topright_label.visible = true
	topright_label.text = text
	topright_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["task"] = true
	SaveManager.save_game(player_data, "player_file")

func tutorial_map():
	var text = "[b]This is the Map button. Tapping this will show you the map of the world."
	top_right.z_index = top_index
	top_right1.modulate = Color(0.5, 0.5, 0.5, 1.0)
	top_right2.modulate = Color(0.5, 0.5, 0.5, 1.0)
	task.modulate = Color(0.5, 0.5, 0.5, 1.0)
	settings.modulate = Color(0.5, 0.5, 0.5, 1.0)
	map.z_index = top_index
	map.modulate = Color(1.0, 1.0, 1.0, 1.0)
	map.visible = true
	
	topright_label.visible = true
	topright_label.text = text
	topright_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["map"] = true
	SaveManager.save_game(player_data, "player_file")

func tutorial_settings():
	var text = "[b]This is the Settings button. Tapping this will lead you to the settings, where you can configure the game to your own liking."
	top_right.z_index = top_index
	top_right1.modulate = Color(0.5, 0.5, 0.5, 1.0)
	top_right2.modulate = Color(0.5, 0.5, 0.5, 1.0)
	task.modulate = Color(0.5, 0.5, 0.5, 1.0)
	map.modulate = Color(0.5, 0.5, 0.5, 1.0)
	settings.z_index = top_index
	settings.modulate = Color(1.0, 1.0, 1.0, 1.0)
	settings.visible = true
	top_right.visible = true
	
	topright_label.visible = true
	topright_label.text = text
	topright_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["settings"] = true
	SaveManager.save_game(player_data, "player_file")
	
	await proceed_button.pressed
	
	trigger_tutorial("task")

func tutorial_joystick():
	joystick.visible = true
	joystick.process_mode = Node.PROCESS_MODE_INHERIT
	joystick.z_index = top_index
	
	joystick_label.visible = true
	joystick_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["joystick"] = true
	SaveManager.save_game(player_data, "player_file")
	
	#await proceed_pressed
	#trigger_tutorial("settings")

func tutorial_interact():
	interact.visible = true
	
	interact.z_index = top_index
	
	interact_label.visible = true
	interact_label.z_index = top_index
	
	player_data = SaveManager.load_game("player_file")
	player_data["ui_tutorial"]["interact"] = true
	SaveManager.save_game(player_data, "player_file")

func _on_continue_pressed() -> void:
	SignalManager.movement_enabled.emit()
	
	bar.z_index = normal_index
	level.z_index = normal_index
	archive.z_index = normal_index
	top_right.z_index = normal_index
	task.z_index = normal_index
	map.z_index = normal_index
	settings.z_index = normal_index
	joystick.z_index = normal_index
	interact.z_index = normal_index
	
	level.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top_right1.modulate = Color(1.0, 1.0, 1.0, 1.0)
	top_right2.modulate = Color(1.0, 1.0, 1.0, 1.0)
	task.modulate = Color(1.0, 1.0, 1.0, 1.0)
	map.modulate = Color(1.0, 1.0, 1.0, 1.0)
	settings.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	tutorial.visible = false
	hp_label.visible = false
	archive_label.visible = false
	joystick_label.visible = false
	interact_label.visible = false
	topright_label.visible = false
	
	proceed_button.visible = false
	joystick.process_mode = Node.PROCESS_MODE_INHERIT
#endregion
