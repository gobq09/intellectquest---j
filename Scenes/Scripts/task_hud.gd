extends TextureButton

@onready var task_container = $ScrollContainer/Task_Container

func _ready() -> void:
	SignalManager.quest_updated.connect(_refresh_tasks)
	SignalManager.new_objective.connect(_on_new_objective)
	
	await get_tree().process_frame
	
	_refresh_tasks()

func _refresh_tasks():
	# clear old tasks
	for child in task_container.get_children():
		child.queue_free()
	
	var active = QuestManager._active_quest()
	
	if active == null:
		print("NO ACTIVE TASK")
		return
	
	var task = active["task_data"]
	print("SHOWING TASK:", task["task_name"])
	
	_add_task(task["task_name"], task["progress"], task["goal"])

func _add_task(task_name, progress, goal):
	var node = RichTextLabel.new()
	var format = str(task_name) + " " + str(int(progress)) + "/" + str(int(goal))
	
	node.bbcode_enabled = true
	node.fit_content = true
	node.scroll_active = false
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	node.add_theme_color_override("default_color", Color.BLACK)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if progress >= goal:
		node.text = "[s]" + format + "[/s]"
		node.modulate.a = 0.5
	else:
		node.text = format
	
	task_container.add_child(node)
	
func _on_new_objective(task_name: String):
	print("NEW OBJECTIVE: ", task_name)
	
	_refresh_tasks()

	_play_objective_anim(task_name)
	
func _play_objective_anim(task_name: String):
	var original_y = position.y
	var drop_y = original_y + 40
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", drop_y, 0.4)
	await tween.finished
	
	await get_tree().create_timer(2.0).timeout
	
	var tween_back = create_tween()
	tween_back.tween_property(self, "position:y", original_y, 0.4)
