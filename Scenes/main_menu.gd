extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	print("New Game Pressed")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_load_game_pressed() -> void:
	print("Load Game Pressed")


func _on_settings_pressed() -> void:
	print("Settings Pressed")


func _on_quit_game_pressed() -> void:
	print("Quit Game Pressed")
	get_tree().quit()


func _on_button_pressed() -> void:
	print("New Game Pressed")
	get_tree().change_scene_to_file("res://Scenes/start_point_beach.tscn")
