extends Control

@export var Task_Expanded:bool = true

func _on_interfacehudtodo_pressed() -> void:
	print("Pressed")
	var tween = create_tween()
	
	if Task_Expanded == false:
		tween.tween_property($Task, "position", Vector2(234.0, -30), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, -1)
		Task_Expanded = true
	else:
		tween.tween_property($Task, "position", Vector2(234.0, 15), 0.25)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_SINE)
		#$Task.position += Vector2(0, 1)
		Task_Expanded = false

func _on_settings_button_pressed() -> void:
	print("Settings")
	SceneLoader.load_scene("uid://tj4vo1mmxfyt")


func _on_map_button_pressed() -> void:
	print("Map")
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_archive_button_pressed() -> void:
	SceneLoader.load_scene("uid://cfvteqvw7wwp")
