extends Area2D

@export var Quest_Target : String
@export var quest_to_start : String = ""

var triggered := false

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name != "Player":
		return
	
	if quest_to_start != "" and not triggered:
		triggered = true
		SignalManager.quest_start.emit(quest_to_start)

	if Quest_Target != "":
		SignalManager.area_entered.emit(Quest_Target)
