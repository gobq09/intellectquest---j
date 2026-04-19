extends Control

@export var Task_Expanded:bool = true
@onready var game_data = SaveManager.load_game("save_file")
@onready var hp_bar: TextureProgressBar = $"HP/Bar/HP Bar"
@onready var player_data = SaveManager.load_game("player_file")
@onready var bar: Sprite2D = $"HP/Bar/Interface-hud-hpbar1"
@onready var level: Label = $"HP/Interface-hud-level/RichTextLabel"

@onready var settings_scene : PackedScene = preload("uid://tj4vo1mmxfyt")
@onready var map_scene : PackedScene = preload("uid://dxogc44ghcvvr")
@onready var quest_scene : PackedScene = preload("uid://bn8572f758heh")
@onready var archive_scene : PackedScene = preload("uid://cfvteqvw7wwp")
@onready var profile_scene : PackedScene = preload("uid://0q5mlknq6fk0")

var last_scene
signal interacted

func _ready() -> void:
	SignalManager.show_hud.connect(show_hud)
	
	level.text = str(int(player_data["player_level"]))
	var max_hp = (player_data["player_end"] * 2) + 50
	hp_bar.value = (player_data["player_hp"] / max_hp) * 100
	#bar.position.x = (hp_bar.value / 2) + 32
	
	SignalManager.player_defeated.connect(player_defeated)

func show_ui(scene: PackedScene):
	$".".hide()
	var instance = scene.instantiate()
	
	$"..".add_child(instance)

func show_hud():
	$".".show()

func player_defeated():
	#print(player_data)
	player_data = SaveManager.load_game("player_file")
	player_data["player_hp"] = 50 + (player_data["player_end"] * 2)
	SaveManager.save_game(player_data, "player_file")
	#print(player_data)
	level.text = str(int(player_data["player_level"]))
	var max_hp = (player_data["player_end"] * 2) + 50
	hp_bar.value = (player_data["player_hp"] / max_hp) * 100

func _on_interfacehudtodo_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	SignalManager.interface_changed.emit()
	print("Pressed")
	var tween = create_tween()
	
	if Task_Expanded == false:
		tween.tween_property($Control/Task, "position", Vector2(-44.0, 16.0), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, -1)
		Task_Expanded = true
	else:
		tween.tween_property($Control/Task, "position", Vector2(-44.0, -30.0), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, 1)
		Task_Expanded = false

func _on_settings_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	SignalManager.interface_changed.emit()
	
	#SceneLoader.load_scene("uid://tj4vo1mmxfyt")
	#$"../Settings".show()
	show_ui(settings_scene)


func _on_map_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	SignalManager.interface_changed.emit()
	print("Map")
	#SceneLoader.load_scene("uid://dxogc44ghcvvr")
	show_ui(map_scene)


func _on_archive_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	#SignalManager.interface_changed.emit()
	#SceneLoader.load_scene("uid://cfvteqvw7wwp")
	show_ui(archive_scene)


func _on_interfacehudlevel_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	SignalManager.interface_changed.emit()
	#SceneLoader.load_scene("uid://0q5mlknq6fk0")
	show_ui(profile_scene)


func _on_interact_button_pressed() -> void:
	Input.action_press("interact")
	Input.action_release("interact")

@onready var task_timer = $Control/Task/Timer

func _on_task_button_down() -> void:
	task_timer.start(0.5)


func _on_task_button_up() -> void:
	task_timer.stop()


func _on_timer_timeout() -> void:
	SignalManager.interface_changed.emit()
	#SceneLoader.load_scene("uid://bn8572f758heh")
	show_ui(quest_scene)
