extends TextureButton

@onready var task_container = $ScrollContainer/Task_Container

func _ready() -> void:
	var tasks_list = QuestManager._active_quest()
	
	if not tasks_list == null:
		for tasks in tasks_list:
			var task_data = tasks_list[tasks]
			if task_data["progress"] < task_data["goal"]:
				_add_task(task_data["task_name"], task_data["progress"], task_data["goal"])
	#for tasks in tasks_list:
		#var task_data = tasks_list[tasks]
		#if task_data["progress"] >= task_data["goal"]:
			#_add_task(task_data["task_name"], task_data["progress"], task_data["goal"])
	#print(task_container.get_children())

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
	print(node.text)
	
	task_container.add_child(node)
