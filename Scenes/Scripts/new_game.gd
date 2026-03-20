extends Control


func _ready() -> void:
	pass

func _on_confirm_pressed() -> void:
	print("Confirm Pressed")
	SceneLoader.load_scene("uid://dvf5porvudl4f")


func _on_cancel_pressed() -> void:
	print("Cancel Pressed")
	SceneLoader.load_scene("uid://dkefgsuwak2hj")
