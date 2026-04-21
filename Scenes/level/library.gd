extends Node2D


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == Player:
		SignalManager.stop_music.emit()
		SceneLoader.load_scene("uid://d4dgymuee0bxt")
