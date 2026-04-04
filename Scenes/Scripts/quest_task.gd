extends HBoxContainer

@onready var quest_data = SaveManager.load_game("quest_file")
@onready var task_name = $Name
@onready var progress = $Progress

var quest_id

func _ready() -> void:
	task_name.text = quest_data[quest_id]["name"]
	progress.text = quest_data[quest_id]["progress"]
