extends Control


func _on_q_1_pressed() -> void:
	QuestManager._add_quest("0")
	pass # Replace with function body.


func _on_q_2_pressed() -> void:
	QuestManager._add_quest("1")


func _on_q_3_pressed() -> void:
	QuestManager._add_quest("2")


func _on_reset_pressed() -> void:
	QuestManager._clear_quests()


func _on_update_pressed() -> void:
	QuestManager._update_task("0", "0", 1)
	QuestManager._update_task("0", "1", 1)
