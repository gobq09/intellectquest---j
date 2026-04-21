extends Area2D

@export var Target_Scene: String
@export var Target_Position: String



func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		SignalManager.stop_music.emit()
		SignalManager.stop_ambience.emit()
		SceneLoader.load_map(Target_Scene, Target_Position)
