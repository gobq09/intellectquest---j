extends Control

@onready var position_data = SaveManager.load_game("position_file")

func _on_close_pressed() -> void:
	#SceneLoader.load_scene(position_data["last_scene"])
	SignalManager.show_hud.emit()
	$"../../../..".queue_free()
	
