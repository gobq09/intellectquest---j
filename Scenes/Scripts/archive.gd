extends Control

@onready var eng_source = Questions.english_topic
@onready var sci_source = Questions.science_topic
@onready var math_source = Questions.math_topic
@onready var fil_source = Questions.fil_topic


@onready var english_topics = SaveManager.load_game("save_file")["eng_topics"]
@onready var science_topics = SaveManager.load_game("save_file")["sci_topics"]
@onready var math_topics = SaveManager.load_game("save_file")["math_topics"]
@onready var fil_topics = SaveManager.load_game("save_file")["fil_topics"]

@onready var last_scene = SaveManager.load_game("save_file")
@onready var anim_player= $Control2/Sprite2D/AnimationPlayer
@onready var eng_button : TextureButton = $Control/English
@onready var sci_button : TextureButton = $Control/Science
@onready var math_button : TextureButton = $Control/Math
@onready var fil_button : TextureButton = $Control/Filipino
@onready var next_button : TextureButton = $Next
@onready var prev_button : TextureButton = $Previous
@onready var topics: Control = $Topics
@onready var page_left: Control = $Topics/Left
@onready var left_topic_name: RichTextLabel = $Topics/Left/Panel4/TopicName
@onready var left_topic_desc: RichTextLabel = $Topics/Left/Panel3/TopicDesc
@onready var page_right: Control = $Topics/Right
@onready var right_topic_name: RichTextLabel = $Topics/Right/Panel4/TopicName
@onready var right_topic_desc: RichTextLabel = $Topics/Right/Panel3/TopicDesc

var darker = Color(0.5, 0.5, 0.5, 1.0)
var normal = Color(1.0, 1.0, 1.0, 1.0)

@onready var english_size = english_topics.size() - 1
@onready var science_size = science_topics.size() - 1
@onready var math_size = math_topics.size() - 1
@onready var fil_size = fil_topics.size() - 1

var id
var count: int = 1
var current_subject: Dictionary
var current_source: Dictionary

func _ready() -> void:
	_on_english_pressed()
	
	#get topicid
	#get matching id from source
	#

func _on_close_pressed() -> void:
	SceneLoader.load_scene(last_scene["last_scene"])

func _load_topic(subject: Dictionary, source: Dictionary, action: String = "next") -> void:
	#print(subject[count])
	if subject.size() <= 0:
		topics.visible = false
		print("no topic")
		return
	else:
		topics.visible = true
	
	if action == "prev":
		count -= 4
		if count <= 1:
			count = 1
	
	if count <= 1:
		prev_button.visible = false
	else:
		prev_button.visible = true

	id = int(subject[str(count)])
	left_topic_name.text = "[b]" + str(source[id]["TopicName"]) + "[/b]"
	left_topic_desc.text = source[id]["TopicDesc"]
	
	count += 1
	
	if count == current_subject.size():
		page_right.visible = false
	else: 
		page_right.visible = true
		id = int(subject[str(count)])
		right_topic_name.text = "[b]" + str(source[id]["TopicName"]) + "[/b]"
		right_topic_desc.text = source[id]["TopicDesc"]
	
	count += 1
	
	if count >= current_subject.size():
		next_button.visible = false
	else:
		next_button.visible = true
	

func _toggle_input(action: bool)-> void:
	next_button.disabled = action
	prev_button.disabled = action
	eng_button.disabled = action
	sci_button.disabled = action
	math_button.disabled = action
	fil_button.disabled = action

func _on_next_pressed() -> void:
	_toggle_input(true)
	
	if count <= 1:
		next_button.visible = false
		prev_button.visible = false
	
	anim_player.play("archive-next")
	await get_tree().create_timer(0.25).timeout
	_load_topic(current_subject, current_source,"next")
	await anim_player.animation_finished
	
	_toggle_input(false)

func _on_previous_pressed() -> void:
	_toggle_input(true)
	
	anim_player.play("archive-previous")
	await get_tree().create_timer(0.25).timeout
	_load_topic(current_subject, current_source,"prev")
	await anim_player.animation_finished
	
	_toggle_input(false)


func _on_english_pressed() -> void:
	print("english pressed")
	count = 1
	eng_button.self_modulate = normal
	sci_button.self_modulate = darker
	math_button.self_modulate = darker
	fil_button.self_modulate = darker
	
	current_subject = english_topics
	current_source = eng_source
	_on_next_pressed()


func _on_science_pressed() -> void:
	print("science pressed")
	count = 1
	eng_button.self_modulate = darker
	sci_button.self_modulate = normal
	math_button.self_modulate = darker
	fil_button.self_modulate = darker
	
	current_subject = science_topics
	current_source = sci_source
	_on_next_pressed()
	


func _on_math_pressed() -> void:
	print("math pressed")
	count = 1
	eng_button.self_modulate = darker
	sci_button.self_modulate = darker
	math_button.self_modulate = normal
	fil_button.self_modulate = darker
	
	current_subject = math_topics
	current_source = math_source
	_on_next_pressed()


func _on_filipino_pressed() -> void:
	print("filipino pressed")
	count = 1
	eng_button.self_modulate = darker
	sci_button.self_modulate = darker
	math_button.self_modulate = darker
	fil_button.self_modulate = normal
	
	current_subject = fil_topics
	current_source = fil_source
	_on_next_pressed()
