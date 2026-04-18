extends Control

@onready var game_data = SaveManager.load_game("save_file")
@onready var general: TextureButton = $Control/General
@onready var video: TextureButton = $Control/Video
@onready var audio: TextureButton = $Control/Audio
@onready var menu: TextureButton = $Control/Menu
@onready var quit: TextureButton = $Control/Quit
@onready var close: TextureButton = $Close
@onready var confirm: TextureButton = $Prompt/Control/Confirm
@onready var cancel: TextureButton = $Prompt/Control/Cancel
@onready var prompt: Control = $Prompt
@onready var label: RichTextLabel = $"Prompt/Control/Prompt Label"

@onready var menu_uid: String = "uid://dkefgsuwak2hj"
@onready var last_scene: String

var pressed: String

func _ready() -> void:
	#AudioManager.duck_music()
	if game_data["in_game"] == true:
		menu.visible = true
		menu.disabled = false
		quit.visible = true
		quit.disabled = false
		
		last_scene = "game"
	else:
		menu.visible = false
		menu.disabled = true
		quit.visible = false
		quit.disabled = true
		
		last_scene = "menu"


func _on_general_pressed() -> void:
	pass # Replace with function body.

func _on_audio_pressed() -> void:
	pass # Replace with function body.

func _on_video_pressed() -> void:
	pass # Replace with function body.

func _on_menu_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	_load_prompt("Menu")

func _on_quit_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	_load_prompt("Quit")


func _load_prompt(press):
	pressed = press
	prompt.visible = true
	confirm.disabled = false
	cancel.disabled = false
	
	if press == "Menu":
		label.text = "Are you sure you want to return to the [b]Main Menu[/b]?"
	elif press == "Quit":
		label.text = "Are you sure you want to [b]Quit the Game[/b]?"

func _on_close_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	#AudioManager.restore_music()
	var position_data = SaveManager.load_game("position_file")
	
	if last_scene == "game":
		last_scene = position_data["last_scene"]
	elif last_scene == "menu":
		last_scene = menu_uid
	
	print(last_scene)
	SceneLoader.load_scene(last_scene)


func _on_confirm_pressed() -> void:
	SignalManager.play_sfx.emit("confirm_sfx")
	confirm.disabled = true
	cancel.disabled = true
	
	if pressed == "Menu":
		SceneLoader.load_scene(menu_uid)
	elif pressed == "Quit":
		get_tree().quit()
	else:
		return


func _on_cancel_pressed() -> void:
	confirm.disabled = true
	cancel.disabled = true
	prompt.visible = false
