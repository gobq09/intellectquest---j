extends Control

@onready var player_data = SaveManager.load_game("player_file")

@onready var tutorial_panel = $Panel
@onready var left_text = $Left_Text
@onready var center_text = $Center_Text
@onready var right_text = $Right_Text

@onready var player_hp = $"../HP/PlayerHP"
@onready var enemy_hp = $"../HP/EnemyHP"

@onready var attack = $"../Action/Attack"
@onready var inventory = $"../Action/Inventory"
@onready var archive = $"../Action/Archive"
@onready var run = $"../Action/Run"

@onready var answers = $"../Control/Control2"
@onready var question = $"../Control/Control"
@onready var ok = $"../Control/OkButton"
@onready var time = $"../Control/Time"

@onready var summary = $"../Summary/Control"

signal next_pressed
signal attack_pressed

var top_index = 4
var normal_index = 0

func _ready() -> void:
	attack_pressed.connect(attack_tutorial)
	
	if player_data["ui_tutorial"]["combat"] == false:
		actions_tutorial()

func actions_tutorial():
	self.visible = true
	tutorial_panel.visible = true
	left_text.visible = false
	center_text.visible = true
	right_text.visible = false
	
	center_text.text = "Since this is your first battle, let us walk you through the [b]combat interface.[/b]"
	show_next()
	await next_pressed
	
	
	right_text.text = "These are your [b]actions.[/b]"
	right_text.visible = true
	center_text.visible = false
	
	attack.z_index = top_index
	inventory.z_index = top_index
	archive.z_index = top_index
	run.z_index = top_index
	
	show_next()
	await next_pressed
	
	attack.z_index = normal_index
	inventory.z_index = top_index
	archive.z_index = normal_index
	run.z_index = normal_index
	
	right_text.text = "This is the [b]Inventory Button[/b]. \nYou can [b]use one item[b] before you attack."
	
	show_next()
	await next_pressed
	
	inventory.z_index = normal_index
	archive.z_index = top_index
	
	right_text.text = "This is the [b]Archive Button[/b]. \nHere, you can review the lessons you collected."
	
	show_next()
	await next_pressed
	
	archive.z_index = normal_index
	run.z_index = top_index
	
	right_text.text = "This is the [b]Run Button[/b]. \nA successful run attempt will let you escape the battle. A failed run attempt will damage you."
	
	show_next()
	await next_pressed
	
	run.z_index = normal_index
	attack.z_index = top_index
	
	right_text.text = "This is the [b]Attack Button[/b]. \nTry pressing it."
	tutorial_panel.mouse_filter = MOUSE_FILTER_IGNORE
	
	await attack_pressed
	tutorial_end()

func attack_tutorial():
	await get_tree().create_timer(0.5).timeout
	tutorial_panel.visible = true
	tutorial_panel.mouse_filter = MOUSE_FILTER_STOP
	
	$"../Control/Time/Timer".paused = true
	
	question.z_index = top_index
	right_text.visible = true
	right_text.text = "This is the [b]Question.[/b]"
	
	show_next()
	await next_pressed
	
	question.z_index = normal_index
	answers.z_index = top_index
	
	right_text.visible = false
	left_text.visible = true
	left_text.text = "These are your [b]Answer Choices[/b]. \n[b]Tapping[/b] this will swap your chosen answer to the next option."
	
	show_next()
	await next_pressed
	
	# this is your hp
	answers.z_index = normal_index
	player_hp.z_index = top_index
	
	left_text.text = "This is your [b]Health Bar[/b]."
	
	show_next()
	await next_pressed
	
	# this is the enemy's hp
	player_hp.z_index = normal_index
	enemy_hp.z_index = top_index
	
	left_text.visible = false
	right_text.visible = true
	right_text.text = "This is the [b]Enemy's Health Bar[/b]."
	
	show_next()
	await next_pressed
	
	# this is the timer
	
	enemy_hp.z_index = normal_index
	time.z_index = top_index
	
	right_text.visible = false
	center_text.visible = true
	center_text.text = "This the [b]Timer[/b]. \nYou will be [b]damaged once it runs out[/b]."
	
	show_next()
	await next_pressed
	
	# this is the ok button
	time.z_index = normal_index
	ok.z_index = top_index
	
	center_text.visible = false
	right_text.visible = true
	right_text.text = "This is the [b]Okay Button[/b]. \nTap it to [b]confirm your answer[/b]."
	
	show_next()
	await next_pressed
	
	ok.z_index = normal_index
	
	right_text.visible = false
	center_text.visible = true
	center_text.text = "[b]Now, try beating the enemy. Goodluck!"
	
	player_data["ui_tutorial"]["combat"] = true
	SaveManager.save_game(player_data, "player_file")
	
	show_next()
	await next_pressed
	
	tutorial_end()
	
	$"../Control/Time/Timer".paused = false

func _on_attack_pressed() -> void:
	if player_data["ui_tutorial"]["combat"] == false:
		attack_pressed.emit()

func tutorial_end():
	tutorial_panel.visible = false
	left_text.visible = false
	center_text.visible = false
	right_text.visible = false
	$Button.visible = false
	$Button.disabled = true

func show_next():
	await get_tree().create_timer(0.2).timeout
	$Button.visible = true
	$Button.disabled = false
	$Button.mouse_filter = MOUSE_FILTER_STOP

func _on_button_pressed() -> void:
	next_pressed.emit()
	#left_text.visible = false
	#center_text.visible = false
	#right_text.visible = false
	
	$Button.visible = false
	$Button.disabled = true
	$Button.mouse_filter = MOUSE_FILTER_IGNORE
