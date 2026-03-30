extends Control

# Called when the node enters the scene tree for the first time.

@onready var game_data = SaveManager.load_game("save_file")
@onready var menu_anim = $Control/AnimationPlayer
@onready var menu = $Control/Control
@onready var prompt = $Prompt
@onready var prompt_confirm = $Prompt/Control/Confirm
@onready var prompt_cancel = $Prompt/Control/Cancel
@onready var prompt_label = $Prompt/Control/Label
@onready var prompt_sprite = $"Prompt/Control/Interface-prompt-newgame"

@onready var new_sprite : CompressedTexture2D = preload("res://ui/title/interface-prompt-newgame.png")
@onready var quit_sprite : CompressedTexture2D = preload("res://ui/title/interface-prompt-quitgame.png")

var pressed : String

func _ready() -> void:
	game_data["in_game"] = false
	SaveManager.save_game(game_data, "save_file")
	
	if not FileAccess.file_exists("user://player.json"):
		$Control/Control/Continue.disabled = true
		$Control/Control/Continue.self_modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		$Control/Control/Continue.disabled = false
		$Control/Control/Continue.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	await menu_anim.animation_finished
	menu.process_mode = Node.PROCESS_MODE_INHERIT

func _on_new_game_pressed() -> void:
	print("New Game Pressed")
	
	_load_prompt("New")

func _on_continue_pressed() -> void:
	print("Continue Pressed")
	game_data["in_game"] = true
	SaveManager.save_game(game_data, "save_file")
	SceneLoader.load_scene("uid://dt532wlk4w78h")
	#get_tree().change_scene_to_file("res://Scenes/start_point_beach.tscn")

func _on_settings_pressed() -> void:
	print("Settings Pressed")
	SceneLoader.load_scene("uid://tj4vo1mmxfyt")
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_game_pressed() -> void:
	print("Quit Game Pressed")
	#SceneLoader.load_scene("uid://nxlclj2vm1y2")
	_load_prompt("Quit")

func _load_prompt(press):
	pressed = press
	prompt.visible = true
	prompt_confirm.disabled = false
	prompt_cancel.disabled = false
	
	if press == "New":
		if $Control/Control/Continue.disabled == true:
			SceneLoader.load_scene("uid://dvf5porvudl4f")
		prompt_sprite = new_sprite
		prompt_label.text = "Are you sure you want to start a new game?\n\n[b]This will overwrite your progress.[/b]"
	elif press == "Quit":
		prompt_sprite = quit_sprite
		prompt_label.text = "Are you sure you want to [b]Quit the Game[/b]?"

func _on_confirm_pressed() -> void:
	prompt_confirm.disabled = true
	prompt_cancel.disabled = true
	
	if pressed == "New":
		SceneLoader.load_scene("uid://dvf5porvudl4f")
	elif pressed == "Quit":
		get_tree().quit()
	else:
		return


func _on_cancel_pressed() -> void:
	prompt_confirm.disabled = true
	prompt_cancel.disabled = true
	prompt.visible = false
