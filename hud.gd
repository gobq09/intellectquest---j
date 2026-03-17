extends Control

@export var Task_Expanded:bool = true
@export var animation_player: AnimationPlayer


func _ready() -> void:
	
	pass

func _on_interfacehudtodo_pressed() -> void:
	print("Pressed")
	
	if Task_Expanded == false:
		while $Task.position.y != -30:
			$Task.position += Vector2(0, -1)
			Task_Expanded = true
	else:
		while $Task.position.y != 15:
			$Task.position += Vector2(0, 1)
			Task_Expanded = false

func _on_settings_button_pressed() -> void:
	print("Settings")
	SceneLoader.load_scene("uid://tj4vo1mmxfyt")


func _on_map_button_pressed() -> void:
	print("Map")
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_archive_button_pressed() -> void:
	SceneLoader.load_scene("uid://cfvteqvw7wwp")
