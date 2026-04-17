extends Area2D

@export var Quest_Target : String



func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		SignalManager.area_entered.emit(Quest_Target)
